Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0778213DD31
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 15:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgAPOQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 09:16:09 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46881 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgAPOQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 09:16:09 -0500
Received: by mail-pg1-f195.google.com with SMTP id z124so9937975pgb.13;
        Thu, 16 Jan 2020 06:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Eu4Tz2PSHJmrgZ6GXoLAyXHUq4EjuOki9XQQRKCo8U0=;
        b=fulQtMWeJzJQoeci+lVO3hnPUXUa8ii7kCvabmXiar4NzJDT43mfCse0/Cq5/HJ00b
         nVZp7FyBkFWK6cMr0yEj/v7iVyBuqPq/VXo7wPZApgeDIKRUAbpNGEw2m5nYsB9r9Kwf
         O6rpbddcdhUzK17ns5jmEKoD28JwZB2ONzrKXY6XN10dFY2XIa/s48lfZJeFXaICKtX0
         fEBMCQv47qv4SHazvM7oUANXT/pMqGf5247ick38zrO8s5lISUVmIDd+6Ec+J2EqBppF
         WjTdSQ/LQw6jTrddr36hXXBqvmajfwIz0+1G8rusdMdg4ZbHofql3yd2vpNKYZOCus0x
         1XKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Eu4Tz2PSHJmrgZ6GXoLAyXHUq4EjuOki9XQQRKCo8U0=;
        b=lP4cSXE8GwaYuH5/eGVhHI+8+DMtAYeBj8px+CVME8mg5zdPrmXEen4N4Xhsru5XGt
         KyBYV8JCMF77zRRRmaNm+zHLC746rRgl9xFv8ejWJA1qeXf1iU8bMQNeq9e3isV3rP7e
         W24vd2myd6AlJ5JIaUpIIDCllcqhTt+u39xRiccus5jkvtGO0OFy3OPPaA92UKkR0q8R
         4RnJA6px1/3ifCwH7Smb8ZxprHuYmfZP7fdGZU+m8oPkuZYuVy9QFGSap/G/zdnBNwfV
         IQRRIRs6k8+T0SfM3CMGoWzVdYzYK32Euf8Z3udETo8IhdqMitnjBqUfxe0/LhQHB1MA
         7FGA==
X-Gm-Message-State: APjAAAVI8Np7Q9LOAbIQ0/UpW/k8yoRo/pM9GilQJm364d5tC400m1Iz
        KQ6P03ACtrAdaHdy6+KHbHk=
X-Google-Smtp-Source: APXvYqwz7SeoXpxYa1ScTJ8o2BScv8vmoek9x9ZLmDFye72qed8GxzEMtxQTPygrsRaX/O13lPWFxQ==
X-Received: by 2002:a63:bc01:: with SMTP id q1mr41620570pge.442.1579184168288;
        Thu, 16 Jan 2020 06:16:08 -0800 (PST)
Received: from localhost.corp.microsoft.com ([167.220.255.5])
        by smtp.googlemail.com with ESMTPSA id j7sm27576502pgn.0.2020.01.16.06.16.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Jan 2020 06:16:07 -0800 (PST)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, stable@vger.kernel.org
Subject: [PATCH V2] x86/Hyper-V: Balloon up according to request page number
Date:   Thu, 16 Jan 2020 22:16:00 +0800
Message-Id: <20200116141600.23391-1-Tianyu.Lan@microsoft.com>
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
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v2:
    - Change logic of switching alloc_unit from 2MB to 4KB
    in the balloon_up() to avoid redundant iteration when
    handle non-aligned page request.
    - Remove 2MB alignment operation and comment in balloon_up()
---
 drivers/hv/hv_balloon.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 7f3e7ab22d5d..536807efbc35 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1684,7 +1684,7 @@ static unsigned int alloc_balloon_pages(struct hv_dynmem_device *dm,
 	if (num_pages < alloc_unit)
 		return 0;
 
-	for (i = 0; (i * alloc_unit) < num_pages; i++) {
+	for (i = 0; i < num_pages / alloc_unit; i++) {
 		if (bl_resp->hdr.size + sizeof(union dm_mem_page_range) >
 			HV_HYP_PAGE_SIZE)
 			return i * alloc_unit;
@@ -1722,7 +1722,7 @@ static unsigned int alloc_balloon_pages(struct hv_dynmem_device *dm,
 
 	}
 
-	return num_pages;
+	return i * alloc_unit;
 }
 
 static void balloon_up(union dm_msg_info *msg_info)
@@ -1737,9 +1737,6 @@ static void balloon_up(union dm_msg_info *msg_info)
 	long avail_pages;
 	unsigned long floor;
 
-	/* The host balloons pages in 2M granularity. */
-	WARN_ON_ONCE(num_pages % PAGES_IN_2M != 0);
-
 	/*
 	 * We will attempt 2M allocations. However, if we fail to
 	 * allocate 2M chunks, we will go back to PAGE_SIZE allocations.
@@ -1749,14 +1746,13 @@ static void balloon_up(union dm_msg_info *msg_info)
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
@@ -1770,7 +1766,7 @@ static void balloon_up(union dm_msg_info *msg_info)
 		num_ballooned = alloc_balloon_pages(&dm_device, num_pages,
 						    bl_resp, alloc_unit);
 
-		if (alloc_unit != 1 && num_ballooned == 0) {
+		if (alloc_unit != 1 && num_ballooned != num_pages) {
 			alloc_unit = 1;
 			continue;
 		}
-- 
2.14.5

