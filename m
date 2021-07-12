Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB873C5602
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351122AbhGLIND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhGLIKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C3D8613E6;
        Mon, 12 Jul 2021 08:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626077250;
        bh=oINRDXEbonTGwhQVPZYckE009Hkz2205CmXRQ/QamCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcecmKaLqUMm/wjXiHQ/c2M7IE9ZxWS99hazntSiIvybDKpDE9f5HpJUyj4Ix1eY5
         XGu6TFUhFUHZ9uIbcze4/BV05cuxaT+NiEXSshXzKaMAVwu2kZakMyN7N7v1SCEZAy
         /oKApPZYuXXoAbTcZCrOmax2XD8zQZqIS8vkws/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yasin, Ahmad" <ahmad.yasin@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.13 116/800] perf/x86/intel: Fix instructions:ppp support in Sapphire Rapids
Date:   Mon, 12 Jul 2021 08:02:19 +0200
Message-Id: <20210712060929.280776310@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 1d5c7880992a06679585e7e568cc679c0c5fd4f2 upstream.

Perf errors out when sampling instructions:ppp.

$ perf record -e instructions:ppp -- true
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument)
for event (instructions:ppp).

The instruction PDIR is only available on the fixed counter 0. The event
constraint has been updated to fixed0_constraint in
icl_get_event_constraints(). The Sapphire Rapids codes unconditionally
error out for the event which is not available on the GP counter 0.

Make the instructions:ppp an exception.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Reported-by: Yasin, Ahmad <ahmad.yasin@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1624029174-122219-4-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4032,8 +4032,10 @@ spr_get_event_constraints(struct cpu_hw_
 	 * The :ppp indicates the Precise Distribution (PDist) facility, which
 	 * is only supported on the GP counter 0. If a :ppp event which is not
 	 * available on the GP counter 0, error out.
+	 * Exception: Instruction PDIR is only available on the fixed counter 0.
 	 */
-	if (event->attr.precise_ip == 3) {
+	if ((event->attr.precise_ip == 3) &&
+	    !constraint_match(&fixed0_constraint, event->hw.config)) {
 		if (c->idxmsk64 & BIT_ULL(0))
 			return &counter0_constraint;
 


