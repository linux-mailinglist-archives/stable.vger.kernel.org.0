Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C00C916A
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfJBTIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35840 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729309AbfJBTIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:16 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyt-00035t-SP; Wed, 02 Oct 2019 20:08:12 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyq-0003hN-UQ; Wed, 02 Oct 2019 20:08:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Michal Suchanek" <msuchanek@suse.de>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Eric Biggers" <ebiggers@google.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.444788492@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 87/87] crypto: user - prevent operating on larval
 algorithms
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/crypto_user.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -53,6 +53,9 @@ static struct crypto_alg *crypto_alg_mat
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
 		int match = 0;
 
+		if (crypto_is_larval(q))
+			continue;
+
 		if ((q->cra_flags ^ p->cru_type) & p->cru_mask)
 			continue;
 

