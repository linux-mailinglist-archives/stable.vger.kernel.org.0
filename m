Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C30B2A5317
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732461AbgKCU4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732446AbgKCU4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 646DC2053B;
        Tue,  3 Nov 2020 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436976;
        bh=7mFk/CA0TIWoc/EhV77uWD+611/NhLjRBi2Jfe8I7qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVzgPNjPAhtA4dVwceN5ZGd2Ja9AVtDP44OSLs/NSCiVJS596ssvKC9RcoGWZWZ1J
         IRCXfUqNx8ONcWI4mrYFgCuMCf2Bd0tSoC3WWjXpQtUwGCPz4/eepfLTr3mBvf6pkZ
         NGiaMaPYlJng/O71/J0O5QqzLqgUqB/zy7gFkiv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/214] nbd: make the config put is called before the notifying the waiter
Date:   Tue,  3 Nov 2020 21:35:41 +0100
Message-Id: <20201103203259.174472239@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 87aac3a80af5cbad93e63250e8a1e19095ba0d30 ]

There has one race case for ceph's rbd-nbd tool. When do mapping
it may fail with EBUSY from ioctl(nbd, NBD_DO_IT), but actually
the nbd device has already unmaped.

It dues to if just after the wake_up(), the recv_work() is scheduled
out and defers calling the nbd_config_put(), though the map process
has exited the "nbd->recv_task" is not cleared.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7c577cabb9c3b..742f8160b6e28 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -787,9 +787,9 @@ static void recv_work(struct work_struct *work)
 
 		blk_mq_complete_request(blk_mq_rq_from_pdu(cmd));
 	}
+	nbd_config_put(nbd);
 	atomic_dec(&config->recv_threads);
 	wake_up(&config->recv_wq);
-	nbd_config_put(nbd);
 	kfree(args);
 }
 
-- 
2.27.0



