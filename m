Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837C13E2534
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243962AbhHFISL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244042AbhHFIQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4678611CE;
        Fri,  6 Aug 2021 08:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237792;
        bh=MXBS4NdaYTZUtLMjFg2tRS12IH7gjij01FImmTHeLvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RzLtTI0Io9FW5O4+wswtHHdxKWdTxgLRUhlZCLq8UdXjArXCfxa/h4RlYUMvx5Umg
         WyBJ2xnmT9gSbKq2XOB3MYQWPvZci5PJ++O58regA56y1Dyo1B0xnA2cpc9Gmq3zDM
         /hVSesbpEARYtIVnQqhcO1Qt9kB5VjzY4n2A3SDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/16] bdi: move bdi_dev_name out of line
Date:   Fri,  6 Aug 2021 10:14:58 +0200
Message-Id: <20210806081111.382172684@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
References: <20210806081111.144943357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit eb7ae5e06bb6e6ac6bb86872d27c43ebab92f6b2 ]

bdi_dev_name is not a fast path function, move it out of line.  This
prepares for using it from modular callers without having to export
an implementation detail like bdi_unknown_name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/backing-dev.h |  9 +--------
 mm/backing-dev.c            | 10 +++++++++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 1ef4aca7b953..d28d57eefe9f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -499,13 +499,6 @@ static inline int bdi_rw_congested(struct backing_dev_info *bdi)
 				  (1 << WB_async_congested));
 }
 
-extern const char *bdi_unknown_name;
-
-static inline const char *bdi_dev_name(struct backing_dev_info *bdi)
-{
-	if (!bdi || !bdi->dev)
-		return bdi_unknown_name;
-	return dev_name(bdi->dev);
-}
+const char *bdi_dev_name(struct backing_dev_info *bdi);
 
 #endif	/* _LINUX_BACKING_DEV_H */
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 2152e85891d1..8501b033bca8 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -19,7 +19,7 @@ struct backing_dev_info noop_backing_dev_info = {
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
 static struct class *bdi_class;
-const char *bdi_unknown_name = "(unknown)";
+static const char *bdi_unknown_name = "(unknown)";
 
 /*
  * bdi_lock protects updates to bdi_list. bdi_list has RCU reader side
@@ -976,6 +976,14 @@ void bdi_put(struct backing_dev_info *bdi)
 }
 EXPORT_SYMBOL(bdi_put);
 
+const char *bdi_dev_name(struct backing_dev_info *bdi)
+{
+	if (!bdi || !bdi->dev)
+		return bdi_unknown_name;
+	return dev_name(bdi->dev);
+}
+EXPORT_SYMBOL_GPL(bdi_dev_name);
+
 static wait_queue_head_t congestion_wqh[2] = {
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
-- 
2.30.2



