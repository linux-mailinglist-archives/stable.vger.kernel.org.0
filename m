Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64152A51E7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgKCUpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730457AbgKCUpD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72134223C6;
        Tue,  3 Nov 2020 20:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436302;
        bh=shjCMavqrPKyGuQkpKOaFnclbdK2XatE+I1jQD1R5m8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeWcIIdypIRuwqxvBXEskrbgjL34VNzNJu3A5+v4GBsbn8lC7cWxtugXA0Dqb8Dsu
         tFRuaVo5IcT1yACWUllqQFxPL6o5ITPi5V/gYHWkZeJ1mzpnPuVLsLiho1V0qvzt6p
         N8n1K3Qd9qGt8C6R4nhFkNiIKzxovdlTVGDw18fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.9 192/391] perf/x86/amd: Fix sampling Large Increment per Cycle events
Date:   Tue,  3 Nov 2020 21:34:03 +0100
Message-Id: <20201103203359.845949104@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 26e52558ead4b39c0e0fe7bf08f82f5a9777a412 upstream.

Commit 5738891229a2 ("perf/x86/amd: Add support for Large Increment
per Cycle Events") mistakenly zeroes the upper 16 bits of the count
in set_period().  That's fine for counting with perf stat, but not
sampling with perf record when only Large Increment events are being
sampled.  To enable sampling, we sign extend the upper 16 bits of the
merged counter pair as described in the Family 17h PPRs:

"Software wanting to preload a value to a merged counter pair writes the
high-order 16-bit value to the low-order 16 bits of the odd counter and
then writes the low-order 48-bit value to the even counter. Reading the
even counter of the merged counter pair returns the full 64-bit value."

Fixes: 5738891229a2 ("perf/x86/amd: Add support for Large Increment per Cycle Events")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1286,11 +1286,11 @@ int x86_perf_event_set_period(struct per
 	wrmsrl(hwc->event_base, (u64)(-left) & x86_pmu.cntval_mask);
 
 	/*
-	 * Clear the Merge event counter's upper 16 bits since
+	 * Sign extend the Merge event counter's upper 16 bits since
 	 * we currently declare a 48-bit counter width
 	 */
 	if (is_counter_pair(hwc))
-		wrmsrl(x86_pmu_event_addr(idx + 1), 0);
+		wrmsrl(x86_pmu_event_addr(idx + 1), 0xffff);
 
 	/*
 	 * Due to erratum on certan cpu we need


