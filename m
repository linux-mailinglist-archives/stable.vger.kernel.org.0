Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197531ACC05
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506705AbgDPPxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896542AbgDPNcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F7B9221F7;
        Thu, 16 Apr 2020 13:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043881;
        bh=cq4mKeRnHnlsgDMbjpf5DmyHS/UQgAcbFh62M2D5pXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPuyIiazfxbN7yfu34h6lPPbQY4WgsOVpXwxSRpy4/FmiknNKpIaE0STa7tgfaiIN
         4mCl+sg9ClnBkALqjL23oYxYZZ7nbO/qnJihgzre7s0AFVPRqseI6N8GFpVhV7VG7u
         0LJMVvs9ZyQN5sub3iNMq/i9oCW5yycnjC7U0rJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/146] crypto: ccree - dec auth tag size from cryptlen map
Date:   Thu, 16 Apr 2020 15:24:39 +0200
Message-Id: <20200416131301.253367669@linuxfoundation.org>
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

[ Upstream commit 8962c6d2c2b8ca51b0f188109015b15fc5f4da44 ]

Remove the auth tag size from cryptlen before mapping the destination
in out-of-place AEAD decryption thus resolving a crash with
extended testmgr tests.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org # v4.19+
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 6681d113c0d67..77e31191e408a 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -1021,8 +1021,12 @@ static int cc_aead_chain_data(struct cc_drvdata *drvdata,
 
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
 
-- 
2.20.1



