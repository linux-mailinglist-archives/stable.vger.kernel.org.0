Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE53359BC23
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 11:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiHVJAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 05:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiHVJAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 05:00:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763832A71C;
        Mon, 22 Aug 2022 02:00:52 -0700 (PDT)
Date:   Mon, 22 Aug 2022 09:00:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661158851;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZouUrPOncH1yw5J1KAjxZC5rf+rfNbJaQtGZIx1R+vw=;
        b=cnik6+fE0eNnwUhMVGUouvaVHXC9kw8wNDg/KHpKVbeR812De0CnwxnVrKeXNV85hsSP/R
        cFUDeNCNOOJ75pJQVJHZCpwlTiVVNP27SWLXRJmAJCmW/bpu6BkzsvbjjcWpjqHI+9VidZ
        plf5zkzi0KnwoHpG4Tt/m84TfMXNTcQzX+nDxU9Vck5jqocQXlphvFHPjwa/UiwdzrpYdP
        sGZe1HTz116t6OZV4083r2+qsjaCB0snc6RV8aONhKCNq9+Ky/wsrP9oANICsj3lo0GFa7
        H4ahyGrl6g3YFWcZn4hfbTASFxbSVPx7kC8qmFYsESxQUDAQqXkej6oYCLmvEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661158851;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZouUrPOncH1yw5J1KAjxZC5rf+rfNbJaQtGZIx1R+vw=;
        b=+8fioaatoVON5hNpnFDOMlKwrvC3LxjDYuQqBbyJCpn3NFTtYeiav6ddVGS4JuBqCThBII
        3onjIinXSDU/pWAw==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf/x86/intel: Fix pebs event constraints for ADL
Cc:     Ammy Yi <ammy.yi@intel.com>, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220818184429.2355857-1-kan.liang@linux.intel.com>
References: <20220818184429.2355857-1-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <166115884946.401.5531726230002276797.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     cde643ff75bc20c538dfae787ca3b587bab16b50
Gitweb:        https://git.kernel.org/tip/cde643ff75bc20c538dfae787ca3b587bab16b50
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Thu, 18 Aug 2022 11:44:29 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Fri, 19 Aug 2022 19:47:31 +02:00

perf/x86/intel: Fix pebs event constraints for ADL

According to the latest event list, the LOAD_LATENCY PEBS event only
works on the GP counter 0 and 1 for ADL and RPL.

Update the pebs event constraints table.

Fixes: f83d2f91d259 ("perf/x86/intel: Add Alder Lake Hybrid support")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20220818184429.2355857-1-kan.liang@linux.intel.com
---
 arch/x86/events/intel/ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index e5b5874..de1f55d 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -830,7 +830,7 @@ struct event_constraint intel_glm_pebs_event_constraints[] = {
 
 struct event_constraint intel_grt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
-	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0xf),
+	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
 	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0xf),
 	EVENT_CONSTRAINT_END
 };
