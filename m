Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B24126A62
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfLSSqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:46:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbfLSSqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:46:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0109222C2;
        Thu, 19 Dec 2019 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781204;
        bh=XQ8ixBV1OwmvAx4bXVDtEJXlvNN41KaE6IvDZ7Ew5Rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnQ/pz/jCCC/BvTST1tkD1+hcfm+4cbio+3OhvDq478i2Pvhr6hk/DpNNWMltVAWZ
         umuAdqwBlg4T3p6yT/UpqKsMyU4wKsOa2R6yXL+6G2qbeR9kZW5gfDqv61xu9Mr1KI
         JfydZ6pM3qEzuVxgt7DNgHnIZvJuKJNTsJW6VpLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.9 088/199] crypto: ecdh - fix big endian bug in ECC library
Date:   Thu, 19 Dec 2019 19:32:50 +0100
Message-Id: <20191219183219.809163370@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
@@ -897,10 +897,11 @@ static void ecc_point_mult(struct ecc_po
 static inline void ecc_swap_digits(const u64 *in, u64 *out,
 				   unsigned int ndigits)
 {
+	const __be64 *src = (__force __be64 *)in;
 	int i;
 
 	for (i = 0; i < ndigits; i++)
-		out[i] = __swab64(in[ndigits - 1 - i]);
+		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
 }
 
 int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,


