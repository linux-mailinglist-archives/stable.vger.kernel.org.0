Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4A152794C
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbiEOSsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238570AbiEOSr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:47:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2188C13D41;
        Sun, 15 May 2022 11:47:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EC306111F;
        Sun, 15 May 2022 18:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020E8C385B8;
        Sun, 15 May 2022 18:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640460;
        bh=JxClA748nwn7YdlTmR2mSEyVEAP8dp2LftaR9n5XV2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4BZDiC4387V0EZXnCPEMy+GCccQR9T+9RoExTHzYEkjJCLLMfnONeMV3B7JceuJl
         XzGDNZPECr95o79smdAcXFeUxkxDcoIeI1gsK24XbAQWRkDAH9r8WLcE4TUNU73xLw
         PNSJpZVsev8gWhDyI2fNdBGp1YHFOooNzTgWneK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.40
Date:   Sun, 15 May 2022 20:47:28 +0200
Message-Id: <1652640447206144@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <1652640447116155@kroah.com>
References: <1652640447116155@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index ceb42be11438..d8003cb5b6ba 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 39
+SUBLEVEL = 40
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 819f8c2e2c67..d02b04d30096 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -468,6 +468,18 @@ config RETPOLINE
 	  branches. Requires a compiler with -mindirect-branch=thunk-extern
 	  support for full protection. The kernel may run slower.
 
+config CC_HAS_SLS
+	def_bool $(cc-option,-mharden-sls=all)
+
+config SLS
+	bool "Mitigate Straight-Line-Speculation"
+	depends on CC_HAS_SLS && X86_64
+	default n
+	help
+	  Compile the kernel with straight-line-speculation options to guard
+	  against straight line speculation. The kernel image might be slightly
+	  larger.
+
 config X86_CPU_RESCTRL
 	bool "x86 CPU resource control support"
 	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 7488cfbbd2f6..300227818206 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -179,6 +179,10 @@ ifdef CONFIG_RETPOLINE
   endif
 endif
 
+ifdef CONFIG_SLS
+  KBUILD_CFLAGS += -mharden-sls=all
+endif
+
 KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
 
 ifdef CONFIG_LTO_CLANG
diff --git a/arch/x86/boot/compressed/efi_thunk_64.S b/arch/x86/boot/compressed/efi_thunk_64.S
index 8bb92e9f4e97..70052779b235 100644
--- a/arch/x86/boot/compressed/efi_thunk_64.S
+++ b/arch/x86/boot/compressed/efi_thunk_64.S
@@ -93,7 +93,7 @@ SYM_FUNC_START(__efi64_thunk)
 
 	pop	%rbx
 	pop	%rbp
-	ret
+	RET
 SYM_FUNC_END(__efi64_thunk)
 
 	.code32
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 572c535cf45b..fd9441f40457 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -813,7 +813,7 @@ SYM_FUNC_START(efi32_pe_entry)
 2:	popl	%edi				// restore callee-save registers
 	popl	%ebx
 	leave
-	ret
+	RET
 SYM_FUNC_END(efi32_pe_entry)
 
 	.section ".rodata"
@@ -868,7 +868,7 @@ SYM_FUNC_START(startup32_set_idt_entry)
 
 	pop     %ecx
 	pop     %ebx
-	ret
+	RET
 SYM_FUNC_END(startup32_set_idt_entry)
 #endif
 
@@ -884,7 +884,7 @@ SYM_FUNC_START(startup32_load_idt)
 	movl	%eax, rva(boot32_idt_desc+2)(%ebp)
 	lidt    rva(boot32_idt_desc)(%ebp)
 #endif
-	ret
+	RET
 SYM_FUNC_END(startup32_load_idt)
 
 /*
@@ -954,7 +954,7 @@ SYM_FUNC_START(startup32_check_sev_cbit)
 	popl	%ebx
 	popl	%eax
 #endif
-	ret
+	RET
 SYM_FUNC_END(startup32_check_sev_cbit)
 
 /*
diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index c1e81a848b2a..a63424d13627 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -58,7 +58,7 @@ SYM_FUNC_START(get_sev_encryption_bit)
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
-	ret
+	RET
 SYM_FUNC_END(get_sev_encryption_bit)
 
 /**
@@ -92,7 +92,7 @@ SYM_CODE_START_LOCAL(sev_es_req_cpuid)
 	/* All good - return success */
 	xorl	%eax, %eax
 1:
-	ret
+	RET
 2:
 	movl	$-1, %eax
 	jmp	1b
@@ -221,7 +221,7 @@ SYM_FUNC_START(set_sev_encryption_mask)
 #endif
 
 	xor	%rax, %rax
-	ret
+	RET
 SYM_FUNC_END(set_sev_encryption_mask)
 
 	.data
diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 51d46d93efbc..b48ddebb4748 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -122,7 +122,7 @@ SYM_FUNC_START_LOCAL(__load_partial)
 	pxor T0, MSG
 
 .Lld_partial_8:
-	ret
+	RET
 SYM_FUNC_END(__load_partial)
 
 /*
@@ -180,7 +180,7 @@ SYM_FUNC_START_LOCAL(__store_partial)
 	mov %r10b, (%r9)
 
 .Lst_partial_1:
-	ret
+	RET
 SYM_FUNC_END(__store_partial)
 
 /*
@@ -225,7 +225,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_init)
 	movdqu STATE4, 0x40(STATEP)
 
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(crypto_aegis128_aesni_init)
 
 /*
@@ -337,7 +337,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lad_out_1:
 	movdqu STATE4, 0x00(STATEP)
@@ -346,7 +346,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lad_out_2:
 	movdqu STATE3, 0x00(STATEP)
@@ -355,7 +355,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 	movdqu STATE1, 0x30(STATEP)
 	movdqu STATE2, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lad_out_3:
 	movdqu STATE2, 0x00(STATEP)
@@ -364,7 +364,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 	movdqu STATE0, 0x30(STATEP)
 	movdqu STATE1, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lad_out_4:
 	movdqu STATE1, 0x00(STATEP)
@@ -373,11 +373,11 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 	movdqu STATE4, 0x30(STATEP)
 	movdqu STATE0, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lad_out:
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(crypto_aegis128_aesni_ad)
 
 .macro encrypt_block a s0 s1 s2 s3 s4 i
@@ -452,7 +452,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lenc_out_1:
 	movdqu STATE3, 0x00(STATEP)
@@ -461,7 +461,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc)
 	movdqu STATE1, 0x30(STATEP)
 	movdqu STATE2, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lenc_out_2:
 	movdqu STATE2, 0x00(STATEP)
@@ -470,7 +470,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc)
 	movdqu STATE0, 0x30(STATEP)
 	movdqu STATE1, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lenc_out_3:
 	movdqu STATE1, 0x00(STATEP)
@@ -479,7 +479,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc)
 	movdqu STATE4, 0x30(STATEP)
 	movdqu STATE0, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lenc_out_4:
 	movdqu STATE0, 0x00(STATEP)
@@ -488,11 +488,11 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Lenc_out:
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(crypto_aegis128_aesni_enc)
 
 /*
@@ -532,7 +532,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc_tail)
 	movdqu STATE3, 0x40(STATEP)
 
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(crypto_aegis128_aesni_enc_tail)
 
 .macro decrypt_block a s0 s1 s2 s3 s4 i
@@ -606,7 +606,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Ldec_out_1:
 	movdqu STATE3, 0x00(STATEP)
@@ -615,7 +615,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec)
 	movdqu STATE1, 0x30(STATEP)
 	movdqu STATE2, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Ldec_out_2:
 	movdqu STATE2, 0x00(STATEP)
@@ -624,7 +624,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec)
 	movdqu STATE0, 0x30(STATEP)
 	movdqu STATE1, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Ldec_out_3:
 	movdqu STATE1, 0x00(STATEP)
@@ -633,7 +633,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec)
 	movdqu STATE4, 0x30(STATEP)
 	movdqu STATE0, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Ldec_out_4:
 	movdqu STATE0, 0x00(STATEP)
@@ -642,11 +642,11 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
 	FRAME_END
-	ret
+	RET
 
 .Ldec_out:
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(crypto_aegis128_aesni_dec)
 
 /*
@@ -696,7 +696,7 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec_tail)
 	movdqu STATE3, 0x40(STATEP)
 
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(crypto_aegis128_aesni_dec_tail)
 
 /*
@@ -743,5 +743,5 @@ SYM_FUNC_START(crypto_aegis128_aesni_final)
 	movdqu MSG, (%rsi)
 
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(crypto_aegis128_aesni_final)
diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index 3f0fc7dd87d7..c799838242a6 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -525,7 +525,7 @@ ddq_add_8:
 	/* return updated IV */
 	vpshufb	xbyteswap, xcounter, xcounter
 	vmovdqu	xcounter, (p_iv)
-	ret
+	RET
 .endm
 
 /*
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 4e3972570916..363699dd7220 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1594,7 +1594,7 @@ SYM_FUNC_START(aesni_gcm_dec)
 	GCM_ENC_DEC dec
 	GCM_COMPLETE arg10, arg11
 	FUNC_RESTORE
-	ret
+	RET
 SYM_FUNC_END(aesni_gcm_dec)
 
 
@@ -1683,7 +1683,7 @@ SYM_FUNC_START(aesni_gcm_enc)
 
 	GCM_COMPLETE arg10, arg11
 	FUNC_RESTORE
-	ret
+	RET
 SYM_FUNC_END(aesni_gcm_enc)
 
 /*****************************************************************************
@@ -1701,7 +1701,7 @@ SYM_FUNC_START(aesni_gcm_init)
 	FUNC_SAVE
 	GCM_INIT %arg3, %arg4,%arg5, %arg6
 	FUNC_RESTORE
-	ret
+	RET
 SYM_FUNC_END(aesni_gcm_init)
 
 /*****************************************************************************
@@ -1716,7 +1716,7 @@ SYM_FUNC_START(aesni_gcm_enc_update)
 	FUNC_SAVE
 	GCM_ENC_DEC enc
 	FUNC_RESTORE
-	ret
+	RET
 SYM_FUNC_END(aesni_gcm_enc_update)
 
 /*****************************************************************************
@@ -1731,7 +1731,7 @@ SYM_FUNC_START(aesni_gcm_dec_update)
 	FUNC_SAVE
 	GCM_ENC_DEC dec
 	FUNC_RESTORE
-	ret
+	RET
 SYM_FUNC_END(aesni_gcm_dec_update)
 
 /*****************************************************************************
@@ -1746,7 +1746,7 @@ SYM_FUNC_START(aesni_gcm_finalize)
 	FUNC_SAVE
 	GCM_COMPLETE %arg3 %arg4
 	FUNC_RESTORE
-	ret
+	RET
 SYM_FUNC_END(aesni_gcm_finalize)
 
 #endif
@@ -1762,7 +1762,7 @@ SYM_FUNC_START_LOCAL(_key_expansion_256a)
 	pxor %xmm1, %xmm0
 	movaps %xmm0, (TKEYP)
 	add $0x10, TKEYP
-	ret
+	RET
 SYM_FUNC_END(_key_expansion_256a)
 SYM_FUNC_END_ALIAS(_key_expansion_128)
 
@@ -1787,7 +1787,7 @@ SYM_FUNC_START_LOCAL(_key_expansion_192a)
 	shufps $0b01001110, %xmm2, %xmm1
 	movaps %xmm1, 0x10(TKEYP)
 	add $0x20, TKEYP
-	ret
+	RET
 SYM_FUNC_END(_key_expansion_192a)
 
 SYM_FUNC_START_LOCAL(_key_expansion_192b)
@@ -1806,7 +1806,7 @@ SYM_FUNC_START_LOCAL(_key_expansion_192b)
 
 	movaps %xmm0, (TKEYP)
 	add $0x10, TKEYP
-	ret
+	RET
 SYM_FUNC_END(_key_expansion_192b)
 
 SYM_FUNC_START_LOCAL(_key_expansion_256b)
@@ -1818,7 +1818,7 @@ SYM_FUNC_START_LOCAL(_key_expansion_256b)
 	pxor %xmm1, %xmm2
 	movaps %xmm2, (TKEYP)
 	add $0x10, TKEYP
-	ret
+	RET
 SYM_FUNC_END(_key_expansion_256b)
 
 /*
@@ -1933,7 +1933,7 @@ SYM_FUNC_START(aesni_set_key)
 	popl KEYP
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_set_key)
 
 /*
@@ -1957,7 +1957,7 @@ SYM_FUNC_START(aesni_enc)
 	popl KEYP
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_enc)
 
 /*
@@ -2014,7 +2014,7 @@ SYM_FUNC_START_LOCAL(_aesni_enc1)
 	aesenc KEY, STATE
 	movaps 0x70(TKEYP), KEY
 	aesenclast KEY, STATE
-	ret
+	RET
 SYM_FUNC_END(_aesni_enc1)
 
 /*
@@ -2122,7 +2122,7 @@ SYM_FUNC_START_LOCAL(_aesni_enc4)
 	aesenclast KEY, STATE2
 	aesenclast KEY, STATE3
 	aesenclast KEY, STATE4
-	ret
+	RET
 SYM_FUNC_END(_aesni_enc4)
 
 /*
@@ -2147,7 +2147,7 @@ SYM_FUNC_START(aesni_dec)
 	popl KEYP
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_dec)
 
 /*
@@ -2204,7 +2204,7 @@ SYM_FUNC_START_LOCAL(_aesni_dec1)
 	aesdec KEY, STATE
 	movaps 0x70(TKEYP), KEY
 	aesdeclast KEY, STATE
-	ret
+	RET
 SYM_FUNC_END(_aesni_dec1)
 
 /*
@@ -2312,7 +2312,7 @@ SYM_FUNC_START_LOCAL(_aesni_dec4)
 	aesdeclast KEY, STATE2
 	aesdeclast KEY, STATE3
 	aesdeclast KEY, STATE4
-	ret
+	RET
 SYM_FUNC_END(_aesni_dec4)
 
 /*
@@ -2372,7 +2372,7 @@ SYM_FUNC_START(aesni_ecb_enc)
 	popl LEN
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_ecb_enc)
 
 /*
@@ -2433,7 +2433,7 @@ SYM_FUNC_START(aesni_ecb_dec)
 	popl LEN
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_ecb_dec)
 
 /*
@@ -2477,7 +2477,7 @@ SYM_FUNC_START(aesni_cbc_enc)
 	popl IVP
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_cbc_enc)
 
 /*
@@ -2570,7 +2570,7 @@ SYM_FUNC_START(aesni_cbc_dec)
 	popl IVP
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_cbc_dec)
 
 /*
@@ -2627,7 +2627,7 @@ SYM_FUNC_START(aesni_cts_cbc_enc)
 	popl IVP
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_cts_cbc_enc)
 
 /*
@@ -2688,7 +2688,7 @@ SYM_FUNC_START(aesni_cts_cbc_dec)
 	popl IVP
 #endif
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_cts_cbc_dec)
 
 .pushsection .rodata
@@ -2725,7 +2725,7 @@ SYM_FUNC_START_LOCAL(_aesni_inc_init)
 	mov $1, TCTR_LOW
 	movq TCTR_LOW, INC
 	movq CTR, TCTR_LOW
-	ret
+	RET
 SYM_FUNC_END(_aesni_inc_init)
 
 /*
@@ -2753,7 +2753,7 @@ SYM_FUNC_START_LOCAL(_aesni_inc)
 .Linc_low:
 	movaps CTR, IV
 	pshufb BSWAP_MASK, IV
-	ret
+	RET
 SYM_FUNC_END(_aesni_inc)
 
 /*
@@ -2816,7 +2816,7 @@ SYM_FUNC_START(aesni_ctr_enc)
 	movups IV, (IVP)
 .Lctr_enc_just_ret:
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(aesni_ctr_enc)
 
 #endif
@@ -2932,7 +2932,7 @@ SYM_FUNC_START(aesni_xts_encrypt)
 	popl IVP
 #endif
 	FRAME_END
-	ret
+	RET
 
 .Lxts_enc_1x:
 	add $64, LEN
@@ -3092,7 +3092,7 @@ SYM_FUNC_START(aesni_xts_decrypt)
 	popl IVP
 #endif
 	FRAME_END
-	ret
+	RET
 
 .Lxts_dec_1x:
 	add $64, LEN
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 98e3552b6e03..0852ab573fd3 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -1767,7 +1767,7 @@ SYM_FUNC_START(aesni_gcm_init_avx_gen2)
         FUNC_SAVE
         INIT GHASH_MUL_AVX, PRECOMPUTE_AVX
         FUNC_RESTORE
-        ret
+        RET
 SYM_FUNC_END(aesni_gcm_init_avx_gen2)
 
 ###############################################################################
@@ -1788,15 +1788,15 @@ SYM_FUNC_START(aesni_gcm_enc_update_avx_gen2)
         # must be 192
         GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GHASH_LAST_8_AVX, GHASH_MUL_AVX, ENC, 11
         FUNC_RESTORE
-        ret
+        RET
 key_128_enc_update:
         GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GHASH_LAST_8_AVX, GHASH_MUL_AVX, ENC, 9
         FUNC_RESTORE
-        ret
+        RET
 key_256_enc_update:
         GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GHASH_LAST_8_AVX, GHASH_MUL_AVX, ENC, 13
         FUNC_RESTORE
-        ret
+        RET
 SYM_FUNC_END(aesni_gcm_enc_update_avx_gen2)
 
 ###############################################################################
@@ -1817,15 +1817,15 @@ SYM_FUNC_START(aesni_gcm_dec_update_avx_gen2)
         # must be 192
         GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GHASH_LAST_8_AVX, GHASH_MUL_AVX, DEC, 11
         FUNC_RESTORE
-        ret
+        RET
 key_128_dec_update:
         GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GHASH_LAST_8_AVX, GHASH_MUL_AVX, DEC, 9
         FUNC_RESTORE
-        ret
+        RET
 key_256_dec_update:
         GCM_ENC_DEC INITIAL_BLOCKS_AVX, GHASH_8_ENCRYPT_8_PARALLEL_AVX, GHASH_LAST_8_AVX, GHASH_MUL_AVX, DEC, 13
         FUNC_RESTORE
-        ret
+        RET
 SYM_FUNC_END(aesni_gcm_dec_update_avx_gen2)
 
 ###############################################################################
@@ -1846,15 +1846,15 @@ SYM_FUNC_START(aesni_gcm_finalize_avx_gen2)
         # must be 192
         GCM_COMPLETE GHASH_MUL_AVX, 11, arg3, arg4
         FUNC_RESTORE
-        ret
+        RET
 key_128_finalize:
         GCM_COMPLETE GHASH_MUL_AVX, 9, arg3, arg4
         FUNC_RESTORE
-        ret
+        RET
 key_256_finalize:
         GCM_COMPLETE GHASH_MUL_AVX, 13, arg3, arg4
         FUNC_RESTORE
-        ret
+        RET
 SYM_FUNC_END(aesni_gcm_finalize_avx_gen2)
 
 ###############################################################################
@@ -2735,7 +2735,7 @@ SYM_FUNC_START(aesni_gcm_init_avx_gen4)
         FUNC_SAVE
         INIT GHASH_MUL_AVX2, PRECOMPUTE_AVX2
         FUNC_RESTORE
-        ret
+        RET
 SYM_FUNC_END(aesni_gcm_init_avx_gen4)
 
 ###############################################################################
@@ -2756,15 +2756,15 @@ SYM_FUNC_START(aesni_gcm_enc_update_avx_gen4)
         # must be 192
         GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, ENC, 11
         FUNC_RESTORE
-	ret
+	RET
 key_128_enc_update4:
         GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, ENC, 9
         FUNC_RESTORE
-	ret
+	RET
 key_256_enc_update4:
         GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, ENC, 13
         FUNC_RESTORE
-	ret
+	RET
 SYM_FUNC_END(aesni_gcm_enc_update_avx_gen4)
 
 ###############################################################################
@@ -2785,15 +2785,15 @@ SYM_FUNC_START(aesni_gcm_dec_update_avx_gen4)
         # must be 192
         GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, DEC, 11
         FUNC_RESTORE
-        ret
+        RET
 key_128_dec_update4:
         GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, DEC, 9
         FUNC_RESTORE
-        ret
+        RET
 key_256_dec_update4:
         GCM_ENC_DEC INITIAL_BLOCKS_AVX2, GHASH_8_ENCRYPT_8_PARALLEL_AVX2, GHASH_LAST_8_AVX2, GHASH_MUL_AVX2, DEC, 13
         FUNC_RESTORE
-        ret
+        RET
 SYM_FUNC_END(aesni_gcm_dec_update_avx_gen4)
 
 ###############################################################################
@@ -2814,13 +2814,13 @@ SYM_FUNC_START(aesni_gcm_finalize_avx_gen4)
         # must be 192
         GCM_COMPLETE GHASH_MUL_AVX2, 11, arg3, arg4
         FUNC_RESTORE
-        ret
+        RET
 key_128_finalize4:
         GCM_COMPLETE GHASH_MUL_AVX2, 9, arg3, arg4
         FUNC_RESTORE
-        ret
+        RET
 key_256_finalize4:
         GCM_COMPLETE GHASH_MUL_AVX2, 13, arg3, arg4
         FUNC_RESTORE
-        ret
+        RET
 SYM_FUNC_END(aesni_gcm_finalize_avx_gen4)
diff --git a/arch/x86/crypto/blake2s-core.S b/arch/x86/crypto/blake2s-core.S
index 2ca79974f819..b50b35ff1fdb 100644
--- a/arch/x86/crypto/blake2s-core.S
+++ b/arch/x86/crypto/blake2s-core.S
@@ -171,7 +171,7 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 	movdqu		%xmm1,0x10(%rdi)
 	movdqu		%xmm14,0x20(%rdi)
 .Lendofloop:
-	ret
+	RET
 SYM_FUNC_END(blake2s_compress_ssse3)
 
 #ifdef CONFIG_AS_AVX512
@@ -251,6 +251,6 @@ SYM_FUNC_START(blake2s_compress_avx512)
 	vmovdqu		%xmm1,0x10(%rdi)
 	vmovdqu		%xmm4,0x20(%rdi)
 	vzeroupper
-	retq
+	RET
 SYM_FUNC_END(blake2s_compress_avx512)
 #endif /* CONFIG_AS_AVX512 */
diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto/blowfish-x86_64-asm_64.S
index 4222ac6d6584..802d71582689 100644
--- a/arch/x86/crypto/blowfish-x86_64-asm_64.S
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -135,10 +135,10 @@ SYM_FUNC_START(__blowfish_enc_blk)
 	jnz .L__enc_xor;
 
 	write_block();
-	ret;
+	RET;
 .L__enc_xor:
 	xor_block();
-	ret;
+	RET;
 SYM_FUNC_END(__blowfish_enc_blk)
 
 SYM_FUNC_START(blowfish_dec_blk)
@@ -170,7 +170,7 @@ SYM_FUNC_START(blowfish_dec_blk)
 
 	movq %r11, %r12;
 
-	ret;
+	RET;
 SYM_FUNC_END(blowfish_dec_blk)
 
 /**********************************************************************
@@ -322,14 +322,14 @@ SYM_FUNC_START(__blowfish_enc_blk_4way)
 
 	popq %rbx;
 	popq %r12;
-	ret;
+	RET;
 
 .L__enc_xor4:
 	xor_block4();
 
 	popq %rbx;
 	popq %r12;
-	ret;
+	RET;
 SYM_FUNC_END(__blowfish_enc_blk_4way)
 
 SYM_FUNC_START(blowfish_dec_blk_4way)
@@ -364,5 +364,5 @@ SYM_FUNC_START(blowfish_dec_blk_4way)
 	popq %rbx;
 	popq %r12;
 
-	ret;
+	RET;
 SYM_FUNC_END(blowfish_dec_blk_4way)
diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index e2a0e0f4bf9d..2e1658ddbe1a 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -192,7 +192,7 @@ SYM_FUNC_START_LOCAL(roundsm16_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_c
 	roundsm16(%xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
 		  %xmm8, %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm15,
 		  %rcx, (%r9));
-	ret;
+	RET;
 SYM_FUNC_END(roundsm16_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
 
 .align 8
@@ -200,7 +200,7 @@ SYM_FUNC_START_LOCAL(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_a
 	roundsm16(%xmm4, %xmm5, %xmm6, %xmm7, %xmm0, %xmm1, %xmm2, %xmm3,
 		  %xmm12, %xmm13, %xmm14, %xmm15, %xmm8, %xmm9, %xmm10, %xmm11,
 		  %rax, (%r9));
-	ret;
+	RET;
 SYM_FUNC_END(roundsm16_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 
 /*
@@ -778,7 +778,7 @@ SYM_FUNC_START_LOCAL(__camellia_enc_blk16)
 		    %xmm15, (key_table)(CTX, %r8, 8), (%rax), 1 * 16(%rax));
 
 	FRAME_END
-	ret;
+	RET;
 
 .align 8
 .Lenc_max32:
@@ -865,7 +865,7 @@ SYM_FUNC_START_LOCAL(__camellia_dec_blk16)
 		    %xmm15, (key_table)(CTX), (%rax), 1 * 16(%rax));
 
 	FRAME_END
-	ret;
+	RET;
 
 .align 8
 .Ldec_max32:
@@ -906,7 +906,7 @@ SYM_FUNC_START(camellia_ecb_enc_16way)
 		     %xmm8, %rsi);
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(camellia_ecb_enc_16way)
 
 SYM_FUNC_START(camellia_ecb_dec_16way)
@@ -936,7 +936,7 @@ SYM_FUNC_START(camellia_ecb_dec_16way)
 		     %xmm8, %rsi);
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(camellia_ecb_dec_16way)
 
 SYM_FUNC_START(camellia_cbc_dec_16way)
@@ -987,5 +987,5 @@ SYM_FUNC_START(camellia_cbc_dec_16way)
 		     %xmm8, %rsi);
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(camellia_cbc_dec_16way)
diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index 706f70829a07..0e4e9abbf4de 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -226,7 +226,7 @@ SYM_FUNC_START_LOCAL(roundsm32_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_c
 	roundsm32(%ymm0, %ymm1, %ymm2, %ymm3, %ymm4, %ymm5, %ymm6, %ymm7,
 		  %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14, %ymm15,
 		  %rcx, (%r9));
-	ret;
+	RET;
 SYM_FUNC_END(roundsm32_x0_x1_x2_x3_x4_x5_x6_x7_y0_y1_y2_y3_y4_y5_y6_y7_cd)
 
 .align 8
@@ -234,7 +234,7 @@ SYM_FUNC_START_LOCAL(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_a
 	roundsm32(%ymm4, %ymm5, %ymm6, %ymm7, %ymm0, %ymm1, %ymm2, %ymm3,
 		  %ymm12, %ymm13, %ymm14, %ymm15, %ymm8, %ymm9, %ymm10, %ymm11,
 		  %rax, (%r9));
-	ret;
+	RET;
 SYM_FUNC_END(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 
 /*
@@ -814,7 +814,7 @@ SYM_FUNC_START_LOCAL(__camellia_enc_blk32)
 		    %ymm15, (key_table)(CTX, %r8, 8), (%rax), 1 * 32(%rax));
 
 	FRAME_END
-	ret;
+	RET;
 
 .align 8
 .Lenc_max32:
@@ -901,7 +901,7 @@ SYM_FUNC_START_LOCAL(__camellia_dec_blk32)
 		    %ymm15, (key_table)(CTX), (%rax), 1 * 32(%rax));
 
 	FRAME_END
-	ret;
+	RET;
 
 .align 8
 .Ldec_max32:
@@ -946,7 +946,7 @@ SYM_FUNC_START(camellia_ecb_enc_32way)
 	vzeroupper;
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(camellia_ecb_enc_32way)
 
 SYM_FUNC_START(camellia_ecb_dec_32way)
@@ -980,7 +980,7 @@ SYM_FUNC_START(camellia_ecb_dec_32way)
 	vzeroupper;
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(camellia_ecb_dec_32way)
 
 SYM_FUNC_START(camellia_cbc_dec_32way)
@@ -1047,5 +1047,5 @@ SYM_FUNC_START(camellia_cbc_dec_32way)
 
 	addq $(16 * 32), %rsp;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(camellia_cbc_dec_32way)
diff --git a/arch/x86/crypto/camellia-x86_64-asm_64.S b/arch/x86/crypto/camellia-x86_64-asm_64.S
index 1372e6408850..347c059f5940 100644
--- a/arch/x86/crypto/camellia-x86_64-asm_64.S
+++ b/arch/x86/crypto/camellia-x86_64-asm_64.S
@@ -213,13 +213,13 @@ SYM_FUNC_START(__camellia_enc_blk)
 	enc_outunpack(mov, RT1);
 
 	movq RR12, %r12;
-	ret;
+	RET;
 
 .L__enc_xor:
 	enc_outunpack(xor, RT1);
 
 	movq RR12, %r12;
-	ret;
+	RET;
 SYM_FUNC_END(__camellia_enc_blk)
 
 SYM_FUNC_START(camellia_dec_blk)
@@ -257,7 +257,7 @@ SYM_FUNC_START(camellia_dec_blk)
 	dec_outunpack();
 
 	movq RR12, %r12;
-	ret;
+	RET;
 SYM_FUNC_END(camellia_dec_blk)
 
 /**********************************************************************
@@ -448,14 +448,14 @@ SYM_FUNC_START(__camellia_enc_blk_2way)
 
 	movq RR12, %r12;
 	popq %rbx;
-	ret;
+	RET;
 
 .L__enc2_xor:
 	enc_outunpack2(xor, RT2);
 
 	movq RR12, %r12;
 	popq %rbx;
-	ret;
+	RET;
 SYM_FUNC_END(__camellia_enc_blk_2way)
 
 SYM_FUNC_START(camellia_dec_blk_2way)
@@ -495,5 +495,5 @@ SYM_FUNC_START(camellia_dec_blk_2way)
 
 	movq RR12, %r12;
 	movq RXOR, %rbx;
-	ret;
+	RET;
 SYM_FUNC_END(camellia_dec_blk_2way)
diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index 8a6181b08b59..b258af420c92 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -279,7 +279,7 @@ SYM_FUNC_START_LOCAL(__cast5_enc_blk16)
 	outunpack_blocks(RR3, RL3, RTMP, RX, RKM);
 	outunpack_blocks(RR4, RL4, RTMP, RX, RKM);
 
-	ret;
+	RET;
 SYM_FUNC_END(__cast5_enc_blk16)
 
 .align 16
@@ -352,7 +352,7 @@ SYM_FUNC_START_LOCAL(__cast5_dec_blk16)
 	outunpack_blocks(RR3, RL3, RTMP, RX, RKM);
 	outunpack_blocks(RR4, RL4, RTMP, RX, RKM);
 
-	ret;
+	RET;
 
 .L__skip_dec:
 	vpsrldq $4, RKR, RKR;
@@ -393,7 +393,7 @@ SYM_FUNC_START(cast5_ecb_enc_16way)
 
 	popq %r15;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(cast5_ecb_enc_16way)
 
 SYM_FUNC_START(cast5_ecb_dec_16way)
@@ -431,7 +431,7 @@ SYM_FUNC_START(cast5_ecb_dec_16way)
 
 	popq %r15;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(cast5_ecb_dec_16way)
 
 SYM_FUNC_START(cast5_cbc_dec_16way)
@@ -483,7 +483,7 @@ SYM_FUNC_START(cast5_cbc_dec_16way)
 	popq %r15;
 	popq %r12;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(cast5_cbc_dec_16way)
 
 SYM_FUNC_START(cast5_ctr_16way)
@@ -559,5 +559,5 @@ SYM_FUNC_START(cast5_ctr_16way)
 	popq %r15;
 	popq %r12;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(cast5_ctr_16way)
diff --git a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
index fbddcecc3e3f..82b716fd5dba 100644
--- a/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast6-avx-x86_64-asm_64.S
@@ -289,7 +289,7 @@ SYM_FUNC_START_LOCAL(__cast6_enc_blk8)
 	outunpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
-	ret;
+	RET;
 SYM_FUNC_END(__cast6_enc_blk8)
 
 .align 8
@@ -336,7 +336,7 @@ SYM_FUNC_START_LOCAL(__cast6_dec_blk8)
 	outunpack_blocks(RA1, RB1, RC1, RD1, RTMP, RX, RKRF, RKM);
 	outunpack_blocks(RA2, RB2, RC2, RD2, RTMP, RX, RKRF, RKM);
 
-	ret;
+	RET;
 SYM_FUNC_END(__cast6_dec_blk8)
 
 SYM_FUNC_START(cast6_ecb_enc_8way)
@@ -359,7 +359,7 @@ SYM_FUNC_START(cast6_ecb_enc_8way)
 
 	popq %r15;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(cast6_ecb_enc_8way)
 
 SYM_FUNC_START(cast6_ecb_dec_8way)
@@ -382,7 +382,7 @@ SYM_FUNC_START(cast6_ecb_dec_8way)
 
 	popq %r15;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(cast6_ecb_dec_8way)
 
 SYM_FUNC_START(cast6_cbc_dec_8way)
@@ -408,5 +408,5 @@ SYM_FUNC_START(cast6_cbc_dec_8way)
 	popq %r15;
 	popq %r12;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(cast6_cbc_dec_8way)
diff --git a/arch/x86/crypto/chacha-avx2-x86_64.S b/arch/x86/crypto/chacha-avx2-x86_64.S
index ee9a40ab4109..f3d8fc018249 100644
--- a/arch/x86/crypto/chacha-avx2-x86_64.S
+++ b/arch/x86/crypto/chacha-avx2-x86_64.S
@@ -193,7 +193,7 @@ SYM_FUNC_START(chacha_2block_xor_avx2)
 
 .Ldone2:
 	vzeroupper
-	ret
+	RET
 
 .Lxorpart2:
 	# xor remaining bytes from partial register into output
@@ -498,7 +498,7 @@ SYM_FUNC_START(chacha_4block_xor_avx2)
 
 .Ldone4:
 	vzeroupper
-	ret
+	RET
 
 .Lxorpart4:
 	# xor remaining bytes from partial register into output
@@ -992,7 +992,7 @@ SYM_FUNC_START(chacha_8block_xor_avx2)
 .Ldone8:
 	vzeroupper
 	lea		-8(%r10),%rsp
-	ret
+	RET
 
 .Lxorpart8:
 	# xor remaining bytes from partial register into output
diff --git a/arch/x86/crypto/chacha-avx512vl-x86_64.S b/arch/x86/crypto/chacha-avx512vl-x86_64.S
index bb193fde123a..946f74dd6fba 100644
--- a/arch/x86/crypto/chacha-avx512vl-x86_64.S
+++ b/arch/x86/crypto/chacha-avx512vl-x86_64.S
@@ -166,7 +166,7 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 
 .Ldone2:
 	vzeroupper
-	ret
+	RET
 
 .Lxorpart2:
 	# xor remaining bytes from partial register into output
@@ -432,7 +432,7 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 
 .Ldone4:
 	vzeroupper
-	ret
+	RET
 
 .Lxorpart4:
 	# xor remaining bytes from partial register into output
@@ -812,7 +812,7 @@ SYM_FUNC_START(chacha_8block_xor_avx512vl)
 
 .Ldone8:
 	vzeroupper
-	ret
+	RET
 
 .Lxorpart8:
 	# xor remaining bytes from partial register into output
diff --git a/arch/x86/crypto/chacha-ssse3-x86_64.S b/arch/x86/crypto/chacha-ssse3-x86_64.S
index ca1788bfee16..7111949cd5b9 100644
--- a/arch/x86/crypto/chacha-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha-ssse3-x86_64.S
@@ -108,7 +108,7 @@ SYM_FUNC_START_LOCAL(chacha_permute)
 	sub		$2,%r8d
 	jnz		.Ldoubleround
 
-	ret
+	RET
 SYM_FUNC_END(chacha_permute)
 
 SYM_FUNC_START(chacha_block_xor_ssse3)
@@ -166,7 +166,7 @@ SYM_FUNC_START(chacha_block_xor_ssse3)
 
 .Ldone:
 	FRAME_END
-	ret
+	RET
 
 .Lxorpart:
 	# xor remaining bytes from partial register into output
@@ -217,7 +217,7 @@ SYM_FUNC_START(hchacha_block_ssse3)
 	movdqu		%xmm3,0x10(%rsi)
 
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(hchacha_block_ssse3)
 
 SYM_FUNC_START(chacha_4block_xor_ssse3)
@@ -762,7 +762,7 @@ SYM_FUNC_START(chacha_4block_xor_ssse3)
 
 .Ldone4:
 	lea		-8(%r10),%rsp
-	ret
+	RET
 
 .Lxorpart4:
 	# xor remaining bytes from partial register into output
diff --git a/arch/x86/crypto/crc32-pclmul_asm.S b/arch/x86/crypto/crc32-pclmul_asm.S
index 6e7d4c4d3208..c392a6edbfff 100644
--- a/arch/x86/crypto/crc32-pclmul_asm.S
+++ b/arch/x86/crypto/crc32-pclmul_asm.S
@@ -236,5 +236,5 @@ fold_64:
 	pxor    %xmm2, %xmm1
 	pextrd  $0x01, %xmm1, %eax
 
-	ret
+	RET
 SYM_FUNC_END(crc32_pclmul_le_16)
diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index ac1f303eed0f..80c0d22fc42c 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -306,7 +306,7 @@ do_return:
 	popq    %rsi
 	popq    %rdi
 	popq    %rbx
-        ret
+        RET
 SYM_FUNC_END(crc_pcl)
 
 .section	.rodata, "a", @progbits
diff --git a/arch/x86/crypto/crct10dif-pcl-asm_64.S b/arch/x86/crypto/crct10dif-pcl-asm_64.S
index b2533d63030e..721474abfb71 100644
--- a/arch/x86/crypto/crct10dif-pcl-asm_64.S
+++ b/arch/x86/crypto/crct10dif-pcl-asm_64.S
@@ -257,7 +257,7 @@ SYM_FUNC_START(crc_t10dif_pcl)
 	# Final CRC value (x^16 * M(x)) mod G(x) is in low 16 bits of xmm0.
 
 	pextrw	$0, %xmm0, %eax
-	ret
+	RET
 
 .align 16
 .Lless_than_256_bytes:
diff --git a/arch/x86/crypto/des3_ede-asm_64.S b/arch/x86/crypto/des3_ede-asm_64.S
index fac0fdc3f25d..f4c760f4cade 100644
--- a/arch/x86/crypto/des3_ede-asm_64.S
+++ b/arch/x86/crypto/des3_ede-asm_64.S
@@ -243,7 +243,7 @@ SYM_FUNC_START(des3_ede_x86_64_crypt_blk)
 	popq %r12;
 	popq %rbx;
 
-	ret;
+	RET;
 SYM_FUNC_END(des3_ede_x86_64_crypt_blk)
 
 /***********************************************************************
@@ -528,7 +528,7 @@ SYM_FUNC_START(des3_ede_x86_64_crypt_blk_3way)
 	popq %r12;
 	popq %rbx;
 
-	ret;
+	RET;
 SYM_FUNC_END(des3_ede_x86_64_crypt_blk_3way)
 
 .section	.rodata, "a", @progbits
diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 99ac25e18e09..2bf871899920 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -85,7 +85,7 @@ SYM_FUNC_START_LOCAL(__clmul_gf128mul_ble)
 	psrlq $1, T2
 	pxor T2, T1
 	pxor T1, DATA
-	ret
+	RET
 SYM_FUNC_END(__clmul_gf128mul_ble)
 
 /* void clmul_ghash_mul(char *dst, const u128 *shash) */
@@ -99,7 +99,7 @@ SYM_FUNC_START(clmul_ghash_mul)
 	pshufb BSWAP, DATA
 	movups DATA, (%rdi)
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(clmul_ghash_mul)
 
 /*
@@ -128,5 +128,5 @@ SYM_FUNC_START(clmul_ghash_update)
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(clmul_ghash_update)
diff --git a/arch/x86/crypto/nh-avx2-x86_64.S b/arch/x86/crypto/nh-avx2-x86_64.S
index b22c7b936272..6a0b15e7196a 100644
--- a/arch/x86/crypto/nh-avx2-x86_64.S
+++ b/arch/x86/crypto/nh-avx2-x86_64.S
@@ -153,5 +153,5 @@ SYM_FUNC_START(nh_avx2)
 	vpaddq		T1, T0, T0
 	vpaddq		T4, T0, T0
 	vmovdqu		T0, (HASH)
-	ret
+	RET
 SYM_FUNC_END(nh_avx2)
diff --git a/arch/x86/crypto/nh-sse2-x86_64.S b/arch/x86/crypto/nh-sse2-x86_64.S
index d7ae22dd6683..34c567bbcb4f 100644
--- a/arch/x86/crypto/nh-sse2-x86_64.S
+++ b/arch/x86/crypto/nh-sse2-x86_64.S
@@ -119,5 +119,5 @@ SYM_FUNC_START(nh_sse2)
 	paddq		PASS2_SUMS, T1
 	movdqu		T0, 0x00(HASH)
 	movdqu		T1, 0x10(HASH)
-	ret
+	RET
 SYM_FUNC_END(nh_sse2)
diff --git a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
index 71fae5a09e56..2077ce7a5647 100644
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
diff --git a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
index b7ee24df7fba..82f2313f512b 100644
--- a/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-avx-x86_64-asm_64.S
@@ -601,7 +601,7 @@ SYM_FUNC_START_LOCAL(__serpent_enc_blk8_avx)
 	write_blocks(RA1, RB1, RC1, RD1, RK0, RK1, RK2);
 	write_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
-	ret;
+	RET;
 SYM_FUNC_END(__serpent_enc_blk8_avx)
 
 .align 8
@@ -655,7 +655,7 @@ SYM_FUNC_START_LOCAL(__serpent_dec_blk8_avx)
 	write_blocks(RC1, RD1, RB1, RE1, RK0, RK1, RK2);
 	write_blocks(RC2, RD2, RB2, RE2, RK0, RK1, RK2);
 
-	ret;
+	RET;
 SYM_FUNC_END(__serpent_dec_blk8_avx)
 
 SYM_FUNC_START(serpent_ecb_enc_8way_avx)
@@ -673,7 +673,7 @@ SYM_FUNC_START(serpent_ecb_enc_8way_avx)
 	store_8way(%rsi, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(serpent_ecb_enc_8way_avx)
 
 SYM_FUNC_START(serpent_ecb_dec_8way_avx)
@@ -691,7 +691,7 @@ SYM_FUNC_START(serpent_ecb_dec_8way_avx)
 	store_8way(%rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(serpent_ecb_dec_8way_avx)
 
 SYM_FUNC_START(serpent_cbc_dec_8way_avx)
@@ -709,5 +709,5 @@ SYM_FUNC_START(serpent_cbc_dec_8way_avx)
 	store_cbc_8way(%rdx, %rsi, RC1, RD1, RB1, RE1, RC2, RD2, RB2, RE2);
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(serpent_cbc_dec_8way_avx)
diff --git a/arch/x86/crypto/serpent-avx2-asm_64.S b/arch/x86/crypto/serpent-avx2-asm_64.S
index 9161b6e441f3..8ea34c9b9316 100644
--- a/arch/x86/crypto/serpent-avx2-asm_64.S
+++ b/arch/x86/crypto/serpent-avx2-asm_64.S
@@ -601,7 +601,7 @@ SYM_FUNC_START_LOCAL(__serpent_enc_blk16)
 	write_blocks(RA1, RB1, RC1, RD1, RK0, RK1, RK2);
 	write_blocks(RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
-	ret;
+	RET;
 SYM_FUNC_END(__serpent_enc_blk16)
 
 .align 8
@@ -655,7 +655,7 @@ SYM_FUNC_START_LOCAL(__serpent_dec_blk16)
 	write_blocks(RC1, RD1, RB1, RE1, RK0, RK1, RK2);
 	write_blocks(RC2, RD2, RB2, RE2, RK0, RK1, RK2);
 
-	ret;
+	RET;
 SYM_FUNC_END(__serpent_dec_blk16)
 
 SYM_FUNC_START(serpent_ecb_enc_16way)
@@ -677,7 +677,7 @@ SYM_FUNC_START(serpent_ecb_enc_16way)
 	vzeroupper;
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(serpent_ecb_enc_16way)
 
 SYM_FUNC_START(serpent_ecb_dec_16way)
@@ -699,7 +699,7 @@ SYM_FUNC_START(serpent_ecb_dec_16way)
 	vzeroupper;
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(serpent_ecb_dec_16way)
 
 SYM_FUNC_START(serpent_cbc_dec_16way)
@@ -722,5 +722,5 @@ SYM_FUNC_START(serpent_cbc_dec_16way)
 	vzeroupper;
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(serpent_cbc_dec_16way)
diff --git a/arch/x86/crypto/serpent-sse2-i586-asm_32.S b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
index 6379b99cb722..8ccb03ad7cef 100644
--- a/arch/x86/crypto/serpent-sse2-i586-asm_32.S
+++ b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
@@ -553,12 +553,12 @@ SYM_FUNC_START(__serpent_enc_blk_4way)
 
 	write_blocks(%eax, RA, RB, RC, RD, RT0, RT1, RE);
 
-	ret;
+	RET;
 
 .L__enc_xor4:
 	xor_blocks(%eax, RA, RB, RC, RD, RT0, RT1, RE);
 
-	ret;
+	RET;
 SYM_FUNC_END(__serpent_enc_blk_4way)
 
 SYM_FUNC_START(serpent_dec_blk_4way)
@@ -612,5 +612,5 @@ SYM_FUNC_START(serpent_dec_blk_4way)
 	movl arg_dst(%esp), %eax;
 	write_blocks(%eax, RC, RD, RB, RE, RT0, RT1, RA);
 
-	ret;
+	RET;
 SYM_FUNC_END(serpent_dec_blk_4way)
diff --git a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
index efb6dc17dc90..e0998a011d1d 100644
--- a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
@@ -675,13 +675,13 @@ SYM_FUNC_START(__serpent_enc_blk_8way)
 	write_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
 	write_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
-	ret;
+	RET;
 
 .L__enc_xor8:
 	xor_blocks(%rsi, RA1, RB1, RC1, RD1, RK0, RK1, RK2);
 	xor_blocks(%rax, RA2, RB2, RC2, RD2, RK0, RK1, RK2);
 
-	ret;
+	RET;
 SYM_FUNC_END(__serpent_enc_blk_8way)
 
 SYM_FUNC_START(serpent_dec_blk_8way)
@@ -735,5 +735,5 @@ SYM_FUNC_START(serpent_dec_blk_8way)
 	write_blocks(%rsi, RC1, RD1, RB1, RE1, RK0, RK1, RK2);
 	write_blocks(%rax, RC2, RD2, RB2, RE2, RK0, RK1, RK2);
 
-	ret;
+	RET;
 SYM_FUNC_END(serpent_dec_blk_8way)
diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index 5eed620f4676..a96b2fd26dab 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -674,7 +674,7 @@ _loop3:
 	pop	%r12
 	pop	%rbx
 
-	ret
+	RET
 
 	SYM_FUNC_END(\name)
 .endm
diff --git a/arch/x86/crypto/sha1_ni_asm.S b/arch/x86/crypto/sha1_ni_asm.S
index 5d8415f482bd..2f94ec0e763b 100644
--- a/arch/x86/crypto/sha1_ni_asm.S
+++ b/arch/x86/crypto/sha1_ni_asm.S
@@ -290,7 +290,7 @@ SYM_FUNC_START(sha1_ni_transform)
 	mov		%rbp, %rsp
 	pop		%rbp
 
-	ret
+	RET
 SYM_FUNC_END(sha1_ni_transform)
 
 .section	.rodata.cst16.PSHUFFLE_BYTE_FLIP_MASK, "aM", @progbits, 16
diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
index d25668d2a1e9..263f916362e0 100644
--- a/arch/x86/crypto/sha1_ssse3_asm.S
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -99,7 +99,7 @@
 	pop	%rbp
 	pop	%r12
 	pop	%rbx
-	ret
+	RET
 
 	SYM_FUNC_END(\name)
 .endm
diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 4739cd31b9db..3baa1ec39097 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -458,7 +458,7 @@ done_hash:
 	popq    %r13
 	popq	%r12
 	popq    %rbx
-	ret
+	RET
 SYM_FUNC_END(sha256_transform_avx)
 
 .section	.rodata.cst256.K256, "aM", @progbits, 256
diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 4087f7432a7e..9bcdbc47b8b4 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -710,7 +710,7 @@ done_hash:
 	popq	%r13
 	popq	%r12
 	popq	%rbx
-	ret
+	RET
 SYM_FUNC_END(sha256_transform_rorx)
 
 .section	.rodata.cst512.K256, "aM", @progbits, 512
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index ddfa863b4ee3..c4a5db612c32 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -472,7 +472,7 @@ done_hash:
 	popq    %r12
 	popq    %rbx
 
-	ret
+	RET
 SYM_FUNC_END(sha256_transform_ssse3)
 
 .section	.rodata.cst256.K256, "aM", @progbits, 256
diff --git a/arch/x86/crypto/sha256_ni_asm.S b/arch/x86/crypto/sha256_ni_asm.S
index 7abade04a3a3..94d50dd27cb5 100644
--- a/arch/x86/crypto/sha256_ni_asm.S
+++ b/arch/x86/crypto/sha256_ni_asm.S
@@ -326,7 +326,7 @@ SYM_FUNC_START(sha256_ni_transform)
 
 .Ldone_hash:
 
-	ret
+	RET
 SYM_FUNC_END(sha256_ni_transform)
 
 .section	.rodata.cst256.K256, "aM", @progbits, 256
diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index 3d8f0fd4eea8..1fefe6dd3a9e 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -361,7 +361,7 @@ updateblock:
 	pop	%rbx
 
 nowork:
-	ret
+	RET
 SYM_FUNC_END(sha512_transform_avx)
 
 ########################################################################
diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index 072cb0f0deae..5cdaab7d6901 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -679,7 +679,7 @@ done_hash:
 	pop	%r12
 	pop	%rbx
 
-	ret
+	RET
 SYM_FUNC_END(sha512_transform_rorx)
 
 ########################################################################
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index bd51c9070bed..b84c22e06c5f 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -363,7 +363,7 @@ updateblock:
 	pop	%rbx
 
 nowork:
-	ret
+	RET
 SYM_FUNC_END(sha512_transform_ssse3)
 
 ########################################################################
diff --git a/arch/x86/crypto/sm4-aesni-avx-asm_64.S b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
index 1cc72b4804fa..4767ab61ff48 100644
--- a/arch/x86/crypto/sm4-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
@@ -246,7 +246,7 @@ SYM_FUNC_START(sm4_aesni_avx_crypt4)
 .Lblk4_store_output_done:
 	vzeroall;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(sm4_aesni_avx_crypt4)
 
 .align 8
@@ -356,7 +356,7 @@ SYM_FUNC_START_LOCAL(__sm4_crypt_blk8)
 	vpshufb RTMP2, RB3, RB3;
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(__sm4_crypt_blk8)
 
 /*
@@ -412,7 +412,7 @@ SYM_FUNC_START(sm4_aesni_avx_crypt8)
 .Lblk8_store_output_done:
 	vzeroall;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(sm4_aesni_avx_crypt8)
 
 /*
@@ -487,7 +487,7 @@ SYM_FUNC_START(sm4_aesni_avx_ctr_enc_blk8)
 
 	vzeroall;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(sm4_aesni_avx_ctr_enc_blk8)
 
 /*
@@ -537,7 +537,7 @@ SYM_FUNC_START(sm4_aesni_avx_cbc_dec_blk8)
 
 	vzeroall;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(sm4_aesni_avx_cbc_dec_blk8)
 
 /*
@@ -590,5 +590,5 @@ SYM_FUNC_START(sm4_aesni_avx_cfb_dec_blk8)
 
 	vzeroall;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(sm4_aesni_avx_cfb_dec_blk8)
diff --git a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
index 9c5d3f3ad45a..4732fe8bb65b 100644
--- a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
@@ -268,7 +268,7 @@ SYM_FUNC_START_LOCAL(__sm4_crypt_blk16)
 	vpshufb RTMP2, RB3, RB3;
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(__sm4_crypt_blk16)
 
 #define inc_le128(x, minus_one, tmp) \
@@ -387,7 +387,7 @@ SYM_FUNC_START(sm4_aesni_avx2_ctr_enc_blk16)
 
 	vzeroall;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(sm4_aesni_avx2_ctr_enc_blk16)
 
 /*
@@ -441,7 +441,7 @@ SYM_FUNC_START(sm4_aesni_avx2_cbc_dec_blk16)
 
 	vzeroall;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(sm4_aesni_avx2_cbc_dec_blk16)
 
 /*
@@ -497,5 +497,5 @@ SYM_FUNC_START(sm4_aesni_avx2_cfb_dec_blk16)
 
 	vzeroall;
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(sm4_aesni_avx2_cfb_dec_blk16)
diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index 37e63b3c664e..31f9b2ec3857 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -267,7 +267,7 @@ SYM_FUNC_START_LOCAL(__twofish_enc_blk8)
 	outunpack_blocks(RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
 	outunpack_blocks(RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
 
-	ret;
+	RET;
 SYM_FUNC_END(__twofish_enc_blk8)
 
 .align 8
@@ -307,7 +307,7 @@ SYM_FUNC_START_LOCAL(__twofish_dec_blk8)
 	outunpack_blocks(RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
 	outunpack_blocks(RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
 
-	ret;
+	RET;
 SYM_FUNC_END(__twofish_dec_blk8)
 
 SYM_FUNC_START(twofish_ecb_enc_8way)
@@ -327,7 +327,7 @@ SYM_FUNC_START(twofish_ecb_enc_8way)
 	store_8way(%r11, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(twofish_ecb_enc_8way)
 
 SYM_FUNC_START(twofish_ecb_dec_8way)
@@ -347,7 +347,7 @@ SYM_FUNC_START(twofish_ecb_dec_8way)
 	store_8way(%r11, RA1, RB1, RC1, RD1, RA2, RB2, RC2, RD2);
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(twofish_ecb_dec_8way)
 
 SYM_FUNC_START(twofish_cbc_dec_8way)
@@ -372,5 +372,5 @@ SYM_FUNC_START(twofish_cbc_dec_8way)
 	popq %r12;
 
 	FRAME_END
-	ret;
+	RET;
 SYM_FUNC_END(twofish_cbc_dec_8way)
diff --git a/arch/x86/crypto/twofish-i586-asm_32.S b/arch/x86/crypto/twofish-i586-asm_32.S
index a6f09e4f2e46..3abcad661884 100644
--- a/arch/x86/crypto/twofish-i586-asm_32.S
+++ b/arch/x86/crypto/twofish-i586-asm_32.S
@@ -260,7 +260,7 @@ SYM_FUNC_START(twofish_enc_blk)
 	pop	%ebx
 	pop	%ebp
 	mov	$1,	%eax
-	ret
+	RET
 SYM_FUNC_END(twofish_enc_blk)
 
 SYM_FUNC_START(twofish_dec_blk)
@@ -317,5 +317,5 @@ SYM_FUNC_START(twofish_dec_blk)
 	pop	%ebx
 	pop	%ebp
 	mov	$1,	%eax
-	ret
+	RET
 SYM_FUNC_END(twofish_dec_blk)
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
index bca4cea757ce..d2288bf38a8a 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
@@ -258,7 +258,7 @@ SYM_FUNC_START(__twofish_enc_blk_3way)
 	popq %rbx;
 	popq %r12;
 	popq %r13;
-	ret;
+	RET;
 
 .L__enc_xor3:
 	outunpack_enc3(xor);
@@ -266,7 +266,7 @@ SYM_FUNC_START(__twofish_enc_blk_3way)
 	popq %rbx;
 	popq %r12;
 	popq %r13;
-	ret;
+	RET;
 SYM_FUNC_END(__twofish_enc_blk_3way)
 
 SYM_FUNC_START(twofish_dec_blk_3way)
@@ -301,5 +301,5 @@ SYM_FUNC_START(twofish_dec_blk_3way)
 	popq %rbx;
 	popq %r12;
 	popq %r13;
-	ret;
+	RET;
 SYM_FUNC_END(twofish_dec_blk_3way)
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64.S b/arch/x86/crypto/twofish-x86_64-asm_64.S
index d2e56232494a..775af290cd19 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64.S
@@ -252,7 +252,7 @@ SYM_FUNC_START(twofish_enc_blk)
 
 	popq	R1
 	movl	$1,%eax
-	ret
+	RET
 SYM_FUNC_END(twofish_enc_blk)
 
 SYM_FUNC_START(twofish_dec_blk)
@@ -304,5 +304,5 @@ SYM_FUNC_START(twofish_dec_blk)
 
 	popq	R1
 	movl	$1,%eax
-	ret
+	RET
 SYM_FUNC_END(twofish_dec_blk)
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index ccb9d32768f3..00413e37feee 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -740,7 +740,7 @@ SYM_FUNC_START(schedule_tail_wrapper)
 	popl	%eax
 
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(schedule_tail_wrapper)
 .popsection
 
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 97b1f84bb53f..e23319ad3f42 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -738,7 +738,7 @@ SYM_FUNC_START(asm_load_gs_index)
 2:	ALTERNATIVE "", "mfence", X86_BUG_SWAPGS_FENCE
 	swapgs
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(asm_load_gs_index)
 EXPORT_SYMBOL(asm_load_gs_index)
 
@@ -889,7 +889,7 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 	 * is needed here.
 	 */
 	SAVE_AND_SET_GSBASE scratch_reg=%rax save_reg=%rbx
-	ret
+	RET
 
 .Lparanoid_entry_checkgs:
 	/* EBX = 1 -> kernel GSBASE active, no restore required */
@@ -910,7 +910,7 @@ SYM_CODE_START_LOCAL(paranoid_entry)
 .Lparanoid_kernel_gsbase:
 
 	FENCE_SWAPGS_KERNEL_ENTRY
-	ret
+	RET
 SYM_CODE_END(paranoid_entry)
 
 /*
@@ -989,7 +989,7 @@ SYM_CODE_START_LOCAL(error_entry)
 	movq	%rax, %rsp			/* switch stack */
 	ENCODE_FRAME_POINTER
 	pushq	%r12
-	ret
+	RET
 
 	/*
 	 * There are two places in the kernel that can potentially fault with
@@ -1020,7 +1020,7 @@ SYM_CODE_START_LOCAL(error_entry)
 	 */
 .Lerror_entry_done_lfence:
 	FENCE_SWAPGS_KERNEL_ENTRY
-	ret
+	RET
 
 .Lbstep_iret:
 	/* Fix truncated RIP */
diff --git a/arch/x86/entry/thunk_32.S b/arch/x86/entry/thunk_32.S
index f1f96d4d8cd6..7591bab060f7 100644
--- a/arch/x86/entry/thunk_32.S
+++ b/arch/x86/entry/thunk_32.S
@@ -24,7 +24,7 @@ SYM_CODE_START_NOALIGN(\name)
 	popl %edx
 	popl %ecx
 	popl %eax
-	ret
+	RET
 	_ASM_NOKPROBE(\name)
 SYM_CODE_END(\name)
 	.endm
diff --git a/arch/x86/entry/thunk_64.S b/arch/x86/entry/thunk_64.S
index 496b11ec469d..505b488fcc65 100644
--- a/arch/x86/entry/thunk_64.S
+++ b/arch/x86/entry/thunk_64.S
@@ -50,7 +50,7 @@ SYM_CODE_START_LOCAL_NOALIGN(__thunk_restore)
 	popq %rsi
 	popq %rdi
 	popq %rbp
-	ret
+	RET
 	_ASM_NOKPROBE(__thunk_restore)
 SYM_CODE_END(__thunk_restore)
 #endif
diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 6ddd7a937b3e..d33c6513fd2c 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -78,7 +78,7 @@ SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
 	popl	%ecx
 	CFI_RESTORE		ecx
 	CFI_ADJUST_CFA_OFFSET	-4
-	ret
+	RET
 	CFI_ENDPROC
 
 	.size __kernel_vsyscall,.-__kernel_vsyscall
diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
index 99dafac992e2..d77d278ee9dd 100644
--- a/arch/x86/entry/vdso/vsgx.S
+++ b/arch/x86/entry/vdso/vsgx.S
@@ -81,7 +81,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	pop	%rbx
 	leave
 	.cfi_def_cfa		%rsp, 8
-	ret
+	RET
 
 	/* The out-of-line code runs with the pre-leave stack frame. */
 	.cfi_def_cfa		%rbp, 16
diff --git a/arch/x86/entry/vsyscall/vsyscall_emu_64.S b/arch/x86/entry/vsyscall/vsyscall_emu_64.S
index 2e203f3a25a7..15e35159ebb6 100644
--- a/arch/x86/entry/vsyscall/vsyscall_emu_64.S
+++ b/arch/x86/entry/vsyscall/vsyscall_emu_64.S
@@ -19,17 +19,17 @@ __vsyscall_page:
 
 	mov $__NR_gettimeofday, %rax
 	syscall
-	ret
+	RET
 
 	.balign 1024, 0xcc
 	mov $__NR_time, %rax
 	syscall
-	ret
+	RET
 
 	.balign 1024, 0xcc
 	mov $__NR_getcpu, %rax
 	syscall
-	ret
+	RET
 
 	.balign 4096, 0xcc
 
diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 365111789cc6..030907922bd0 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -18,6 +18,20 @@
 #define __ALIGN_STR	__stringify(__ALIGN)
 #endif
 
+#ifdef CONFIG_SLS
+#define RET	ret; int3
+#else
+#define RET	ret
+#endif
+
+#else /* __ASSEMBLY__ */
+
+#ifdef CONFIG_SLS
+#define ASM_RET	"ret; int3\n\t"
+#else
+#define ASM_RET	"ret\n\t"
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_LINKAGE_H */
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index da3a1ac82be5..4d8b2731f4f8 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -665,7 +665,7 @@ bool __raw_callee_save___native_vcpu_is_preempted(long cpu);
 	    "call " #func ";"						\
 	    PV_RESTORE_ALL_CALLER_REGS					\
 	    FRAME_END							\
-	    "ret;"							\
+	    ASM_RET							\
 	    ".size " PV_THUNK_NAME(func) ", .-" PV_THUNK_NAME(func) ";"	\
 	    ".popsection")
 
diff --git a/arch/x86/include/asm/qspinlock_paravirt.h b/arch/x86/include/asm/qspinlock_paravirt.h
index 159622ee0674..1474cf96251d 100644
--- a/arch/x86/include/asm/qspinlock_paravirt.h
+++ b/arch/x86/include/asm/qspinlock_paravirt.h
@@ -48,7 +48,7 @@ asm    (".pushsection .text;"
 	"jne   .slowpath;"
 	"pop   %rdx;"
 	FRAME_END
-	"ret;"
+	ASM_RET
 	".slowpath: "
 	"push   %rsi;"
 	"movzbl %al,%esi;"
@@ -56,7 +56,7 @@ asm    (".pushsection .text;"
 	"pop    %rsi;"
 	"pop    %rdx;"
 	FRAME_END
-	"ret;"
+	ASM_RET
 	".size " PV_UNLOCK ", .-" PV_UNLOCK ";"
 	".popsection");
 
diff --git a/arch/x86/include/asm/static_call.h b/arch/x86/include/asm/static_call.h
index cbb67b6030f9..343234569392 100644
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -35,7 +35,7 @@
 	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, ".byte 0xe9; .long " #func " - (. + 4)")
 
 #define ARCH_DEFINE_STATIC_CALL_NULL_TRAMP(name)			\
-	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "ret; nop; nop; nop; nop")
+	__ARCH_DEFINE_STATIC_CALL_TRAMP(name, "ret; int3; nop; nop; nop")
 
 
 #define ARCH_ADD_TRAMP_KEY(name)					\
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index daf88f8143c5..cf69081073b5 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -60,7 +60,7 @@ save_registers:
 	popl	saved_context_eflags
 
 	movl	$ret_point, saved_eip
-	ret
+	RET
 
 
 restore_registers:
@@ -70,7 +70,7 @@ restore_registers:
 	movl	saved_context_edi, %edi
 	pushl	saved_context_eflags
 	popfl
-	ret
+	RET
 
 SYM_CODE_START(do_suspend_lowlevel)
 	call	save_processor_state
@@ -86,7 +86,7 @@ SYM_CODE_START(do_suspend_lowlevel)
 ret_point:
 	call	restore_registers
 	call	restore_processor_state
-	ret
+	RET
 SYM_CODE_END(do_suspend_lowlevel)
 
 .data
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index e9da3dc71254..ae0f718b8ebb 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -537,7 +537,7 @@ asm (
 "	.type		int3_magic, @function\n"
 "int3_magic:\n"
 "	movl	$1, (%" _ASM_ARG1 ")\n"
-"	ret\n"
+	ASM_RET
 "	.size		int3_magic, .-int3_magic\n"
 "	.popsection\n"
 );
@@ -930,10 +930,13 @@ void text_poke_sync(void)
 }
 
 struct text_poke_loc {
-	s32 rel_addr; /* addr := _stext + rel_addr */
-	s32 rel32;
+	/* addr := _stext + rel_addr */
+	s32 rel_addr;
+	s32 disp;
+	u8 len;
 	u8 opcode;
 	const u8 text[POKE_MAX_OPCODE_SIZE];
+	/* see text_poke_bp_batch() */
 	u8 old;
 };
 
@@ -948,7 +951,8 @@ static struct bp_patching_desc *bp_desc;
 static __always_inline
 struct bp_patching_desc *try_get_desc(struct bp_patching_desc **descp)
 {
-	struct bp_patching_desc *desc = __READ_ONCE(*descp); /* rcu_dereference */
+	/* rcu_dereference */
+	struct bp_patching_desc *desc = __READ_ONCE(*descp);
 
 	if (!desc || !arch_atomic_inc_not_zero(&desc->refs))
 		return NULL;
@@ -982,7 +986,7 @@ noinstr int poke_int3_handler(struct pt_regs *regs)
 {
 	struct bp_patching_desc *desc;
 	struct text_poke_loc *tp;
-	int len, ret = 0;
+	int ret = 0;
 	void *ip;
 
 	if (user_mode(regs))
@@ -1022,8 +1026,7 @@ noinstr int poke_int3_handler(struct pt_regs *regs)
 			goto out_put;
 	}
 
-	len = text_opcode_size(tp->opcode);
-	ip += len;
+	ip += tp->len;
 
 	switch (tp->opcode) {
 	case INT3_INSN_OPCODE:
@@ -1038,12 +1041,12 @@ noinstr int poke_int3_handler(struct pt_regs *regs)
 		break;
 
 	case CALL_INSN_OPCODE:
-		int3_emulate_call(regs, (long)ip + tp->rel32);
+		int3_emulate_call(regs, (long)ip + tp->disp);
 		break;
 
 	case JMP32_INSN_OPCODE:
 	case JMP8_INSN_OPCODE:
-		int3_emulate_jmp(regs, (long)ip + tp->rel32);
+		int3_emulate_jmp(regs, (long)ip + tp->disp);
 		break;
 
 	default:
@@ -1118,7 +1121,7 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
 	 */
 	for (do_sync = 0, i = 0; i < nr_entries; i++) {
 		u8 old[POKE_MAX_OPCODE_SIZE] = { tp[i].old, };
-		int len = text_opcode_size(tp[i].opcode);
+		int len = tp[i].len;
 
 		if (len - INT3_INSN_SIZE > 0) {
 			memcpy(old + INT3_INSN_SIZE,
@@ -1195,20 +1198,36 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 			       const void *opcode, size_t len, const void *emulate)
 {
 	struct insn insn;
-	int ret;
+	int ret, i;
 
 	memcpy((void *)tp->text, opcode, len);
 	if (!emulate)
 		emulate = opcode;
 
 	ret = insn_decode_kernel(&insn, emulate);
-
 	BUG_ON(ret < 0);
-	BUG_ON(len != insn.length);
 
 	tp->rel_addr = addr - (void *)_stext;
+	tp->len = len;
 	tp->opcode = insn.opcode.bytes[0];
 
+	switch (tp->opcode) {
+	case RET_INSN_OPCODE:
+	case JMP32_INSN_OPCODE:
+	case JMP8_INSN_OPCODE:
+		/*
+		 * Control flow instructions without implied execution of the
+		 * next instruction can be padded with INT3.
+		 */
+		for (i = insn.length; i < len; i++)
+			BUG_ON(tp->text[i] != INT3_INSN_OPCODE);
+		break;
+
+	default:
+		BUG_ON(len != insn.length);
+	};
+
+
 	switch (tp->opcode) {
 	case INT3_INSN_OPCODE:
 	case RET_INSN_OPCODE:
@@ -1217,7 +1236,7 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 	case CALL_INSN_OPCODE:
 	case JMP32_INSN_OPCODE:
 	case JMP8_INSN_OPCODE:
-		tp->rel32 = insn.immediate.value;
+		tp->disp = insn.immediate.value;
 		break;
 
 	default: /* assume NOP */
@@ -1225,13 +1244,13 @@ static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
 		case 2: /* NOP2 -- emulate as JMP8+0 */
 			BUG_ON(memcmp(emulate, x86_nops[len], len));
 			tp->opcode = JMP8_INSN_OPCODE;
-			tp->rel32 = 0;
+			tp->disp = 0;
 			break;
 
 		case 5: /* NOP5 -- emulate as JMP32+0 */
 			BUG_ON(memcmp(emulate, x86_nops[len], len));
 			tp->opcode = JMP32_INSN_OPCODE;
-			tp->rel32 = 0;
+			tp->disp = 0;
 			break;
 
 		default: /* unknown instruction */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b3ce3b4a2a2..847776cc1aa4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -308,7 +308,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		1
+#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
diff --git a/arch/x86/kernel/ftrace_32.S b/arch/x86/kernel/ftrace_32.S
index e405fe1a8bf4..a0ed0e4a2c0c 100644
--- a/arch/x86/kernel/ftrace_32.S
+++ b/arch/x86/kernel/ftrace_32.S
@@ -19,7 +19,7 @@
 #endif
 
 SYM_FUNC_START(__fentry__)
-	ret
+	RET
 SYM_FUNC_END(__fentry__)
 EXPORT_SYMBOL(__fentry__)
 
@@ -84,7 +84,7 @@ ftrace_graph_call:
 
 /* This is weak to keep gas from relaxing the jumps */
 SYM_INNER_LABEL_ALIGN(ftrace_stub, SYM_L_WEAK)
-	ret
+	RET
 SYM_CODE_END(ftrace_caller)
 
 SYM_CODE_START(ftrace_regs_caller)
@@ -177,7 +177,7 @@ SYM_CODE_START(ftrace_graph_caller)
 	popl	%edx
 	popl	%ecx
 	popl	%eax
-	ret
+	RET
 SYM_CODE_END(ftrace_graph_caller)
 
 .globl return_to_handler
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 7c273846c687..d6af81d1b788 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -132,7 +132,7 @@
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 SYM_FUNC_START(__fentry__)
-	retq
+	RET
 SYM_FUNC_END(__fentry__)
 EXPORT_SYMBOL(__fentry__)
 
@@ -181,11 +181,11 @@ SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL)
 
 /*
  * This is weak to keep gas from relaxing the jumps.
- * It is also used to copy the retq for trampolines.
+ * It is also used to copy the RET for trampolines.
  */
 SYM_INNER_LABEL_ALIGN(ftrace_stub, SYM_L_WEAK)
 	UNWIND_HINT_FUNC
-	retq
+	RET
 SYM_FUNC_END(ftrace_epilogue)
 
 SYM_FUNC_START(ftrace_regs_caller)
@@ -299,7 +299,7 @@ fgraph_trace:
 #endif
 
 SYM_INNER_LABEL(ftrace_stub, SYM_L_GLOBAL)
-	retq
+	RET
 
 trace:
 	/* save_mcount_regs fills in first two parameters */
@@ -331,7 +331,7 @@ SYM_FUNC_START(ftrace_graph_caller)
 
 	restore_mcount_regs
 
-	retq
+	RET
 SYM_FUNC_END(ftrace_graph_caller)
 
 SYM_FUNC_START(return_to_handler)
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index d8c64dab0efe..eb8656bac99b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -340,7 +340,7 @@ SYM_FUNC_END(startup_32_smp)
 __INIT
 setup_once:
 	andl $0,setup_once_ref	/* Once is enough, thanks */
-	ret
+	RET
 
 SYM_FUNC_START(early_idt_handler_array)
 	# 36(%esp) %eflags
diff --git a/arch/x86/kernel/irqflags.S b/arch/x86/kernel/irqflags.S
index 8ef35063964b..b8db1022aa6c 100644
--- a/arch/x86/kernel/irqflags.S
+++ b/arch/x86/kernel/irqflags.S
@@ -10,6 +10,6 @@
 SYM_FUNC_START(native_save_fl)
 	pushf
 	pop %_ASM_AX
-	ret
+	RET
 SYM_FUNC_END(native_save_fl)
 EXPORT_SYMBOL(native_save_fl)
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index b6e046e4b289..f6727c67ae02 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1044,7 +1044,7 @@ asm(
 	RESTORE_REGS_STRING
 	"	popfl\n"
 #endif
-	"	ret\n"
+	ASM_RET
 	".size kretprobe_trampoline, .-kretprobe_trampoline\n"
 );
 NOKPROBE_SYMBOL(kretprobe_trampoline);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 04cafc057bed..f1cdb8891ad4 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -41,7 +41,7 @@ extern void _paravirt_nop(void);
 asm (".pushsection .entry.text, \"ax\"\n"
      ".global _paravirt_nop\n"
      "_paravirt_nop:\n\t"
-     "ret\n\t"
+     ASM_RET
      ".size _paravirt_nop, . - _paravirt_nop\n\t"
      ".type _paravirt_nop, @function\n\t"
      ".popsection");
diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index f469153eca8a..fcc8a7699103 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -91,7 +91,7 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	movl    %edi, %eax
 	addl    $(identity_mapped - relocate_kernel), %eax
 	pushl   %eax
-	ret
+	RET
 SYM_CODE_END(relocate_kernel)
 
 SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
@@ -159,7 +159,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	xorl    %edx, %edx
 	xorl    %esi, %esi
 	xorl    %ebp, %ebp
-	ret
+	RET
 1:
 	popl	%edx
 	movl	CP_PA_SWAP_PAGE(%edi), %esp
@@ -190,7 +190,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	movl	%edi, %eax
 	addl	$(virtual_mapped - relocate_kernel), %eax
 	pushl	%eax
-	ret
+	RET
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -208,7 +208,7 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
 	popl	%edi
 	popl	%esi
 	popl	%ebx
-	ret
+	RET
 SYM_CODE_END(virtual_mapped)
 
 	/* Do the copies */
@@ -271,7 +271,7 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	popl	%edi
 	popl	%ebx
 	popl	%ebp
-	ret
+	RET
 SYM_CODE_END(swap_pages)
 
 	.globl kexec_control_code_size
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index c53271aebb64..5019091af059 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -104,7 +104,7 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	/* jump to identity mapped page */
 	addq	$(identity_mapped - relocate_kernel), %r8
 	pushq	%r8
-	ret
+	RET
 SYM_CODE_END(relocate_kernel)
 
 SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
@@ -191,7 +191,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	xorl	%r14d, %r14d
 	xorl	%r15d, %r15d
 
-	ret
+	RET
 
 1:
 	popq	%rdx
@@ -210,7 +210,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	call	swap_pages
 	movq	$virtual_mapped, %rax
 	pushq	%rax
-	ret
+	RET
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
@@ -231,7 +231,7 @@ SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
 	popq	%r12
 	popq	%rbp
 	popq	%rbx
-	ret
+	RET
 SYM_CODE_END(virtual_mapped)
 
 	/* Do the copies */
@@ -288,7 +288,7 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	lea	PAGE_SIZE(%rax), %rsi
 	jmp	0b
 3:
-	ret
+	RET
 SYM_CODE_END(swap_pages)
 
 	.globl kexec_control_code_size
diff --git a/arch/x86/kernel/sev_verify_cbit.S b/arch/x86/kernel/sev_verify_cbit.S
index ee04941a6546..3355e27c69eb 100644
--- a/arch/x86/kernel/sev_verify_cbit.S
+++ b/arch/x86/kernel/sev_verify_cbit.S
@@ -85,5 +85,5 @@ SYM_FUNC_START(sev_verify_cbit)
 #endif
 	/* Return page-table pointer */
 	movq	%rdi, %rax
-	ret
+	RET
 SYM_FUNC_END(sev_verify_cbit)
diff --git a/arch/x86/kernel/static_call.c b/arch/x86/kernel/static_call.c
index 3d68dfb10aaa..3ec2cb881eef 100644
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -16,6 +16,8 @@ enum insn_type {
  */
 static const u8 xor5rax[] = { 0x2e, 0x2e, 0x2e, 0x31, 0xc0 };
 
+static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
+
 static void __ref __static_call_transform(void *insn, enum insn_type type, void *func)
 {
 	const void *emulate = NULL;
@@ -41,8 +43,7 @@ static void __ref __static_call_transform(void *insn, enum insn_type type, void
 		break;
 
 	case RET:
-		code = text_gen_insn(RET_INSN_OPCODE, insn, func);
-		size = RET_INSN_SIZE;
+		code = &retinsn;
 		break;
 	}
 
diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index 641f0fe1e5b4..1258a5872d12 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -132,9 +132,9 @@ SYM_FUNC_START_LOCAL(verify_cpu)
 .Lverify_cpu_no_longmode:
 	popf				# Restore caller passed flags
 	movl $1,%eax
-	ret
+	RET
 .Lverify_cpu_sse_ok:
 	popf				# Restore caller passed flags
 	xorl %eax, %eax
-	ret
+	RET
 SYM_FUNC_END(verify_cpu)
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3747a754a8e8..82eff14bd064 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -315,7 +315,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 	__FOP_FUNC(#name)
 
 #define __FOP_RET(name) \
-	"ret \n\t" \
+	ASM_RET \
 	".size " name ", .-" name "\n\t"
 
 #define FOP_RET(name) \
@@ -427,15 +427,30 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 	FOP_END
 
 /* Special case for SETcc - 1 instruction per cc */
+
+/*
+ * Depending on .config the SETcc functions look like:
+ *
+ * SETcc %al   [3 bytes]
+ * RET         [1 byte]
+ * INT3        [1 byte; CONFIG_SLS]
+ *
+ * Which gives possible sizes 4 or 5.  When rounded up to the
+ * next power-of-two alignment they become 4 or 8.
+ */
+#define SETCC_LENGTH	(4 + IS_ENABLED(CONFIG_SLS))
+#define SETCC_ALIGN	(4 << IS_ENABLED(CONFIG_SLS))
+static_assert(SETCC_LENGTH <= SETCC_ALIGN);
+
 #define FOP_SETCC(op) \
-	".align 4 \n\t" \
+	".align " __stringify(SETCC_ALIGN) " \n\t" \
 	".type " #op ", @function \n\t" \
 	#op ": \n\t" \
 	#op " %al \n\t" \
 	__FOP_RET(#op)
 
 asm(".pushsection .fixup, \"ax\"\n"
-    "kvm_fastop_exception: xor %esi, %esi; ret\n"
+    "kvm_fastop_exception: xor %esi, %esi; " ASM_RET
     ".popsection");
 
 FOP_START(setcc)
@@ -1053,7 +1068,7 @@ static int em_bsr_c(struct x86_emulate_ctxt *ctxt)
 static __always_inline u8 test_cc(unsigned int condition, unsigned long flags)
 {
 	u8 rc;
-	void (*fop)(void) = (void *)em_setcc + 4 * (condition & 0xf);
+	void (*fop)(void) = (void *)em_setcc + SETCC_ALIGN * (condition & 0xf);
 
 	flags = (flags & EFLAGS_MASK) | X86_EFLAGS_IF;
 	asm("push %[flags]; popf; " CALL_NOSPEC
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 4fa17df123cd..dfaeb47fcf2a 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -148,7 +148,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	pop %edi
 #endif
 	pop %_ASM_BP
-	ret
+	RET
 
 3:	cmpb $0, kvm_rebooting
 	jne 2b
@@ -202,7 +202,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	pop %edi
 #endif
 	pop %_ASM_BP
-	ret
+	RET
 
 3:	cmpb $0, kvm_rebooting
 	jne 2b
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 3a6461694fc2..435c187927c4 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -49,14 +49,14 @@ SYM_FUNC_START_LOCAL(vmx_vmenter)
 	je 2f
 
 1:	vmresume
-	ret
+	RET
 
 2:	vmlaunch
-	ret
+	RET
 
 3:	cmpb $0, kvm_rebooting
 	je 4f
-	ret
+	RET
 4:	ud2
 
 	_ASM_EXTABLE(1b, 3b)
@@ -89,7 +89,7 @@ SYM_FUNC_START(vmx_vmexit)
 	pop %_ASM_AX
 .Lvmexit_skip_rsb:
 #endif
-	ret
+	RET
 SYM_FUNC_END(vmx_vmexit)
 
 /**
@@ -228,7 +228,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	pop %edi
 #endif
 	pop %_ASM_BP
-	ret
+	RET
 
 	/* VM-Fail.  Out-of-line to avoid a taken Jcc after VM-Exit. */
 2:	mov $1, %eax
@@ -293,7 +293,7 @@ SYM_FUNC_START(vmread_error_trampoline)
 	pop %_ASM_AX
 	pop %_ASM_BP
 
-	ret
+	RET
 SYM_FUNC_END(vmread_error_trampoline)
 
 SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
@@ -326,5 +326,5 @@ SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
 	 */
 	mov %_ASM_BP, %_ASM_SP
 	pop %_ASM_BP
-	ret
+	RET
 SYM_FUNC_END(vmx_do_interrupt_nmi_irqoff)
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 16bc9130e7a5..e768815e58ae 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -9,81 +9,83 @@
 #include <asm/alternative.h>
 
 /* if you want SMP support, implement these with real spinlocks */
-.macro LOCK reg
+.macro IRQ_SAVE reg
 	pushfl
 	cli
 .endm
 
-.macro UNLOCK reg
+.macro IRQ_RESTORE reg
 	popfl
 .endm
 
-#define BEGIN(op) \
+#define BEGIN_IRQ_SAVE(op) \
 .macro endp; \
 SYM_FUNC_END(atomic64_##op##_386); \
 .purgem endp; \
 .endm; \
 SYM_FUNC_START(atomic64_##op##_386); \
-	LOCK v;
+	IRQ_SAVE v;
 
 #define ENDP endp
 
-#define RET \
-	UNLOCK v; \
-	ret
-
-#define RET_ENDP \
-	RET; \
-	ENDP
+#define RET_IRQ_RESTORE \
+	IRQ_RESTORE v; \
+	RET
 
 #define v %ecx
-BEGIN(read)
+BEGIN_IRQ_SAVE(read)
 	movl  (v), %eax
 	movl 4(v), %edx
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(set)
+BEGIN_IRQ_SAVE(set)
 	movl %ebx,  (v)
 	movl %ecx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v  %esi
-BEGIN(xchg)
+BEGIN_IRQ_SAVE(xchg)
 	movl  (v), %eax
 	movl 4(v), %edx
 	movl %ebx,  (v)
 	movl %ecx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %ecx
-BEGIN(add)
+BEGIN_IRQ_SAVE(add)
 	addl %eax,  (v)
 	adcl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %ecx
-BEGIN(add_return)
+BEGIN_IRQ_SAVE(add_return)
 	addl  (v), %eax
 	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %ecx
-BEGIN(sub)
+BEGIN_IRQ_SAVE(sub)
 	subl %eax,  (v)
 	sbbl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %ecx
-BEGIN(sub_return)
+BEGIN_IRQ_SAVE(sub_return)
 	negl %edx
 	negl %eax
 	sbbl $0, %edx
@@ -91,47 +93,52 @@ BEGIN(sub_return)
 	adcl 4(v), %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(inc)
+BEGIN_IRQ_SAVE(inc)
 	addl $1,  (v)
 	adcl $0, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(inc_return)
+BEGIN_IRQ_SAVE(inc_return)
 	movl  (v), %eax
 	movl 4(v), %edx
 	addl $1, %eax
 	adcl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(dec)
+BEGIN_IRQ_SAVE(dec)
 	subl $1,  (v)
 	sbbl $0, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(dec_return)
+BEGIN_IRQ_SAVE(dec_return)
 	movl  (v), %eax
 	movl 4(v), %edx
 	subl $1, %eax
 	sbbl $0, %edx
 	movl %eax,  (v)
 	movl %edx, 4(v)
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
 
 #define v %esi
-BEGIN(add_unless)
+BEGIN_IRQ_SAVE(add_unless)
 	addl %eax, %ecx
 	adcl %edx, %edi
 	addl  (v), %eax
@@ -143,7 +150,7 @@ BEGIN(add_unless)
 	movl %edx, 4(v)
 	movl $1, %eax
 2:
-	RET
+	RET_IRQ_RESTORE
 3:
 	cmpl %edx, %edi
 	jne 1b
@@ -153,7 +160,7 @@ ENDP
 #undef v
 
 #define v %esi
-BEGIN(inc_not_zero)
+BEGIN_IRQ_SAVE(inc_not_zero)
 	movl  (v), %eax
 	movl 4(v), %edx
 	testl %eax, %eax
@@ -165,7 +172,7 @@ BEGIN(inc_not_zero)
 	movl %edx, 4(v)
 	movl $1, %eax
 2:
-	RET
+	RET_IRQ_RESTORE
 3:
 	testl %edx, %edx
 	jne 1b
@@ -174,7 +181,7 @@ ENDP
 #undef v
 
 #define v %esi
-BEGIN(dec_if_positive)
+BEGIN_IRQ_SAVE(dec_if_positive)
 	movl  (v), %eax
 	movl 4(v), %edx
 	subl $1, %eax
@@ -183,5 +190,6 @@ BEGIN(dec_if_positive)
 	movl %eax,  (v)
 	movl %edx, 4(v)
 1:
-RET_ENDP
+	RET_IRQ_RESTORE
+ENDP
 #undef v
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index ce6935690766..90afb488b396 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -18,7 +18,7 @@
 
 SYM_FUNC_START(atomic64_read_cx8)
 	read64 %ecx
-	ret
+	RET
 SYM_FUNC_END(atomic64_read_cx8)
 
 SYM_FUNC_START(atomic64_set_cx8)
@@ -28,7 +28,7 @@ SYM_FUNC_START(atomic64_set_cx8)
 	cmpxchg8b (%esi)
 	jne 1b
 
-	ret
+	RET
 SYM_FUNC_END(atomic64_set_cx8)
 
 SYM_FUNC_START(atomic64_xchg_cx8)
@@ -37,7 +37,7 @@ SYM_FUNC_START(atomic64_xchg_cx8)
 	cmpxchg8b (%esi)
 	jne 1b
 
-	ret
+	RET
 SYM_FUNC_END(atomic64_xchg_cx8)
 
 .macro addsub_return func ins insc
@@ -68,7 +68,7 @@ SYM_FUNC_START(atomic64_\func\()_return_cx8)
 	popl %esi
 	popl %ebx
 	popl %ebp
-	ret
+	RET
 SYM_FUNC_END(atomic64_\func\()_return_cx8)
 .endm
 
@@ -93,7 +93,7 @@ SYM_FUNC_START(atomic64_\func\()_return_cx8)
 	movl %ebx, %eax
 	movl %ecx, %edx
 	popl %ebx
-	ret
+	RET
 SYM_FUNC_END(atomic64_\func\()_return_cx8)
 .endm
 
@@ -118,7 +118,7 @@ SYM_FUNC_START(atomic64_dec_if_positive_cx8)
 	movl %ebx, %eax
 	movl %ecx, %edx
 	popl %ebx
-	ret
+	RET
 SYM_FUNC_END(atomic64_dec_if_positive_cx8)
 
 SYM_FUNC_START(atomic64_add_unless_cx8)
@@ -149,7 +149,7 @@ SYM_FUNC_START(atomic64_add_unless_cx8)
 	addl $8, %esp
 	popl %ebx
 	popl %ebp
-	ret
+	RET
 4:
 	cmpl %edx, 4(%esp)
 	jne 2b
@@ -176,5 +176,5 @@ SYM_FUNC_START(atomic64_inc_not_zero_cx8)
 	movl $1, %eax
 3:
 	popl %ebx
-	ret
+	RET
 SYM_FUNC_END(atomic64_inc_not_zero_cx8)
diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index 4304320e51f4..929ad1747dea 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -127,7 +127,7 @@ SYM_FUNC_START(csum_partial)
 8:
 	popl %ebx
 	popl %esi
-	ret
+	RET
 SYM_FUNC_END(csum_partial)
 
 #else
@@ -245,7 +245,7 @@ SYM_FUNC_START(csum_partial)
 90: 
 	popl %ebx
 	popl %esi
-	ret
+	RET
 SYM_FUNC_END(csum_partial)
 				
 #endif
@@ -371,7 +371,7 @@ EXC(	movb %cl, (%edi)	)
 	popl %esi
 	popl %edi
 	popl %ecx			# equivalent to addl $4,%esp
-	ret	
+	RET
 SYM_FUNC_END(csum_partial_copy_generic)
 
 #else
@@ -447,7 +447,7 @@ EXC(	movb %dl, (%edi)         )
 	popl %esi
 	popl %edi
 	popl %ebx
-	ret
+	RET
 SYM_FUNC_END(csum_partial_copy_generic)
 				
 #undef ROUND
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index c4c7dd115953..fe59b8ac4fcc 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -17,7 +17,7 @@ SYM_FUNC_START(clear_page_rep)
 	movl $4096/8,%ecx
 	xorl %eax,%eax
 	rep stosq
-	ret
+	RET
 SYM_FUNC_END(clear_page_rep)
 EXPORT_SYMBOL_GPL(clear_page_rep)
 
@@ -39,7 +39,7 @@ SYM_FUNC_START(clear_page_orig)
 	leaq	64(%rdi),%rdi
 	jnz	.Lloop
 	nop
-	ret
+	RET
 SYM_FUNC_END(clear_page_orig)
 EXPORT_SYMBOL_GPL(clear_page_orig)
 
@@ -47,6 +47,6 @@ SYM_FUNC_START(clear_page_erms)
 	movl $4096,%ecx
 	xorl %eax,%eax
 	rep stosb
-	ret
+	RET
 SYM_FUNC_END(clear_page_erms)
 EXPORT_SYMBOL_GPL(clear_page_erms)
diff --git a/arch/x86/lib/cmpxchg16b_emu.S b/arch/x86/lib/cmpxchg16b_emu.S
index 3542502faa3b..33c70c0160ea 100644
--- a/arch/x86/lib/cmpxchg16b_emu.S
+++ b/arch/x86/lib/cmpxchg16b_emu.S
@@ -37,11 +37,11 @@ SYM_FUNC_START(this_cpu_cmpxchg16b_emu)
 
 	popfq
 	mov $1, %al
-	ret
+	RET
 
 .Lnot_same:
 	popfq
 	xor %al,%al
-	ret
+	RET
 
 SYM_FUNC_END(this_cpu_cmpxchg16b_emu)
diff --git a/arch/x86/lib/cmpxchg8b_emu.S b/arch/x86/lib/cmpxchg8b_emu.S
index ca01ed6029f4..6a912d58fecc 100644
--- a/arch/x86/lib/cmpxchg8b_emu.S
+++ b/arch/x86/lib/cmpxchg8b_emu.S
@@ -32,7 +32,7 @@ SYM_FUNC_START(cmpxchg8b_emu)
 	movl %ecx, 4(%esi)
 
 	popfl
-	ret
+	RET
 
 .Lnot_same:
 	movl  (%esi), %eax
@@ -40,7 +40,7 @@ SYM_FUNC_START(cmpxchg8b_emu)
 	movl 4(%esi), %edx
 
 	popfl
-	ret
+	RET
 
 SYM_FUNC_END(cmpxchg8b_emu)
 EXPORT_SYMBOL(cmpxchg8b_emu)
diff --git a/arch/x86/lib/copy_mc_64.S b/arch/x86/lib/copy_mc_64.S
index e5f77e293034..2c623a2bbd26 100644
--- a/arch/x86/lib/copy_mc_64.S
+++ b/arch/x86/lib/copy_mc_64.S
@@ -77,7 +77,7 @@ SYM_FUNC_START(copy_mc_fragile)
 .L_done_memcpy_trap:
 	xorl %eax, %eax
 .L_done:
-	ret
+	RET
 SYM_FUNC_END(copy_mc_fragile)
 
 	.section .fixup, "ax"
@@ -132,7 +132,7 @@ SYM_FUNC_START(copy_mc_enhanced_fast_string)
 	rep movsb
 	/* Copy successful. Return zero */
 	xorl %eax, %eax
-	ret
+	RET
 SYM_FUNC_END(copy_mc_enhanced_fast_string)
 
 	.section .fixup, "ax"
@@ -145,7 +145,7 @@ SYM_FUNC_END(copy_mc_enhanced_fast_string)
 	 * user-copy routines.
 	 */
 	movq %rcx, %rax
-	ret
+	RET
 
 	.previous
 
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index db4b4f9197c7..30ea644bf446 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -17,7 +17,7 @@ SYM_FUNC_START(copy_page)
 	ALTERNATIVE "jmp copy_page_regs", "", X86_FEATURE_REP_GOOD
 	movl	$4096/8, %ecx
 	rep	movsq
-	ret
+	RET
 SYM_FUNC_END(copy_page)
 EXPORT_SYMBOL(copy_page)
 
@@ -85,5 +85,5 @@ SYM_FUNC_START_LOCAL(copy_page_regs)
 	movq	(%rsp), %rbx
 	movq	1*8(%rsp), %r12
 	addq	$2*8, %rsp
-	ret
+	RET
 SYM_FUNC_END(copy_page_regs)
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 57b79c577496..84cee84fc658 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -105,7 +105,7 @@ SYM_FUNC_START(copy_user_generic_unrolled)
 	jnz 21b
 23:	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 
 	.section .fixup,"ax"
 30:	shll $6,%ecx
@@ -173,7 +173,7 @@ SYM_FUNC_START(copy_user_generic_string)
 	movsb
 	xorl %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 
 	.section .fixup,"ax"
 11:	leal (%rdx,%rcx,8),%ecx
@@ -207,7 +207,7 @@ SYM_FUNC_START(copy_user_enhanced_fast_string)
 	movsb
 	xorl %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 
 	.section .fixup,"ax"
 12:	movl %ecx,%edx		/* ecx is zerorest also */
@@ -239,7 +239,7 @@ SYM_CODE_START_LOCAL(.Lcopy_user_handle_tail)
 1:	rep movsb
 2:	mov %ecx,%eax
 	ASM_CLAC
-	ret
+	RET
 
 	/*
 	 * Return zero to pretend that this copy succeeded. This
@@ -250,7 +250,7 @@ SYM_CODE_START_LOCAL(.Lcopy_user_handle_tail)
 	 */
 3:	xorl %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 
 	_ASM_EXTABLE_CPY(1b, 2b)
 SYM_CODE_END(.Lcopy_user_handle_tail)
@@ -361,7 +361,7 @@ SYM_FUNC_START(__copy_user_nocache)
 	xorl %eax,%eax
 	ASM_CLAC
 	sfence
-	ret
+	RET
 
 	.section .fixup,"ax"
 .L_fixup_4x8b_copy:
diff --git a/arch/x86/lib/csum-copy_64.S b/arch/x86/lib/csum-copy_64.S
index 1fbd8ee9642d..d9e16a2cf285 100644
--- a/arch/x86/lib/csum-copy_64.S
+++ b/arch/x86/lib/csum-copy_64.S
@@ -201,7 +201,7 @@ SYM_FUNC_START(csum_partial_copy_generic)
 	movq 3*8(%rsp), %r13
 	movq 4*8(%rsp), %r15
 	addq $5*8, %rsp
-	ret
+	RET
 .Lshort:
 	movl %ecx, %r10d
 	jmp  .L1
diff --git a/arch/x86/lib/error-inject.c b/arch/x86/lib/error-inject.c
index be5b5fb1598b..520897061ee0 100644
--- a/arch/x86/lib/error-inject.c
+++ b/arch/x86/lib/error-inject.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/linkage.h>
 #include <linux/error-injection.h>
 #include <linux/kprobes.h>
 
@@ -10,7 +11,7 @@ asm(
 	".type just_return_func, @function\n"
 	".globl just_return_func\n"
 	"just_return_func:\n"
-	"	ret\n"
+		ASM_RET
 	".size just_return_func, .-just_return_func\n"
 );
 
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index fa1bc2104b32..b70d98d79a9d 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -57,7 +57,7 @@ SYM_FUNC_START(__get_user_1)
 1:	movzbl (%_ASM_AX),%edx
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__get_user_1)
 EXPORT_SYMBOL(__get_user_1)
 
@@ -71,7 +71,7 @@ SYM_FUNC_START(__get_user_2)
 2:	movzwl (%_ASM_AX),%edx
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__get_user_2)
 EXPORT_SYMBOL(__get_user_2)
 
@@ -85,7 +85,7 @@ SYM_FUNC_START(__get_user_4)
 3:	movl (%_ASM_AX),%edx
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__get_user_4)
 EXPORT_SYMBOL(__get_user_4)
 
@@ -100,7 +100,7 @@ SYM_FUNC_START(__get_user_8)
 4:	movq (%_ASM_AX),%rdx
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 #else
 	LOAD_TASK_SIZE_MINUS_N(7)
 	cmp %_ASM_DX,%_ASM_AX
@@ -112,7 +112,7 @@ SYM_FUNC_START(__get_user_8)
 5:	movl 4(%_ASM_AX),%ecx
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 #endif
 SYM_FUNC_END(__get_user_8)
 EXPORT_SYMBOL(__get_user_8)
@@ -124,7 +124,7 @@ SYM_FUNC_START(__get_user_nocheck_1)
 6:	movzbl (%_ASM_AX),%edx
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__get_user_nocheck_1)
 EXPORT_SYMBOL(__get_user_nocheck_1)
 
@@ -134,7 +134,7 @@ SYM_FUNC_START(__get_user_nocheck_2)
 7:	movzwl (%_ASM_AX),%edx
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__get_user_nocheck_2)
 EXPORT_SYMBOL(__get_user_nocheck_2)
 
@@ -144,7 +144,7 @@ SYM_FUNC_START(__get_user_nocheck_4)
 8:	movl (%_ASM_AX),%edx
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__get_user_nocheck_4)
 EXPORT_SYMBOL(__get_user_nocheck_4)
 
@@ -159,7 +159,7 @@ SYM_FUNC_START(__get_user_nocheck_8)
 #endif
 	xor %eax,%eax
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__get_user_nocheck_8)
 EXPORT_SYMBOL(__get_user_nocheck_8)
 
@@ -169,7 +169,7 @@ SYM_CODE_START_LOCAL(.Lbad_get_user_clac)
 bad_get_user:
 	xor %edx,%edx
 	mov $(-EFAULT),%_ASM_AX
-	ret
+	RET
 SYM_CODE_END(.Lbad_get_user_clac)
 
 #ifdef CONFIG_X86_32
@@ -179,7 +179,7 @@ bad_get_user_8:
 	xor %edx,%edx
 	xor %ecx,%ecx
 	mov $(-EFAULT),%_ASM_AX
-	ret
+	RET
 SYM_CODE_END(.Lbad_get_user_8_clac)
 #endif
 
diff --git a/arch/x86/lib/hweight.S b/arch/x86/lib/hweight.S
index dbf8cc97b7f5..12c16c6aa44a 100644
--- a/arch/x86/lib/hweight.S
+++ b/arch/x86/lib/hweight.S
@@ -32,7 +32,7 @@ SYM_FUNC_START(__sw_hweight32)
 	imull $0x01010101, %eax, %eax		# w_tmp *= 0x01010101
 	shrl $24, %eax				# w = w_tmp >> 24
 	__ASM_SIZE(pop,) %__ASM_REG(dx)
-	ret
+	RET
 SYM_FUNC_END(__sw_hweight32)
 EXPORT_SYMBOL(__sw_hweight32)
 
@@ -65,7 +65,7 @@ SYM_FUNC_START(__sw_hweight64)
 
 	popq    %rdx
 	popq    %rdi
-	ret
+	RET
 #else /* CONFIG_X86_32 */
 	/* We're getting an u64 arg in (%eax,%edx): unsigned long hweight64(__u64 w) */
 	pushl   %ecx
@@ -77,7 +77,7 @@ SYM_FUNC_START(__sw_hweight64)
 	addl    %ecx, %eax                      # result
 
 	popl    %ecx
-	ret
+	RET
 #endif
 SYM_FUNC_END(__sw_hweight64)
 EXPORT_SYMBOL(__sw_hweight64)
diff --git a/arch/x86/lib/iomap_copy_64.S b/arch/x86/lib/iomap_copy_64.S
index cb5a1964506b..a1f9416bf67a 100644
--- a/arch/x86/lib/iomap_copy_64.S
+++ b/arch/x86/lib/iomap_copy_64.S
@@ -11,5 +11,5 @@
 SYM_FUNC_START(__iowrite32_copy)
 	movl %edx,%ecx
 	rep movsd
-	ret
+	RET
 SYM_FUNC_END(__iowrite32_copy)
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 1cc9da6e29c7..59cf2343f3d9 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -39,7 +39,7 @@ SYM_FUNC_START_WEAK(memcpy)
 	rep movsq
 	movl %edx, %ecx
 	rep movsb
-	ret
+	RET
 SYM_FUNC_END(memcpy)
 SYM_FUNC_END_ALIAS(__memcpy)
 EXPORT_SYMBOL(memcpy)
@@ -53,7 +53,7 @@ SYM_FUNC_START_LOCAL(memcpy_erms)
 	movq %rdi, %rax
 	movq %rdx, %rcx
 	rep movsb
-	ret
+	RET
 SYM_FUNC_END(memcpy_erms)
 
 SYM_FUNC_START_LOCAL(memcpy_orig)
@@ -137,7 +137,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movq %r9,	1*8(%rdi)
 	movq %r10,	-2*8(%rdi, %rdx)
 	movq %r11,	-1*8(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_16bytes:
 	cmpl $8,	%edx
@@ -149,7 +149,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movq -1*8(%rsi, %rdx),	%r9
 	movq %r8,	0*8(%rdi)
 	movq %r9,	-1*8(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_8bytes:
 	cmpl $4,	%edx
@@ -162,7 +162,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movl -4(%rsi, %rdx), %r8d
 	movl %ecx, (%rdi)
 	movl %r8d, -4(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_3bytes:
 	subl $1, %edx
@@ -180,7 +180,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movb %cl, (%rdi)
 
 .Lend:
-	retq
+	RET
 SYM_FUNC_END(memcpy_orig)
 
 .popsection
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 64801010d312..50ea390df712 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -40,7 +40,7 @@ SYM_FUNC_START(__memmove)
 	/* FSRM implies ERMS => no length checks, do the copy directly */
 .Lmemmove_begin_forward:
 	ALTERNATIVE "cmp $0x20, %rdx; jb 1f", "", X86_FEATURE_FSRM
-	ALTERNATIVE "", "movq %rdx, %rcx; rep movsb; retq", X86_FEATURE_ERMS
+	ALTERNATIVE "", __stringify(movq %rdx, %rcx; rep movsb; RET), X86_FEATURE_ERMS
 
 	/*
 	 * movsq instruction have many startup latency
@@ -205,7 +205,7 @@ SYM_FUNC_START(__memmove)
 	movb (%rsi), %r11b
 	movb %r11b, (%rdi)
 13:
-	retq
+	RET
 SYM_FUNC_END(__memmove)
 SYM_FUNC_END_ALIAS(memmove)
 EXPORT_SYMBOL(__memmove)
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 9827ae267f96..d624f2bc42f1 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -40,7 +40,7 @@ SYM_FUNC_START(__memset)
 	movl %edx,%ecx
 	rep stosb
 	movq %r9,%rax
-	ret
+	RET
 SYM_FUNC_END(__memset)
 SYM_FUNC_END_ALIAS(memset)
 EXPORT_SYMBOL(memset)
@@ -63,7 +63,7 @@ SYM_FUNC_START_LOCAL(memset_erms)
 	movq %rdx,%rcx
 	rep stosb
 	movq %r9,%rax
-	ret
+	RET
 SYM_FUNC_END(memset_erms)
 
 SYM_FUNC_START_LOCAL(memset_orig)
@@ -125,7 +125,7 @@ SYM_FUNC_START_LOCAL(memset_orig)
 
 .Lende:
 	movq	%r10,%rax
-	ret
+	RET
 
 .Lbad_alignment:
 	cmpq $7,%rdx
diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
index a2b9caa5274c..ebd259f31496 100644
--- a/arch/x86/lib/msr-reg.S
+++ b/arch/x86/lib/msr-reg.S
@@ -35,7 +35,7 @@ SYM_FUNC_START(\op\()_safe_regs)
 	movl    %edi, 28(%r10)
 	popq %r12
 	popq %rbx
-	ret
+	RET
 3:
 	movl    $-EIO, %r11d
 	jmp     2b
@@ -77,7 +77,7 @@ SYM_FUNC_START(\op\()_safe_regs)
 	popl %esi
 	popl %ebp
 	popl %ebx
-	ret
+	RET
 3:
 	movl    $-EIO, 4(%esp)
 	jmp     2b
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index 0ea344c5ea43..ecb2049c1273 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -52,7 +52,7 @@ SYM_INNER_LABEL(__put_user_nocheck_1, SYM_L_GLOBAL)
 1:	movb %al,(%_ASM_CX)
 	xor %ecx,%ecx
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__put_user_1)
 EXPORT_SYMBOL(__put_user_1)
 EXPORT_SYMBOL(__put_user_nocheck_1)
@@ -66,7 +66,7 @@ SYM_INNER_LABEL(__put_user_nocheck_2, SYM_L_GLOBAL)
 2:	movw %ax,(%_ASM_CX)
 	xor %ecx,%ecx
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__put_user_2)
 EXPORT_SYMBOL(__put_user_2)
 EXPORT_SYMBOL(__put_user_nocheck_2)
@@ -80,7 +80,7 @@ SYM_INNER_LABEL(__put_user_nocheck_4, SYM_L_GLOBAL)
 3:	movl %eax,(%_ASM_CX)
 	xor %ecx,%ecx
 	ASM_CLAC
-	ret
+	RET
 SYM_FUNC_END(__put_user_4)
 EXPORT_SYMBOL(__put_user_4)
 EXPORT_SYMBOL(__put_user_nocheck_4)
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index 5385d26af6e4..9556ff5f4773 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -23,7 +23,7 @@
 .Ldo_rop_\@:
 	mov     %\reg, (%_ASM_SP)
 	UNWIND_HINT_FUNC
-	ret
+	RET
 .endm
 
 .macro THUNK reg
@@ -34,7 +34,7 @@ SYM_FUNC_START(__x86_indirect_thunk_\reg)
 
 	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
 		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), X86_FEATURE_RETPOLINE_LFENCE
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE
 
 SYM_FUNC_END(__x86_indirect_thunk_\reg)
 
diff --git a/arch/x86/math-emu/div_Xsig.S b/arch/x86/math-emu/div_Xsig.S
index 951da2ad54bb..8c270ab415be 100644
--- a/arch/x86/math-emu/div_Xsig.S
+++ b/arch/x86/math-emu/div_Xsig.S
@@ -341,7 +341,7 @@ L_exit:
 	popl	%esi
 
 	leave
-	ret
+	RET
 
 
 #ifdef PARANOID
diff --git a/arch/x86/math-emu/div_small.S b/arch/x86/math-emu/div_small.S
index d047d1816abe..637439bfefa4 100644
--- a/arch/x86/math-emu/div_small.S
+++ b/arch/x86/math-emu/div_small.S
@@ -44,5 +44,5 @@ SYM_FUNC_START(FPU_div_small)
 	popl	%esi
 
 	leave
-	ret
+	RET
 SYM_FUNC_END(FPU_div_small)
diff --git a/arch/x86/math-emu/mul_Xsig.S b/arch/x86/math-emu/mul_Xsig.S
index 4afc7b1fa6e9..54a031b66142 100644
--- a/arch/x86/math-emu/mul_Xsig.S
+++ b/arch/x86/math-emu/mul_Xsig.S
@@ -62,7 +62,7 @@ SYM_FUNC_START(mul32_Xsig)
 
 	popl %esi
 	leave
-	ret
+	RET
 SYM_FUNC_END(mul32_Xsig)
 
 
@@ -115,7 +115,7 @@ SYM_FUNC_START(mul64_Xsig)
 
 	popl %esi
 	leave
-	ret
+	RET
 SYM_FUNC_END(mul64_Xsig)
 
 
@@ -175,5 +175,5 @@ SYM_FUNC_START(mul_Xsig_Xsig)
 
 	popl %esi
 	leave
-	ret
+	RET
 SYM_FUNC_END(mul_Xsig_Xsig)
diff --git a/arch/x86/math-emu/polynom_Xsig.S b/arch/x86/math-emu/polynom_Xsig.S
index 702315eecb86..35fd723fc0df 100644
--- a/arch/x86/math-emu/polynom_Xsig.S
+++ b/arch/x86/math-emu/polynom_Xsig.S
@@ -133,5 +133,5 @@ L_accum_done:
 	popl	%edi
 	popl	%esi
 	leave
-	ret
+	RET
 SYM_FUNC_END(polynomial_Xsig)
diff --git a/arch/x86/math-emu/reg_norm.S b/arch/x86/math-emu/reg_norm.S
index cad1d60b1e84..594936eeed67 100644
--- a/arch/x86/math-emu/reg_norm.S
+++ b/arch/x86/math-emu/reg_norm.S
@@ -72,7 +72,7 @@ L_exit_valid:
 L_exit:
 	popl	%ebx
 	leave
-	ret
+	RET
 
 
 L_zero:
@@ -138,7 +138,7 @@ L_exit_nuo_valid:
 
 	popl	%ebx
 	leave
-	ret
+	RET
 
 L_exit_nuo_zero:
 	movl	TAG_Zero,%eax
@@ -146,5 +146,5 @@ L_exit_nuo_zero:
 
 	popl	%ebx
 	leave
-	ret
+	RET
 SYM_FUNC_END(FPU_normalize_nuo)
diff --git a/arch/x86/math-emu/reg_round.S b/arch/x86/math-emu/reg_round.S
index 4a9fc3cc5a4d..0bb2a092161a 100644
--- a/arch/x86/math-emu/reg_round.S
+++ b/arch/x86/math-emu/reg_round.S
@@ -437,7 +437,7 @@ fpu_Arith_exit:
 	popl	%edi
 	popl	%esi
 	leave
-	ret
+	RET
 
 
 /*
diff --git a/arch/x86/math-emu/reg_u_add.S b/arch/x86/math-emu/reg_u_add.S
index 9c9e2c810afe..07247287a3af 100644
--- a/arch/x86/math-emu/reg_u_add.S
+++ b/arch/x86/math-emu/reg_u_add.S
@@ -164,6 +164,6 @@ L_exit:
 	popl	%edi
 	popl	%esi
 	leave
-	ret
+	RET
 #endif /* PARANOID */
 SYM_FUNC_END(FPU_u_add)
diff --git a/arch/x86/math-emu/reg_u_div.S b/arch/x86/math-emu/reg_u_div.S
index e2fb5c2644c5..b5a41e2fc484 100644
--- a/arch/x86/math-emu/reg_u_div.S
+++ b/arch/x86/math-emu/reg_u_div.S
@@ -468,7 +468,7 @@ L_exit:
 	popl	%esi
 
 	leave
-	ret
+	RET
 #endif /* PARANOID */ 
 
 SYM_FUNC_END(FPU_u_div)
diff --git a/arch/x86/math-emu/reg_u_mul.S b/arch/x86/math-emu/reg_u_mul.S
index 0c779c87ac5b..e2588b24b8c2 100644
--- a/arch/x86/math-emu/reg_u_mul.S
+++ b/arch/x86/math-emu/reg_u_mul.S
@@ -144,7 +144,7 @@ L_exit:
 	popl	%edi
 	popl	%esi
 	leave
-	ret
+	RET
 #endif /* PARANOID */ 
 
 SYM_FUNC_END(FPU_u_mul)
diff --git a/arch/x86/math-emu/reg_u_sub.S b/arch/x86/math-emu/reg_u_sub.S
index e9bb7c248649..4c900c29e4ff 100644
--- a/arch/x86/math-emu/reg_u_sub.S
+++ b/arch/x86/math-emu/reg_u_sub.S
@@ -270,5 +270,5 @@ L_exit:
 	popl	%edi
 	popl	%esi
 	leave
-	ret
+	RET
 SYM_FUNC_END(FPU_u_sub)
diff --git a/arch/x86/math-emu/round_Xsig.S b/arch/x86/math-emu/round_Xsig.S
index d9d7de8dbd7b..126c40473bad 100644
--- a/arch/x86/math-emu/round_Xsig.S
+++ b/arch/x86/math-emu/round_Xsig.S
@@ -78,7 +78,7 @@ L_exit:
 	popl	%esi
 	popl	%ebx
 	leave
-	ret
+	RET
 SYM_FUNC_END(round_Xsig)
 
 
@@ -138,5 +138,5 @@ L_n_exit:
 	popl	%esi
 	popl	%ebx
 	leave
-	ret
+	RET
 SYM_FUNC_END(norm_Xsig)
diff --git a/arch/x86/math-emu/shr_Xsig.S b/arch/x86/math-emu/shr_Xsig.S
index 726af985f758..f726bf6f6396 100644
--- a/arch/x86/math-emu/shr_Xsig.S
+++ b/arch/x86/math-emu/shr_Xsig.S
@@ -45,7 +45,7 @@ SYM_FUNC_START(shr_Xsig)
 	popl	%ebx
 	popl	%esi
 	leave
-	ret
+	RET
 
 L_more_than_31:
 	cmpl	$64,%ecx
@@ -61,7 +61,7 @@ L_more_than_31:
 	movl	$0,8(%esi)
 	popl	%esi
 	leave
-	ret
+	RET
 
 L_more_than_63:
 	cmpl	$96,%ecx
@@ -76,7 +76,7 @@ L_more_than_63:
 	movl	%edx,8(%esi)
 	popl	%esi
 	leave
-	ret
+	RET
 
 L_more_than_95:
 	xorl	%eax,%eax
@@ -85,5 +85,5 @@ L_more_than_95:
 	movl	%eax,8(%esi)
 	popl	%esi
 	leave
-	ret
+	RET
 SYM_FUNC_END(shr_Xsig)
diff --git a/arch/x86/math-emu/wm_shrx.S b/arch/x86/math-emu/wm_shrx.S
index 4fc89174caf0..f608a28a4c43 100644
--- a/arch/x86/math-emu/wm_shrx.S
+++ b/arch/x86/math-emu/wm_shrx.S
@@ -55,7 +55,7 @@ SYM_FUNC_START(FPU_shrx)
 	popl	%ebx
 	popl	%esi
 	leave
-	ret
+	RET
 
 L_more_than_31:
 	cmpl	$64,%ecx
@@ -70,7 +70,7 @@ L_more_than_31:
 	movl	$0,4(%esi)
 	popl	%esi
 	leave
-	ret
+	RET
 
 L_more_than_63:
 	cmpl	$96,%ecx
@@ -84,7 +84,7 @@ L_more_than_63:
 	movl	%edx,4(%esi)
 	popl	%esi
 	leave
-	ret
+	RET
 
 L_more_than_95:
 	xorl	%eax,%eax
@@ -92,7 +92,7 @@ L_more_than_95:
 	movl	%eax,4(%esi)
 	popl	%esi
 	leave
-	ret
+	RET
 SYM_FUNC_END(FPU_shrx)
 
 
@@ -146,7 +146,7 @@ SYM_FUNC_START(FPU_shrxs)
 	popl	%ebx
 	popl	%esi
 	leave
-	ret
+	RET
 
 /* Shift by [0..31] bits */
 Ls_less_than_32:
@@ -163,7 +163,7 @@ Ls_less_than_32:
 	popl	%ebx
 	popl	%esi
 	leave
-	ret
+	RET
 
 /* Shift by [64..95] bits */
 Ls_more_than_63:
@@ -189,7 +189,7 @@ Ls_more_than_63:
 	popl	%ebx
 	popl	%esi
 	leave
-	ret
+	RET
 
 Ls_more_than_95:
 /* Shift by [96..inf) bits */
@@ -203,5 +203,5 @@ Ls_more_than_95:
 	popl	%ebx
 	popl	%esi
 	leave
-	ret
+	RET
 SYM_FUNC_END(FPU_shrxs)
diff --git a/arch/x86/mm/mem_encrypt_boot.S b/arch/x86/mm/mem_encrypt_boot.S
index 17d292b7072f..3d1dba05fce4 100644
--- a/arch/x86/mm/mem_encrypt_boot.S
+++ b/arch/x86/mm/mem_encrypt_boot.S
@@ -65,7 +65,7 @@ SYM_FUNC_START(sme_encrypt_execute)
 	movq	%rbp, %rsp		/* Restore original stack pointer */
 	pop	%rbp
 
-	ret
+	RET
 SYM_FUNC_END(sme_encrypt_execute)
 
 SYM_FUNC_START(__enc_copy)
@@ -151,6 +151,6 @@ SYM_FUNC_START(__enc_copy)
 	pop	%r12
 	pop	%r15
 
-	ret
+	RET
 .L__enc_copy_end:
 SYM_FUNC_END(__enc_copy)
diff --git a/arch/x86/platform/efi/efi_stub_32.S b/arch/x86/platform/efi/efi_stub_32.S
index 09ec84f6ef51..f3cfdb1c9a35 100644
--- a/arch/x86/platform/efi/efi_stub_32.S
+++ b/arch/x86/platform/efi/efi_stub_32.S
@@ -56,5 +56,5 @@ SYM_FUNC_START(efi_call_svam)
 
 	movl	16(%esp), %ebx
 	leave
-	ret
+	RET
 SYM_FUNC_END(efi_call_svam)
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 90380a17ab23..2206b8bc47b8 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -23,5 +23,5 @@ SYM_FUNC_START(__efi_call)
 	mov %rsi, %rcx
 	CALL_NOSPEC rdi
 	leave
-	ret
+	RET
 SYM_FUNC_END(__efi_call)
diff --git a/arch/x86/platform/efi/efi_thunk_64.S b/arch/x86/platform/efi/efi_thunk_64.S
index fd3dd1708eba..f2a8eec69f8f 100644
--- a/arch/x86/platform/efi/efi_thunk_64.S
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -63,7 +63,7 @@ SYM_CODE_START(__efi64_thunk)
 1:	movq	24(%rsp), %rsp
 	pop	%rbx
 	pop	%rbp
-	retq
+	RET
 
 	.code32
 2:	pushl	$__KERNEL_CS
diff --git a/arch/x86/platform/olpc/xo1-wakeup.S b/arch/x86/platform/olpc/xo1-wakeup.S
index 75f4faff8468..3a5abffe5660 100644
--- a/arch/x86/platform/olpc/xo1-wakeup.S
+++ b/arch/x86/platform/olpc/xo1-wakeup.S
@@ -77,7 +77,7 @@ save_registers:
 	pushfl
 	popl saved_context_eflags
 
-	ret
+	RET
 
 restore_registers:
 	movl saved_context_ebp, %ebp
@@ -88,7 +88,7 @@ restore_registers:
 	pushl saved_context_eflags
 	popfl
 
-	ret
+	RET
 
 SYM_CODE_START(do_olpc_suspend_lowlevel)
 	call	save_processor_state
@@ -109,7 +109,7 @@ ret_point:
 
 	call	restore_registers
 	call	restore_processor_state
-	ret
+	RET
 SYM_CODE_END(do_olpc_suspend_lowlevel)
 
 .data
diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index 8786653ad3c0..5606a15cf9a1 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -32,7 +32,7 @@ SYM_FUNC_START(swsusp_arch_suspend)
 	FRAME_BEGIN
 	call swsusp_save
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(swsusp_arch_suspend)
 
 SYM_CODE_START(restore_image)
@@ -108,5 +108,5 @@ SYM_FUNC_START(restore_registers)
 	/* tell the hibernation core that we've just restored the memory */
 	movl	%eax, in_suspend
 
-	ret
+	RET
 SYM_FUNC_END(restore_registers)
diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index d9bed596d849..0a0539e1cc81 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -66,7 +66,7 @@ SYM_FUNC_START(restore_registers)
 	/* tell the hibernation core that we've just restored the memory */
 	movq	%rax, in_suspend(%rip)
 
-	ret
+	RET
 SYM_FUNC_END(restore_registers)
 
 SYM_FUNC_START(swsusp_arch_suspend)
@@ -96,7 +96,7 @@ SYM_FUNC_START(swsusp_arch_suspend)
 	FRAME_BEGIN
 	call swsusp_save
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(swsusp_arch_suspend)
 
 SYM_FUNC_START(restore_image)
diff --git a/arch/x86/um/checksum_32.S b/arch/x86/um/checksum_32.S
index 13f118dec74f..aed782ab7721 100644
--- a/arch/x86/um/checksum_32.S
+++ b/arch/x86/um/checksum_32.S
@@ -110,7 +110,7 @@ csum_partial:
 7:	
 	popl %ebx
 	popl %esi
-	ret
+	RET
 
 #else
 
@@ -208,7 +208,7 @@ csum_partial:
 80: 
 	popl %ebx
 	popl %esi
-	ret
+	RET
 				
 #endif
 	EXPORT_SYMBOL(csum_partial)
diff --git a/arch/x86/um/setjmp_32.S b/arch/x86/um/setjmp_32.S
index 62eaf8c80e04..2d991ddbcca5 100644
--- a/arch/x86/um/setjmp_32.S
+++ b/arch/x86/um/setjmp_32.S
@@ -34,7 +34,7 @@ kernel_setjmp:
 	movl %esi,12(%edx)
 	movl %edi,16(%edx)
 	movl %ecx,20(%edx)		# Return address
-	ret
+	RET
 
 	.size kernel_setjmp,.-kernel_setjmp
 
diff --git a/arch/x86/um/setjmp_64.S b/arch/x86/um/setjmp_64.S
index 1b5d40d4ff46..b46acb6a8ebd 100644
--- a/arch/x86/um/setjmp_64.S
+++ b/arch/x86/um/setjmp_64.S
@@ -33,7 +33,7 @@ kernel_setjmp:
 	movq %r14,40(%rdi)
 	movq %r15,48(%rdi)
 	movq %rsi,56(%rdi)		# Return address
-	ret
+	RET
 
 	.size kernel_setjmp,.-kernel_setjmp
 
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 3bebf66569b4..962d30ea01a2 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -45,7 +45,7 @@ SYM_FUNC_START(xen_irq_enable_direct)
 	call check_events
 1:
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(xen_irq_enable_direct)
 
 
@@ -55,7 +55,7 @@ SYM_FUNC_END(xen_irq_enable_direct)
  */
 SYM_FUNC_START(xen_irq_disable_direct)
 	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
-	ret
+	RET
 SYM_FUNC_END(xen_irq_disable_direct)
 
 /*
@@ -71,7 +71,7 @@ SYM_FUNC_START(xen_save_fl_direct)
 	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	setz %ah
 	addb %ah, %ah
-	ret
+	RET
 SYM_FUNC_END(xen_save_fl_direct)
 
 /*
@@ -100,7 +100,7 @@ SYM_FUNC_START(check_events)
 	pop %rcx
 	pop %rax
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(check_events)
 
 SYM_FUNC_START(xen_read_cr2)
@@ -108,14 +108,14 @@ SYM_FUNC_START(xen_read_cr2)
 	_ASM_MOV PER_CPU_VAR(xen_vcpu), %_ASM_AX
 	_ASM_MOV XEN_vcpu_info_arch_cr2(%_ASM_AX), %_ASM_AX
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(xen_read_cr2);
 
 SYM_FUNC_START(xen_read_cr2_direct)
 	FRAME_BEGIN
 	_ASM_MOV PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_arch_cr2, %_ASM_AX
 	FRAME_END
-	ret
+	RET
 SYM_FUNC_END(xen_read_cr2_direct);
 
 .macro xen_pv_trap name
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index cb6538ae2fe0..565062932ef1 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -70,7 +70,7 @@ SYM_CODE_START(hypercall_page)
 	.rept (PAGE_SIZE / 32)
 		UNWIND_HINT_FUNC
 		.skip 31, 0x90
-		ret
+		RET
 	.endr
 
 #define HYPERCALL(n) \
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 0ed4861b038f..b3d5f97f16cd 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -75,11 +75,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 
 	if (fileident) {
 		if (adinicb || (offset + lfi < 0)) {
-			memcpy(udf_get_fi_ident(sfi), fileident, lfi);
+			memcpy(sfi->impUse + liu, fileident, lfi);
 		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
 		} else {
-			memcpy(udf_get_fi_ident(sfi), fileident, -offset);
+			memcpy(sfi->impUse + liu, fileident, -offset);
 			memcpy(fibh->ebh->b_data, fileident - offset,
 				lfi + offset);
 		}
@@ -88,11 +88,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 	offset += lfi;
 
 	if (adinicb || (offset + padlen < 0)) {
-		memset(udf_get_fi_ident(sfi) + lfi, 0x00, padlen);
+		memset(sfi->impUse + liu + lfi, 0x00, padlen);
 	} else if (offset >= 0) {
 		memset(fibh->ebh->b_data + offset, 0x00, padlen);
 	} else {
-		memset(udf_get_fi_ident(sfi) + lfi, 0x00, -offset);
+		memset(sfi->impUse + liu + lfi, 0x00, -offset);
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}
 
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index a7360c8c72f8..3da5cfcf84c1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -35,6 +35,9 @@
 /* HCI priority */
 #define HCI_PRIO_MAX	7
 
+/* HCI maximum id value */
+#define HCI_MAX_ID 10000
+
 /* HCI Core structures */
 struct inquiry_data {
 	bdaddr_t	bdaddr;
diff --git a/include/uapi/linux/rfkill.h b/include/uapi/linux/rfkill.h
index 283c5a7b3f2c..db6c8588c1d0 100644
--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -184,7 +184,7 @@ struct rfkill_event_ext {
 #define RFKILL_IOC_NOINPUT	1
 #define RFKILL_IOCTL_NOINPUT	_IO(RFKILL_IOC_MAGIC, RFKILL_IOC_NOINPUT)
 #define RFKILL_IOC_MAX_SIZE	2
-#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_EXT_SIZE, __u32)
+#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_MAX_SIZE, __u32)
 
 /* and that's all userspace gets */
 
diff --git a/mm/gup.c b/mm/gup.c
index ba2ab7a223f8..05068d3d2557 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -465,7 +465,7 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, unsigned int flags)
 {
 	/* No page to get reference */
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return -EFAULT;
 
 	if (flags & FOLL_TOUCH) {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e659a7ef5acf..6b1556b4972e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -705,8 +705,10 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 			      (void *)&priv);
 	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
+	else
+		ret = 0;
 	mmap_read_unlock(p->mm);
-	return ret ? -EFAULT : -EHWPOISON;
+	return ret > 0 ? -EHWPOISON : -EFAULT;
 }
 
 static const char *action_name[] = {
diff --git a/mm/memory.c b/mm/memory.c
index bdf7185f1bf2..26d115ded4ab 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5467,6 +5467,8 @@ long copy_huge_page_from_user(struct page *dst_page,
 		if (rc)
 			break;
 
+		flush_dcache_page(subpage);
+
 		cond_resched();
 	}
 	return ret_val;
diff --git a/mm/migrate.c b/mm/migrate.c
index 1852d787e6ab..afb944b600fe 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -948,9 +948,12 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage)))
-			flush_dcache_page(newpage);
+		if (likely(!is_zone_device_page(newpage))) {
+			int i, nr = compound_nr(newpage);
 
+			for (i = 0; i < nr; i++)
+				flush_dcache_page(newpage + i);
+		}
 	}
 out:
 	return rc;
diff --git a/mm/mlock.c b/mm/mlock.c
index c6946c91193d..0cee3f97d3df 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -837,6 +837,7 @@ int user_shm_lock(size_t size, struct ucounts *ucounts)
 	}
 	if (!get_ucounts(ucounts)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
+		allowed = 0;
 		goto out;
 	}
 	allowed = 1;
diff --git a/mm/shmem.c b/mm/shmem.c
index 1609a8daba26..342d1bc72867 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2394,8 +2394,10 @@ int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 				/* don't free the page */
 				goto out_unacct_blocks;
 			}
+
+			flush_dcache_page(page);
 		} else {		/* ZEROPAGE */
-			clear_highpage(page);
+			clear_user_highpage(page, dst_addr);
 		}
 	} else {
 		page = *pagep;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 7a9008415534..c9bab48856c6 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -151,6 +151,8 @@ static int mcopy_atomic_pte(struct mm_struct *dst_mm,
 			/* don't free the page */
 			goto out;
 		}
+
+		flush_dcache_page(page);
 	} else {
 		page = *pagep;
 		*pagep = NULL;
@@ -621,6 +623,7 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 				err = -EFAULT;
 				goto out;
 			}
+			flush_dcache_page(page);
 			goto retry;
 		} else
 			BUG_ON(page);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index c67390367cc2..cdca53732304 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3907,10 +3907,10 @@ int hci_register_dev(struct hci_dev *hdev)
 	 */
 	switch (hdev->dev_type) {
 	case HCI_PRIMARY:
-		id = ida_simple_get(&hci_index_ida, 0, 0, GFP_KERNEL);
+		id = ida_simple_get(&hci_index_ida, 0, HCI_MAX_ID, GFP_KERNEL);
 		break;
 	case HCI_AMP:
-		id = ida_simple_get(&hci_index_ida, 1, 0, GFP_KERNEL);
+		id = ida_simple_get(&hci_index_ida, 1, HCI_MAX_ID, GFP_KERNEL);
 		break;
 	default:
 		return -EINVAL;
@@ -3919,7 +3919,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	if (id < 0)
 		return id;
 
-	sprintf(hdev->name, "hci%d", id);
+	snprintf(hdev->name, sizeof(hdev->name), "hci%d", id);
 	hdev->id = id;
 
 	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);
diff --git a/samples/ftrace/ftrace-direct-modify.c b/samples/ftrace/ftrace-direct-modify.c
index 89e6bf27cd9f..d620f3da086f 100644
--- a/samples/ftrace/ftrace-direct-modify.c
+++ b/samples/ftrace/ftrace-direct-modify.c
@@ -31,7 +31,7 @@ asm (
 "	call my_direct_func1\n"
 "	leave\n"
 "	.size		my_tramp1, .-my_tramp1\n"
-"	ret\n"
+	ASM_RET
 "	.type		my_tramp2, @function\n"
 "	.globl		my_tramp2\n"
 "   my_tramp2:"
@@ -39,7 +39,7 @@ asm (
 "	movq %rsp, %rbp\n"
 "	call my_direct_func2\n"
 "	leave\n"
-"	ret\n"
+	ASM_RET
 "	.size		my_tramp2, .-my_tramp2\n"
 "	.popsection\n"
 );
diff --git a/samples/ftrace/ftrace-direct-too.c b/samples/ftrace/ftrace-direct-too.c
index 11b99325f3db..3927cb880d1a 100644
--- a/samples/ftrace/ftrace-direct-too.c
+++ b/samples/ftrace/ftrace-direct-too.c
@@ -31,7 +31,7 @@ asm (
 "	popq %rsi\n"
 "	popq %rdi\n"
 "	leave\n"
-"	ret\n"
+	ASM_RET
 "	.size		my_tramp, .-my_tramp\n"
 "	.popsection\n"
 );
diff --git a/samples/ftrace/ftrace-direct.c b/samples/ftrace/ftrace-direct.c
index 642c50b5f716..1e901bb8d729 100644
--- a/samples/ftrace/ftrace-direct.c
+++ b/samples/ftrace/ftrace-direct.c
@@ -24,7 +24,7 @@ asm (
 "	call my_direct_func\n"
 "	popq %rdi\n"
 "	leave\n"
-"	ret\n"
+	ASM_RET
 "	.size		my_tramp, .-my_tramp\n"
 "	.popsection\n"
 );
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 3efc984d4c69..2b988b6ccacb 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -224,6 +224,17 @@ cmd_record_mcount = $(if $(findstring $(strip $(CC_FLAGS_FTRACE)),$(_c_flags)),
 endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
 
 ifdef CONFIG_STACK_VALIDATION
+
+objtool_args =								\
+	$(if $(CONFIG_UNWINDER_ORC),orc generate,check)			\
+	$(if $(part-of-module), --module)				\
+	$(if $(CONFIG_FRAME_POINTER),, --no-fp)				\
+	$(if $(CONFIG_GCOV_KERNEL)$(CONFIG_LTO_CLANG), --no-unreachable)\
+	$(if $(CONFIG_RETPOLINE), --retpoline)				\
+	$(if $(CONFIG_X86_SMAP), --uaccess)				\
+	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)		\
+	$(if $(CONFIG_SLS), --sls)
+
 ifndef CONFIG_LTO_CLANG
 
 __objtool_obj := $(objtree)/tools/objtool/objtool
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 54582673fc1a..0a8a4689c3eb 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -232,17 +232,6 @@ ifeq ($(CONFIG_LTO_CLANG),y)
 mod-prelink-ext := .lto
 endif
 
-# Objtool arguments are also needed for modfinal with LTO, so we define
-# then here to avoid duplication.
-objtool_args =								\
-	$(if $(CONFIG_UNWINDER_ORC),orc generate,check)			\
-	$(if $(part-of-module), --module)				\
-	$(if $(CONFIG_FRAME_POINTER),, --no-fp)				\
-	$(if $(CONFIG_GCOV_KERNEL)$(CONFIG_LTO_CLANG), --no-unreachable)\
-	$(if $(CONFIG_RETPOLINE), --retpoline)				\
-	$(if $(CONFIG_X86_SMAP), --uaccess)				\
-	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount)
-
 # Useful for describing the dependency of composite objects
 # Usage:
 #   $(call multi_depend, multi_used_targets, suffix_to_remove, suffix_to_add)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index d74cee5c4326..59a3df87907e 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -139,6 +139,9 @@ objtool_link()
 		if [ -n "${CONFIG_X86_SMAP}" ]; then
 			objtoolopt="${objtoolopt} --uaccess"
 		fi
+		if [ -n "${CONFIG_SLS}" ]; then
+			objtoolopt="${objtoolopt} --sls"
+		fi
 		info OBJTOOL ${1}
 		tools/objtool/objtool ${objtoolcmd} ${objtoolopt} ${1}
 	fi
diff --git a/tools/arch/x86/lib/memcpy_64.S b/tools/arch/x86/lib/memcpy_64.S
index 1cc9da6e29c7..59cf2343f3d9 100644
--- a/tools/arch/x86/lib/memcpy_64.S
+++ b/tools/arch/x86/lib/memcpy_64.S
@@ -39,7 +39,7 @@ SYM_FUNC_START_WEAK(memcpy)
 	rep movsq
 	movl %edx, %ecx
 	rep movsb
-	ret
+	RET
 SYM_FUNC_END(memcpy)
 SYM_FUNC_END_ALIAS(__memcpy)
 EXPORT_SYMBOL(memcpy)
@@ -53,7 +53,7 @@ SYM_FUNC_START_LOCAL(memcpy_erms)
 	movq %rdi, %rax
 	movq %rdx, %rcx
 	rep movsb
-	ret
+	RET
 SYM_FUNC_END(memcpy_erms)
 
 SYM_FUNC_START_LOCAL(memcpy_orig)
@@ -137,7 +137,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movq %r9,	1*8(%rdi)
 	movq %r10,	-2*8(%rdi, %rdx)
 	movq %r11,	-1*8(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_16bytes:
 	cmpl $8,	%edx
@@ -149,7 +149,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movq -1*8(%rsi, %rdx),	%r9
 	movq %r8,	0*8(%rdi)
 	movq %r9,	-1*8(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_8bytes:
 	cmpl $4,	%edx
@@ -162,7 +162,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movl -4(%rsi, %rdx), %r8d
 	movl %ecx, (%rdi)
 	movl %r8d, -4(%rdi, %rdx)
-	retq
+	RET
 	.p2align 4
 .Lless_3bytes:
 	subl $1, %edx
@@ -180,7 +180,7 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 	movb %cl, (%rdi)
 
 .Lend:
-	retq
+	RET
 SYM_FUNC_END(memcpy_orig)
 
 .popsection
diff --git a/tools/arch/x86/lib/memset_64.S b/tools/arch/x86/lib/memset_64.S
index 9827ae267f96..d624f2bc42f1 100644
--- a/tools/arch/x86/lib/memset_64.S
+++ b/tools/arch/x86/lib/memset_64.S
@@ -40,7 +40,7 @@ SYM_FUNC_START(__memset)
 	movl %edx,%ecx
 	rep stosb
 	movq %r9,%rax
-	ret
+	RET
 SYM_FUNC_END(__memset)
 SYM_FUNC_END_ALIAS(memset)
 EXPORT_SYMBOL(memset)
@@ -63,7 +63,7 @@ SYM_FUNC_START_LOCAL(memset_erms)
 	movq %rdx,%rcx
 	rep stosb
 	movq %r9,%rax
-	ret
+	RET
 SYM_FUNC_END(memset_erms)
 
 SYM_FUNC_START_LOCAL(memset_orig)
@@ -125,7 +125,7 @@ SYM_FUNC_START_LOCAL(memset_orig)
 
 .Lende:
 	movq	%r10,%rax
-	ret
+	RET
 
 .Lbad_alignment:
 	cmpq $7,%rdx
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 77b51600e3e9..63ffbc36dacc 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -529,6 +529,11 @@ int arch_decode_instruction(const struct elf *elf, const struct section *sec,
 		}
 		break;
 
+	case 0xcc:
+		/* int3 */
+		*type = INSN_TRAP;
+		break;
+
 	case 0xe3:
 		/* jecxz/jrcxz */
 		*type = INSN_JUMP_CONDITIONAL;
@@ -665,10 +670,10 @@ const char *arch_ret_insn(int len)
 {
 	static const char ret[5][5] = {
 		{ BYTE_RET },
-		{ BYTE_RET, BYTES_NOP1 },
-		{ BYTE_RET, BYTES_NOP2 },
-		{ BYTE_RET, BYTES_NOP3 },
-		{ BYTE_RET, BYTES_NOP4 },
+		{ BYTE_RET, 0xcc },
+		{ BYTE_RET, 0xcc, BYTES_NOP1 },
+		{ BYTE_RET, 0xcc, BYTES_NOP2 },
+		{ BYTE_RET, 0xcc, BYTES_NOP3 },
 	};
 
 	if (len < 1 || len > 5) {
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 8b38b5d6fec7..38070f26105b 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -20,7 +20,7 @@
 #include <objtool/objtool.h>
 
 bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-     validate_dup, vmlinux, mcount, noinstr, backup;
+     validate_dup, vmlinux, mcount, noinstr, backup, sls;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -45,6 +45,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('l', "vmlinux", &vmlinux, "vmlinux.o validation"),
 	OPT_BOOLEAN('M', "mcount", &mcount, "generate __mcount_loc"),
 	OPT_BOOLEAN('B', "backup", &backup, "create .orig files before modification"),
+	OPT_BOOLEAN('S', "sls", &sls, "validate straight-line-speculation"),
 	OPT_END(),
 };
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 58350fe1944b..66c7c13098b3 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -871,6 +871,16 @@ static void add_call_dest(struct objtool_file *file, struct instruction *insn,
 			               : arch_nop_insn(insn->len));
 
 		insn->type = sibling ? INSN_RETURN : INSN_NOP;
+
+		if (sibling) {
+			/*
+			 * We've replaced the tail-call JMP insn by two new
+			 * insn: RET; INT3, except we only have a single struct
+			 * insn here. Mark it retpoline_safe to avoid the SLS
+			 * warning, instead of adding another insn.
+			 */
+			insn->retpoline_safe = true;
+		}
 	}
 
 	if (mcount && !strcmp(insn->call_dest->name, "__fentry__")) {
@@ -2776,6 +2786,12 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 		switch (insn->type) {
 
 		case INSN_RETURN:
+			if (next_insn && next_insn->type == INSN_TRAP) {
+				next_insn->ignore = true;
+			} else if (sls && !insn->retpoline_safe) {
+				WARN_FUNC("missing int3 after ret",
+					  insn->sec, insn->offset);
+			}
 			return validate_return(func, insn, &state);
 
 		case INSN_CALL:
@@ -2819,6 +2835,14 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 			break;
 
 		case INSN_JUMP_DYNAMIC:
+			if (next_insn && next_insn->type == INSN_TRAP) {
+				next_insn->ignore = true;
+			} else if (sls && !insn->retpoline_safe) {
+				WARN_FUNC("missing int3 after indirect jump",
+					  insn->sec, insn->offset);
+			}
+
+			/* fallthrough */
 		case INSN_JUMP_DYNAMIC_CONDITIONAL:
 			if (is_sibling_call(insn)) {
 				ret = validate_sibling_call(insn, &state);
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 478e054fcdf7..9ca08d95e78e 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -26,6 +26,7 @@ enum insn_type {
 	INSN_CLAC,
 	INSN_STD,
 	INSN_CLD,
+	INSN_TRAP,
 	INSN_OTHER,
 };
 
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 15ac0b7d3d6a..89ba869ed08f 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -9,7 +9,7 @@
 
 extern const struct option check_options[];
 extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats,
-            validate_dup, vmlinux, mcount, noinstr, backup;
+            validate_dup, vmlinux, mcount, noinstr, backup, sls;
 
 extern int cmd_parse_options(int argc, const char **argv, const char * const usage[]);
 
