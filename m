Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D941579CD
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgBJNSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:18:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbgBJMhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:55 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B224E24672;
        Mon, 10 Feb 2020 12:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338274;
        bh=7OTbkjHlNEdy+CXRaMfUslaLkdTv82A7etR1wjm5MEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2tjB1S84+CmmmryRoS6C6zP/w23dn1TAy/hYsuEHaJv/kby1ml+VufcnfTxMx8Qd
         Hd7PEZ0uVUuLqECW+Ev9rukFFiy7617eTvusv+CNwkyc3BEK5AQDDjLiHMx4EF5WBK
         spa6JeGESL1P9AnkJrMEFcXZ6MFd3v+O6HM7xASg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 159/309] crypto: pcrypt - Do not clear MAY_SLEEP flag in original request
Date:   Mon, 10 Feb 2020 04:31:55 -0800
Message-Id: <20200210122421.480770827@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
@@ -71,7 +71,6 @@ static void pcrypt_aead_done(struct cryp
 	struct padata_priv *padata = pcrypt_request_padata(preq);
 
 	padata->info = err;
-	req->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	padata_do_serial(padata);
 }


