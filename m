Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B335D9F1
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 02:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfGCA6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 20:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfGCA6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 20:58:05 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC2DD20449;
        Tue,  2 Jul 2019 21:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562102286;
        bh=ZncPmqJjQ5p8Nzi6KA3tSryklHFPA1+D6VokdeGHa28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SB5zOgdMv5+0+Y00OB/l2Jsui1egnX0iDRToH0chu73SQDnspeXPnukhhoEmUrnLn
         1J+BRo9A3r/sqHCxARyy5JjA32jtlBzB0ijOU2DU7SGrhcMqqdeMDKnGYa4XxgYNle
         NM7aJFyBE6dbHGDyiqMab5d1sEPNEWHorvFmP4uM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     chetjain@in.ibm.com, "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: user - prevent operating on larval algorithms
Date:   Tue,  2 Jul 2019 14:17:00 -0700
Message-Id: <20190702211700.16526-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190701153154.1569c2dc@kitsune.suse.cz>
References: <20190701153154.1569c2dc@kitsune.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Michal Suchanek reported [1] that running the pcrypt_aead01 test from
LTP [2] in a loop and holding Ctrl-C causes a NULL dereference of
alg->cra_users.next in crypto_remove_spawns(), via crypto_del_alg().
The test repeatedly uses CRYPTO_MSG_NEWALG and CRYPTO_MSG_DELALG.

The crash occurs when the instance that CRYPTO_MSG_DELALG is trying to
unregister isn't a real registered algorithm, but rather is a "test
larval", which is a special "algorithm" added to the algorithms list
while the real algorithm is still being tested.  Larvals don't have
initialized cra_users, so that causes the crash.  Normally pcrypt_aead01
doesn't trigger this because CRYPTO_MSG_NEWALG waits for the algorithm
to be tested; however, CRYPTO_MSG_NEWALG returns early when interrupted.

Everything else in the "crypto user configuration" API has this same bug
too, i.e. it inappropriately allows operating on larval algorithms
(though it doesn't look like the other cases can cause a crash).

Fix this by making crypto_alg_match() exclude larval algorithms.

[1] https://lkml.kernel.org/r/20190625071624.27039-1-msuchanek@suse.de
[2] https://github.com/linux-test-project/ltp/blob/20190517/testcases/kernel/crypto/pcrypt_aead01.c

Reported-by: Michal Suchanek <msuchanek@suse.de>
Fixes: a38f7907b926 ("crypto: Add userspace configuration API")
Cc: <stable@vger.kernel.org> # v3.2+
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crypto_user_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index e48da3b75c71d4..a89fcc530092a8 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -56,6 +56,9 @@ struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		int match = 0;
 
+		if (crypto_is_larval(q))
+			continue;
+
 		if ((q->cra_flags ^ p->cru_type) & p->cru_mask)
 			continue;
 
-- 
2.22.0.410.gd8fdbe21b5-goog

