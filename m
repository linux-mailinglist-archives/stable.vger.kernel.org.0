Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BFEEA106
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfJ3P45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728929AbfJ3P45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:56:57 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C7722067D;
        Wed, 30 Oct 2019 15:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572451016;
        bh=rc56oxVDzxSyspd9WL/F3AQ8LjXvk4rfeFvwFp/w1uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Dj3LdBGdrHKehXom1s1JUeKzutH0PMEHSxYjuAU1q+ST0nq0v8LZMWvHOk//odHq
         JtbHPch1onzmAfLxuUJAwxwk6yV3tPqZSTNeeyi9j0WANTJMd1wZSqgo14ySFUCo7i
         a+SB/xmQzhAYmnPXe6DjzbHIVOGoVSnQ1L8/nJMU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Mike Christie <mchristi@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, nbd@other.debian.org
Subject: [PATCH AUTOSEL 4.14 23/24] nbd: handle racing with error'ed out commands
Date:   Wed, 30 Oct 2019 11:55:54 -0400
Message-Id: <20191030155555.10494-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155555.10494-1-sashal@kernel.org>
References: <20191030155555.10494-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a234600849558..f322bb3286910 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -648,6 +648,12 @@ static struct nbd_cmd *nbd_read_stat(struct nbd_device *nbd, int index)
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

