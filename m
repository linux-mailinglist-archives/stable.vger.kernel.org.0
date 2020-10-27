Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A17D29B14A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759276AbgJ0O2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759271AbgJ0O2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:28:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1701206DC;
        Tue, 27 Oct 2020 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808923;
        bh=Noym+lf8cZ47Ly+mv+s8DXWgLUwSiQZUDXTZQt2zu7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LD8xjM+A8gbe1dPr7MkEvVK3E3rJG/AY6kwbJxhB/kaL4y5FGsBL9jp5lj/Uk+lDd
         y/P+7uys2JnI6+/3teUYabxvZG7BtNglUatIGYb/JnUkJHMWvzBldoNuRR3evCOuts
         kvLdztFP/l9a/Mxq4+/iXgjq60WkNsbyCSKuG+jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com
Subject: [PATCH 5.4 011/408] tipc: fix the skb_unshare() in tipc_buf_append()
Date:   Tue, 27 Oct 2020 14:49:09 +0100
Message-Id: <20201027135455.577087822@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit ed42989eab57d619667d7e87dfbd8fe207db54fe ]

skb_unshare() drops a reference count on the old skb unconditionally,
so in the failure case, we end up freeing the skb twice here.
And because the skb is allocated in fclone and cloned by caller
tipc_msg_reassemble(), the consequence is actually freeing the
original skb too, thus triggered the UAF by syzbot.

Fix this by replacing this skb_unshare() with skb_cloned()+skb_copy().

Fixes: ff48b6222e65 ("tipc: use skb_unshare() instead in tipc_buf_append()")
Reported-and-tested-by: syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/msg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -140,7 +140,8 @@ int tipc_buf_append(struct sk_buff **hea
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		frag = skb_unshare(frag, GFP_ATOMIC);
+		if (skb_cloned(frag))
+			frag = skb_copy(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;


