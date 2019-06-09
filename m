Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C0D3A9F3
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731178AbfFIQ4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732956AbfFIQ4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:56:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E86C206DF;
        Sun,  9 Jun 2019 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099379;
        bh=/zs1kV0ZRxtxgbKMD18C+JsRrw20wJO0yHWqfbX8Exw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkjDLzKUfSPDMDZCoZgBLwoD0RNk/4X0Y8ephJ22ArHs9GuzfpTTPgJcIGmFS2UfM
         prLnxGMjlXlgXS9LkTbs88fHx/5W7Umfn8PJ1qfz4WU992TCW/fZlrQ3iWTOfZc6XB
         UKXZ7n52NHmG/xNSCwF8NuknusOHx6cU9InhrCvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.4 022/241] crypto: gcm - Fix error return code in crypto_gcm_create_common()
Date:   Sun,  9 Jun 2019 18:39:24 +0200
Message-Id: <20190609164148.422696674@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 9b40f79c08e81234d759f188b233980d7e81df6c upstream.

Fix to return error code -EINVAL from the invalid alg ivsize error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/gcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -670,11 +670,11 @@ static int crypto_gcm_create_common(stru
 	ctr = crypto_skcipher_spawn_alg(&ctx->ctr);
 
 	/* We only support 16-byte blocks. */
+	err = -EINVAL;
 	if (ctr->cra_ablkcipher.ivsize != 16)
 		goto out_put_ctr;
 
 	/* Not a stream cipher? */
-	err = -EINVAL;
 	if (ctr->cra_blocksize != 1)
 		goto out_put_ctr;
 


