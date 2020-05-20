Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD93F1DB6EA
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgETO2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:28:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32800 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726868AbgETOWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:23 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-00035L-Vi; Wed, 20 May 2020 15:22:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbu-007DP7-8F; Wed, 20 May 2020 15:22:18 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        syzbot+c2f1558d49e25cc36e5e@syzkaller.appspotmail.com,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 20 May 2020 15:13:44 +0100
Message-ID: <lsq.1589984008.269195898@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 16/99] crypto: af_alg - Use bh_lock_sock in sk_destruct
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 37f96694cf73ba116993a9d2d99ad6a75fa7fdb0 upstream.

As af_alg_release_parent may be called from BH context (most notably
due to an async request that only completes after socket closure,
or as reported here because of an RCU-delayed sk_destruct call), we
must use bh_lock_sock instead of lock_sock.

Reported-by: syzbot+c2f1558d49e25cc36e5e@syzkaller.appspotmail.com
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c840ac6af3f8 ("crypto: af_alg - Disallow bind/setkey/...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/af_alg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -136,11 +136,13 @@ void af_alg_release_parent(struct sock *
 	sk = ask->parent;
 	ask = alg_sk(sk);
 
-	lock_sock(sk);
+	local_bh_disable();
+	bh_lock_sock(sk);
 	ask->nokey_refcnt -= nokey;
 	if (!last)
 		last = !--ask->refcnt;
-	release_sock(sk);
+	bh_unlock_sock(sk);
+	local_bh_enable();
 
 	if (last)
 		sock_put(sk);

