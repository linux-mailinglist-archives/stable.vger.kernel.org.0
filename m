Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144F71579E1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbgBJNSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728934AbgBJMhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:52 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F33320838;
        Mon, 10 Feb 2020 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338272;
        bh=J/lmHUViGli8bjSqncoe3JiPGp6T358jYaUDRNV9w+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPj+Wj4keBcxM2nK40QKRD8R24s+GmFMbu+SGDHV/CPqEWlJWXudN+CgLFwpJoPM/
         u03K2M3fcXWETgGqIMCVioT5YhXak7Ww4CF4nLVcpxnRY68UXDCm9XP9Z2lZ93ULDm
         /G4aol5fOn3DwbJZfVegXJMRT8ChyZnSZUrjI2zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 155/309] crypto: api - fix unexpectedly getting generic implementation
Date:   Mon, 10 Feb 2020 04:31:51 -0800
Message-Id: <20200210122421.126373787@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 2bbb3375d967155bccc86a5887d4a6e29c56b683 upstream.

When CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, the first lookup of an
algorithm that needs to be instantiated using a template will always get
the generic implementation, even when an accelerated one is available.

This happens because the extra self-tests for the accelerated
implementation allocate the generic implementation for comparison
purposes, and then crypto_alg_tested() for the generic implementation
"fulfills" the original request (i.e. sets crypto_larval::adult).

This patch fixes this by only fulfilling the original request if
we are currently the best outstanding larval as judged by the
priority.  If we're not the best then we will ask all waiters on
that larval request to retry the lookup.

Note that this patch introduces a behaviour change when the module
providing the new algorithm is unregistered during the process.
Previously we would have failed with ENOENT, after the patch we
will instead redo the lookup.

Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against...")
Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against...")
Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against...")
Reported-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algapi.c |   24 +++++++++++++++++++++---
 crypto/api.c    |    4 +++-
 2 files changed, 24 insertions(+), 4 deletions(-)

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -257,6 +257,7 @@ void crypto_alg_tested(const char *name,
 	struct crypto_alg *alg;
 	struct crypto_alg *q;
 	LIST_HEAD(list);
+	bool best;
 
 	down_write(&crypto_alg_sem);
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
@@ -280,6 +281,21 @@ found:
 
 	alg->cra_flags |= CRYPTO_ALG_TESTED;
 
+	/* Only satisfy larval waiters if we are the best. */
+	best = true;
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		if (crypto_is_moribund(q) || !crypto_is_larval(q))
+			continue;
+
+		if (strcmp(alg->cra_name, q->cra_name))
+			continue;
+
+		if (q->cra_priority > alg->cra_priority) {
+			best = false;
+			break;
+		}
+	}
+
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		if (q == alg)
 			continue;
@@ -303,10 +319,12 @@ found:
 				continue;
 			if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
 				continue;
-			if (!crypto_mod_get(alg))
-				continue;
 
-			larval->adult = alg;
+			if (best && crypto_mod_get(alg))
+				larval->adult = alg;
+			else
+				larval->adult = ERR_PTR(-EAGAIN);
+
 			continue;
 		}
 
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -97,7 +97,7 @@ static void crypto_larval_destroy(struct
 	struct crypto_larval *larval = (void *)alg;
 
 	BUG_ON(!crypto_is_larval(alg));
-	if (larval->adult)
+	if (!IS_ERR_OR_NULL(larval->adult))
 		crypto_mod_put(larval->adult);
 	kfree(larval);
 }
@@ -178,6 +178,8 @@ static struct crypto_alg *crypto_larval_
 		alg = ERR_PTR(-ETIMEDOUT);
 	else if (!alg)
 		alg = ERR_PTR(-ENOENT);
+	else if (IS_ERR(alg))
+		;
 	else if (crypto_is_test_larval(larval) &&
 		 !(alg->cra_flags & CRYPTO_ALG_TESTED))
 		alg = ERR_PTR(-EAGAIN);


