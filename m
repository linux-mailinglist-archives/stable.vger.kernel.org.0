Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6552171D07
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388665AbgB0ORN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389671AbgB0ORM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04602246A0;
        Thu, 27 Feb 2020 14:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813031;
        bh=P1XSfdaSgEZICuGIRjIcJt2bPHVLM3N9ff5tD9ONhss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tqrl3CpnKLYcknLL7uS0+J35mdjEzzKE/ywGEyIolK6bpmT2O52g6EMHWbORNPFVz
         qcazN/PN7bMM/LBKKVPIitBwq+1XmqscowmWQuWMuX8QswzyCKdxOmrlreX3b0gPe6
         nbn4Jx8E98au8PTcEeGogqZywiVHmynUK3fL0ifI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 103/150] crypto: chacha20poly1305 - prevent integer overflow on large input
Date:   Thu, 27 Feb 2020 14:37:20 +0100
Message-Id: <20200227132247.974403432@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit c9cc0517bba9f0213f1e55172feceb99e5512daf upstream.

This code assigns src_len (size_t) to sl (int), which causes problems
when src_len is very large. Probably nobody in the kernel should be
passing this much data to chacha20poly1305 all in one go anyway, so I
don't think we need to change the algorithm or introduce larger types
or anything. But we should at least error out early in this case and
print a warning so that we get reports if this does happen and can look
into why anybody is possibly passing it that much data or if they're
accidently passing -1 or similar.

Fixes: d95312a3ccc0 ("crypto: lib/chacha20poly1305 - reimplement crypt_from_sg() routine")
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/crypto/chacha20poly1305.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -235,6 +235,9 @@ bool chacha20poly1305_crypt_sg_inplace(s
 		__le64 lens[2];
 	} b __aligned(16);
 
+	if (WARN_ON(src_len > INT_MAX))
+		return false;
+
 	chacha_load_key(b.k, key);
 
 	b.iv[0] = 0;


