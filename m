Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4801AC696
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394469AbgDPOlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392726AbgDPOBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF9EC2078B;
        Thu, 16 Apr 2020 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045662;
        bh=cIOg4crpwTP9ciJe671gs1El4Wkf8mdK+l18SkpVrV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2k12MC0AtQ5bzCfp0g1DRuOgXqWhcpIgHK1bveZ+q7FWxZw79YVaQI2oHD71JGt6
         yQgmIX7Ukgyp2DD8jOyS9Q8FnzKjRM8Q1144yHbSuOlYzQ0bxq4U08Yj6VzvlCki8l
         7poQur4DxEOJOLNhcqFoWAEp3pJ4jm6A6lT9ojCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.6 187/254] crypto: ccree - dec auth tag size from cryptlen map
Date:   Thu, 16 Apr 2020 15:24:36 +0200
Message-Id: <20200416131349.731381817@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit 8962c6d2c2b8ca51b0f188109015b15fc5f4da44 upstream.

Remove the auth tag size from cryptlen before mapping the destination
in out-of-place AEAD decryption thus resolving a crash with
extended testmgr tests.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org # v4.19+
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_buffer_mgr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -894,8 +894,12 @@ static int cc_aead_chain_data(struct cc_
 
 	if (req->src != req->dst) {
 		size_for_map = areq_ctx->assoclen + req->cryptlen;
-		size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
-				authsize : 0;
+
+		if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT)
+			size_for_map += authsize;
+		else
+			size_for_map -= authsize;
+
 		if (is_gcm4543)
 			size_for_map += crypto_aead_ivsize(tfm);
 


