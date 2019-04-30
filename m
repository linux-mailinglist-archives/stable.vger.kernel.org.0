Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397E3F70E
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbfD3Ltu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:49:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731059AbfD3Ltt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972D020449;
        Tue, 30 Apr 2019 11:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624989;
        bh=JA1cVPFQA7jeyfiTzE+eEd+tw3Y5fVwIqMIbkAFPUu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggar+msAAGljK0YRtHuCxuwjdZ9HA2itIZ1TPDuPxEkYEypOCcDvzMYa1Bb+u+XCg
         5WRjDvZQtKrzPPLhIeKblsxfBl+Mi5O/4Hnfbhw3tlrB4n19u9DsW5qPEXvy+4SwDj
         mSc8pnl7XXThrnF/dVnA5sdhAc1bzfHFkGS6wayE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 5.0 14/89] crypto: lrw - Fix atomic sleep when walking skcipher
Date:   Tue, 30 Apr 2019 13:38:05 +0200
Message-Id: <20190430113610.371633316@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit b257b48cd5830c5b1d0c347eb281f9c28056f881 upstream.

When we perform a walk in the completion function, we need to ensure
that it is atomic.

Fixes: ac3c8f36c31d ("crypto: lrw - Do not use auxiliary buffer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/lrw.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -212,8 +212,12 @@ static void crypt_done(struct crypto_asy
 {
 	struct skcipher_request *req = areq->data;
 
-	if (!err)
+	if (!err) {
+		struct rctx *rctx = skcipher_request_ctx(req);
+
+		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 		err = xor_tweak_post(req);
+	}
 
 	skcipher_request_complete(req, err);
 }


