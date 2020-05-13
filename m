Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A131D0E75
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732694AbgEMJve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732822AbgEMJvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A4AA20769;
        Wed, 13 May 2020 09:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363491;
        bh=Jze8i4rj65vnF9d3Kd8ooqtpOb+CdZklIrrCf6FWc/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgdSI0JaQ/X4d1bmokNUBN85GI1kUN3WclMDqJpTOty2tz6WEOwcL4jqDtr37omQM
         rbxvNICBnGtPSPj3x4enK2eMYvnW+GCJvKtFmCq0bRwR0/ANC3ftI8gWelqHI51cSM
         Y4yIbKzDeZekj6nMZZZ+cG+YCtexrD2CEjNbj0ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 88/90] bdi: add a ->dev_name field to struct backing_dev_info
Date:   Wed, 13 May 2020 11:45:24 +0200
Message-Id: <20200513094418.338015981@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6bd87eec23cbc9ed222bed0f5b5b02bf300e9a8d ]

Cache a copy of the name for the life time of the backing_dev_info
structure so that we can reference it even after unregistering.

Fixes: 68f23b89067f ("memcg: fix a crash in wb_workfn when a device disappears")
Reported-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/backing-dev-defs.h | 1 +
 mm/backing-dev.c                 | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 4fc87dee005ab..2849bdbb3acbe 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -220,6 +220,7 @@ struct backing_dev_info {
 	wait_queue_head_t wb_waitq;
 
 	struct device *dev;
+	char dev_name[64];
 	struct device *owner;
 
 	struct timer_list laptop_mode_wb_timer;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 680e5028d0fc5..3f2480e4c5af3 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -938,7 +938,8 @@ int bdi_register_va(struct backing_dev_info *bdi, const char *fmt, va_list args)
 	if (bdi->dev)	/* The driver needs to use separate queues per device */
 		return 0;
 
-	dev = device_create_vargs(bdi_class, NULL, MKDEV(0, 0), bdi, fmt, args);
+	vsnprintf(bdi->dev_name, sizeof(bdi->dev_name), fmt, args);
+	dev = device_create(bdi_class, NULL, MKDEV(0, 0), bdi, bdi->dev_name);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
@@ -1047,7 +1048,7 @@ const char *bdi_dev_name(struct backing_dev_info *bdi)
 {
 	if (!bdi || !bdi->dev)
 		return bdi_unknown_name;
-	return dev_name(bdi->dev);
+	return bdi->dev_name;
 }
 EXPORT_SYMBOL_GPL(bdi_dev_name);
 
-- 
2.20.1



