Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9392023610
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388945AbfETM3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388848AbfETM3o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:29:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC592216C4;
        Mon, 20 May 2019 12:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355383;
        bh=N8d2+4SnFNE53BBI5L7qN6qxAsHj6sYtOtlPLCR3Gi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjPbh4PXCBEIQXIoosG3VbObPE+NbO10pniIilzhOtxiu2YXSDoCtoV8L6CIoLu5e
         OIQf8TBnWEg2cT4t1+NyfdCd0q1npjiSqqEihSKUJkW7d7PHp33FnMKt9AL3XJGuxH
         JosPy/8RNoidAQCcCHuojR2sy5/tywBaA7cFspeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 061/123] crypto: ccree - use correct internal state sizes for export
Date:   Mon, 20 May 2019 14:14:01 +0200
Message-Id: <20190520115248.849293422@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit f3df82b468f00cca241d96ee3697c9a5e7fb6bd0 upstream.

We were computing the size of the import buffer based on the digest size
but the 318 and 224 byte variants use 512 and 256 bytes internal state
sizes respectfully, thus causing the import buffer to overrun.

Fix it by using the right sizes.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_hash.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -1639,7 +1639,7 @@ static struct cc_hash_template driver_ha
 			.setkey = cc_hash_setkey,
 			.halg = {
 				.digestsize = SHA224_DIGEST_SIZE,
-				.statesize = CC_STATE_SIZE(SHA224_DIGEST_SIZE),
+				.statesize = CC_STATE_SIZE(SHA256_DIGEST_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA224,
@@ -1666,7 +1666,7 @@ static struct cc_hash_template driver_ha
 			.setkey = cc_hash_setkey,
 			.halg = {
 				.digestsize = SHA384_DIGEST_SIZE,
-				.statesize = CC_STATE_SIZE(SHA384_DIGEST_SIZE),
+				.statesize = CC_STATE_SIZE(SHA512_DIGEST_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA384,


