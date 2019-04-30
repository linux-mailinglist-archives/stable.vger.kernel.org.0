Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9547DF720
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfD3Lz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730985AbfD3Lt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:49:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E382054F;
        Tue, 30 Apr 2019 11:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624968;
        bh=0ciGWazNr8j4GuCDsuHETt61WKcUTfQMjk8tZXtymO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQqbXzS98Fs326DGwVXD/a+X0vQcBOJ9Scgz6WPE7HG5yKBmQapTyOBYtOLpvPplT
         zvRb42WVehskVe4qOMEERwv7HOzphWU4Gj3IV9MZXp4/9YxdLpMfJIsfp/dlyuRGou
         1kOzpL1hixzWpmay//acdaRXVCzbtVJWuMCuuNxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6f72c20560060c98b566@syzkaller.appspotmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 5.0 13/89] crypto: xts - Fix atomic sleep when walking skcipher
Date:   Tue, 30 Apr 2019 13:38:04 +0200
Message-Id: <20190430113610.342144523@linuxfoundation.org>
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

commit 44427c0fbc09b448b22410978a4ef6ee37599d25 upstream.

When we perform a walk in the completion function, we need to ensure
that it is atomic.

Reported-by: syzbot+6f72c20560060c98b566@syzkaller.appspotmail.com
Fixes: 78105c7e769b ("crypto: xts - Drop use of auxiliary buffer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/xts.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -137,8 +137,12 @@ static void crypt_done(struct crypto_asy
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


