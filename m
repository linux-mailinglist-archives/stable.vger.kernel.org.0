Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173F02A551C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbgKCVQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:16:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388782AbgKCVKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:10:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B985B205ED;
        Tue,  3 Nov 2020 21:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437851;
        bh=3hMGAx5cl3J9r3hhWcF3oOq1fS9krPCO+1IrkgH8BuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xS2FqoqsPYkCweE3GGolr5u1Pvqdw42UVc2vvmDKpF5jPsp5fyLfuZHYEnTozQAKx
         /OcgvmyqsxzUg88bMhwD3U3lJUjID79eiINjaRSYoz7SCg48PBECJ/0atCTDikRDwm
         1yBai1s4Y9NLkSlKwMkqdHIJripZEZWrbllt/Un8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 058/125] nbd: make the config put is called before the notifying the waiter
Date:   Tue,  3 Nov 2020 21:37:15 +0100
Message-Id: <20201103203205.370701418@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
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
index f22fad977c913..cdf62fb94fb15 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -725,9 +725,9 @@ static void recv_work(struct work_struct *work)
 
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



