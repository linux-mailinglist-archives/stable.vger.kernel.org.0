Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94CF1ACBF9
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896527AbgDPPxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896323AbgDPNct (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 216F522203;
        Thu, 16 Apr 2020 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043883;
        bh=OEew58mkSIbkMTtU/U7Oqx/XWT9VP8sFa5a3n5jfRDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tl+AOJeT1nHwHgIFogsHGEYcPqCVkrvlEbhPFlWSbLXsWkg9qOXQB1pjyXqIX39Td
         p7kO75LNsysSKTQ7wBGEl5LQgNVOn+lGq0oOfX2ehVrIK93p7Wz8M5qm/F+ahlwloT
         Nm43GvjASGrmfdXv1pJA6kqbIHaeLIyoeTiZqXMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/146] crypto: ccree - only try to map auth tag if needed
Date:   Thu, 16 Apr 2020 15:24:40 +0200
Message-Id: <20200416131301.381270546@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit 504e84abec7a635b861afd8d7f92ecd13eaa2b09 ]

Make sure to only add the size of the auth tag to the source mapping
for encryption if it is an in-place operation. Failing to do this
previously caused us to try and map auth size len bytes from a NULL
mapping and crashing if both the cryptlen and assoclen are zero.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 77e31191e408a..630020255941a 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -1242,9 +1242,11 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 	}
 
 	size_to_map = req->cryptlen + areq_ctx->assoclen;
-	if (areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT)
+	/* If we do in-place encryption, we also need the auth tag */
+	if ((areq_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_ENCRYPT) &&
+	   (req->src == req->dst)) {
 		size_to_map += authsize;
-
+	}
 	if (is_gcm4543)
 		size_to_map += crypto_aead_ivsize(tfm);
 	rc = cc_map_sg(dev, req->src, size_to_map, DMA_BIDIRECTIONAL,
-- 
2.20.1



