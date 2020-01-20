Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8B011425F3
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 09:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgATIl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 03:41:59 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41353 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgATIl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 03:41:59 -0500
Received: by mail-pf1-f194.google.com with SMTP id w62so15496307pfw.8;
        Mon, 20 Jan 2020 00:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EY2MDrWinifj7MCYl+z9onO507BA337ICgHM373gFUM=;
        b=Z7EBYI7cGAGA0LYnhxJIxhm/AmdmvJcGkWQq574+rFyxqNkfBdMKlvg3XRDucT9lDw
         VKeKbh6jGZQITq2/U9J9nZlRt46Q2DkCNszl1H84XpL/jU3DmIV4ILkDJWUN+cR+h+tX
         454yTWc2UCPCQZF8BveHA7fAtaRxocpvYMzZ53KD/f9/EI5OT7zrqvy17LXyhJSxowgj
         n1OYXtTmyfs8j6ob6+g6vP7stIG8Ge4Wq1ZFHB9Ddu3aDge2kzF+9nvh2eG74lo3sJ4c
         YCOzTuI+79p621ggW2j9MS4d1gALEgDL8NcMRJp7blkpCdudhr4IdpX+KfrsGK57JHAZ
         SBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EY2MDrWinifj7MCYl+z9onO507BA337ICgHM373gFUM=;
        b=Ch4wpI8JQPxyduY99HJjWY5eI+keETNiq1qA31R8hhdzWdPDze46w58e6+HBrkKDSC
         yAstAmeVUU/A7xSpCsXCT8DbAVcfp4j6wWpK6wZc4SE9HxmRToXPxDUDLJNlFVbYUOEP
         hQ/n190AJgrLDCZyuDJeD3QM7iuOGagDanlG+pxtzs/rLg20QRh82O0cC1kfixqD8urM
         G6koHTXmBUDy3gmfTPcq9syCtfXHWJ7bG+ADlFulrZaXCcQtEzXGpM+G0Q0ui0pNQa8o
         UnMup2GcN2uO66qw6BwitTrqPMZ/BnxojgfKqwqRhjcRt2StzJNDkqSfKVsogvmMe7pr
         DqYw==
X-Gm-Message-State: APjAAAV2QyKYQvp+peHZWfuZ/ILKINBBiRNHX7fvZQMmnCbglK+sEJMK
        SihbrvsOgNpx/zLO4Q87hh8=
X-Google-Smtp-Source: APXvYqxwN4NmF5om54ObzIn0da84s6+Cyh5NURt5Vp0Y16BCtacyYQlsdnCyq8yJyYKlGCCT3NHdJQ==
X-Received: by 2002:a63:5062:: with SMTP id q34mr58778067pgl.378.1579509718742;
        Mon, 20 Jan 2020 00:41:58 -0800 (PST)
Received: from localhost.corp.microsoft.com ([167.220.255.5])
        by smtp.googlemail.com with ESMTPSA id z6sm38259693pfa.155.2020.01.20.00.41.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Jan 2020 00:41:58 -0800 (PST)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, stable@vger.kernel.org
Subject: [PATCH V3] x86/Hyper-V: Balloon up according to request page number
Date:   Mon, 20 Jan 2020 16:41:49 +0800
Message-Id: <20200120084149.4791-1-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Current code has assumption that balloon request memory size aligns
with 2MB. But actually Hyper-V doesn't guarantee such alignment. When
balloon driver receives non-aligned balloon request, it produces warning
and balloon up more memory than requested in order to keep 2MB alignment.
Remove the warning and balloon up memory according to actual requested
memory size.

Fixes: f6712238471a ("hv: hv_balloon: avoid memory leak on alloc_error of 2MB memory block")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v2:
    - Remove check between request page number and alloc_unit
    in the alloc_balloon_pages() because it's redundant with
    new change.
    - Remove the "continue" just follwoing alloc_unit switch
     from 2MB to 4K in order to avoid skipping allocated
     memory.

Change since v1:
    - Change logic of switching alloc_unit from 2MB to 4KB
    in the balloon_up() to avoid redundant iteration when
    handle non-aligned page request.
    - Remove 2MB alignment operation and comment in balloon_up()
---
 drivers/hv/hv_balloon.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 7f3e7ab22d5d..73092a7a3345 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1681,10 +1681,7 @@ static unsigned int alloc_balloon_pages(struct hv_dynmem_device *dm,
 	unsigned int i, j;
 	struct page *pg;
 
-	if (num_pages < alloc_unit)
-		return 0;
-
-	for (i = 0; (i * alloc_unit) < num_pages; i++) {
+	for (i = 0; i < num_pages / alloc_unit; i++) {
 		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
 			HV_HYP_PAGE_SIZE)
 			return i * alloc_unit;
@@ -1722,7 +1719,7 @@ static unsigned int alloc_balloon_pages(struct hv_dynmem_device *dm,
 
 	}
 
-	return num_pages;
+	return i * alloc_unit;
 }
 
 static void balloon_up(union dm_msg_info *msg_info)
@@ -1737,9 +1734,6 @@ static void balloon_up(union dm_msg_info *msg_info)
 	long avail_pages;
 	unsigned long floor;
 
-	/* The host balloons pages in 2M granularity. */
-	WARN_ON_ONCE(num_pages % PAGES_IN_2M != 0);
-
 	/*
 	 * We will attempt 2M allocations. However, if we fail to
 	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
@@ -1749,14 +1743,13 @@ static void balloon_up(union dm_msg_info *msg_info)
 	avail_pages = si_mem_available();
 	floor = compute_balloon_floor();
 
-	/* Refuse to balloon below the floor, keep the 2M granularity. */
+	/* Refuse to balloon below the floor. */
 	if (avail_pages < num_pages || avail_pages - num_pages < floor) {
 		pr_warn("Balloon request will be partially fulfilled. %s\n",
 			avail_pages < num_pages ? "Not enough memory." :
 			"Balloon floor reached.");
 
 		num_pages = avail_pages > floor ? (avail_pages - floor) : 0;
-		num_pages -= num_pages % PAGES_IN_2M;
 	}
 
 	while (!done) {
@@ -1770,10 +1763,8 @@ static void balloon_up(union dm_msg_info *msg_info)
 		num_ballooned = alloc_balloon_pages(&dm_device, num_pages,
 						    bl_resp, alloc_unit);
 
-		if (alloc_unit != 1 && num_ballooned == 0) {
+		if (alloc_unit != 1 && num_ballooned != num_pages)
 			alloc_unit = 1;
-			continue;
-		}
 
 		if (num_ballooned == 0 || num_ballooned == num_pages) {
 			pr_debug("Ballooned %u out of %u requested pages.\n",
-- 
2.14.5

