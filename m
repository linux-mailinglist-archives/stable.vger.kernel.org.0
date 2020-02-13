Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F2815C761
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgBMQKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbgBMPWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:40 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC1A52469A;
        Thu, 13 Feb 2020 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607359;
        bh=nue5T3gYIodIk7hAlwR2JIdhQ6M5D4n4gZHo6VdSTpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ys1dDdod8VIQy77VtN096Lxydon7sp5hw/NImhNek/3zJy7rlgfZAJ1jA2YA9QVWk
         UiOsCauo0/kK7CyuMhQfU1N8cUCf9PZkbAQM0xcUYpBHlzZC2pl659u1P5bwk3uhu+
         dZjVWU1hb1F3LgdJx9I0UdaNHHDBVyzAgjaG/5Sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 28/91] crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
Date:   Thu, 13 Feb 2020 07:19:45 -0800
Message-Id: <20200213151832.503729659@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit e8d998264bffade3cfe0536559f712ab9058d654 upstream.

We should not be modifying the original request's MAY_SLEEP flag
upon completion.  It makes no sense to do so anyway.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/pcrypt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -130,7 +130,6 @@ static void pcrypt_aead_done(struct cryp
 	struct padata_priv *padata = pcrypt_request_padata(preq);
 
 	padata->info = err;
-	req->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	padata_do_serial(padata);
 }


