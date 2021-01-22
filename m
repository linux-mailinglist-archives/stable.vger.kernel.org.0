Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD62300C42
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbhAVSms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbhAVOWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2EA523B51;
        Fri, 22 Jan 2021 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324965;
        bh=U+H9QY895yIA4dEjk9EOwQp3tOH3m8bsnCOmG/cOMGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y25u0bqwJGbgodVX6xhN6ZtB/kd6hHvQTbzpJv2xoLeLiFv1f29ufhX2JGAOCXYq+
         RpILcgm56xVXkQd64kebm1OYGyXaKJptr1iQ1R7pPTE+ds0SxxvrutJsZe9q8wz5+v
         +aqYLoBT6e430Nnu7uW5pOiliwOuT3xoiuiQk0wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jian Cai <jiancai@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 04/22] crypto: x86/crc32c - fix building with clang ias
Date:   Fri, 22 Jan 2021 15:12:22 +0100
Message-Id: <20210122135732.098221677@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 44623b2818f4a442726639572f44fd9b6d0ef68c upstream.

The clang integrated assembler complains about movzxw:

arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'

It seems that movzwq is the mnemonic that it expects instead,
and this is what objdump prints when disassembling the file.

Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[jc: Fixed conflicts due to lack of 34fdce6981b9 ("x86: Change {JMP,CALL}_NOSPEC argument")]
Signed-off-by: Jian Cai <jiancai@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -170,7 +170,7 @@ continue_block:
 
 	## branch into array
 	lea	jump_table(%rip), bufp
-	movzxw  (bufp, %rax, 2), len
+	movzwq  (bufp, %rax, 2), len
 	lea	crc_array(%rip), bufp
 	lea     (bufp, len, 1), bufp
 	JMP_NOSPEC bufp


