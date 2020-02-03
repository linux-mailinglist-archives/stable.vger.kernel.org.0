Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDB7150B0D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgBCQU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728541AbgBCQU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:20:26 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD2812086A;
        Mon,  3 Feb 2020 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580746826;
        bh=i4Fj1l9bmgpgllRjXQzyyZlFb6ND9niGu1f2Esom5cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moxwM6LgY+e9fGjsbvvCPj8JWYgP+2ic/Vyj3amfu7FhKPc9WKaoOgRoTAeFrwVtq
         jfF9hgwqDyYnfqFHGRD9zdUFOEPLLfqLn5tu9QUBT2iAKet7NSk67++a5AVg5eOt3Q
         bakIHQgJZWA/TgL+l921NmulYum4UNxmybuTuoLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c2f1558d49e25cc36e5e@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 22/53] crypto: af_alg - Use bh_lock_sock in sk_destruct
Date:   Mon,  3 Feb 2020 16:19:14 +0000
Message-Id: <20200203161907.131942747@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
References: <20200203161902.714326084@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 37f96694cf73ba116993a9d2d99ad6a75fa7fdb0 upstream.

As af_alg_release_parent may be called from BH context (most notably
due to an async request that only completes after socket closure,
or as reported here because of an RCU-delayed sk_destruct call), we
must use bh_lock_sock instead of lock_sock.

Reported-by: syzbot+c2f1558d49e25cc36e5e@syzkaller.appspotmail.com
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c840ac6af3f8 ("crypto: af_alg - Disallow bind/setkey/...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/af_alg.c |    6 ++++--
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


