Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2932E3E55
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503936AbgL1O1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503304AbgL1OZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54BBA20715;
        Mon, 28 Dec 2020 14:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165536;
        bh=pY0itU/xOz4MGKhhC9FFmTZzOSMxhay0JtAGkES93VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDU+JGceMZswQlo6TUGZ5S/Xbhxtgfamu9z8z9rzSTs2y65i4Ib0+qd85ZixWrq0K
         R3aO8AlxG/XkUHJZSj6D6el2gcgkVgayI6ExBaxr2NgETsJ/G1FuYjuliL1tlujjX2
         rh9hv93x7SByJJc/yKDOKjSeAZEAxbzb8ZUPGdaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 566/717] perf/x86/intel: Add event constraint for CYCLE_ACTIVITY.STALLS_MEM_ANY
Date:   Mon, 28 Dec 2020 13:49:24 +0100
Message-Id: <20201228125048.029549742@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 306e3e91edf1c6739a55312edd110d298ff498dd upstream.

The event CYCLE_ACTIVITY.STALLS_MEM_ANY (0x14a3) should be available on
all 8 GP counters on ICL, but it's only scheduled on the first four
counters due to the current ICL constraint table.

Add a line for the CYCLE_ACTIVITY.STALLS_MEM_ANY event in the ICL
constraint table.
Correct the comments for the CYCLE_ACTIVITY.CYCLES_MEM_ANY event.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201019164529.32154-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -257,7 +257,8 @@ static struct event_constraint intel_icl
 	INTEL_EVENT_CONSTRAINT_RANGE(0x48, 0x54, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0x60, 0x8b, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_TOTAL */
-	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_MEM_ANY */
+	INTEL_UEVENT_CONSTRAINT(0x10a3, 0xff),  /* CYCLE_ACTIVITY.CYCLES_MEM_ANY */
+	INTEL_UEVENT_CONSTRAINT(0x14a3, 0xff),  /* CYCLE_ACTIVITY.STALLS_MEM_ANY */
 	INTEL_EVENT_CONSTRAINT(0xa3, 0xf),      /* CYCLE_ACTIVITY.* */
 	INTEL_EVENT_CONSTRAINT_RANGE(0xa8, 0xb0, 0xf),
 	INTEL_EVENT_CONSTRAINT_RANGE(0xb7, 0xbd, 0xf),


