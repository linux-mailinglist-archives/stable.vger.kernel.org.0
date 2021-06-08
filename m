Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A853A033A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbhFHTOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235925AbhFHTMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3AB06194A;
        Tue,  8 Jun 2021 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178157;
        bh=CAnlmVg2OB/1ByO4Wsm94f5zmagty4A3TeD/u65t30k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfxGsNcA0Yx/5iFUu0noBiaalewnb6Y3ehEKq4lqN1lw+B4g61kNjn/vIugj0hCxg
         wlVlwToWI8gh6mY5CTv7yArxpoxrJWp8QMtr1Cp+qAZmlwkkGsH7Gj8ujY36fxAT8+
         t/ys5qJvwvgh0plasweVWwUxGcwzXcZj+ftJzzNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 099/161] wireguard: allowedips: initialize list head in selftest
Date:   Tue,  8 Jun 2021 20:27:09 +0200
Message-Id: <20210608175948.806991696@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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


