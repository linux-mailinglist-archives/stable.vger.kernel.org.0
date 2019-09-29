Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A72C157C
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbfI2ODS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbfI2ODR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:03:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D772082F;
        Sun, 29 Sep 2019 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765797;
        bh=gPEAdCoQcj/Dl5H8Ugwgo+VOs5S376PUW8I37nNTxQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUN6jmdEYXzxZDO4qzEvhoOExwOS17H5Al6kj2esU0rRv5oq7PSGoWnP68Uv1dINL
         2AUqa8vJQftEQR9pBkk9Syze9wF8a7aGHc3Bl4+cCe1C5jitFNYDls+6xnzu4HvOob
         hGSallG4Z3LAd+CpVW/7kNuB8QEiOfl+NwzGNe0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 16/25] crypto: talitos - fix missing break in switch statement
Date:   Sun, 29 Sep 2019 15:56:19 +0200
Message-Id: <20190929135015.560978240@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
References: <20190929135006.127269625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 5fc194ea6d34dfad9833d3043ce41d6c52aff39a upstream.

Add missing break statement in order to prevent the code from falling
through to case CRYPTO_ALG_TYPE_AHASH.

Fixes: aeb4c132f33d ("crypto: talitos - Convert to new AEAD interface")
Cc: stable@vger.kernel.org
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3140,6 +3140,7 @@ static int talitos_remove(struct platfor
 			break;
 		case CRYPTO_ALG_TYPE_AEAD:
 			crypto_unregister_aead(&t_alg->algt.alg.aead);
+			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			crypto_unregister_ahash(&t_alg->algt.alg.hash);
 			break;


