Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F029F55AC
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387767AbfKHTD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389401AbfKHTD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:03:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ACB220650;
        Fri,  8 Nov 2019 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239837;
        bh=26yenZUwaIRr6X613M2xzDB+jE59fnyLX4fWHHmWfnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeOeAnzS8GPMibf/f9ooSSMUQhQ7ImvxaXtLsmj7G6boLNKWmxZkvHRpW3/iwFbN7
         gxmB2TFOs4Q4m/7cSd0SyAWqIgla36HAODa3qF7g4hZNCq1j/Q49GWAuNWilgOKCk6
         nhZ5oUDQDtfvhP+9XK6UzlV5azrDfW9ySMOiGuwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/79] nbd: handle racing with errored out commands
Date:   Fri,  8 Nov 2019 19:50:16 +0100
Message-Id: <20191108174806.174452403@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7ce23e8e0a9cd38338fc8316ac5772666b565ca9 ]

We hit the following warning in production

print_req_error: I/O error, dev nbd0, sector 7213934408 flags 80700
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 25 PID: 32407 at lib/refcount.c:190 refcount_sub_and_test_checked+0x53/0x60
Workqueue: knbd-recv recv_work [nbd]
RIP: 0010:refcount_sub_and_test_checked+0x53/0x60
Call Trace:
 blk_mq_free_request+0xb7/0xf0
 blk_mq_complete_request+0x62/0xf0
 recv_work+0x29/0xa1 [nbd]
 process_one_work+0x1f5/0x3f0
 worker_thread+0x2d/0x3d0
 ? rescuer_thread+0x340/0x340
 kthread+0x111/0x130
 ? kthread_create_on_node+0x60/0x60
 ret_from_fork+0x1f/0x30
---[ end trace b079c3c67f98bb7c ]---

This was preceded by us timing out everything and shutting down the
sockets for the device.  The problem is we had a request in the queue at
the same time, so we completed the request twice.  This can actually
happen in a lot of cases, we fail to get a ref on our config, we only
have one connection and just error out the command, etc.

Fix this by checking cmd->status in nbd_read_stat.  We only change this
under the cmd->lock, so we are safe to check this here and see if we've
already error'ed this command out, which would indicate that we've
completed it as well.

Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index da6a36d14f4cf..867841c56a6da 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -663,6 +663,12 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
 		ret = -ENOENT;
 		goto out;
 	}
+	if (cmd->status != BLK_STS_OK) {
+		dev_err(disk_to_dev(nbd->disk), "Command already handled %p\n",
+			req);
+		ret = -ENOENT;
+		goto out;
+	}
 	if (test_bit(NBD_CMD_REQUEUED, &cmd->flags)) {
 		dev_err(disk_to_dev(nbd->disk), "Raced with timeout on req %p\n",
 			req);
-- 
2.20.1



