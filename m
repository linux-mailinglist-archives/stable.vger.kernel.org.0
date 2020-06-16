Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0655D1FB780
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgFPPqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732230AbgFPPqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D223E214DB;
        Tue, 16 Jun 2020 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322412;
        bh=cB0xYbRke6CaPhv+2x3VkaVLolCq4Lq7+R793GDpnis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0OkRiPqdZDd5gFvbKo4vhzkEqd+cv+GDFaznmBmOG5Z/wECczI9e+BBFwEzMwCfZ
         faM/el+7CkgEs7i1C+g42wWl/oBLtOfn7k1e02kR+0EP34ca/9i2kSfkOapz+GjHug
         xybbWDVTCzFwQpp73JA2xBRJxr2fA5HuhNkTtvpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.7 091/163] crypto: algapi - Avoid spurious modprobe on LOADED
Date:   Tue, 16 Jun 2020 17:34:25 +0200
Message-Id: <20200616153111.195011314@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
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


