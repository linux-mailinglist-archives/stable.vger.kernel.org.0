Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7471A300627
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbhAVOxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbhAVOXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF2AA23B88;
        Fri, 22 Jan 2021 14:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325081;
        bh=o/eurK4c6tuXNbBi3YWhTOliawOpWz+i9hcPPayYzGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qqfn5z/jQ8CMzhfcg9oh3yThij77D0pdIDpQiSJyglBLfijy6PzQGD0E3fP/V+PBN
         MspR+wlLKkXwPV8sHEN9amIoOV2xQri+li8pj8bAodAiJGZ8QvI6nKpsf8HKtZv+8B
         GGaCVDaN6UypQFgES2U8KbDYC75Y2ldru5U1wQ9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 15/33] net: skbuff: disambiguate argument and member for skb_list_walk_safe helper
Date:   Fri, 22 Jan 2021 15:12:31 +0100
Message-Id: <20210122135734.198767015@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 5eee7bd7e245914e4e050c413dfe864e31805207 upstream.

This worked before, because we made all callers name their next pointer
"next". But in trying to be more "drop-in" ready, the silliness here is
revealed. This commit fixes the problem by making the macro argument and
the member use different names.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1481,9 +1481,9 @@ static inline void skb_mark_not_on_list(
 }
 
 /* Iterate through singly-linked GSO fragments of an skb. */
-#define skb_list_walk_safe(first, skb, next)                                   \
-	for ((skb) = (first), (next) = (skb) ? (skb)->next : NULL; (skb);      \
-	     (skb) = (next), (next) = (skb) ? (skb)->next : NULL)
+#define skb_list_walk_safe(first, skb, next_skb)                               \
+	for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
+	     (skb) = (next_skb), (next_skb) = (skb) ? (skb)->next : NULL)
 
 static inline void skb_list_del_init(struct sk_buff *skb)
 {


