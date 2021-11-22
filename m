Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710BD4593DD
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 18:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhKVRVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 12:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbhKVRVv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 12:21:51 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAC3C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 09:18:44 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id d27-20020a25addb000000b005c2355d9052so28817752ybe.3
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 09:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SNHJzc5YkzTSy6pFZ2owaRtyi4nMc4RVazCgbt76sDQ=;
        b=T2Pq40oW1IFyVohwxPSKakohpMUifrBHHONigGq1YVWeSBoJSNYvYQxYXcaLuYHp6C
         hyI7vf7NVmxhWvkNqUISBNew+Yl8VX6+QKxo+BCf4JdNx55kMM8hmPnTGIVY6+Ommttu
         DrUqhNe+UVmMIIjMeJi0pm6rFXchRDxW9JmI0LGr/FgoNAUDwNb4WfQVxsPF5apP7pzb
         i68fzKl9lZvquHOw8iTeFo7sI/2NXy5uFJlJDCNulTEkICj3sJELWlLzRcnky3DzFISm
         oXz+jFmUsDZlT9EwxyGOChqrfPv7LUMPpM+gYLJcujagag3fS6K9bdHlzMYo1vWXnG37
         Qykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SNHJzc5YkzTSy6pFZ2owaRtyi4nMc4RVazCgbt76sDQ=;
        b=oscwFIv7RX7wmCtjdTdwl+o1fOLjPFH/8FSNdY9LGrLcWOwEfD/mrQlx/p/hTZ8+/t
         iuMT28YApRPDINytrXeKMsuvSLFGu6nT4Wpr1mPfeWJTEBhHcJ8YPPhr6Xw3pcLsbvtf
         7gvdhHfmw71COj9cpGg7JLV5wpmqNvblssdHa75qxV1b8xuM3wxJRiaLpjVUH9MwF/I4
         Um76wZOs0P+gShkIporF0Lq3bsQfG5US4KAMTxkxIdJI7vtTydljI0IDsPO4SftEFHok
         VJTyiRfObwKLDt7X34tuOPnHazj/KY3U4LrCz2OmIEKGjrEVzQd9/DqOQ/JqzlV+uesX
         VKRw==
X-Gm-Message-State: AOAM530QrvuXIk8FO68SC76h0qNtEW5etUxqHP+ZHlzcxJiJMfkPKGFz
        lR1y8gPiP5rjCm6j8MY8dgkhi/Ier2MtYThyYFJnKgzVVNVFV76bh9mq5xNXRzl2VE3y1uNzCug
        4riYy6eGFQj+jW1uvwQj9wQFLuLxvO5PtwkaN8dKHybvNFXGw2oguFtMPeM6ERYll
X-Google-Smtp-Source: ABdhPJwVzPwPYRL7lKLsAL2zQIzqXWHJ9uAfOi3U2AStVupH/Ja9zEmWJOWJ9wNunWOUE9nRbvBnKbJejHuQ
X-Received: from gthelen2.svl.corp.google.com ([2620:15c:2cd:202:e00:41d2:6dc5:6993])
 (user=gthelen job=sendgmr) by 2002:a25:3841:: with SMTP id
 f62mr69133897yba.446.1637601524119; Mon, 22 Nov 2021 09:18:44 -0800 (PST)
Date:   Mon, 22 Nov 2021 09:18:18 -0800
Message-Id: <20211122171818.1582357-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 5.4] perf/core: Avoid put_page() when GUP fails
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
[gthelen: manual backport to 5.4]
---
 kernel/events/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1993a741d2dc..6ffe3d3e7b06 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6536,7 +6536,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 static u64 perf_virt_to_phys(u64 virt)
 {
 	u64 phys_addr = 0;
-	struct page *p = NULL;
 
 	if (!virt)
 		return 0;
@@ -6555,14 +6554,15 @@ static u64 perf_virt_to_phys(u64 virt)
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

