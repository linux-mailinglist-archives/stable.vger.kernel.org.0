Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96A4773F9C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfGXT1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbfGXT1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:27:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6BB9229F4;
        Wed, 24 Jul 2019 19:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996434;
        bh=oykOg457b4MOi6oKg3nWwv2kHjXazVRNX17Xw5Z9xuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHBwpB5DIWnuS5reWdBkUNz0UwIYj8oTifuMYFgMKsCvXCNX/VwhGOwrPHoqmM1Cm
         lMPXiDEzPh0u9qyhcXo1vwslo8I20uXrpvicgfuPOmmh2nzNNFkZK5ooYtynhDNEZZ
         bQFUwX8YoUiOnbeHUhZh1bXCSEBjRiB/XwChqmak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 095/413] crypto: testmgr - add some more preemption points
Date:   Wed, 24 Jul 2019 21:16:26 +0200
Message-Id: <20190724191741.831988026@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e63e1b0dd0003dc31f73d875907432be3a2abe5d ]

Call cond_resched() after each fuzz test iteration.  This avoids stall
warnings if fuzz_iterations is set very high for testing purposes.

While we're at it, also call cond_resched() after finishing testing each
test vector.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 658a7eeebab2..292d28caf00f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1279,6 +1279,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 						req, tsgl, hashstate);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1493,6 +1494,7 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		err = test_hash_vec(driver, &vecs[i], i, req, tsgl, hashstate);
 		if (err)
 			goto out;
+		cond_resched();
 	}
 	err = test_hash_vs_generic_impl(driver, generic_driver, maxkeysize, req,
 					tsgl, hashstate);
@@ -1755,6 +1757,7 @@ static int test_aead_vec(const char *driver, int enc,
 						&cfg, req, tsgls);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1994,6 +1997,7 @@ static int test_aead(const char *driver, int enc,
 				    tsgls);
 		if (err)
 			return err;
+		cond_resched();
 	}
 	return 0;
 }
@@ -2336,6 +2340,7 @@ static int test_skcipher_vec(const char *driver, int enc,
 						    &cfg, req, tsgls);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -2535,6 +2540,7 @@ static int test_skcipher(const char *driver, int enc,
 					tsgls);
 		if (err)
 			return err;
+		cond_resched();
 	}
 	return 0;
 }
-- 
2.20.1



