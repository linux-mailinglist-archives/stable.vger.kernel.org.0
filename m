Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6995B2A1704
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgJaLts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbgJaLl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34BF12074F;
        Sat, 31 Oct 2020 11:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144517;
        bh=4ozeNlVICQObkOWpxcFFcUdPW/bi0sqYkQWFx7KvbwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op4+otEpCj8u9GuCUSn4xV8djZnbdCqG3ZA0kfuSkX72mSfZCUtBWxIsYRiYxokA5
         gf9i9aBFJgXHamVS/3R7IXHHLmRk5XSHg2eAulJQju0TNhCzvM14stLtuqqUv2IVAH
         bR9wYbFmVWmg2HZa3HrtrotaFLf2r5l+oVRAMIMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.8 21/70] arm64: Run ARCH_WORKAROUND_2 enabling code on all CPUs
Date:   Sat, 31 Oct 2020 12:35:53 +0100
Message-Id: <20201031113500.519853045@linuxfoundation.org>
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

commit 39533e12063be7f55e3d6ae21ffe067799d542a4 upstream.

Commit 606f8e7b27bf ("arm64: capabilities: Use linear array for
detection and verification") changed the way we deal with per-CPU errata
by only calling the .matches() callback until one CPU is found to be
affected. At this point, .matches() stop being called, and .cpu_enable()
will be called on all CPUs.

This breaks the ARCH_WORKAROUND_2 handling, as only a single CPU will be
mitigated.

In order to address this, forcefully call the .matches() callback from a
.cpu_enable() callback, which brings us back to the original behaviour.

Fixes: 606f8e7b27bf ("arm64: capabilities: Use linear array for detection and verification")
Cc: <stable@vger.kernel.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpu_errata.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -457,6 +457,12 @@ out_printmsg:
 	return required;
 }
 
+static void cpu_enable_ssbd_mitigation(const struct arm64_cpu_capabilities *cap)
+{
+	if (ssbd_state != ARM64_SSBD_FORCE_DISABLE)
+		cap->matches(cap, SCOPE_LOCAL_CPU);
+}
+
 /* known invulnerable cores */
 static const struct midr_range arm64_ssb_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
@@ -914,6 +920,7 @@ const struct arm64_cpu_capabilities arm6
 		.capability = ARM64_SSBD,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_ssbd_mitigation,
+		.cpu_enable = cpu_enable_ssbd_mitigation,
 		.midr_range_list = arm64_ssb_cpus,
 	},
 #ifdef CONFIG_ARM64_ERRATUM_1418040


