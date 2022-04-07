Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E42D4F7107
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbiDGBXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbiDGBSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:18:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A4519BE54;
        Wed,  6 Apr 2022 18:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D76A161DB0;
        Thu,  7 Apr 2022 01:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAD9C385A7;
        Thu,  7 Apr 2022 01:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294008;
        bh=+bwDGyDJKCF8LB9fJwHxTM4vlvD9HScCpYl69iObhuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PfD7nxEAHS1PrsX5olp8G7j98cRIS44147AQLKGJsyM3yXwq3iAvUiBFl6l9QalHY
         Cj2N3gecg0ohJzu2ZGtH8w+Sr7JY+rsrSdHOmekuimmLprOu2Bj6ut2+omH5ZmkBxX
         GTPztSJXM0ApoRIhmUciecPIBeMpbAMJDEgzm2QjCJZvnovBLXbJkZzUP9fGo1zeC4
         diS3aF4mrMVSW8fs7O3xY/coA8UrHFDVdIdH0ThptHHqaC2BZQlzvExTDgo18e4ebS
         1SAHXOATuRuTkj/Ec0zhLDbrPTxnmQ3u70o/U3sOV7CxIQoAqOEOb6kiDZ+Aw/Wt2v
         rYB11usvThv3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Martin Willi <martin@strongswan.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 12/27] crypto: x86/chacha20 - Avoid spurious jumps to other functions
Date:   Wed,  6 Apr 2022 21:12:42 -0400
Message-Id: <20220407011257.114287-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4327d168515fd8b5b92fa1efdf1d219fb6514460 ]

The chacha_Nblock_xor_avx512vl() functions all have their own,
identical, .LdoneN label, however in one particular spot {2,4} jump to
the 8 version instead of their own. Resulting in:

  arch/x86/crypto/chacha-x86_64.o: warning: objtool: chacha_2block_xor_avx512vl() falls through to next function chacha_8block_xor_avx512vl()
  arch/x86/crypto/chacha-x86_64.o: warning: objtool: chacha_4block_xor_avx512vl() falls through to next function chacha_8block_xor_avx512vl()

Make each function consistently use its own done label.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/chacha-avx512vl-x86_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/chacha-avx512vl-x86_64.S b/arch/x86/crypto/chacha-avx512vl-x86_64.S
index bb193fde123a..8713c16c2501 100644
--- a/arch/x86/crypto/chacha-avx512vl-x86_64.S
+++ b/arch/x86/crypto/chacha-avx512vl-x86_64.S
@@ -172,7 +172,7 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%rax
 	and		$0xf,%rcx
-	jz		.Ldone8
+	jz		.Ldone2
 	mov		%rax,%r9
 	and		$~0xf,%r9
 
@@ -438,7 +438,7 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%rax
 	and		$0xf,%rcx
-	jz		.Ldone8
+	jz		.Ldone4
 	mov		%rax,%r9
 	and		$~0xf,%r9
 
-- 
2.35.1

