Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C1027C391
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgI2LHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728552AbgI2LHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:07:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F1FE21941;
        Tue, 29 Sep 2020 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377619;
        bh=Id1n6rf2mWSjm9sPa5X++geLufjs9SgNuL3/iStXyaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VR14s7OmYADZZ7vqByfU96H/327enHGIEd+ns/tipNtiorjjYe3Z8dBq+35uYa8F7
         L3jzcAUHawSBoNmn9LeTIaVeuKdhmixgVxDytQeu+GZC5I37O6uo/FAQjaX3m1K/ke
         pJGpiE8CerWB/MOmKNtgE/qRqA7l/Wg5L8wbu5mI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 012/121] net: add __must_check to skb_put_padto()
Date:   Tue, 29 Sep 2020 12:59:16 +0200
Message-Id: <20200929105930.790779331@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
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
 include/linux/skbuff.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2795,7 +2795,7 @@ static inline int skb_padto(struct sk_bu
  *	is untouched. Otherwise it is extended. Returns zero on
  *	success. The skb is freed on error.
  */
-static inline int skb_put_padto(struct sk_buff *skb, unsigned int len)
+static inline int __must_check skb_put_padto(struct sk_buff *skb, unsigned int len)
 {
 	unsigned int size = skb->len;
 


