Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FF23B285D
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 09:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhFXHMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 03:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhFXHMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 03:12:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C08C061756;
        Thu, 24 Jun 2021 00:09:47 -0700 (PDT)
Date:   Thu, 24 Jun 2021 07:09:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624518586;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fMqOhdk1olr8dGwvNoq8Rvnxa5eJ80RxJU+yQQuLjZg=;
        b=ILyXkEwveW9tOjp09gNvn2vK4wqKP4EjJ59JAZQajiTdzUCItNJ6sB1A21Hpkxt9V3TiHe
        vTYq/1cVWbeGmevjrRTkdKvYEXvARj13WgwFFO0P1E4RLEZSJG59u+AVkz4vEmr6V5LWc7
        yLcrJfNfAy1Lt8n4QW+pbOMJgCUkh9iU+bKhAMLm0JJxu/2g2ZaDFNzYT8Bq1JdWjZch9h
        mU6d8MUvEMKoSZtFFOl+6QpGMCdYrxBjFDIV1pZmL/uUnIbttMFdO0eWFdo2yFh/mnFP7m
        r/OZA/AW6yYQIUV6r2dScOcrWBBH1sxTW/yZ3KKX6FJcCmK8WEKPywUlbusJTg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624518586;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fMqOhdk1olr8dGwvNoq8Rvnxa5eJ80RxJU+yQQuLjZg=;
        b=/M+/TIv2H4pNia7J0PP7UVCXgjZc1csnJLttJJ1BDzzI10RpSHW6+VA0LhZ5rW9/s00l2L
        s0vY821I2reP5iCA==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel: Fix instructions:ppp support in
 Sapphire Rapids
Cc:     "Yasin, Ahmad" <ahmad.yasin@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1624029174-122219-4-git-send-email-kan.liang@linux.intel.com>
References: <1624029174-122219-4-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <162451858575.395.8356666893270560379.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     1d5c7880992a06679585e7e568cc679c0c5fd4f2
Gitweb:        https://git.kernel.org/tip/1d5c7880992a06679585e7e568cc679c0c5fd4f2
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Fri, 18 Jun 2021 08:12:54 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 23 Jun 2021 18:30:55 +02:00

perf/x86/intel: Fix instructions:ppp support in Sapphire Rapids

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
---
 arch/x86/events/intel/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index e442b55..e355db5 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4032,8 +4032,10 @@ spr_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
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
 
