Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E183413A235
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 08:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgANHot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 02:44:49 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38925 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbgANHot (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 02:44:49 -0500
Received: by mail-pf1-f193.google.com with SMTP id q10so6173298pfs.6;
        Mon, 13 Jan 2020 23:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ji4/GGpTpCHtZjwRvAzGm3fytTn1eM1/uYYEuqSMvlo=;
        b=V7KEAGOqYjfGtkT+aweWULgGvMOzq6GY5wvsDR1sJdb64//nhwfaSD0nOvGnCLEjl2
         0KPkZx6/HX96zUi+9gxvqP5LwKvkIs5UfgdB8qCsGkaBClX/eqik4m7nYTYdoWz1D0Vw
         pNOg/HJuG7UUFBMV6O8o73HCTlMrhBq07//BJdsnfXERnQ5bnfooehnVtlCTB9EOjLIx
         aPqNfPG2EdrmsmDWPJaVQybqDQ9x0YymC5mSFSZuyqwPKmO0SuWKXAlcaSZSz7Hvd4AE
         a6mLXqGH7cdyVKn1hiLPmbTAG7lYKIcL4xlUu1mJjSCnjNZxHmGGHQKbMY7+Cv5For94
         LxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ji4/GGpTpCHtZjwRvAzGm3fytTn1eM1/uYYEuqSMvlo=;
        b=bF3PrXUh0+4TCWH0Gl+nbNRu8TeYARjKqXknAbgk8RDt9hkhm08GfPFLOPnsNbUeTz
         xS/D1uuiPUtHJNN/Pgtea2/UvtlWIXf2WNXEmt/xdlTiO3wwGj+EmZSVuzCf1KifwBLd
         WX7sh7kDp9bBlvsJ9DzWR9ADAcX44Do83FCgM14hQIaqfEHwEUld1YvwzgDvPrL6WMb0
         zmh1wU7xffoIa8j3y6yt/MrvgAntGqkvaM+oOR0mCAPHutGtDidZKuFWqRgIW5X2aGcg
         5MvXk0NeeGPpMpvzb2uvYsLJT7q0rMZ0aaGREoN00ijKQdPzZig41sVw6wTGxIydEry2
         kAyw==
X-Gm-Message-State: APjAAAXxkTLvOle9AvtEfE6Rdmyfxp+Lw/ZEkpCchZ3nwXnamgITqqzd
        BnqIw/NiMYN3gwJmeiYNXBQ=
X-Google-Smtp-Source: APXvYqyR5qwh+EUVMQkFPgPEHQisjOpHIgs/mjN2cccTS/mUHiwuYt7H2FWIoKBjBCSftyqoVQPsNg==
X-Received: by 2002:aa7:9808:: with SMTP id e8mr24349821pfl.32.1578987888490;
        Mon, 13 Jan 2020 23:44:48 -0800 (PST)
Received: from localhost.corp.microsoft.com ([167.220.255.5])
        by smtp.googlemail.com with ESMTPSA id k3sm16350745pgc.3.2020.01.13.23.44.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Jan 2020 23:44:47 -0800 (PST)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        akpm@linux-foundation.org, michael.h.kelley@microsoft.com,
        decui@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-mm@kvack.org, vkuznets@redhat.com, stable@vger.kernel.org
Subject: [PATCH] x86/Hyper-V: Balloon up according to request page number
Date:   Tue, 14 Jan 2020 15:44:35 +0800
Message-Id: <20200114074435.12732-1-Tianyu.Lan@microsoft.com>
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
 drivers/hv/hv_balloon.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 7f3e7ab22d5d..38ad0e44e927 100644
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
-- 
2.14.5

