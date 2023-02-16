Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5209A69989F
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 16:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBPPT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 10:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBPPTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 10:19:24 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1314A2B2A6
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:19:23 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id bl9so756317iob.7
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/F3fWfMedxCdmHWDLO4jWxLDIXa+8W9/VD2h3x3YdLE=;
        b=n7NMQgUwwQ2lV3+N2KcdRGMX7e7mSpP5B+MqazTTWnq/qyDn7uAr5jVX1N91P2oV1a
         aIzr56pwYXFNBbz3xNrroizN63sx+BAovpMsQf2E8+VbgTNcIY9O3h0qQsIgg+qTL/kq
         CM/3S/ePYMOUBfdfZy0CVo+WlZZAlE6MilxcE3dYVQfDvgOtSo59LbSvh439ztwBfwMc
         mIN1Z+UB5S314OynuIlbE710Ym89tznIOp3M+3YuTcOPWkjagv2KZcB1np7Ez6WXS6KV
         dr2cJkRbe0mu+zi54KEp6kVkoRMDVzCzW3PmZiEIBvl+YouT9JiF7/lQahoBiXyfIUt6
         0PtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/F3fWfMedxCdmHWDLO4jWxLDIXa+8W9/VD2h3x3YdLE=;
        b=GF7RKGznywWW8U6/gk15KnRsGuFoOwW+8a3fwUcTTTJSy+SaKJAXqrbrMg6Ty3rC5x
         TykrStCjodj0apkHuJ6A5ejKeTaGA1/4cmkCi1WmAw8QLzsj9+sBN7dNPUJniJWmKp0p
         +l0woV6Iroc4XviPYBVUwCX/DH85Cp1GLV1gLB77aLq0m0WRVeNgYCGZxkRmv8Fef04Y
         RuSQiCDzQTt9myuqRIZg/P0z0y7cc/SSZPbYw3BrjLsnZ6XVtiaIFprofdvRrNsoYGfu
         mipUzNG+imJNwqDDaekrOfQJX/aN/VtE+Ghy1hK/4ZDTjWEeGyDSqqo46CSfguckcRij
         zrEQ==
X-Gm-Message-State: AO0yUKX53Sefp40kKynp49jxpKlJYsrmSg9WNK/JI8RZ6lgEHG8X0WX5
        i+Vozhgo3IqbAh19XufOZB3mzQ==
X-Google-Smtp-Source: AK7set9LWTTzjD5GXy/p4+RQKI/uf/IChRvuK1DjWxxfbFY+Fi743xVLaKmgmrmeLMb5DAgnWuzd7A==
X-Received: by 2002:a05:6602:2ac8:b0:740:7d21:d96f with SMTP id m8-20020a0566022ac800b007407d21d96fmr4855169iov.1.1676560763243;
        Thu, 16 Feb 2023 07:19:23 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p10-20020a0566022b0a00b006e2f2369d3csm561600iov.50.2023.02.16.07.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:19:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     hch@infradead.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] brd: return 0/-error from brd_insert_page()
Date:   Thu, 16 Feb 2023 08:19:15 -0700
Message-Id: <20230216151918.319585-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216151918.319585-1-axboe@kernel.dk>
References: <20230216151918.319585-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It currently returns a page, but callers just check for NULL/page to
gauge success. Clean this up and return the appropriate error directly
instead.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/brd.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 20acc4a1fd6d..15a148d5aad9 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -78,11 +78,9 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 }
 
 /*
- * Look up and return a brd's page for a given sector.
- * If one does not exist, allocate an empty page, and insert that. Then
- * return it.
+ * Insert a new page for a given sector, if one does not already exist.
  */
-static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
+static int brd_insert_page(struct brd_device *brd, sector_t sector)
 {
 	pgoff_t idx;
 	struct page *page;
@@ -90,7 +88,7 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
-		return page;
+		return 0;
 
 	/*
 	 * Must use NOIO because we don't want to recurse back into the
@@ -99,11 +97,11 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 	gfp_flags = GFP_NOIO | __GFP_ZERO | __GFP_HIGHMEM;
 	page = alloc_page(gfp_flags);
 	if (!page)
-		return NULL;
+		return -ENOMEM;
 
 	if (radix_tree_preload(GFP_NOIO)) {
 		__free_page(page);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	spin_lock(&brd->brd_lock);
@@ -120,8 +118,7 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
-
-	return page;
+	return 0;
 }
 
 /*
@@ -174,16 +171,17 @@ static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n)
 {
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
+	int ret;
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
-	if (!brd_insert_page(brd, sector))
-		return -ENOSPC;
+	ret = brd_insert_page(brd, sector);
+	if (ret)
+		return ret;
 	if (copy < n) {
 		sector += copy >> SECTOR_SHIFT;
-		if (!brd_insert_page(brd, sector))
-			return -ENOSPC;
+		ret = brd_insert_page(brd, sector);
 	}
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.39.1

