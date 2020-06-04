Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBF31EEA9A
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 20:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgFDSyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 14:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbgFDSyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 14:54:43 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 516EC206C3;
        Thu,  4 Jun 2020 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591296883;
        bh=B0Ytorsu/91zKD3BZ3pYu9U56refImH31xHXCQKGTdk=;
        h=From:To:Cc:Subject:Date:From;
        b=f9E269jUvQiQv5VrfRptpd2wpoHnvNTSQn4Km2pa3NPWH6MgMEHVHjrmNEuVAWBfD
         93TWp2dE9z1NWeg20cR6gtebfJJDQER6GKIidH7vkLZilfTyCvADKn6HI4AEUUf6AK
         AaCnX/DVNeqUHiTBascLUF1dCUH+oBoY8RmpM4IQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Gerow <gerow@google.com>
Subject: [PATCH] crypto: algboss - don't wait during notifier callback
Date:   Thu,  4 Jun 2020 11:52:53 -0700
Message-Id: <20200604185253.5119-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When a crypto template needs to be instantiated, CRYPTO_MSG_ALG_REQUEST
is sent to crypto_chain.  cryptomgr_schedule_probe() handles this by
starting a thread to instantiate the template, then waiting for this
thread to complete via crypto_larval::completion.

This can deadlock because instantiating the template may require loading
modules, and this (apparently depending on userspace) may need to wait
for the crc-t10dif module (lib/crc-t10dif.c) to be loaded.  But
crc-t10dif's module_init function uses crypto_register_notifier() and
therefore takes crypto_chain.rwsem for write.  That can't proceed until
the notifier callback has finished, as it holds this semaphore for read.

Fix this by removing the wait on crypto_larval::completion from within
cryptomgr_schedule_probe().  It's actually unnecessary because
crypto_alg_mod_lookup() calls crypto_larval_wait() itself after sending
CRYPTO_MSG_ALG_REQUEST.

This only actually became a problem in v4.20 due to commit b76377543b73
("crc-t10dif: Pick better transform if one becomes available"), but the
unnecessary wait was much older.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207159
Reported-by: Mike Gerow <gerow@google.com>
Fixes: 398710379f51 ("crypto: algapi - Move larval completion into algboss")
Cc: <stable@vger.kernel.org> # v3.6+
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algboss.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 535f1f87e6c1..5ebccbd6b74e 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -178,8 +178,6 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 	if (IS_ERR(thread))
 		goto err_put_larval;
 
-	wait_for_completion_interruptible(&larval->completion);
-
 	return NOTIFY_STOP;
 
 err_put_larval:
-- 
2.27.0.rc2.251.g90737beb825-goog

