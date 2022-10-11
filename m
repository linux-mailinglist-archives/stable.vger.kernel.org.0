Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2505FB5AA
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiJKO4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiJKOzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF26C6C13C;
        Tue, 11 Oct 2022 07:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D0DD61166;
        Tue, 11 Oct 2022 14:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0137BC433D7;
        Tue, 11 Oct 2022 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499915;
        bh=x32F4CsgPwMHtEyCKulF2Xq3YJudJVWiV7tN9IUCuYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hf/C+tNor6OKuxzDSW/QxxrSoXYEFi5B7N6bTHNXxQ1vGaqIYiTsqfPIAeA0NHzfs
         eZB+XcKN8VLu9i0otiqtLxfnoR6HcmPng1tEFVtsLmx3aj6AFWWjmVC7vEk5wF2jCY
         MlT6UtluigJeScRd8Ubl9/9h7DfZfXLD0Pg1ORNWG0Kr6Tunjc5oYPP2safm1af0SS
         1hysELnb9UOxvB+YHcgZisy7Vo8vz/0aCouDvsltBK41JS55+/LKKkfDt94el01KS5
         H92wi6VUuH0DV9IEQmWGQlFbDeceAWA9yoQ1zuEmjv1kmh6feAbpmSwu9VrpQ6p0Wy
         KWD+U3y9tm1ow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 15/40] kselftest/arm64: Allow larger buffers in get_signal_context()
Date:   Tue, 11 Oct 2022 10:51:04 -0400
Message-Id: <20221011145129.1623487-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 38150a6204c731a4846786682e500d132571fd82 ]

In order to allow testing of signal contexts that overflow the base signal
frame allow callers to pass the buffer size for the user context into
get_signal_context(). No functional change.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220829160703.874492-10-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/signal/test_signals_utils.h    | 5 +++--
 .../arm64/signal/testcases/fake_sigreturn_bad_magic.c        | 2 +-
 .../arm64/signal/testcases/fake_sigreturn_bad_size.c         | 2 +-
 .../signal/testcases/fake_sigreturn_bad_size_for_magic0.c    | 2 +-
 .../signal/testcases/fake_sigreturn_duplicated_fpsimd.c      | 2 +-
 .../arm64/signal/testcases/fake_sigreturn_misaligned_sp.c    | 2 +-
 .../arm64/signal/testcases/fake_sigreturn_missing_fpsimd.c   | 2 +-
 .../arm64/signal/testcases/fake_sigreturn_sme_change_vl.c    | 2 +-
 .../arm64/signal/testcases/fake_sigreturn_sve_change_vl.c    | 2 +-
 tools/testing/selftests/arm64/signal/testcases/sme_vl.c      | 2 +-
 tools/testing/selftests/arm64/signal/testcases/ssve_regs.c   | 2 +-
 tools/testing/selftests/arm64/signal/testcases/sve_regs.c    | 2 +-
 tools/testing/selftests/arm64/signal/testcases/sve_vl.c      | 2 +-
 tools/testing/selftests/arm64/signal/testcases/za_regs.c     | 2 +-
 14 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/test_signals_utils.h b/tools/testing/selftests/arm64/signal/test_signals_utils.h
index f3aa99ba67bb..222093f51b67 100644
--- a/tools/testing/selftests/arm64/signal/test_signals_utils.h
+++ b/tools/testing/selftests/arm64/signal/test_signals_utils.h
@@ -56,7 +56,8 @@ static inline bool feats_ok(struct tdescr *td)
  * at sizeof(ucontext_t).
  */
 static __always_inline bool get_current_context(struct tdescr *td,
-						ucontext_t *dest_uc)
+						ucontext_t *dest_uc,
+						size_t dest_sz)
 {
 	static volatile bool seen_already;
 
@@ -64,7 +65,7 @@ static __always_inline bool get_current_context(struct tdescr *td,
 	/* it's a genuine invocation..reinit */
 	seen_already = 0;
 	td->live_uc_valid = 0;
-	td->live_sz = sizeof(*dest_uc);
+	td->live_sz = dest_sz;
 	memset(dest_uc, 0x00, td->live_sz);
 	td->live_uc = dest_uc;
 	/*
diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_magic.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_magic.c
index 8dc600a7d4fd..8c7f00ea9823 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_magic.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_magic.c
@@ -21,7 +21,7 @@ static int fake_sigreturn_bad_magic_run(struct tdescr *td,
 	struct _aarch64_ctx *shead = GET_SF_RESV_HEAD(sf), *head;
 
 	/* just to fill the ucontext_t with something real */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	/* need at least 2*HDR_SZ space: KSFT_BAD_MAGIC + terminator. */
diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_size.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_size.c
index b3c362100666..1c03f6b638e0 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_size.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_size.c
@@ -24,7 +24,7 @@ static int fake_sigreturn_bad_size_run(struct tdescr *td,
 	struct _aarch64_ctx *shead = GET_SF_RESV_HEAD(sf), *head;
 
 	/* just to fill the ucontext_t with something real */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_size_for_magic0.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_size_for_magic0.c
index a44b88bfc81a..bc22f64b544e 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_size_for_magic0.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_bad_size_for_magic0.c
@@ -21,7 +21,7 @@ static int fake_sigreturn_bad_size_for_magic0_run(struct tdescr *td,
 	struct _aarch64_ctx *shead = GET_SF_RESV_HEAD(sf), *head;
 
 	/* just to fill the ucontext_t with something real */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	/* at least HDR_SZ for the badly sized terminator. */
diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_duplicated_fpsimd.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_duplicated_fpsimd.c
index afe8915f0998..63e3906b631c 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_duplicated_fpsimd.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_duplicated_fpsimd.c
@@ -21,7 +21,7 @@ static int fake_sigreturn_duplicated_fpsimd_run(struct tdescr *td,
 	struct _aarch64_ctx *shead = GET_SF_RESV_HEAD(sf), *head;
 
 	/* just to fill the ucontext_t with something real */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	head = get_starting_head(shead, sizeof(struct fpsimd_context) + HDR_SZ,
diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_misaligned_sp.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_misaligned_sp.c
index 1e089e66f9f3..d00625ff12c2 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_misaligned_sp.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_misaligned_sp.c
@@ -19,7 +19,7 @@ static int fake_sigreturn_misaligned_run(struct tdescr *td,
 					 siginfo_t *si, ucontext_t *uc)
 {
 	/* just to fill the ucontext_t with something real */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	/* Forcing sigframe on misaligned SP (16 + 3) */
diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_missing_fpsimd.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_missing_fpsimd.c
index 08ecd8073a1a..f805138cb20d 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_missing_fpsimd.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_missing_fpsimd.c
@@ -23,7 +23,7 @@ static int fake_sigreturn_missing_fpsimd_run(struct tdescr *td,
 	struct _aarch64_ctx *head = GET_SF_RESV_HEAD(sf);
 
 	/* just to fill the ucontext_t with something real */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sme_change_vl.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sme_change_vl.c
index 7ed762b7202f..ebd5815b54bb 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sme_change_vl.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sme_change_vl.c
@@ -54,7 +54,7 @@ static int fake_sigreturn_ssve_change_vl(struct tdescr *td,
 	struct sve_context *sve;
 
 	/* Get a signal context with a SME ZA frame in it */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
diff --git a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sve_change_vl.c b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sve_change_vl.c
index 915821375b0a..e2a452190511 100644
--- a/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sve_change_vl.c
+++ b/tools/testing/selftests/arm64/signal/testcases/fake_sigreturn_sve_change_vl.c
@@ -56,7 +56,7 @@ static int fake_sigreturn_sve_change_vl(struct tdescr *td,
 	struct sve_context *sve;
 
 	/* Get a signal context with a SVE frame in it */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
diff --git a/tools/testing/selftests/arm64/signal/testcases/sme_vl.c b/tools/testing/selftests/arm64/signal/testcases/sme_vl.c
index 13ff3b35cbaf..75f387f2db81 100644
--- a/tools/testing/selftests/arm64/signal/testcases/sme_vl.c
+++ b/tools/testing/selftests/arm64/signal/testcases/sme_vl.c
@@ -34,7 +34,7 @@ static int sme_vl(struct tdescr *td, siginfo_t *si, ucontext_t *uc)
 	struct za_context *za;
 
 	/* Get a signal context which should have a ZA frame in it */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
diff --git a/tools/testing/selftests/arm64/signal/testcases/ssve_regs.c b/tools/testing/selftests/arm64/signal/testcases/ssve_regs.c
index 9022a6cab4b3..71f14632c524 100644
--- a/tools/testing/selftests/arm64/signal/testcases/ssve_regs.c
+++ b/tools/testing/selftests/arm64/signal/testcases/ssve_regs.c
@@ -73,7 +73,7 @@ static int do_one_sme_vl(struct tdescr *td, siginfo_t *si, ucontext_t *uc,
 	 * in it.
 	 */
 	setup_ssve_regs();
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
diff --git a/tools/testing/selftests/arm64/signal/testcases/sve_regs.c b/tools/testing/selftests/arm64/signal/testcases/sve_regs.c
index 4b2418aa08a9..4cdedb706786 100644
--- a/tools/testing/selftests/arm64/signal/testcases/sve_regs.c
+++ b/tools/testing/selftests/arm64/signal/testcases/sve_regs.c
@@ -71,7 +71,7 @@ static int do_one_sve_vl(struct tdescr *td, siginfo_t *si, ucontext_t *uc,
 	 * in it.
 	 */
 	setup_sve_regs();
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
diff --git a/tools/testing/selftests/arm64/signal/testcases/sve_vl.c b/tools/testing/selftests/arm64/signal/testcases/sve_vl.c
index 92904653add1..aa835acec062 100644
--- a/tools/testing/selftests/arm64/signal/testcases/sve_vl.c
+++ b/tools/testing/selftests/arm64/signal/testcases/sve_vl.c
@@ -34,7 +34,7 @@ static int sve_vl(struct tdescr *td, siginfo_t *si, ucontext_t *uc)
 	struct sve_context *sve;
 
 	/* Get a signal context which should have a SVE frame in it */
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
diff --git a/tools/testing/selftests/arm64/signal/testcases/za_regs.c b/tools/testing/selftests/arm64/signal/testcases/za_regs.c
index b94e4f99fcac..70c00ca6eded 100644
--- a/tools/testing/selftests/arm64/signal/testcases/za_regs.c
+++ b/tools/testing/selftests/arm64/signal/testcases/za_regs.c
@@ -71,7 +71,7 @@ static int do_one_sme_vl(struct tdescr *td, siginfo_t *si, ucontext_t *uc,
 	 * in it.
 	 */
 	setup_za_regs();
-	if (!get_current_context(td, &sf.uc))
+	if (!get_current_context(td, &sf.uc, sizeof(sf.uc)))
 		return 1;
 
 	resv_sz = GET_SF_RESV_SIZE(sf);
-- 
2.35.1

