Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C107236DB
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbfETMRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387523AbfETMRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:17:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE31920815;
        Mon, 20 May 2019 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354640;
        bh=9WsSvO/ZYAemycEEPmwo5X7jWRagg1S1SsUuhQ1A66A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2RDnUjnftXPkSUzqsIgwaZTTh36J1dKJqxtpTfe817u3mJKcMb8W5WSjiQYOguu2
         8zI2lJRmwQ6Cyh9ng7uUKgqJjIW797SYp6Ei247Kj5Z6JJT8e+SWckitoYcOmaiW96
         yi/v5lK3B4u+nupxmyvJMDtlXZY0fM8bRPwL9wYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.9 34/44] crypto: gcm - Fix error return code in crypto_gcm_create_common()
Date:   Mon, 20 May 2019 14:14:23 +0200
Message-Id: <20190520115235.180288663@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/gcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -670,11 +670,11 @@ static int crypto_gcm_create_common(stru
 	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
 
 	/* We only support 16-byte blocks. */
+	err = -EINVAL;
 	if (crypto_skcipher_alg_ivsize(ctr) != 16)
 		goto out_put_ctr;
 
 	/* Not a stream cipher? */
-	err = -EINVAL;
 	if (ctr->base.cra_blocksize != 1)
 		goto out_put_ctr;
 


