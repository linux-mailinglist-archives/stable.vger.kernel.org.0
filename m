Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903E1247544
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387705AbgHQTV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgHQPgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:36:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25898221E2;
        Mon, 17 Aug 2020 15:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678580;
        bh=A+gXy+WEDFoe8sMhOiELZeqnP0z58AULk6aCMoFF6Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJWdFVAebUBHhGq97CGMxAFpjbfNMQ6Gz7uASbwtHm938FZqSQj4YXSLqhoauJE4O
         CsLFZ2WEW7UbeWSPOn04BUeZQudbnSFXow33Y+7aGJMZWJKTa28mXxSrB6XjnOTPUo
         q0c3EBzfa3VpK7rYGXLDHE7LaYJ+VkrQDNjvA/AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Jian Cai <caij2003@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 382/464] crypto: aesni - add compatibility with IAS
Date:   Mon, 17 Aug 2020 17:15:35 +0200
Message-Id: <20200817143852.075012454@linuxfoundation.org>
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

From: Jian Cai <caij2003@gmail.com>

[ Upstream commit 44069737ac9625a0f02f0f7f5ab96aae4cd819bc ]

Clang's integrated assembler complains "invalid reassignment of
non-absolute variable 'var_ddq_add'" while assembling
arch/x86/crypto/aes_ctrby8_avx-x86_64.S. It was because var_ddq_add was
reassigned with non-absolute values several times, which IAS did not
support. We can avoid the reassignment by replacing the uses of
var_ddq_add with its definitions accordingly to have compatilibility
with IAS.

Link: https://github.com/ClangBuiltLinux/linux/issues/1008
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Reported-by: Fangrui Song <maskray@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # build+boot Linux v5.7.5; clang v11.0.0-git
Signed-off-by: Jian Cai <caij2003@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index ec437db1fa547..494a3bda84870 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -127,10 +127,6 @@ ddq_add_8:
 
 /* generate a unique variable for ddq_add_x */
 
-.macro setddq n
-	var_ddq_add = ddq_add_\n
-.endm
-
 /* generate a unique variable for xmm register */
 .macro setxdata n
 	var_xdata = %xmm\n
@@ -140,9 +136,7 @@ ddq_add_8:
 
 .macro club name, id
 .altmacro
-	.if \name == DDQ_DATA
-		setddq %\id
-	.elseif \name == XDATA
+	.if \name == XDATA
 		setxdata %\id
 	.endif
 .noaltmacro
@@ -165,9 +159,8 @@ ddq_add_8:
 
 	.set i, 1
 	.rept (by - 1)
-		club DDQ_DATA, i
 		club XDATA, i
-		vpaddq	var_ddq_add(%rip), xcounter, var_xdata
+		vpaddq	(ddq_add_1 + 16 * (i - 1))(%rip), xcounter, var_xdata
 		vptest	ddq_low_msk(%rip), var_xdata
 		jnz 1f
 		vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
@@ -180,8 +173,7 @@ ddq_add_8:
 	vmovdqa	1*16(p_keys), xkeyA
 
 	vpxor	xkey0, xdata0, xdata0
-	club DDQ_DATA, by
-	vpaddq	var_ddq_add(%rip), xcounter, xcounter
+	vpaddq	(ddq_add_1 + 16 * (by - 1))(%rip), xcounter, xcounter
 	vptest	ddq_low_msk(%rip), xcounter
 	jnz	1f
 	vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
-- 
2.25.1



