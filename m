Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CA4531C79
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbiEWROl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbiEWRMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:12:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BD795A4;
        Mon, 23 May 2022 10:12:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0853D614B8;
        Mon, 23 May 2022 17:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED440C385AA;
        Mon, 23 May 2022 17:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325911;
        bh=yWszmqLY47S5iaXcawYdL8HPP6PVa/621Zhmc4slavE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BE15vY18GCOr2FK2EJ2HuL8pMnNuSlXSRjqSYiTA8mWflTsf9mo/xZRZkEQhHYRk
         WmhSIQ5Ipbpk69/g7KiVZ1l+a1S/06IlM408nkcL/qm2yNPBq3Gz8/RZADlw/aLbmi
         +ntb0Sjhd2lTve18DKfXLnmKgDDBwlzTIy2hp+fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Martin Willi <martin@strongswan.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/68] crypto: x86/chacha20 - Avoid spurious jumps to other functions
Date:   Mon, 23 May 2022 19:04:36 +0200
Message-Id: <20220523165804.100193933@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



