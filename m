Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA2C57EDDB
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbiGWKDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237922AbiGWKDR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:03:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972FF87222;
        Sat, 23 Jul 2022 02:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99DE86116A;
        Sat, 23 Jul 2022 09:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EB5C341C0;
        Sat, 23 Jul 2022 09:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570361;
        bh=DYakpdbPRHY7KHTWH+Lrd6E6Ay+oTi6Mb+KyBy/h+A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSlykiNOF6NfbYtd5zTGivPsYnLmfvBnIKWvmDJytSMozIv0FhMiL6nD9DiSni/Hu
         fkkC+WH9pHbqVz30RmcNrb4dH7KFXPBglEARTSE3BEFq3I7v7F4fbkXi5Oq1NjXjiY
         49lC72Ofy9t3nUD/4WA59Naaf3Lt10q58Hnc6MOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 070/148] crypto: x86/poly1305 - Fixup SLS
Date:   Sat, 23 Jul 2022 11:54:42 +0200
Message-Id: <20220723095243.840940616@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 7ed7aa4de9421229be6d331ed52d5cd09c99f409 upstream.

Due to being a perl generated asm file, it got missed by the mass
convertion script.

arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_init_x86_64()+0x3a: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_x86_64()+0xf2: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_emit_x86_64()+0x37: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: __poly1305_block()+0x6d: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: __poly1305_init_avx()+0x1e8: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx()+0x18a: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx()+0xaf8: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_emit_avx()+0x99: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx2()+0x18a: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx2()+0x776: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx512()+0x18a: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx512()+0x796: missing int3 after ret
arch/x86/crypto/poly1305-x86_64-cryptogams.o: warning: objtool: poly1305_blocks_avx512()+0x10bd: missing int3 after ret

Fixes: f94909ceb1ed ("x86: Prepare asm files for straight-line-speculation")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/poly1305-x86_64-cryptogams.pl |   38 +++++++++++++-------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
+++ b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
@@ -297,7 +297,7 @@ ___
 $code.=<<___;
 	mov	\$1,%eax
 .Lno_key:
-	ret
+	RET
 ___
 &end_function("poly1305_init_x86_64");
 
@@ -373,7 +373,7 @@ $code.=<<___;
 .cfi_adjust_cfa_offset	-48
 .Lno_data:
 .Lblocks_epilogue:
-	ret
+	RET
 .cfi_endproc
 ___
 &end_function("poly1305_blocks_x86_64");
@@ -399,7 +399,7 @@ $code.=<<___;
 	mov	%rax,0($mac)	# write result
 	mov	%rcx,8($mac)
 
-	ret
+	RET
 ___
 &end_function("poly1305_emit_x86_64");
 if ($avx) {
@@ -429,7 +429,7 @@ ___
 	&poly1305_iteration();
 $code.=<<___;
 	pop $ctx
-	ret
+	RET
 .size	__poly1305_block,.-__poly1305_block
 
 .type	__poly1305_init_avx,\@abi-omnipotent
@@ -594,7 +594,7 @@ __poly1305_init_avx:
 
 	lea	-48-64($ctx),$ctx	# size [de-]optimization
 	pop %rbp
-	ret
+	RET
 .size	__poly1305_init_avx,.-__poly1305_init_avx
 ___
 
@@ -747,7 +747,7 @@ $code.=<<___;
 .cfi_restore	%rbp
 .Lno_data_avx:
 .Lblocks_avx_epilogue:
-	ret
+	RET
 .cfi_endproc
 
 .align	32
@@ -1452,7 +1452,7 @@ $code.=<<___	if (!$win64);
 ___
 $code.=<<___;
 	vzeroupper
-	ret
+	RET
 .cfi_endproc
 ___
 &end_function("poly1305_blocks_avx");
@@ -1508,7 +1508,7 @@ $code.=<<___;
 	mov	%rax,0($mac)	# write result
 	mov	%rcx,8($mac)
 
-	ret
+	RET
 ___
 &end_function("poly1305_emit_avx");
 
@@ -1675,7 +1675,7 @@ $code.=<<___;
 .cfi_restore 	%rbp
 .Lno_data_avx2$suffix:
 .Lblocks_avx2_epilogue$suffix:
-	ret
+	RET
 .cfi_endproc
 
 .align	32
@@ -2201,7 +2201,7 @@ $code.=<<___	if (!$win64);
 ___
 $code.=<<___;
 	vzeroupper
-	ret
+	RET
 .cfi_endproc
 ___
 if($avx > 2 && $avx512) {
@@ -2792,7 +2792,7 @@ $code.=<<___	if (!$win64);
 .cfi_def_cfa_register	%rsp
 ___
 $code.=<<___;
-	ret
+	RET
 .cfi_endproc
 ___
 
@@ -2893,7 +2893,7 @@ $code.=<<___	if ($flavour =~ /elf32/);
 ___
 $code.=<<___;
 	mov	\$1,%eax
-	ret
+	RET
 .size	poly1305_init_base2_44,.-poly1305_init_base2_44
 ___
 {
@@ -3010,7 +3010,7 @@ poly1305_blocks_vpmadd52:
 	jnz		.Lblocks_vpmadd52_4x
 
 .Lno_data_vpmadd52:
-	ret
+	RET
 .size	poly1305_blocks_vpmadd52,.-poly1305_blocks_vpmadd52
 ___
 }
@@ -3451,7 +3451,7 @@ poly1305_blocks_vpmadd52_4x:
 	vzeroall
 
 .Lno_data_vpmadd52_4x:
-	ret
+	RET
 .size	poly1305_blocks_vpmadd52_4x,.-poly1305_blocks_vpmadd52_4x
 ___
 }
@@ -3824,7 +3824,7 @@ $code.=<<___;
 	vzeroall
 
 .Lno_data_vpmadd52_8x:
-	ret
+	RET
 .size	poly1305_blocks_vpmadd52_8x,.-poly1305_blocks_vpmadd52_8x
 ___
 }
@@ -3861,7 +3861,7 @@ poly1305_emit_base2_44:
 	mov	%rax,0($mac)	# write result
 	mov	%rcx,8($mac)
 
-	ret
+	RET
 .size	poly1305_emit_base2_44,.-poly1305_emit_base2_44
 ___
 }	}	}
@@ -3916,7 +3916,7 @@ xor128_encrypt_n_pad:
 
 .Ldone_enc:
 	mov	$otp,%rax
-	ret
+	RET
 .size	xor128_encrypt_n_pad,.-xor128_encrypt_n_pad
 
 .globl	xor128_decrypt_n_pad
@@ -3967,7 +3967,7 @@ xor128_decrypt_n_pad:
 
 .Ldone_dec:
 	mov	$otp,%rax
-	ret
+	RET
 .size	xor128_decrypt_n_pad,.-xor128_decrypt_n_pad
 ___
 }
@@ -4109,7 +4109,7 @@ avx_handler:
 	pop	%rbx
 	pop	%rdi
 	pop	%rsi
-	ret
+	RET
 .size	avx_handler,.-avx_handler
 
 .section	.pdata


