Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C4A55C3BE
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243372AbiF1CT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243335AbiF1CTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:19:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BA622BF8;
        Mon, 27 Jun 2022 19:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE0C1B81C0A;
        Tue, 28 Jun 2022 02:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2C3C341CB;
        Tue, 28 Jun 2022 02:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382740;
        bh=79bXSpWjGPh6CzHNAJvqzaDpWV02fZudh2qvMmluaos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Glb9aijZ76eLTniIJ+AFDiPZL5DDrD/vGsM/9WfvSOLTcuzWDlGn7Um9tDSM6Je6y
         BCPqteDb8OvDpVoMB6BUd31CHH9DSbfiP86JBPQnhtKnG7gMySSocpfSFaOS0JvnZD
         5hZPLHV4HpuqoyBRROQsDvhrHwFR4x6/ApSiS9ZIGTl63OtLd9T8VhRjcVPKeus8Gc
         pCuERs6IGd28sQhUPqGUEJlKcwLk3UCIW0nf6b1Jiu1sVnYUoxuLF2jfgy2STBM+Zq
         TuPzDjWLBTjY5lCvahwTmY33f3lmVJygdzFaTBa06/sTEg9tKfnwxHZmjdAdpQCC48
         obtE7iLGCuGpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, nathan@kernel.org, ndesaulniers@google.com,
        linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 09/53] selftests: Fix clang cross compilation
Date:   Mon, 27 Jun 2022 22:17:55 -0400
Message-Id: <20220628021839.594423-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 795285ef242543bb636556b7225f20adb7d3795c ]

Unlike GCC clang uses a single compiler image to support multiple target
architectures meaning that we can't simply rely on CROSS_COMPILE to select
the output architecture. Instead we must pass --target to the compiler to
tell it what to output, kselftest was not doing this so cross compilation
of kselftest using clang resulted in kselftest being built for the host
architecture.

More work is required to fix tests using custom rules but this gets the
bulk of things building.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 2a2d240cdc1b..1a5cc3cd97ec 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -7,10 +7,31 @@ else ifneq ($(filter -%,$(LLVM)),)
 LLVM_SUFFIX := $(LLVM)
 endif
 
-CC := $(LLVM_PREFIX)clang$(LLVM_SUFFIX)
+CLANG_TARGET_FLAGS_arm          := arm-linux-gnueabi
+CLANG_TARGET_FLAGS_arm64        := aarch64-linux-gnu
+CLANG_TARGET_FLAGS_hexagon      := hexagon-linux-musl
+CLANG_TARGET_FLAGS_m68k         := m68k-linux-gnu
+CLANG_TARGET_FLAGS_mips         := mipsel-linux-gnu
+CLANG_TARGET_FLAGS_powerpc      := powerpc64le-linux-gnu
+CLANG_TARGET_FLAGS_riscv        := riscv64-linux-gnu
+CLANG_TARGET_FLAGS_s390         := s390x-linux-gnu
+CLANG_TARGET_FLAGS_x86          := x86_64-linux-gnu
+CLANG_TARGET_FLAGS              := $(CLANG_TARGET_FLAGS_$(ARCH))
+
+ifeq ($(CROSS_COMPILE),)
+ifeq ($(CLANG_TARGET_FLAGS),)
+$(error Specify CROSS_COMPILE or add '--target=' option to lib.mk
+else
+CLANG_FLAGS     += --target=$(CLANG_TARGET_FLAGS)
+endif # CLANG_TARGET_FLAGS
+else
+CLANG_FLAGS     += --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif # CROSS_COMPILE
+
+CC := $(LLVM_PREFIX)clang$(LLVM_SUFFIX) $(CLANG_FLAGS) -fintegrated-as
 else
 CC := $(CROSS_COMPILE)gcc
-endif
+endif # LLVM
 
 ifeq (0,$(MAKELEVEL))
     ifeq ($(OUTPUT),)
-- 
2.35.1

