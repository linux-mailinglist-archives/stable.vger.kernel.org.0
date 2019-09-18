Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671F7B5D15
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfIRGbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729569AbfIRGXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:23:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 961A621924;
        Wed, 18 Sep 2019 06:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787800;
        bh=AbcZKFH4I95JP2aJSzd0CiOxs91bEROQGpBuAi0B2rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0ytuv1sESRNKp/Or+OXOexkksrWVXx3X3xsobZIB6Hi4T+f7m5XM/Fr3P0A1bCsA
         88VQNchIPP3AxwqMoUuK65vB225JZPvzm0EDB8cUyFmns7qIC/y+GrWzk+XZWvExRX
         kiPI/vAefHk4lGUz+o4vY1+xJuGa4cfg4fWpkTfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 39/50] crypto: talitos - HMAC SNOOP NO AFEU mode requires SW icv checking.
Date:   Wed, 18 Sep 2019 08:19:22 +0200
Message-Id: <20190918061227.715396366@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 4bbfb839259a9c96a0be872e16f7471b7136aee5 upstream.

In that mode, hardware ICV verification is not supported.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 7405c8d7ff97 ("crypto: talitos - templates for AEAD using HMAC_SNOOP_NO_AFEU")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1480,7 +1480,8 @@ static int aead_decrypt(struct aead_requ
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	if ((priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
+	if ((edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
+	    (priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
 	    ((!edesc->src_nents && !edesc->dst_nents) ||
 	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
 


