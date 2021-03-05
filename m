Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BEF32EB44
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhCEMnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:43:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhCEMmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:42:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 110A46501F;
        Fri,  5 Mar 2021 12:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614948166;
        bh=Z9qREOSIzMhQPTuqF3NRq5oBloErHn22rIbf1nsD0kY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlcuAxHkC7xelKMaFrx+SZhIZyLrHvHfu00ZWO0pok63t4EdZLY83yG9UbK10fSoU
         kG693+zxNi5RlqZ6T28X2W1lhXA4em+PkDVAqH+sOlGN3OAnj4yh3Y9bFz7pj9tX/8
         AbbBP0mTihFQtXYR8QOcP/XJNP/tMpker1Zl0ez8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Marco Elver <elver@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 10/30] net: fix up truesize of cloned skb in skb_prepare_for_shift()
Date:   Fri,  5 Mar 2021 13:22:39 +0100
Message-Id: <20210305120849.909910163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120849.381261651@linuxfoundation.org>
References: <20210305120849.381261651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 097b9146c0e26aabaa6ff3e5ea536a53f5254a79 upstream.

Avoid the assumption that ksize(kmalloc(S)) == ksize(kmalloc(S)): when
cloning an skb, save and restore truesize after pskb_expand_head(). This
can occur if the allocator decides to service an allocation of the same
size differently (e.g. use a different size class, or pass the
allocation on to KFENCE).

Because truesize is used for bookkeeping (such as sk_wmem_queued), a
modified truesize of a cloned skb may result in corrupt bookkeeping and
relevant warnings (such as in sk_stream_kill_queues()).

Link: https://lkml.kernel.org/r/X9JR/J6dMMOy1obu@elver.google.com
Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210201160420.2826895-1-elver@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2628,7 +2628,19 @@ EXPORT_SYMBOL(skb_split);
  */
 static int skb_prepare_for_shift(struct sk_buff *skb)
 {
-	return skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
+	int ret = 0;
+
+	if (skb_cloned(skb)) {
+		/* Save and restore truesize: pskb_expand_head() may reallocate
+		 * memory where ksize(kmalloc(S)) != ksize(kmalloc(S)), but we
+		 * cannot change truesize at this point.
+		 */
+		unsigned int save_truesize = skb->truesize;
+
+		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
+		skb->truesize = save_truesize;
+	}
+	return ret;
 }
 
 /**


