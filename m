Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2A02A16E0
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgJaLlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbgJaLl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8C8A20731;
        Sat, 31 Oct 2020 11:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144489;
        bh=+d/sucMsUapMozPmJw7Ff+qM2F0/qiUU8RKwYMKg6O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PITULxK6RVht7/gLuImLXVdEcvh4z2+My1W3ElU6ofa8z7xjiFVTg17rMT/2LWi0E
         GphhDLnmQv5ehh4F98J7mj7nDi05Ck11D/govcVOlnG4IjnXqpo8mOhyuq7L6i1wyD
         5mXJQwAiN9d+5G9/kLKHC4o86H9yIk3X38tMZxpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.8 20/70] arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs
Date:   Sat, 31 Oct 2020 12:35:52 +0100
Message-Id: <20201031113500.477897266@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
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
@@ -599,6 +599,12 @@ check_branch_predictor(const struct arm6
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
@@ -890,9 +896,11 @@ const struct arm64_cpu_capabilities arm6
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


