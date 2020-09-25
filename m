Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DD2278884
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgIYMyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgIYMyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:54:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D1B2072E;
        Fri, 25 Sep 2020 12:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038447;
        bh=delpviO4pXh2YsWXBUFYRjSsf2CZCAW+dQcpg3WDQos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gi7y9VhZ7Vc3fgt9ylD5gDsPqv4JfGs6FZMi3Jxob2BtAghliCMApLPOfX34Dr0U5
         O+yDHXQ8CSX+PtERmpR5ZZmKpd4+ppwQh6fC0djp4kkfEBVI7uhBpUOU0aGbI6rWck
         UmRvjtKUoIpR3wViCiFMwl4FsZQEyhIXZwFfqjhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 22/37] net: add __must_check to skb_put_padto()
Date:   Fri, 25 Sep 2020 14:48:50 +0200
Message-Id: <20200925124724.288529564@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124720.972208530@linuxfoundation.org>
References: <20200925124720.972208530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4a009cb04aeca0de60b73f37b102573354214b52 ]

skb_put_padto() and __skb_put_padto() callers
must check return values or risk use-after-free.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3014,8 +3014,9 @@ static inline int skb_padto(struct sk_bu
  *	is untouched. Otherwise it is extended. Returns zero on
  *	success. The skb is freed on error if @free_on_error is true.
  */
-static inline int __skb_put_padto(struct sk_buff *skb, unsigned int len,
-				  bool free_on_error)
+static inline int __must_check __skb_put_padto(struct sk_buff *skb,
+					       unsigned int len,
+					       bool free_on_error)
 {
 	unsigned int size = skb->len;
 
@@ -3038,7 +3039,7 @@ static inline int __skb_put_padto(struct
  *	is untouched. Otherwise it is extended. Returns zero on
  *	success. The skb is freed on error.
  */
-static inline int skb_put_padto(struct sk_buff *skb, unsigned int len)
+static inline int __must_check skb_put_padto(struct sk_buff *skb, unsigned int len)
 {
 	return __skb_put_padto(skb, len, true);
 }


