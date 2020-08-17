Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FAE24775A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732724AbgHQTsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:48:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729279AbgHQPUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:20:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07267206FA;
        Mon, 17 Aug 2020 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677624;
        bh=IHgBT8Vjik3BbIgxDcxrZBpBmFQ3aLVlSzGsnPVE574=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rkzk0BZmMOyLcmT8ErNAkGUaJlEjqlNHWQErKzf0ZmdPm0W3YDcDIlXwB80ESyGM4
         cuU16mOQ3gbV/P57Q8+cSTxVRQKGzYLMVpXdlkMlrNhHTjvljFsLTwP3mDOsfa0A3H
         UmFQ57NAAQd5GTRDvUXVniORuiZPPBY1z1fbgZuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 048/464] crypto: x86/crc32c - fix building with clang ias
Date:   Mon, 17 Aug 2020 17:10:01 +0200
Message-Id: <20200817143836.060176492@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 44623b2818f4a442726639572f44fd9b6d0ef68c ]

The clang integrated assembler complains about movzxw:

arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'

It seems that movzwq is the mnemonic that it expects instead,
and this is what objdump prints when disassembling the file.

Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 8501ec4532f4f..442599cbe7960 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -170,7 +170,7 @@ continue_block:
 
 	## branch into array
 	lea	jump_table(%rip), %bufp
-	movzxw  (%bufp, %rax, 2), len
+	movzwq  (%bufp, %rax, 2), len
 	lea	crc_array(%rip), %bufp
 	lea     (%bufp, len, 1), %bufp
 	JMP_NOSPEC bufp
-- 
2.25.1



