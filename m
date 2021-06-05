Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D3839C556
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 05:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhFEDDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 23:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhFEDDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 23:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFCF2613F4;
        Sat,  5 Jun 2021 03:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622862072;
        bh=5Glz9eV9ywxNKU5L2Ppl13Cqd/TaZRXGBw4LPAe1YCI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=s5Nuh6uRQcJ7kkWtdssPcHdR3r7gXqNv0JNFp5Hfb6om5JWXKU7jW06oRACTIyLTx
         5Nqpni+pFZy77evRCNskaPmnD5kF6kWZmfSgCL3jfmmzNmmK7tzt1p6xUpekUDPt2y
         Es1oCbfbIV6NueInMWaOsuaVzOIj3J8RJuNu9Kws=
Date:   Fri, 04 Jun 2021 20:01:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, David.Laight@ACULAB.COM,
        dvyukov@google.com, elver@google.com, glider@google.com,
        hdanton@sina.com, linux-mm@kvack.org, mgorman@suse.de,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 02/13] kfence: use TASK_IDLE when awaiting
 allocation
Message-ID: <20210605030111.zE60Ybm3T%akpm@linux-foundation.org>
In-Reply-To: <20210604200040.d8d0406caf195525620c0f3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kfence: use TASK_IDLE when awaiting allocation

Since wait_event() uses TASK_UNINTERRUPTIBLE by default, waiting for an
allocation counts towards load.  However, for KFENCE, this does not make
any sense, since there is no busy work we're awaiting.

Instead, use TASK_IDLE via wait_event_idle() to not count towards load.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1185565
Link: https://lkml.kernel.org/r/20210521083209.3740269-1-elver@google.com
Fixes: 407f1d8c1b5f ("kfence: await for allocation using wait_event")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>	[5.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kfence/core.c~kfence-use-task_idle-when-awaiting-allocation
+++ a/mm/kfence/core.c
@@ -627,10 +627,10 @@ static void toggle_allocation_gate(struc
 		 * During low activity with no allocations we might wait a
 		 * while; let's avoid the hung task warning.
 		 */
-		wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
-				   sysctl_hung_task_timeout_secs * HZ / 2);
+		wait_event_idle_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
+					sysctl_hung_task_timeout_secs * HZ / 2);
 	} else {
-		wait_event(allocation_wait, atomic_read(&kfence_allocation_gate));
+		wait_event_idle(allocation_wait, atomic_read(&kfence_allocation_gate));
 	}
 
 	/* Disable static key and reset timer. */
_
