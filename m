Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F12404FA6
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344234AbhIIMV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:21:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350182AbhIIMR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:17:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C76B6128C;
        Thu,  9 Sep 2021 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188200;
        bh=n94kMwFHUMe+HkJMYWMwz/mNrdLxyfQDhWM2x1S7TPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kz6vSgWUBrb9kZTnxAFTqc2zadE0DF7hS5d1vUpwlnqTrfShngSXvw9cj0rccSU3m
         zQcu6HhxT/kzyoZOGt89gm51lkdF7K+1m/jj599jG3Jz5xZkRzQOzmEFysPebr0Jfg
         qsdPv6lsa56l0otBiy3524mNdVBBc28e3EsnkdEvGUj40Amd41kpdiQtvRSKwB5VM8
         tGTNvoern3IUHFXj5N+YHSQfmpCSwZGAcg4scfplTXNbOW/JpxmuWkH/LR3KtvAphp
         U79YRm1N0/gdr9RyudDTa/IYvH/uJD4i0y+Sygrtr3G4q17SA6qixKJtr28Y68kTvb
         inWbDW2MrQavg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 158/219] kselftest/arm64: pac: Fix skipping of tests on systems without PAC
Date:   Thu,  9 Sep 2021 07:45:34 -0400
Message-Id: <20210909114635.143983-158-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 0c69bd2ca6ee20064dde7853cd749284e053a874 ]

The PAC tests check to see if the system supports the relevant PAC features
but instead of skipping the tests if they can't be executed they fail the
tests which makes things look like they're not working when they are.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210819165723.43903-1-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/pauth/pac.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/arm64/pauth/pac.c b/tools/testing/selftests/arm64/pauth/pac.c
index 592fe538506e..b743daa772f5 100644
--- a/tools/testing/selftests/arm64/pauth/pac.c
+++ b/tools/testing/selftests/arm64/pauth/pac.c
@@ -25,13 +25,15 @@
 do { \
 	unsigned long hwcaps = getauxval(AT_HWCAP); \
 	/* data key instructions are not in NOP space. This prevents a SIGILL */ \
-	ASSERT_NE(0, hwcaps & HWCAP_PACA) TH_LOG("PAUTH not enabled"); \
+	if (!(hwcaps & HWCAP_PACA))					\
+		SKIP(return, "PAUTH not enabled"); \
 } while (0)
 #define ASSERT_GENERIC_PAUTH_ENABLED() \
 do { \
 	unsigned long hwcaps = getauxval(AT_HWCAP); \
 	/* generic key instructions are not in NOP space. This prevents a SIGILL */ \
-	ASSERT_NE(0, hwcaps & HWCAP_PACG) TH_LOG("Generic PAUTH not enabled"); \
+	if (!(hwcaps & HWCAP_PACG)) \
+		SKIP(return, "Generic PAUTH not enabled");	\
 } while (0)
 
 void sign_specific(struct signatures *sign, size_t val)
@@ -256,7 +258,7 @@ TEST(single_thread_different_keys)
 	unsigned long hwcaps = getauxval(AT_HWCAP);
 
 	/* generic and data key instructions are not in NOP space. This prevents a SIGILL */
-	ASSERT_NE(0, hwcaps & HWCAP_PACA) TH_LOG("PAUTH not enabled");
+	ASSERT_PAUTH_ENABLED();
 	if (!(hwcaps & HWCAP_PACG)) {
 		TH_LOG("WARNING: Generic PAUTH not enabled. Skipping generic key checks");
 		nkeys = NKEYS - 1;
@@ -299,7 +301,7 @@ TEST(exec_changed_keys)
 	unsigned long hwcaps = getauxval(AT_HWCAP);
 
 	/* generic and data key instructions are not in NOP space. This prevents a SIGILL */
-	ASSERT_NE(0, hwcaps & HWCAP_PACA) TH_LOG("PAUTH not enabled");
+	ASSERT_PAUTH_ENABLED();
 	if (!(hwcaps & HWCAP_PACG)) {
 		TH_LOG("WARNING: Generic PAUTH not enabled. Skipping generic key checks");
 		nkeys = NKEYS - 1;
-- 
2.30.2

