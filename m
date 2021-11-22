Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3CD4593EB
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 18:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbhKVRYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 12:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhKVRYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 12:24:18 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475DFC061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 09:21:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b11-20020a17090acc0b00b001a9179dc89fso12344149pju.6
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 09:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gEt50zHEmIp3U90ueWOdmSaeFiWYINXESWpvUldSyps=;
        b=E8qXv7h/DPwnpoN6Xn9W//SRIfUdgKgMgDydYMuhQgOscIVy9PwO7vhH4SOY0D93v/
         5dJw5V8oYP9qxa0CzF5nzRpUpYl1na+G+Zvuyl2B3kakEMA/iv/x94BHgk6bJFoRNcJu
         m9ikx+xqmK6gvIEZOhRF+xI+ayWzmij5acuFR75taoc+veeW2l+c1cql3id7yaM8B3i0
         ZRrblfHC1cscUGSyA8rwsYnb2Ad2mQWs+ifIUmHjDLLixbIAKRRsZ7ShYwQnB3ud2a/2
         4+ImXFOFGCAghQwBRxVwZ4wvQJ/69lPxZT3DKhmbELz/FWqAoeltqJHhorCr1UFdSjnh
         1/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gEt50zHEmIp3U90ueWOdmSaeFiWYINXESWpvUldSyps=;
        b=dw7jdTOfXXlRsDP1339iay0xAgjt9jw3hoeugFPHjt32mdGVwKim/0RuKx7GaHcWnP
         ccunHQd8yyw159E9qZVRE2i07BNSnxvTfi0FFZKH9eBIefXF6ZOxwqtE5hwugm3ijxs3
         cPTwbJmFvp3OVTxYde0pFMTnhtc2xCjqLd2q8GEma69mm3J5zlMrvd42hIIH4zagorIO
         9zTIN5OO7KfC19CGp2P9B42IT2lDuNGDahKrWyrujMOb49TmIZqZGjacMviMzFJbKVCG
         VG7soeygA8KzvV/U16o0Q4jdVj3fCNlCxVTr2y7huZ1jvEHhZJVxMBvVLL0LxA15YNGb
         PJNg==
X-Gm-Message-State: AOAM530aELmq/QAziOJLCt8m4/byRxjWw27DDyPKGHOfGkG6caUWYdU4
        /OnP8suwlK0YI1Wmg3btB1aTUyvRouZ0f5RVXf4qVpsFhjWA0n/wBC/1+TbLNhu628zTd3r0AEB
        J5s6Q3MBASIkNjAjfl6zU92nRYAhtlNryBEiybvp/+64N/h261ZWsXeTgth4uirP4
X-Google-Smtp-Source: ABdhPJzLZtTXTo/RGQ8f6LfxiHpbagel8pQmklr19TAp7ytYpWEEJaaF6nuebUJREZWrc/zdmeFAew5GGPDR
X-Received: from gthelen2.svl.corp.google.com ([2620:15c:2cd:202:e00:41d2:6dc5:6993])
 (user=gthelen job=sendgmr) by 2002:a17:90b:4c8d:: with SMTP id
 my13mr33890908pjb.107.1637601671608; Mon, 22 Nov 2021 09:21:11 -0800 (PST)
Date:   Mon, 22 Nov 2021 09:18:24 -0800
Message-Id: <20211122171824.1582407-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 4.19] perf/core: Avoid put_page() when GUP fails
From:   Greg Thelen <gthelen@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4716023a8f6a0f4a28047f14dd7ebdc319606b84 upstream.

PEBS PERF_SAMPLE_PHYS_ADDR events use perf_virt_to_phys() to convert PMU
sampled virtual addresses to physical using get_user_page_fast_only()
and page_to_phys().

Some get_user_page_fast_only() error cases return false, indicating no
page reference, but still initialize the output page pointer with an
unreferenced page. In these error cases perf_virt_to_phys() calls
put_page(). This causes page reference count underflow, which can lead
to unintentional page sharing.

Fix perf_virt_to_phys() to only put_page() if get_user_page_fast_only()
returns a referenced page.

Fixes: fc7ce9c74c3ad ("perf/core, x86: Add PERF_SAMPLE_PHYS_ADDR")
Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211111021814.757086-1-gthelen@google.com
[gthelen: manual backport to 4.19]
---
 kernel/events/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4a8c3f5313f9..e6e11b598438 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6424,7 +6424,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 static u64 perf_virt_to_phys(u64 virt)
 {
 	u64 phys_addr = 0;
-	struct page *p = NULL;
 
 	if (!virt)
 		return 0;
@@ -6443,14 +6442,15 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * If failed, leave phys_addr as 0.
 		 */
 		if (current->mm != NULL) {
+			struct page *p;
+
 			pagefault_disable();
-			if (__get_user_pages_fast(virt, 1, 0, &p) == 1)
+			if (__get_user_pages_fast(virt, 1, 0, &p) == 1) {
 				phys_addr = page_to_phys(p) + virt % PAGE_SIZE;
+				put_page(p);
+			}
 			pagefault_enable();
 		}
-
-		if (p)
-			put_page(p);
 	}
 
 	return phys_addr;
-- 
2.34.0.rc2.393.gf8c9666880-goog

