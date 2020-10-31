Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA81C2A15BB
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgJaLhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbgJaLgs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:36:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A451620791;
        Sat, 31 Oct 2020 11:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144208;
        bh=ZNmYTsr5WeuvMBDgFNeihJLom20CHDmhTDRZeEwZL10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXaBODn4+ul91C62N2P4gYbIMaxsXO6dco97R0VcuxXkHXPRIAR64SXqUCeO/3g1l
         yYvQcrnk0p2y8JFK/9cr4FH6pXovcxVoV9/b8bkrJI4ikYg5b/XU5PN6RLoQMmMgIh
         eUpkRoGkCgmWrboWHZInHrpH9o63/UHkjiwuKZHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jian Cai <jiancai@google.com>
Subject: [PATCH 5.4 46/49] crypto: x86/crc32c - fix building with clang ias
Date:   Sat, 31 Oct 2020 12:35:42 +0100
Message-Id: <20201031113457.665835631@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
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


