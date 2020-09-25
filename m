Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34F2788B6
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgIYM5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729154AbgIYMvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B2EC206DB;
        Fri, 25 Sep 2020 12:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038266;
        bh=0Tmpdw6N71PRbb7aCXjelqKZtzWw3UqqAEr+hFpvGTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1S1z6pLA73Lo1s/Mnm5kNcb3JtX2YglXry8Zcl8Z6WWJtLKSiXBvsRKmXZxMFa0DI
         jfY4oQjp6yQOcoycPJyh6qYCFQHrqrKEe09v9bWeoTfxpwDzxnxX0aKvmCF/Kp3ePM
         k8RmNQga/jo+Fwc79rpLNC3IBYOojad8vYVme0z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 42/56] net: add __must_check to skb_put_padto()
Date:   Fri, 25 Sep 2020 14:48:32 +0200
Message-Id: <20200925124734.168669943@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
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
@@ -3208,8 +3208,9 @@ static inline int skb_padto(struct sk_bu
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
 
@@ -3232,7 +3233,7 @@ static inline int __skb_put_padto(struct
  *	is untouched. Otherwise it is extended. Returns zero on
  *	success. The skb is freed on error.
  */
-static inline int skb_put_padto(struct sk_buff *skb, unsigned int len)
+static inline int __must_check skb_put_padto(struct sk_buff *skb, unsigned int len)
 {
 	return __skb_put_padto(skb, len, true);
 }


