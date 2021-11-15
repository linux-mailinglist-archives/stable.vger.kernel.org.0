Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BE8451F60
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356185AbhKPAiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343906AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D07D6339F;
        Mon, 15 Nov 2021 18:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002089;
        bh=8vWF8aQpljnn08VrZucwogFkbfZQolocwahYzzYTMEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwv5WYe8UbHLRbQI8HUFD259gPcy0In3h/XZJG7gqhM45KU7+Pv7oHACYiAr7rYZW
         lDnM4Rk5dS7n9uHDW17AMlhsa4s34RnVeSlRtv6FuHOxooN5In1GlFc5reAXs9tbRK
         yU7Q9SR/ELKHaZQn6Vl3R1nYXYo1MuxouEgfPQqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ovidiu Panait <ovidiu.panait@windriver.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 434/917] crypto: octeontx2 - set assoclen in aead_do_fallback()
Date:   Mon, 15 Nov 2021 17:58:49 +0100
Message-Id: <20211115165443.508663606@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 06f6e365e2ecf799c249bb464aa9d5f055e88b56 ]

Currently, in case of aead fallback, no associated data info is set in the
fallback request. To fix this, call aead_request_set_ad() to pass the assoclen.

Fixes: 6f03f0e8b6c8 ("crypto: octeontx2 - register with linux crypto framework")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index a72723455df72..877a948469bd1 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -1274,6 +1274,7 @@ static int aead_do_fallback(struct aead_request *req, bool is_enc)
 					  req->base.complete, req->base.data);
 		aead_request_set_crypt(&rctx->fbk_req, req->src,
 				       req->dst, req->cryptlen, req->iv);
+		aead_request_set_ad(&rctx->fbk_req, req->assoclen);
 		ret = is_enc ? crypto_aead_encrypt(&rctx->fbk_req) :
 			       crypto_aead_decrypt(&rctx->fbk_req);
 	} else {
-- 
2.33.0



