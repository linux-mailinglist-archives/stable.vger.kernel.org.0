Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49084D25DB
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbfJJIj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387430AbfJJIj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B06E21D7A;
        Thu, 10 Oct 2019 08:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696767;
        bh=NROWJEU6vUCbpXiz1egOIyuqyJi8o/fjEm1WAP2iO8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/+3Oj3JxOOsgeqZZpLMxk8j1DnYfKlZTElVCPBr34YyFJ2vbrFifS1VwgEriupRK
         wfBnilp59wcKjGKekRpeLiOX3NBS5wtka/UG+On8VJTtA/vyeWmgwxtjXlTbsZvYQU
         ro4O8I/clwyGRQohk5PC5nyVgN+sdt+pyuAA/PF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 046/148] crypto: ccree - use the full crypt length value
Date:   Thu, 10 Oct 2019 10:35:07 +0200
Message-Id: <20191010083613.938277698@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit 7a4be6c113c1f721818d1e3722a9015fe393295c upstream.

In case of AEAD decryption verifcation error we were using the
wrong value to zero out the plaintext buffer leaving the end of
the buffer with the false plaintext.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: ff27e85a85bb ("crypto: ccree - add AEAD support")
CC: stable@vger.kernel.org # v4.17+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_aead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -236,7 +236,7 @@ static void cc_aead_complete(struct devi
 			/* In case of payload authentication failure, MUST NOT
 			 * revealed the decrypted message --> zero its memory.
 			 */
-			cc_zero_sgl(areq->dst, areq_ctx->cryptlen);
+			cc_zero_sgl(areq->dst, areq->cryptlen);
 			err = -EBADMSG;
 		}
 	} else { /*ENCRYPT*/


