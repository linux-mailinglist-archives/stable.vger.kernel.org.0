Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BCB3FC71A
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 14:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhHaMMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 08:12:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58282 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbhHaMIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 08:08:45 -0400
Date:   Tue, 31 Aug 2021 12:07:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630411665;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qDigqgPV8yJfOxz472ODUDU1mq4m8aPF67p9mgA9Oyg=;
        b=MZUuZ9Trl8jabv91dQY0FB1SJ/cHxQ2tAl6NUdaCUYGWghS7gpjTytDHo/L4XmIF9MxEyY
        VenoFG+QmVh4y5WQxeGpInyEiX6KuQbrVVp2a0QWZlPMwA29tvNaVQqa8RdGdFMKgapBVN
        rW8Qoj4o55ckv+ahlAOQzi7Vh559VrBLBsw69BiFW0IYVA9yfmpxvJaNWM0zdHroGbz5AS
        akr88RKf1T4rV4UvlO76LKVzqhbXqrKjJ2BbuIA4uUHJ+prsTPRBJzmhvRFgfCz4fDgHXR
        hJBK+k3LexgIQKGB4s2Huo2nfwxLzVHlGRlASaapqvj/CK0H/bl5LqOu1VaErQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630411665;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qDigqgPV8yJfOxz472ODUDU1mq4m8aPF67p9mgA9Oyg=;
        b=/5AZ/nCINPCGgx/JDw+crPfF4mYhZ08RHL/gfejNSolnDu/rfKgFSpTx9Hhlg+Bwqc6D9n
        blW2LosaK4vxPUAg==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel/uncore: Fix invalid unit check
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1629991963-102621-3-git-send-email-kan.liang@linux.intel.com>
References: <1629991963-102621-3-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <163041166497.25758.760980443983936282.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     e2bb9fab08cbcc7922050c7eb0bd650807abfa4e
Gitweb:        https://git.kernel.org/tip/e2bb9fab08cbcc7922050c7eb0bd650807abfa4e
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Thu, 26 Aug 2021 08:32:38 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 31 Aug 2021 13:59:35 +02:00

perf/x86/intel/uncore: Fix invalid unit check

The uncore unit with the type ID 0 and the unit ID 0 is missed.

The table3 of the uncore unit maybe 0. The
uncore_discovery_invalid_unit() mistakenly treated it as an invalid
value.

Remove the !unit.table3 check.

Fixes: edae1f06c2cd ("perf/x86/intel/uncore: Parse uncore discovery tables")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1629991963-102621-3-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/uncore_discovery.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_discovery.h b/arch/x86/events/intel/uncore_discovery.h
index 7280c8a..6d73561 100644
--- a/arch/x86/events/intel/uncore_discovery.h
+++ b/arch/x86/events/intel/uncore_discovery.h
@@ -30,7 +30,7 @@
 
 
 #define uncore_discovery_invalid_unit(unit)			\
-	(!unit.table1 || !unit.ctl || !unit.table3 ||	\
+	(!unit.table1 || !unit.ctl || \
 	 unit.table1 == -1ULL || unit.ctl == -1ULL ||	\
 	 unit.table3 == -1ULL)
 
