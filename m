Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0249A11B5A1
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbfLKPPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731568AbfLKPPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2E9824658;
        Wed, 11 Dec 2019 15:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077344;
        bh=wytKeplqK/AKhB4cIpXTYLqEbmNYTJ0B2BTWnB98EBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSz8WYcQZc4wiaFJg5GP/j/ZC953qLA2fovNJFbHLckR6s1Vr15y4jScElseK3xnO
         PWi7kywf56whDVZn7RRFk1Z0zBy5a8kM+x3hO42rxN6nS8Ur7dqgfK25qBs8YzjEFB
         StXYNlc8KjrVUFRf0mD7WR5JkfXcVIfTnbF5FY20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 090/105] crypto: ecdh - fix big endian bug in ECC library
Date:   Wed, 11 Dec 2019 16:06:19 +0100
Message-Id: <20191211150300.743726216@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit f398243e9fd6a3a059c1ea7b380c40628dbf0c61 upstream.

The elliptic curve arithmetic library used by the EC-DH KPP implementation
assumes big endian byte order, and unconditionally reverses the byte
and word order of multi-limb quantities. On big endian systems, the byte
reordering is not necessary, while the word ordering needs to be retained.

So replace the __swab64() invocation with a call to be64_to_cpu() which
should do the right thing for both little and big endian builds.

Fixes: 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/ecc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1284,10 +1284,11 @@ EXPORT_SYMBOL(ecc_point_mult_shamir);
 static inline void ecc_swap_digits(const u64 *in, u64 *out,
 				   unsigned int ndigits)
 {
+	const __be64 *src = (__force __be64 *)in;
 	int i;
 
 	for (i = 0; i < ndigits; i++)
-		out[i] = __swab64(in[ndigits - 1 - i]);
+		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
 }
 
 static int __ecc_is_key_valid(const struct ecc_curve *curve,


