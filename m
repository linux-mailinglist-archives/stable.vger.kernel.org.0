Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F062A5281
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbgKCUue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731819AbgKCUue (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63C5822404;
        Tue,  3 Nov 2020 20:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436632;
        bh=F8VxgKMCo4xfPAphVEmXh9dpgcHkQhkrIp7DJUjVgPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0R5Kr6WG1aGjzotluCZv/nNDFNXGtMhBrsU1f1R4bO4ZsOuLUOMtRx+ToAXDVi36s
         lWvNmePJjjFKIf1a8nSYuGTfRfmpoW4IrMNjaXWQgprbh++mNg0pLTP+Dpvg4ZtfxV
         wYEDaPterH9Oinfdo10LvJDIT1paXnny7r8PfppE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 334/391] intel_idle: Ignore _CST if control cannot be taken from the platform
Date:   Tue,  3 Nov 2020 21:36:25 +0100
Message-Id: <20201103203409.661043035@linuxfoundation.org>
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

From: Mel Gorman <mgorman@techsingularity.net>

commit 75af76d0a34e048651a6af311781d7206b6964c7 upstream.

e6d4f08a6776 ("intel_idle: Use ACPI _CST on server systems") avoids
enabling c-states that have been disabled by the platform with the
exception of C1E.

Unfortunately, BIOS implementations are not always consistent in terms
of how capabilities are advertised and control cannot always be handed
over. If control cannot be handed over then intel_idle reports that "ACPI
_CST not found or not usable" but does not clear acpi_state_table.count
meaning the information is still partially used.

This patch ignores ACPI information if CST control cannot be requested from
the platform. This was only observed on a number of Haswell platforms that
had identical CPUs but not identical BIOS versions.  While this problem
may be rare overall, 24 separate test cases bisected to this specific
commit across 4 separate test machines and is worth addressing. If the
situation occurs, the kernel behaves as it did before commit e6d4f08a6776
and uses any c-states that are discovered.

The affected test cases were all ones that involved a small number of
processes -- exec microbenchmark, pipe microbenchmark, git test suite,
netperf, tbench with one client and system call microbenchmark. Each
case benefits from being able to use turboboost which is prevented if the
lower c-states are unavailable. This may mask real regressions specific
to older hardware so it is worth addressing.

C-state status before and after the patch

5.9.0-vanilla            POLL     latency:0      disabled:0 default:enabled
5.9.0-vanilla            C1       latency:2      disabled:0 default:enabled
5.9.0-vanilla            C1E      latency:10     disabled:0 default:enabled
5.9.0-vanilla            C3       latency:33     disabled:1 default:disabled
5.9.0-vanilla            C6       latency:133    disabled:1 default:disabled
5.9.0-ignore-cst-v1r1    POLL     latency:0      disabled:0 default:enabled
5.9.0-ignore-cst-v1r1    C1       latency:2      disabled:0 default:enabled
5.9.0-ignore-cst-v1r1    C1E      latency:10     disabled:0 default:enabled
5.9.0-ignore-cst-v1r1    C3       latency:33     disabled:0 default:enabled
5.9.0-ignore-cst-v1r1    C6       latency:133    disabled:0 default:enabled

Patch enables C3/C6.

Netperf UDP_STREAM

netperf-udp
                                      5.5.0                  5.9.0
                                    vanilla        ignore-cst-v1r1
Hmean     send-64         193.41 (   0.00%)      226.54 *  17.13%*
Hmean     send-128        392.16 (   0.00%)      450.54 *  14.89%*
Hmean     send-256        769.94 (   0.00%)      881.85 *  14.53%*
Hmean     send-1024      2994.21 (   0.00%)     3468.95 *  15.85%*
Hmean     send-2048      5725.60 (   0.00%)     6628.99 *  15.78%*
Hmean     send-3312      8468.36 (   0.00%)    10288.02 *  21.49%*
Hmean     send-4096     10135.46 (   0.00%)    12387.57 *  22.22%*
Hmean     send-8192     17142.07 (   0.00%)    19748.11 *  15.20%*
Hmean     send-16384    28539.71 (   0.00%)    30084.45 *   5.41%*

Fixes: e6d4f08a6776 ("intel_idle: Use ACPI _CST on server systems")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/idle/intel_idle.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1212,14 +1212,13 @@ static bool __init intel_idle_acpi_cst_e
 		if (!intel_idle_cst_usable())
 			continue;
 
-		if (!acpi_processor_claim_cst_control()) {
-			acpi_state_table.count = 0;
-			return false;
-		}
+		if (!acpi_processor_claim_cst_control())
+			break;
 
 		return true;
 	}
 
+	acpi_state_table.count = 0;
 	pr_debug("ACPI _CST not found or not usable\n");
 	return false;
 }


