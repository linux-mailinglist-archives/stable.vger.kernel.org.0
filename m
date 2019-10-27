Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9D0E68A4
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbfJ0VP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730718AbfJ0VP4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:15:56 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1E94205C9;
        Sun, 27 Oct 2019 21:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210955;
        bh=8IOV29BNjDY+REp3WUyqDVAt2o6u+fOSAlETP48YXZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hr0pqfHjpSBNS8p9sB0LYq1W1T43P2Xqbm1Wx1BbsxJuVy33RlO5SKyQyCinBOKLO
         c1k/Is5GTFeKlYmnVi3MDP7qG2EwiF6ZyIYYBgBaeRVyqH/TWTUnEmZjX5Kq+Awhup
         oYi8YPitjvuALjLIF9+7cvCA9huC7xv4ZX8FDAQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 73/93] arm64: Enable workaround for Cavium TX2 erratum 219 when running SMT
Date:   Sun, 27 Oct 2019 22:01:25 +0100
Message-Id: <20191027203310.113079555@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 93916beb70143c46bf1d2bacf814be3a124b253b upstream.

It appears that the only case where we need to apply the TX2_219_TVM
mitigation is when the core is in SMT mode. So let's condition the
enabling on detecting a CPU whose MPIDR_EL1.Aff0 is non-zero.

Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpu_errata.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -23,6 +23,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/smp_plat.h>
 
 static bool __maybe_unused
 is_affected_midr_range(const struct arm64_cpu_capabilities *entry, int scope)
@@ -618,6 +619,30 @@ check_branch_predictor(const struct arm6
 	return (need_wa > 0);
 }
 
+static const __maybe_unused struct midr_range tx2_family_cpus[] = {
+	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
+	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
+	{},
+};
+
+static bool __maybe_unused
+needs_tx2_tvm_workaround(const struct arm64_cpu_capabilities *entry,
+			 int scope)
+{
+	int i;
+
+	if (!is_affected_midr_range_list(entry, scope) ||
+	    !is_hyp_mode_available())
+		return false;
+
+	for_each_possible_cpu(i) {
+		if (MPIDR_AFFINITY_LEVEL(cpu_logical_map(i), 0) != 0)
+			return true;
+	}
+
+	return false;
+}
+
 #ifdef CONFIG_HARDEN_EL2_VECTORS
 
 static const struct midr_range arm64_harden_el2_vectors[] = {
@@ -802,6 +827,14 @@ const struct arm64_cpu_capabilities arm6
 		.matches = has_cortex_a76_erratum_1463225,
 	},
 #endif
+#ifdef CONFIG_CAVIUM_TX2_ERRATUM_219
+	{
+		.desc = "Cavium ThunderX2 erratum 219 (KVM guest sysreg trapping)",
+		.capability = ARM64_WORKAROUND_CAVIUM_TX2_219_TVM,
+		ERRATA_MIDR_RANGE_LIST(tx2_family_cpus),
+		.matches = needs_tx2_tvm_workaround,
+	},
+#endif
 	{
 	}
 };


