Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402E5697B1
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbfGONwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732248AbfGONwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:52:42 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A1BD206B8;
        Mon, 15 Jul 2019 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198761;
        bh=dbZ9UkTc8jQ7thfAA7TdTEU2rDgk8mjNAe28LtjKQ68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYvdasqGPDKX13yqgjBtK13rhhxyYSAac4dMWe6xc83Waw5zi3z7hG/Zs3UbG/NP5
         yf8XRzjJuhoLjMHh/bnu/4IKjKPE85hGNtIoCNu2QL35wVI7edPc9rMYBlPYqKah4P
         JIDRtDJgOA0NM21K6olNtW3mjLOnebQmLcTy9eWk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 098/249] crypto: testmgr - add some more preemption points
Date:   Mon, 15 Jul 2019 09:44:23 -0400
Message-Id: <20190715134655.4076-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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

