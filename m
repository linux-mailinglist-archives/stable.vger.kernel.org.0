Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5F94593EF
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 18:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbhKVRYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 12:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237615AbhKVRYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 12:24:23 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB4CC061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 09:21:16 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id mv1-20020a17090b198100b001a67d5901d2so12343076pjb.7
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 09:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=p99lqcDcUt23Cte2C2AlGFeMfydTi+ddAcgMRKWUNSk=;
        b=cOup7RKNNJopbTuekXMwAMKymLmWdUQISZSrKpSWLgLGZ+Y1C1ukQv3/d8EoiHt0oN
         WORGIgGnKI5FABEx+iOF/FuQlIM1V9Xun/Hd0x+bCKGwF8xDE4cIuXyJBPVTX4hrkBgp
         cah3i33xtigWaHi9gfw5vENVsdwWMBf8SZcUxdoZfekCDeVMNSuuq/jPRZjGxQuLA25d
         gkxe84xgFjyB3LikAyharBNeEVNWUUVzNEyODrXddhHfA/VIwWI6rGOelmMIMtVuc/7G
         tt287lbkkCpjXvhg/DWymTblrd71HwRbNKmm1ChB419NJ7p8lfLi7EPSM75ANXeiD+R5
         IleQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=p99lqcDcUt23Cte2C2AlGFeMfydTi+ddAcgMRKWUNSk=;
        b=lDFC+z6XTMUuf/yDEbj3qeXeJ2R5B3EjIjzi2UwmVtWtQ9ZNY9xxkD5pJZ85PfkuQ8
         g7Fsz/FwddRIwlIcCmE4KX2ryCmgH6CAlqJZ+8btmHTQ1gDhev6PLiCDOm0S0w6WDxfo
         HgkBrrNyQDQpO0nK96eAsX3jsKpaY+JNDwnjrJU+Fj0q++mVL5+4dsyM9K7DNejtUpZS
         cdFfe5DY/0gZydBccZb+UKXyJPvoT+4egWtx/cK/sbBvHlYHmwT3p3+0VXKQPyzUha+t
         gLxyVhzTC4G/gl7aDArGV0OR2XMV+NU+/SCDTfO+osMzLUD/nz0pBQBBxIiZ9qI3u84s
         +FuA==
X-Gm-Message-State: AOAM532d6D3/xOMDhBqgXtbWvdLfTEImArQMsd/DA3MQGwJ0SBzX9LHM
        dNQy3nuO2b6m74m/2CnqHrERmFQl/XJZGXUa6c4mj995ZeizFj+PCcm2IS0EiwvkbtoRtIrLNTd
        1eKsoLi7ryGonSwdxwOhRZYSBmVsS+hujeY5Aa7aWKI+sdowvE3Cs9RGl4IUFZrkj
X-Google-Smtp-Source: ABdhPJzfl7I2+BZfPhdadJWVG9zPSP+sNM04Ilki5jnoI1JJo07JsQzDelujpz4F993y8ygUPCaYRRh4PWyS
X-Received: from gthelen2.svl.corp.google.com ([2620:15c:2cd:202:e00:41d2:6dc5:6993])
 (user=gthelen job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr8448pjf.1.1637601675114; Mon, 22 Nov 2021 09:21:15 -0800 (PST)
Date:   Mon, 22 Nov 2021 09:18:25 -0800
Message-Id: <20211122171825.1582436-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 4.14] perf/core: Avoid put_page() when GUP fails
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
[gthelen: manual backport to 4.14]
---
 kernel/events/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 236e7900e3fc..0736508d595b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6110,7 +6110,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 static u64 perf_virt_to_phys(u64 virt)
 {
 	u64 phys_addr = 0;
-	struct page *p = NULL;
 
 	if (!virt)
 		return 0;
@@ -6129,14 +6128,15 @@ static u64 perf_virt_to_phys(u64 virt)
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

