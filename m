Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633553A021D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbhFHTB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237128AbhFHS5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1D6961622;
        Tue,  8 Jun 2021 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177746;
        bh=CAnlmVg2OB/1ByO4Wsm94f5zmagty4A3TeD/u65t30k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JF8wI4yY7xETEez5DSUV9kEVGPXq/eWEVSnKFx6z9M/UUOYiWSQJrt4MaXtFUrGOk
         LpCgWEl7skgVTp7SHT9ODmSazjg0wYTjApyluJBkcaMl3WHa4m3P4mPLQszMJWtohK
         5POyJ9Dw7OV4GuvUCMNXgL3txD2+Vurmd1kLgcxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 085/137] wireguard: allowedips: initialize list head in selftest
Date:   Tue,  8 Jun 2021 20:27:05 +0200
Message-Id: <20210608175945.242677364@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 46cfe8eee285cde465b420637507884551f5d7ca upstream.

The randomized trie tests weren't initializing the dummy peer list head,
resulting in a NULL pointer dereference when used. Fix this by
initializing it in the randomized trie test, just like we do for the
static unit test.

While we're at it, all of the other strings like this have the word
"self-test", so add it to the missing place here.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/selftest/allowedips.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireguard/selftest/allowedips.c
+++ b/drivers/net/wireguard/selftest/allowedips.c
@@ -296,6 +296,7 @@ static __init bool randomized_test(void)
 			goto free;
 		}
 		kref_init(&peers[i]->refcount);
+		INIT_LIST_HEAD(&peers[i]->allowedips_list);
 	}
 
 	mutex_lock(&mutex);
@@ -333,7 +334,7 @@ static __init bool randomized_test(void)
 			if (wg_allowedips_insert_v4(&t,
 						    (struct in_addr *)mutated,
 						    cidr, peer, &mutex) < 0) {
-				pr_err("allowedips random malloc: FAIL\n");
+				pr_err("allowedips random self-test malloc: FAIL\n");
 				goto free_locked;
 			}
 			if (horrible_allowedips_insert_v4(&h,


