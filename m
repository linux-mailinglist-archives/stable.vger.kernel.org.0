Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2462A53D4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733126AbgKCVFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:05:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732706AbgKCVDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:03:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08CEA20658;
        Tue,  3 Nov 2020 21:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437379;
        bh=T9mhykYyDpuupiNvHJ9Z4437cyY0TUXF+Gyuyiv4tMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxfFDxyLzuYQPPUDA33EwILWeoypo6ukr93cjMVcj+xuxKmS1PoU0Fl8lmL3pC9Lj
         uMqCxM/iW+/nKpvmImbJ2x330Pny768hAgCjkHV5r5pUtz/GLralYZuLLpUIJAGPc8
         u9y5Teg6UsVYM8Tb5Ld8SE+VpZT7JkdgmvRXFk9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 003/191] arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs
Date:   Tue,  3 Nov 2020 21:34:55 +0100
Message-Id: <20201103203233.088740109@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 18fce56134c987e5b4eceddafdbe4b00c07e2ae1 upstream.

Commit 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack
thereof") changed the way we deal with ARCH_WORKAROUND_1, by moving most
of the enabling code to the .matches() callback.

This has the unfortunate effect that the workaround gets only enabled on
the first affected CPU, and no other.

In order to address this, forcefully call the .matches() callback from a
.cpu_enable() callback, which brings us back to the original behaviour.

Fixes: 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack thereof")
Cc: <stable@vger.kernel.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpu_errata.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -619,6 +619,12 @@ check_branch_predictor(const struct arm6
 	return (need_wa > 0);
 }
 
+static void
+cpu_enable_branch_predictor_hardening(const struct arm64_cpu_capabilities *cap)
+{
+	cap->matches(cap, SCOPE_LOCAL_CPU);
+}
+
 static const __maybe_unused struct midr_range tx2_family_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
 	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
@@ -813,9 +819,11 @@ const struct arm64_cpu_capabilities arm6
 	},
 #endif
 	{
+		.desc = "Branch predictor hardening",
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = check_branch_predictor,
+		.cpu_enable = cpu_enable_branch_predictor_hardening,
 	},
 #ifdef CONFIG_HARDEN_EL2_VECTORS
 	{


