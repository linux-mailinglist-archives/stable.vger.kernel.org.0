Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52181A06F5
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 08:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgDGGEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 02:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgDGGEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 02:04:14 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A1D72051A;
        Tue,  7 Apr 2020 06:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586239453;
        bh=cESVjNv8wDERqvJRgrWmpES3qp0fDrI8i1y53OkBYME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPMDrS76dTeN3ibl4UBkEAH9iQzmcoFewH0QZtcCPI3A0TBk1bHgrH0ddnwZoGoYZ
         JsY+QUGXwlA5jHXrf/wmYPzzAF4yFEfBp6BdReDfG/UQ5FzexdbWkyr3eQ7sCr05DI
         3re4wuLS45eiicgrcvZWTats1nCxHEEIWlYXB30A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] crypto: algapi - Avoid spurious modprobe on LOADED
Date:   Mon,  6 Apr 2020 23:02:40 -0700
Message-Id: <20200407060240.175837-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407051744.GA13037@gondor.apana.org.au>
References: <20200407051744.GA13037@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
---
 crypto/algapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 69605e21af92..849254d7e627 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -403,7 +403,7 @@ static void crypto_wait_for_test(struct crypto_larval *larval)
 	err = wait_for_completion_killable(&larval->completion);
 	WARN_ON(err);
 	if (!err)
-		crypto_probing_notify(CRYPTO_MSG_ALG_LOADED, larval);
+		crypto_notify(CRYPTO_MSG_ALG_LOADED, larval);
 
 out:
 	crypto_larval_kill(&larval->alg);
-- 
2.26.0

