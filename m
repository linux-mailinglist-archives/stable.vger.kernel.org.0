Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1DA64D370
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 00:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLNX3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 18:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiLNX2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 18:28:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB053511EE;
        Wed, 14 Dec 2022 15:26:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 568B361BF8;
        Wed, 14 Dec 2022 23:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB6DC433D2;
        Wed, 14 Dec 2022 23:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671060397;
        bh=kkfEQgwWyo+kPv5VWEAu/1iunwHHV2AQpSwt9ibZlUY=;
        h=From:To:Cc:Subject:Date:From;
        b=dVVEHCmymGa2rwiZytT5fwntuTx84t4e8vd1gx8FET1GJQpYgyYAdH9sdZ6Fr0CMY
         PhprWN1t/BNlbT578Bu8t/D0NWQ8QYTm6GsFTklgMpS6nlzbg+MYzKdvZmzZfpEc5F
         GHfAWvSnHtPJSjQD4C6UE0FSwvw8m5ukX8KkqT1arsj6v6EwP93inuCfI8WbefQ3Tu
         u7sP8cx+q1AxHS0YUQ/L73VaoxaB/x/5q3azqCaC7N2uMJqgzv73aNDbqThJkg0z9j
         GhQDq3zEEr5mVG6lztAWvl8pfJ/0LoE25pd4Mlu5zfuNMVqjVCd/gPxyEeDBD0QZTm
         /TaWkt4hlXdGg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Tom Rix <trix@redhat.com>, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6
Date:   Wed, 14 Dec 2022 16:26:03 -0700
Message-Id: <20221214232602.4118147-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A bad bug in clang's implementation of -fzero-call-used-regs can result
in NULL pointer dereferences (see the links above the check for more
information). Restrict CONFIG_CC_HAS_ZERO_CALL_USED_REGS to either a
supported GCC version or a clang newer than 15.0.6, which will catch
both a theoretical 15.0.7 and the upcoming 16.0.0, which will both have
the bug fixed.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 security/Kconfig.hardening | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index d766b7d0ffd1..53baa95cb644 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -257,6 +257,9 @@ config INIT_ON_FREE_DEFAULT_ON
 
 config CC_HAS_ZERO_CALL_USED_REGS
 	def_bool $(cc-option,-fzero-call-used-regs=used-gpr)
+	# https://github.com/ClangBuiltLinux/linux/issues/1766
+	# https://github.com/llvm/llvm-project/issues/59242
+	depends on !CC_IS_CLANG || CLANG_VERSION > 150006
 
 config ZERO_CALL_USED_REGS
 	bool "Enable register zeroing on function exit"

base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
-- 
2.39.0

