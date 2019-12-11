Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BF611B59E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbfLKPPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:15:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731817AbfLKPPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 835E524654;
        Wed, 11 Dec 2019 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077337;
        bh=qZP2yRdgbUNSFmpXlCEF63tmGL1c3FYWJMWm9kxrw1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsPlMqn65ggXD2kw/h++SyvdhJyKcl0Pt3l/JaCi/d+HjNCurVDSAju3Z0BX53pvZ
         n7GU6GECB024xnkEpjxOkVaLnzcGKswslEnz+b5Gy+pMUMEqArqgPCWMOI6QhGbdlN
         KF/YfxNbRCFUeA6bDk1jqdsmtszuJA3Ngf5ebSe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.3 087/105] crypto: af_alg - cast ki_complete ternary op to int
Date:   Wed, 11 Dec 2019 16:06:16 +0100
Message-Id: <20191211150259.785118286@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>

commit 64e7f852c47ce99f6c324c46d6a299a5a7ebead9 upstream.

when libkcapi test is executed  using HW accelerator, cipher operation
return -74.Since af_alg_async_cb->ki_complete treat err as unsigned int,
libkcapi receive 429467222 even though it expect -ve value.

Hence its required to cast resultlen to int so that proper
error is returned to libkcapi.

AEAD one shot non-aligned test 2(libkcapi test)
./../bin/kcapi   -x 10   -c "gcm(aes)" -i 7815d4b06ae50c9c56e87bd7
-k ea38ac0c9b9998c80e28fb496a2b88d9 -a
"853f98a750098bec1aa7497e979e78098155c877879556bb51ddeb6374cbaefc"
-t "c4ce58985b7203094be1d134c1b8ab0b" -q
"b03692f86d1b8b39baf2abb255197c98"

Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/af_alg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1043,7 +1043,7 @@ void af_alg_async_cb(struct crypto_async
 	af_alg_free_resources(areq);
 	sock_put(sk);
 
-	iocb->ki_complete(iocb, err ? err : resultlen, 0);
+	iocb->ki_complete(iocb, err ? err : (int)resultlen, 0);
 }
 EXPORT_SYMBOL_GPL(af_alg_async_cb);
 


