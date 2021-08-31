Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E259C3FC727
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 14:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241968AbhHaMPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 08:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241852AbhHaMPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 08:15:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB54C03548A;
        Tue, 31 Aug 2021 05:07:47 -0700 (PDT)
Date:   Tue, 31 Aug 2021 12:07:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1630411665;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOu1lT8p5JIR/YFvIDz1elV3e0260+GL41AX8UZe44E=;
        b=4zlRusccqnXAwRcU1BNYEMdAWOAGi8e8NLIo/1hxliySprVP/0+MaRAzzmJdGTAdWUhs5I
        VDEMeo+GJ76XF8Mbze0zjZc1xAv/bM88rc9/0SPLBf5Qlm1SWJi1++sEdiQGf+s+wCLAdv
        rK8y5irKmwdMeFGnrl1kMqsMfKi3qpQNRAHohuSpF3hy8Yw7a6g1NmW8F0E3jqA4/cCN5a
        jlrcdm1rl3jwqzY02jLfkXzL0HfiKW2z18DNsJKTq/Alr+/v3Odmk0AdDQDwoOIrLxAv1I
        VsT7q3YzmbEADXBCjS85mcl5IZ3YdgQZzJC4WZz2g4TZKH2K+lub6C43Rj5fxA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1630411665;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOu1lT8p5JIR/YFvIDz1elV3e0260+GL41AX8UZe44E=;
        b=/AR/lM07XsZjR5TtRJVgXAE0Bspdz/JjqLtJFCYTfIdGeozWH3zeFJ7TL1FiSAeNaHaaEN
        G22ZCSaI9nIsfMDg==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel/uncore: Fix Intel ICX IIO event constraints
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1629991963-102621-4-git-send-email-kan.liang@linux.intel.com>
References: <1629991963-102621-4-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <163041166418.25758.3528483172435513308.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     f42e8a603c88f72bf047a710b9fc1d3579f31e71
Gitweb:        https://git.kernel.org/tip/f42e8a603c88f72bf047a710b9fc1d3579f31e71
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Thu, 26 Aug 2021 08:32:39 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Tue, 31 Aug 2021 13:59:36 +02:00

perf/x86/intel/uncore: Fix Intel ICX IIO event constraints

According to the latest uncore document, both NUM_OUTSTANDING_REQ_OF_CPU
(0x88) event and COMP_BUF_OCCUPANCY(0xd5) event also have constraints. Add
them into the event constraints table.

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1629991963-102621-4-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/uncore_snbep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index ea29e89..d941854 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5076,8 +5076,10 @@ static struct event_constraint icx_uncore_iio_constraints[] = {
 	UNCORE_EVENT_CONSTRAINT(0x02, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x03, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x83, 0x3),
+	UNCORE_EVENT_CONSTRAINT(0x88, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0xc0, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0xc5, 0xc),
+	UNCORE_EVENT_CONSTRAINT(0xd5, 0xc),
 	EVENT_CONSTRAINT_END
 };
 
