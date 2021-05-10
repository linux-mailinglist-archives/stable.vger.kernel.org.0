Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F73F378EFC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhEJN1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:27:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243796AbhEJL5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA8F660E09;
        Mon, 10 May 2021 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620647774;
        bh=lvQXdb1uLea5kXdp+Ftv8+KRCK1dJmRCKA5861t8EtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARelgk0148UJssKESsH3cNto6r6TczRUB5cvXfHFxWwY9a3SkVqHmcrJtiAIbr7za
         Y9uLO+Dkz51IsKticWfbms6hinNt4mX1ioF+70b8bjCyLk4yJTDXAhwCjvEFWyeHgM
         NIbdxZka1RNJJEuIaJAqU3iW7VZ6Osbv7mpovXmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 083/342] kselftest/arm64: mte: Fix MTE feature detection
Date:   Mon, 10 May 2021 12:17:53 +0200
Message-Id: <20210510102012.861972949@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 592432862cc4019075a7196d9961562c49507d6f ]

To check whether the CPU and kernel support the MTE features we want
to test, we use an (emulated) CPU ID register read. However we only
check against a very particular feature version (0b0010), even though
the ARM ARM promises ID register features to be backwards compatible.

While this could be fixed by using ">=" instead of "==", we should
actually use the explicit HWCAP2_MTE hardware capability, exposed by the
kernel via the ELF auxiliary vectors.

That moves this responsibility to the kernel, and fixes running the
tests on machines with FEAT_MTE3 capability.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Mark Brown <broone@kernel.org>
Link: https://lore.kernel.org/r/20210319165334.29213-7-andre.przywara@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/mte/mte_common_util.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/arm64/mte/mte_common_util.c b/tools/testing/selftests/arm64/mte/mte_common_util.c
index 39f8908988ea..70665ba88cbb 100644
--- a/tools/testing/selftests/arm64/mte/mte_common_util.c
+++ b/tools/testing/selftests/arm64/mte/mte_common_util.c
@@ -278,22 +278,13 @@ int mte_switch_mode(int mte_option, unsigned long incl_mask)
 	return 0;
 }
 
-#define ID_AA64PFR1_MTE_SHIFT		8
-#define ID_AA64PFR1_MTE			2
-
 int mte_default_setup(void)
 {
-	unsigned long hwcaps = getauxval(AT_HWCAP);
+	unsigned long hwcaps2 = getauxval(AT_HWCAP2);
 	unsigned long en = 0;
 	int ret;
 
-	if (!(hwcaps & HWCAP_CPUID)) {
-		ksft_print_msg("FAIL: CPUID registers unavailable\n");
-		return KSFT_FAIL;
-	}
-	/* Read ID_AA64PFR1_EL1 register */
-	asm volatile("mrs %0, id_aa64pfr1_el1" : "=r"(hwcaps) : : "memory");
-	if (((hwcaps >> ID_AA64PFR1_MTE_SHIFT) & MT_TAG_MASK) != ID_AA64PFR1_MTE) {
+	if (!(hwcaps2 & HWCAP2_MTE)) {
 		ksft_print_msg("FAIL: MTE features unavailable\n");
 		return KSFT_SKIP;
 	}
-- 
2.30.2



