Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E23339534
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 18:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhCLRkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 12:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhCLRkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 12:40:00 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAF7C061574;
        Fri, 12 Mar 2021 09:40:00 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so11398168pjg.5;
        Fri, 12 Mar 2021 09:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jF8mBIpe3t0bmWBsiEvUHTeBeX7mPeL5p74zwuxcf3k=;
        b=J2brkoMtL++eHoP33bjjSwU9jl8TxgwQLfwP1JFP5dLtuq6iUaqbwJtkfPlt0jODOT
         hg0hgAuaqQ9hYcYCOsMqDKLVLhqAU4E0ge6hFznAMxR6Rrt9IZoGvtVuY47ouks5uHKd
         Of1BeIpg4KO7go3P6aw+4e3hPpHHnYwc/NkoryWorBPAUiIOENmMOqpMQUwJJ43S8xxX
         F/gd5ULgA8XNTZhNb9yUvUhSbOHGHzgmBeeIPrQ24Fx2E6lX4V/Nf+xB0cseOiWEUggj
         XATslKZBRWnwZUSzuNfQHEM0HyTaIh5XZ1RQX9CWBHo7v3ySSFZCfnvM/L8P0UISCwIa
         0TUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=jF8mBIpe3t0bmWBsiEvUHTeBeX7mPeL5p74zwuxcf3k=;
        b=LdSPN83vprMQZBXDLwev/vVPXJUajSD5FAZ5zRdGwRkxL0uNdiWjoaF0hUTSUCes5A
         VWWr8EHwO42eWIF9Q5hYM/MwHNvxIeTYWkc89tzWrwb6Cpg2XJKkshxHblm0K1lSBy8I
         9qgMnn63XLAMLYqpGxtoDFuMDGHGjLdTkWE0HmCOSHBDJfJwdSfxwaCPYmD2ozLZwqmE
         510yOj9hIzo7psRCCGoGndTPDACbbFWimaeoXPrazgkclAyHfPzhmAjswgeXWvEZu6pC
         BTfsrlbADAS6eqmVYKtlEBOsrimLdCeYdTV7bWMwr45blw6ZVp42c6YDt6YktnGTVTnY
         QiOw==
X-Gm-Message-State: AOAM532GNYAMRJ+/YDrOHE+XinFB/JFF9uQj+9Zjwj6aJr1ZQxbK1x6a
        IqsCYBA2kdm1ji6TzwlYr92fzE4S6O0=
X-Google-Smtp-Source: ABdhPJz7DuHu7lS1atq20fvfOwIMRFEDU14H5wnmffCLvPBtRGFd7tmYPVhISCqoSbAkNk4COiMmEw==
X-Received: by 2002:a17:90a:bf0a:: with SMTP id c10mr14846966pjs.195.1615570799523;
        Fri, 12 Mar 2021 09:39:59 -0800 (PST)
Received: from bbox-1.mtv.corp.google.com ([2620:15c:211:201:8d76:9272:43a9:a6d0])
        by smtp.gmail.com with ESMTPSA id g21sm2694958pjl.28.2021.03.12.09.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:39:58 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     joaodias@google.com, LKML <linux-kernel@vger.kernel.org>,
        Amos Bianchi <amosbianchi@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] zram: fix return value on writeback_store
Date:   Fri, 12 Mar 2021 09:39:48 -0800
Message-Id: <20210312173949.2197662-1-minchan@kernel.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

writeback_store's return value is overwritten by submit_bio_wait's
return value. Thus, writeback_store will return zero since there
was no IO error. In the end, write syscall from userspace will
see the zero as return value, which could make the process stall
to keep trying the write until it will succeed.

Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: stable@vger.kernel.org
Fixes: 3b82a051c101("drivers/block/zram/zram_drv.c: fix error return codes not being returned in writeback_store")
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a711a2e2a794..63bbefdffc81 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -627,7 +627,7 @@ static ssize_t writeback_store(struct device *dev,
 	struct bio_vec bio_vec;
 	struct page *page;
 	ssize_t ret = len;
-	int mode;
+	int mode, err;
 	unsigned long blk_idx = 0;
 
 	if (sysfs_streq(buf, "idle"))
@@ -728,12 +728,17 @@ static ssize_t writeback_store(struct device *dev,
 		 * XXX: A single page IO would be inefficient for write
 		 * but it would be not bad as starter.
 		 */
-		ret = submit_bio_wait(&bio);
-		if (ret) {
+		err = submit_bio_wait(&bio);
+		if (err) {
 			zram_slot_lock(zram, index);
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
+			/*
+			 * Return last IO error unless every IO were
+			 * not suceeded.
+			 */
+			ret = err;
 			continue;
 		}
 
-- 
2.31.0.rc2.261.g7f71774620-goog

