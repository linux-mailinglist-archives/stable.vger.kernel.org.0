Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177AA6247D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387429AbfGHPnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388344AbfGHPYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:24:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5314221743;
        Mon,  8 Jul 2019 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599462;
        bh=XQyksg6BQprAUNPQBRwXdMzPOwjy+Jls0OH6AIq2J9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbJ6+HI8mtVam6hkveGTsj0eg24KyQ7n7y5oVdwjpRjzP/VLrbodw2OHHJ9meT6IQ
         VjhideNPWKJRWpfkQus8NWmlURjdAQTx0jd69167ci9M3U0U7cTtqLBnaTt2wIurdX
         fOIyyYu/xcLFxNGRgVmpMmX4Ls+zClvsCvFdOj8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14 24/56] crypto: user - prevent operating on larval algorithms
Date:   Mon,  8 Jul 2019 17:13:16 +0200
Message-Id: <20190708150521.596980733@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150514.376317156@linuxfoundation.org>
References: <20190708150514.376317156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 21d4120ec6f5b5992b01b96ac484701163917b63 upstream.

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/crypto_user.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -55,6 +55,9 @@ static struct crypto_alg *crypto_alg_mat
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		int match = 0;
 
+		if (crypto_is_larval(q))
+			continue;
+
 		if ((q->cra_flags ^ p->cru_type) & p->cru_mask)
 			continue;
 


