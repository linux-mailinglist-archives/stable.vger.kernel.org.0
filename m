Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AEA1D0E74
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732844AbgEMJvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387662AbgEMJv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:51:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFD9520575;
        Wed, 13 May 2020 09:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363489;
        bh=WAETQjuLl5QS1YCI7B1gmJLMQhVKG4lIqaVhHcXqd+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNX/JVk/wyGNP3LM7g6LH856msxxkDiHDoxOHBMhqRZBrQ1CZpItbaSvdekC534fI
         doEfsx2Etbe4w0UKQtgpfsM/mjSKd5HUixKHSXbwXPdZZA2OYDx3nEFGBmlOzRhqh7
         9cc83PoYGqUEGYyRpb/zmR7rUj1ihHIaSZTpqEMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 87/90] bdi: move bdi_dev_name out of line
Date:   Wed, 13 May 2020 11:45:23 +0200
Message-Id: <20200513094418.238412780@linuxfoundation.org>
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
index f88197c1ffc2d..c9ad5c3b7b4b2 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -505,13 +505,6 @@ static inline int bdi_rw_congested(struct backing_dev_info *bdi)
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
index 62f05f605fb5b..680e5028d0fc5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -21,7 +21,7 @@ struct backing_dev_info noop_backing_dev_info = {
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
 static struct class *bdi_class;
-const char *bdi_unknown_name = "(unknown)";
+static const char *bdi_unknown_name = "(unknown)";
 
 /*
  * bdi_lock protects bdi_tree and updates to bdi_list. bdi_list has RCU
@@ -1043,6 +1043,14 @@ void bdi_put(struct backing_dev_info *bdi)
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
2.20.1



