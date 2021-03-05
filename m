Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAF732E906
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhCEMaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhCEM3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:29:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 412C965019;
        Fri,  5 Mar 2021 12:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947384;
        bh=oq5lFA/D4SMpasVjtdcT153xdMXfnB079y5PiHu9hX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZF2QEKBIxaf53vPWGOW41irONX1RfujafVVRK3qpOlNyzABnazbOl73cKIUkUCIB0
         nk9+3gpLMH2EXPvNpjZj/idRWJWVJKgD6Z66oDyZv+AJmEfRX6ojnetidlFlFSmU9W
         ZMd33dMv0ttR354894Vagl+wamdugJ4tIRr5yspc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Marco Elver <elver@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 016/102] net: fix up truesize of cloned skb in skb_prepare_for_shift()
Date:   Fri,  5 Mar 2021 13:20:35 +0100
Message-Id: <20210305120904.073334915@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
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
@@ -3285,7 +3285,19 @@ EXPORT_SYMBOL(skb_split);
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


