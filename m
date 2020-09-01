Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057C22595E4
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbgIAP5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731793AbgIAPon (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7464206EB;
        Tue,  1 Sep 2020 15:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975082;
        bh=jQ+lvqk8m21u94r+IH23YkPMdq4xCdiRLIOoDC8ASpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkT4ryxyHhP0md8Ob6jP7ZEKbiOiUQyR10BQ4INfYVdHoTTuKmEZBv0UQv0tNU5X5
         Lr6P4vRfcTBpTNA/eJ9vHNB2fXtw9ONn3gcUAkWtC12OlSbq68evGZ12I8QG3NsQzT
         qmTplpk75/yjU18ONJgyKwmgW5l5rrtqpAVI46lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.8 202/255] powerpc/perf: Fix crashes with generic_compat_pmu & BHRB
Date:   Tue,  1 Sep 2020 17:10:58 +0200
Message-Id: <20200901151010.375799862@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit b460b512417ae9c8b51a3bdcc09020cd6c60ff69 upstream.

The bhrb_filter_map ("The Branch History Rolling Buffer") callback is
only defined in raw CPUs' power_pmu structs. The "architected" CPUs
use generic_compat_pmu, which does not have this callback, and crashes
occur if a user tries to enable branch stack for an event.

This add a NULL pointer check for bhrb_filter_map() which behaves as
if the callback returned an error.

This does not add the same check for config_bhrb() as the only caller
checks for cpuhw->bhrb_users which remains zero if bhrb_filter_map==0.

Fixes: be80e758d0c2 ("powerpc/perf: Add generic compat mode pmu driver")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200602025612.62707-1-aik@ozlabs.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/perf/core-book3s.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1517,9 +1517,16 @@ nocheck:
 	ret = 0;
  out:
 	if (has_branch_stack(event)) {
-		power_pmu_bhrb_enable(event);
-		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
-					event->attr.branch_sample_type);
+		u64 bhrb_filter = -1;
+
+		if (ppmu->bhrb_filter_map)
+			bhrb_filter = ppmu->bhrb_filter_map(
+				event->attr.branch_sample_type);
+
+		if (bhrb_filter != -1) {
+			cpuhw->bhrb_filter = bhrb_filter;
+			power_pmu_bhrb_enable(event);
+		}
 	}
 
 	perf_pmu_enable(event->pmu);
@@ -1841,7 +1848,6 @@ static int power_pmu_event_init(struct p
 	int n;
 	int err;
 	struct cpu_hw_events *cpuhw;
-	u64 bhrb_filter;
 
 	if (!ppmu)
 		return -ENOENT;
@@ -1947,7 +1953,10 @@ static int power_pmu_event_init(struct p
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 
 	if (has_branch_stack(event)) {
-		bhrb_filter = ppmu->bhrb_filter_map(
+		u64 bhrb_filter = -1;
+
+		if (ppmu->bhrb_filter_map)
+			bhrb_filter = ppmu->bhrb_filter_map(
 					event->attr.branch_sample_type);
 
 		if (bhrb_filter == -1) {


