Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD11E61713
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfGGTpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:45:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57126 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727529AbfGGTiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:06 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz4-0006g3-9v; Sun, 07 Jul 2019 20:38:02 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz2-0005Zk-Vp; Sun, 07 Jul 2019 20:38:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Eric Biggers" <ebiggers@google.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.77341541@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 043/129] crypto: testmgr - skip crc32c context test
 for ahash algorithms
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit eb5e6730db98fcc4b51148b4a819fa4bf864ae54 upstream.

Instantiating "cryptd(crc32c)" causes a crypto self-test failure because
the crypto_alloc_shash() in alg_test_crc32c() fails.  This is because
cryptd(crc32c) is an ahash algorithm, not a shash algorithm; so it can
only be accessed through the ahash API, unlike shash algorithms which
can be accessed through both the ahash and shash APIs.

As the test is testing the shash descriptor format which is only
applicable to shash algorithms, skip it for ahash algorithms.

(Note that it's still important to fix crypto self-test failures even
 for weird algorithm instantiations like cryptd(crc32c) that no one
 would really use; in fips_enabled mode unprivileged users can use them
 to panic the kernel, and also they prevent treating a crypto self-test
 failure as a bug when fuzzing the kernel.)

Fixes: 8e3ee85e68c5 ("crypto: crc32c - Test descriptor context format")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/testmgr.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1655,14 +1655,21 @@ static int alg_test_crc32c(const struct
 
 	err = alg_test_hash(desc, driver, type, mask);
 	if (err)
-		goto out;
+		return err;
 
 	tfm = crypto_alloc_shash(driver, type, mask);
 	if (IS_ERR(tfm)) {
+		if (PTR_ERR(tfm) == -ENOENT) {
+			/*
+			 * This crc32c implementation is only available through
+			 * ahash API, not the shash API, so the remaining part
+			 * of the test is not applicable to it.
+			 */
+			return 0;
+		}
 		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
-		err = PTR_ERR(tfm);
-		goto out;
+		return PTR_ERR(tfm);
 	}
 
 	do {
@@ -1691,7 +1698,6 @@ static int alg_test_crc32c(const struct
 
 	crypto_free_shash(tfm);
 
-out:
 	return err;
 }
 

