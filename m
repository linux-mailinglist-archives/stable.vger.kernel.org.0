Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A35D234FF
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390094AbfETMcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390522AbfETMcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:32:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBC90204FD;
        Mon, 20 May 2019 12:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355542;
        bh=0msjDw4e8JU1SNWYIWYp0Zm3hjgfapzuhX6gELrNtSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgZgzeGtFvrJdDgyRMwZp1eMtldtWoE5iNSuKTO93V/O6YiR8NL9wHI1y0ka4XhPS
         ZLanpa8iO2wgPDOVjLkLe+aQt14hhM503DWGnRwVvvLQMYNPBNkCbZtpBam2HE/+sb
         BLuCORTrTfbfcKHjlNf2ODfGXV4Y2RX0dMk+bcZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ondrej=20Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.1 031/128] crypto: vmx - fix copy-paste error in CTR mode
Date:   Mon, 20 May 2019 14:13:38 +0200
Message-Id: <20190520115251.741979733@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

commit dcf7b48212c0fab7df69e84fab22d6cb7c8c0fb9 upstream.

The original assembly imported from OpenSSL has two copy-paste
errors in handling CTR mode. When dealing with a 2 or 3 block tail,
the code branches to the CBC decryption exit path, rather than to
the CTR exit path.

This leads to corruption of the IV, which leads to subsequent blocks
being corrupted.

This can be detected with libkcapi test suite, which is available at
https://github.com/smuellerDD/libkcapi

Reported-by: Ondrej Mosnáček <omosnacek@gmail.com>
Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Axtens <dja@axtens.net>
Tested-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Ondrej Mosnacek <omosnacek@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/vmx/aesp8-ppc.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/vmx/aesp8-ppc.pl
+++ b/drivers/crypto/vmx/aesp8-ppc.pl
@@ -1854,7 +1854,7 @@ Lctr32_enc8x_three:
 	stvx_u		$out1,$x10,$out
 	stvx_u		$out2,$x20,$out
 	addi		$out,$out,0x30
-	b		Lcbc_dec8x_done
+	b		Lctr32_enc8x_done
 
 .align	5
 Lctr32_enc8x_two:
@@ -1866,7 +1866,7 @@ Lctr32_enc8x_two:
 	stvx_u		$out0,$x00,$out
 	stvx_u		$out1,$x10,$out
 	addi		$out,$out,0x20
-	b		Lcbc_dec8x_done
+	b		Lctr32_enc8x_done
 
 .align	5
 Lctr32_enc8x_one:


