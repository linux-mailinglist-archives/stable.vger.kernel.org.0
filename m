Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D5E6998A3
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 16:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjBPPTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 10:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBPPT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 10:19:27 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060C52E0CD
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:19:26 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id bl9so756362iob.7
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676560765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CulG6zK2nW/HgGbhd9JkZzAHs0nEf73drPFn60pMvSQ=;
        b=JZiE+1WytL5c1cjaZbScE5/h8NtfsKgMUNvCJP/lTXNoLt4FGC189+3uPudVOIAlHy
         33qmKz8ODkFLVf0KsQ1yjGqN0SjzmS8bI088jlZRr4mL4HAja0oWz+Ap58ZxYbnjHSri
         5+f+UxVgu8ShJtlSoEkoWktBL1JKDqlYRaUumK0Wpf1IFTial0CwFn9W2ik3m+PVfBKO
         RcNykP57vmNQbd++6Je+KCeWFwWOOxf15xmudmCEwuRt4pFTCvBGOMKng6Q9pwWe+IAM
         tRTG2lrI3A+QDr0Ag37IhkXiV7oqLHLUvRSXF1B14j1RS1MpwjUHcL7HRAq7NADZXlfY
         GjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676560765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CulG6zK2nW/HgGbhd9JkZzAHs0nEf73drPFn60pMvSQ=;
        b=DPCAwfdlN9e/otJvwoUPAj3rruUkK7xOWRop06ERupbv+og+g5Ccs9CNGgaDMsFNdu
         WqGR4PF0/MoFIVZFMLtLk1CByM4oSqdgbdp8tq6t+FdeJFah14ZaECzlmSTYl9/7SJ0i
         y4EAWvs+oZ/yTDwtDMyz9HCiMTPQ8BdefX2RwV3VBp9fhDQ9qeXOz2Qdr6WIyyYU5zU0
         bcsgJiwyvblXD6cW14BJfv//1Ls+VGvi55MHrmukYd/kavHMDKagNUXGm4KKxPrXVuhP
         GRLGZKEJzK7kg18Ni0xIk33lw2ChrFNJW9x6Gz9SfceDLXdLivMR3xuDV01uWzDTHiJk
         cTOQ==
X-Gm-Message-State: AO0yUKVnqn1tCyuakUTKnWBa+Iebdszp2HZJi5/QVH7jOCRRM+jH/m58
        HhyJpGOTn0FuMe1vfoy12sZPmg==
X-Google-Smtp-Source: AK7set9ajQ9uDKbPcAl17QNiFke5xKDK+BOgSt8RK+k4lTC+8vd0IFOxq2KqydCY9etadKicXQYSMA==
X-Received: by 2002:a05:6602:154b:b0:715:f031:a7f5 with SMTP id h11-20020a056602154b00b00715f031a7f5mr4894275iow.1.1676560765660;
        Thu, 16 Feb 2023 07:19:25 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p10-20020a0566022b0a00b006e2f2369d3csm561600iov.50.2023.02.16.07.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:19:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     hch@infradead.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] brd: only preload radix tree if we're using a blocking gfp mask
Date:   Thu, 16 Feb 2023 08:19:17 -0700
Message-Id: <20230216151918.319585-4-axboe@kernel.dk>
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

radix_tree_preload() warns on attempting to call it with an allocation
mask that doesn't allow blocking. While that warning could arguably
be removed, we need to handle radix insertion failures anyway as they
are more likely if we cannot block to get memory.

Remove legacy BUG_ON()'s and turn them into proper errors instead, one
for the allocation failure and one for finding a page that doesn't
match the correct index.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/brd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 1ddada0cdaca..6019ef23344f 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -84,6 +84,7 @@ static int brd_insert_page(struct brd_device *brd, sector_t sector, gfp_t gfp)
 {
 	pgoff_t idx;
 	struct page *page;
+	int ret = 0;
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
@@ -93,7 +94,7 @@ static int brd_insert_page(struct brd_device *brd, sector_t sector, gfp_t gfp)
 	if (!page)
 		return -ENOMEM;
 
-	if (radix_tree_preload(gfp)) {
+	if (gfpflags_allow_blocking(gfp) && radix_tree_preload(gfp)) {
 		__free_page(page);
 		return -ENOMEM;
 	}
@@ -104,8 +105,10 @@ static int brd_insert_page(struct brd_device *brd, sector_t sector, gfp_t gfp)
 	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
 		__free_page(page);
 		page = radix_tree_lookup(&brd->brd_pages, idx);
-		BUG_ON(!page);
-		BUG_ON(page->index != idx);
+		if (!page)
+			ret = -ENOMEM;
+		else if (page->index != idx)
+			ret = -EIO;
 	} else {
 		brd->brd_nr_pages++;
 	}
-- 
2.39.1

