Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32EF27C453
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgI2LNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgI2LMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:12:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DA9120848;
        Tue, 29 Sep 2020 11:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377963;
        bh=Wubh1/an2GrwMUL1dHNmyv0XO1Vj8IER5x5XkGGuNeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijANW8ulYsItJboligV4JDJR5LvCdbFmXBEYJqFdW0N65SjVqIvisXua2+fFo5dDC
         lfeyhkk5QVxYerUwIqqrGkmCEqPZ/z9YSu2WVKgqKqd1K+QTYf/Suo44b19zUcqw7X
         U/xSlN3TB5WIJNPB++pMi+3j8Do2xaCQevvrKFkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 014/166] net: add __must_check to skb_put_padto()
Date:   Tue, 29 Sep 2020 12:58:46 +0200
Message-Id: <20200929105935.900251428@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
@@ -2999,8 +2999,9 @@ static inline int skb_padto(struct sk_bu
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
 
@@ -3023,7 +3024,7 @@ static inline int __skb_put_padto(struct
  *	is untouched. Otherwise it is extended. Returns zero on
  *	success. The skb is freed on error.
  */
-static inline int skb_put_padto(struct sk_buff *skb, unsigned int len)
+static inline int __must_check skb_put_padto(struct sk_buff *skb, unsigned int len)
 {
 	return __skb_put_padto(skb, len, true);
 }


