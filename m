Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C86440E43D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241802AbhIPQ4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346230AbhIPQyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:54:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2424861355;
        Thu, 16 Sep 2021 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809804;
        bh=n94kMwFHUMe+HkJMYWMwz/mNrdLxyfQDhWM2x1S7TPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOMth0DVLMjbvqIP+AV5FpnQWHp8Z0LDjbBxp+OUbV9YW1rCj35ooBQgzDSu1PiSt
         BzbNX9hk8lwKpevjRJ7dwCk1a3RZ8CXoi5VlGiQ7a8PT57freY6Wq9zOhoFc1r3SEw
         TO/mIl1/RB4fD8RkSjUjImKH5C8Ob12Z2VnE1Ym4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 290/380] kselftest/arm64: pac: Fix skipping of tests on systems without PAC
Date:   Thu, 16 Sep 2021 18:00:47 +0200
Message-Id: <20210916155813.929919044@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



