Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2871A45C279
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347814AbhKXN3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348222AbhKXN0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:26:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 970396147F;
        Wed, 24 Nov 2021 12:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758204;
        bh=rOaGVzg/mdFLzlzAh6/QEVhZwSB68nTQZwNTvf77e/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okg64ydW9OFwWXW3xo4lf7Ac80S68oEp5HP8YHfX5HfLx+L10EvfciAiBXoyerz6E
         3u13bcjd34oPkrfsclFoUGJSIwM4bTb7wzJcZXjtvX5r1e/z+anC0brDNbpqCHe9mP
         keU2rCpTVxemk4fTOpufE6C+nDpJIsJBkQOluhrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 092/100] perf/core: Avoid put_page() when GUP fails
Date:   Wed, 24 Nov 2021 12:58:48 +0100
Message-Id: <20211124115657.825335757@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Thelen <gthelen@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6536,7 +6536,6 @@ void perf_output_sample(struct perf_outp
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


