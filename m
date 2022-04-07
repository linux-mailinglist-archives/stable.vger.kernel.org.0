Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1634C4F707F
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbiDGBVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240317AbiDGBTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:19:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E29180225;
        Wed,  6 Apr 2022 18:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DE7461DE0;
        Thu,  7 Apr 2022 01:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56544C385A6;
        Thu,  7 Apr 2022 01:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294142;
        bh=yWszmqLY47S5iaXcawYdL8HPP6PVa/621Zhmc4slavE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WaP66KpASaCWXFNJehH9dSoQIvPA99Ix27UCJ+eoGaX1MhKCAfSSbhVSiJFj8bJvP
         bGyZ+2NuO11Wvb9i6hTt6otAW3LIkTLL1FPyk+JE7bEo0HMF3KLaknIgzZKkIsdRfO
         +QbnV7rcA20Z/GFZAx6nIvSf8B1KWuJBxWOH0ePwoTT2yZPf5AKGiZTnM1FtK8QEtL
         zjhbqQtf0B2OE7rgUeQt4tsf3eIwCCQ5/E6K7iw7nCDdQlpDzgNl6i5E6ifMbE6K3x
         beBqsSfgqQs2WG/3siR8ziELWpXjuVUZrYugEw9j2Coigyh5wzxEwiwvgmeZ1KPsoA
         nKa3aCNZh9dqw==
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
Subject: [PATCH AUTOSEL 5.4 08/17] crypto: x86/chacha20 - Avoid spurious jumps to other functions
Date:   Wed,  6 Apr 2022 21:15:12 -0400
Message-Id: <20220407011521.115014-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011521.115014-1-sashal@kernel.org>
References: <20220407011521.115014-1-sashal@kernel.org>
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
index 848f9c75fd4f..596f91e3a774 100644
--- a/arch/x86/crypto/chacha-avx512vl-x86_64.S
+++ b/arch/x86/crypto/chacha-avx512vl-x86_64.S
@@ -172,7 +172,7 @@ ENTRY(chacha_2block_xor_avx512vl)
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%rax
 	and		$0xf,%rcx
-	jz		.Ldone8
+	jz		.Ldone2
 	mov		%rax,%r9
 	and		$~0xf,%r9
 
@@ -438,7 +438,7 @@ ENTRY(chacha_4block_xor_avx512vl)
 	# xor remaining bytes from partial register into output
 	mov		%rcx,%rax
 	and		$0xf,%rcx
-	jz		.Ldone8
+	jz		.Ldone4
 	mov		%rax,%r9
 	and		$~0xf,%r9
 
-- 
2.35.1

