Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13D31FB83E
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgFPPyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732991AbgFPPy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:54:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8364207C4;
        Tue, 16 Jun 2020 15:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322869;
        bh=cB0xYbRke6CaPhv+2x3VkaVLolCq4Lq7+R793GDpnis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tbs3KAJXWBIZ+DHAG+gsceJsXfdgI/CWSUwS0WF5lzi3lojot1sCxJF+yChNLrg6r
         z66sok+NXutI4ueCRYrsfW1dg2mXc5h+YZl8H5PhGYm/v8Djx25XeisyBvbTNgw7Oo
         OB+CeJKTDIuOhd+/Ewqa4FUEacrjjtkFK5xTyWzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.6 096/161] crypto: algapi - Avoid spurious modprobe on LOADED
Date:   Tue, 16 Jun 2020 17:34:46 +0200
Message-Id: <20200616153110.949933399@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit beeb460cd12ac9b91640b484b6a52dcba9d9fc8f upstream.

Currently after any algorithm is registered and tested, there's an
unnecessary request_module("cryptomgr") even if it's already loaded.
Also, CRYPTO_MSG_ALG_LOADED is sent twice, and thus if the algorithm is
"crct10dif", lib/crc-t10dif.c replaces the tfm twice rather than once.

This occurs because CRYPTO_MSG_ALG_LOADED is sent using
crypto_probing_notify(), which tries to load "cryptomgr" if the
notification is not handled (NOTIFY_DONE).  This doesn't make sense
because "cryptomgr" doesn't handle this notification.

Fix this by using crypto_notify() instead of crypto_probing_notify().

Fixes: dd8b083f9a5e ("crypto: api - Introduce notifier for new crypto algorithms")
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algapi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -403,7 +403,7 @@ static void crypto_wait_for_test(struct
 	err = wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
 	if (!err)
-		crypto_probing_notify(CRYPTO_MSG_ALG_LOADED, larval);
+		crypto_notify(CRYPTO_MSG_ALG_LOADED, larval);
 
 out:
 	crypto_larval_kill(&larval->alg);


