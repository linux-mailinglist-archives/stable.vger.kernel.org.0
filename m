Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1DE73DCE
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391193AbfGXTrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391174AbfGXTrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:47:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79A4921873;
        Wed, 24 Jul 2019 19:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997623;
        bh=K35cIH3EA1Ft8Qi7ysiiVtejwUxQ3ffPih0OJkln8yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7zMo4iT4hdqWX9v/dAw6NhY+dbhe917fQ75R6dbU1GTJUUEq2DW84LIyiBQufbqO
         S+W15RK5ffM82yxYBf5LuIhZCUExfN0L4gv84j+BE1tkwC0BGrzAy3HNK7yo147kYm
         07KmOq65fs2oZvTMfkvO6Q9qU2T4Lk/rrTtOxhcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 088/371] crypto: testmgr - add some more preemption points
Date:   Wed, 24 Jul 2019 21:17:20 +0200
Message-Id: <20190724191731.459718924@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
index 8386038d67c7..51540dbee23b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1050,6 +1050,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 						req, tsgl, hashstate);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1105,6 +1106,7 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		err = test_hash_vec(driver, &vecs[i], i, req, tsgl, hashstate);
 		if (err)
 			goto out;
+		cond_resched();
 	}
 	err = 0;
 out:
@@ -1346,6 +1348,7 @@ static int test_aead_vec(const char *driver, int enc,
 						&cfg, req, tsgls);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1365,6 +1368,7 @@ static int test_aead(const char *driver, int enc,
 				    tsgls);
 		if (err)
 			return err;
+		cond_resched();
 	}
 	return 0;
 }
@@ -1679,6 +1683,7 @@ static int test_skcipher_vec(const char *driver, int enc,
 						    &cfg, req, tsgls);
 			if (err)
 				return err;
+			cond_resched();
 		}
 	}
 #endif
@@ -1698,6 +1703,7 @@ static int test_skcipher(const char *driver, int enc,
 					tsgls);
 		if (err)
 			return err;
+		cond_resched();
 	}
 	return 0;
 }
-- 
2.20.1



