Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B4161712
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfGGTpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:45:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57166 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727531AbfGGTiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:06 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0006gF-9w; Sun, 07 Jul 2019 20:38:02 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0005Zp-1P; Sun, 07 Jul 2019 20:38:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Biggers" <ebiggers@kernel.org>,
        "Ard Biesheuvel" <ard.biesheuvel@linaro.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.499548159@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 044/129] crypto: arm64/aes-ccm - fix logical bug in
 AAD MAC handling
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit eaf46edf6ea89675bd36245369c8de5063a0272c upstream.

The NEON MAC calculation routine fails to handle the case correctly
where there is some data in the buffer, and the input fills it up
exactly. In this case, we enter the loop at the end with w8 == 0,
while a negative value is assumed, and so the loop carries on until
the increment of the 32-bit counter wraps around, which is quite
obviously wrong.

So omit the loop altogether in this case, and exit right away.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: a3fd82105b9d1 ("arm64/crypto: AES in CCM mode using ARMv8 Crypto ...")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -74,12 +74,13 @@ ENTRY(ce_aes_ccm_auth_data)
 	beq	10f
 	ext	v0.16b, v0.16b, v0.16b, #1	/* rotate out the mac bytes */
 	b	7b
-8:	mov	w7, w8
+8:	cbz	w8, 91f
+	mov	w7, w8
 	add	w8, w8, #16
 9:	ext	v1.16b, v1.16b, v1.16b, #1
 	adds	w7, w7, #1
 	bne	9b
-	eor	v0.16b, v0.16b, v1.16b
+91:	eor	v0.16b, v0.16b, v1.16b
 	st1	{v0.16b}, [x0]
 10:	str	w8, [x3]
 	ret

