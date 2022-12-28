Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EAD6580FE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiL1QXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiL1QWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:22:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1053F1BEAF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A14CC61562
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7BCC433D2;
        Wed, 28 Dec 2022 16:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244414;
        bh=0vuYdpv/hdcD+4QKCTXqaiBNEPGinL4DTMC3vrWhyZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJDHX5II8ULRBppQ2/gGH9GewG9Rr605rm187Zh2N3spwd7GWmS8cVmPgGsH4OXye
         qNmUS5jemKwkfJywPeOF4da55/b8Tw5BNPl1A9RiUeJlGJc87VHHflJSivtVojA+71
         7iANkvzIOrLk9cTVpuGPuINqrbn35/taJRIqz8Ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0643/1146] crypto: arm64/sm3 - fix possible crash with CFI enabled
Date:   Wed, 28 Dec 2022 15:36:22 +0100
Message-Id: <20221228144347.626018253@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit be8f6b6496076588fd49cbe5bfaaf3ab883eb779 ]

sm3_neon_transform() is called via indirect function calls.  Therefore
it needs to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause
its type hash to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure (if
the compiler didn't happen to optimize out the indirect call).

Fixes: c50d32859e70 ("arm64: Add types to indirect called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/crypto/sm3-neon-core.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sm3-neon-core.S b/arch/arm64/crypto/sm3-neon-core.S
index 3e3b4e5c736f..4357e0e51be3 100644
--- a/arch/arm64/crypto/sm3-neon-core.S
+++ b/arch/arm64/crypto/sm3-neon-core.S
@@ -9,6 +9,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
 /* Context structure */
@@ -351,7 +352,7 @@
 	 */
 	.text
 .align 3
-SYM_FUNC_START(sm3_neon_transform)
+SYM_TYPED_FUNC_START(sm3_neon_transform)
 	ldp		ra, rb, [RSTATE, #0]
 	ldp		rc, rd, [RSTATE, #8]
 	ldp		re, rf, [RSTATE, #16]
-- 
2.35.1



