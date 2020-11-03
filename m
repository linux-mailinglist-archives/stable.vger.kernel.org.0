Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB782A5832
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbgKCUth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731607AbgKCUtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C73A922404;
        Tue,  3 Nov 2020 20:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436576;
        bh=1C8r9xI3AEIUJPKi37mcrxU88njAYtT2vNbfJ4mxwQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VQtO8zZ7B9UfCsRYMy6I/AsU+ZD/IX4d0soDJVreqc5B3skjiUDzVwiBQitxF0iq
         OPAJC0J+1yvzIyu4w88YMsrOxD35n+9vvN0FP1J0jatmqltNUFNWrRV7ph8UurbZjU
         lUs5W3cHuwHAgmofg3aBp7mvrYKks4U3acGOX2Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.9 311/391] ARC: perf: redo the pct irq missing in device-tree handling
Date:   Tue,  3 Nov 2020 21:36:02 +0100
Message-Id: <20201103203408.096030270@linuxfoundation.org>
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

From: Vineet Gupta <vgupta@synopsys.com>

commit 8c42a5c02bec6c7eccf08957be3c6c8fccf9790b upstream.

commit feb92d7d3813456c11dce21 "(ARC: perf: don't bail setup if pct irq
missing in device-tree)" introduced a silly brown-paper bag bug:
The assignment and comparison in an if statement were not bracketed
correctly leaving the order of evaluation undefined.

|
| if (has_interrupts && (irq = platform_get_irq(pdev, 0) >= 0)) {
|                           ^^^                         ^^^^

And given such a chance, the compiler will bite you hard, fully entitled
to generating this piece of beauty:

|
| # if (has_interrupts && (irq = platform_get_irq(pdev, 0) >= 0)) {
|
| bl.d @platform_get_irq  <-- irq returned in r0
|
| setge r2, r0, 0   	<-- r2 is bool 1 or 0 if irq >= 0 true/false
| brlt.d r0, 0, @.L114
|
| st_s	r2,[sp]    	<-- irq saved is bool 1 or 0, not actual return val
| st	1,[r3,160]   	# arc_pmu.18_29->irq <-- drops bool and assumes 1
|
| # return __request_percpu_irq(irq, handler, 0,
|
| bl.d @__request_percpu_irq;
| mov_s	r0,1	   <-- drops even bool and assumes 1 which fails

With the snafu fixed, everything is as expected.

| bl.d @platform_get_irq	<-- returns irq in r0
|
| mov_s	r2,r0
| brlt.d r2, 0, @.L112
|
| st_s	r0,[sp]			<-- irq isaved is actual return value above
| st	r0,[r13,160]	#arc_pmu.18_27->irq
|
| bl.d @__request_percpu_irq	<-- r0 unchanged so actual irq returned
| add r4,r4,r12	#, tmp363, __ptr

Cc: <stable@vger.kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/perf_event.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -562,7 +562,7 @@ static int arc_pmu_device_probe(struct p
 {
 	struct arc_reg_pct_build pct_bcr;
 	struct arc_reg_cc_build cc_bcr;
-	int i, has_interrupts, irq;
+	int i, has_interrupts, irq = -1;
 	int counter_size;	/* in bits */
 
 	union cc_name {
@@ -637,18 +637,27 @@ static int arc_pmu_device_probe(struct p
 		.attr_groups	= arc_pmu->attr_groups,
 	};
 
-	if (has_interrupts && (irq = platform_get_irq(pdev, 0) >= 0)) {
+	if (has_interrupts) {
+		irq = platform_get_irq(pdev, 0);
+		if (irq >= 0) {
+			int ret;
+
+			arc_pmu->irq = irq;
+
+			/* intc map function ensures irq_set_percpu_devid() called */
+			ret = request_percpu_irq(irq, arc_pmu_intr, "ARC perf counters",
+						 this_cpu_ptr(&arc_pmu_cpu));
+
+			if (!ret)
+				on_each_cpu(arc_cpu_pmu_irq_init, &irq, 1);
+			else
+				irq = -1;
+		}
 
-		arc_pmu->irq = irq;
-
-		/* intc map function ensures irq_set_percpu_devid() called */
-		request_percpu_irq(irq, arc_pmu_intr, "ARC perf counters",
-				   this_cpu_ptr(&arc_pmu_cpu));
+	}
 
-		on_each_cpu(arc_cpu_pmu_irq_init, &irq, 1);
-	} else {
+	if (irq == -1)
 		arc_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
-	}
 
 	/*
 	 * perf parser doesn't really like '-' symbol in events name, so let's


