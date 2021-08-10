Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A1E3E7FB1
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhHJRmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234253AbhHJRkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 372476109F;
        Tue, 10 Aug 2021 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617076;
        bh=R//KGMnHgn3imwAr23wCSUTcCP7r7swND//LrSgLaF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFN9qYgIdnIxIlEi/SAoSi9Zwbqu0Ep1w8jG6aCJTAO9k7X0vSC1fbx4C1rLkZ4Sj
         CSpCnzZPVSKaNJKy7vyOkLW0wP+HLIpz3orYAHS3eRsHYF1j+akmPL5iLXdkAgOuWj
         AVVYcchmKlVoynt6l5bSO/g2ZMpecgG7p41Fb0zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com
Subject: [PATCH 5.10 004/135] net: xfrm: fix memory leak in xfrm_user_rcv_msg
Date:   Tue, 10 Aug 2021 19:28:58 +0200
Message-Id: <20210810172955.821047403@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 7c1a80e80cde008f271bae630d28cf684351e807 ]

Syzbot reported memory leak in xfrm_user_rcv_msg(). The
problem was is non-freed skb's frag_list.

In skb_release_all() skb_release_data() will be called only
in case of skb->head != NULL, but netlink_skb_destructor()
sets head to NULL. So, allocated frag_list skb should be
freed manualy, since consume_skb() won't take care of it

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Reported-and-tested-by: syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 45f86a97eaf2..6f97665b632e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2751,6 +2751,16 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	err = link->doit(skb, nlh, attrs);
 
+	/* We need to free skb allocated in xfrm_alloc_compat() before
+	 * returning from this function, because consume_skb() won't take
+	 * care of frag_list since netlink destructor sets
+	 * sbk->head to NULL. (see netlink_skb_destructor())
+	 */
+	if (skb_has_frag_list(skb)) {
+		kfree_skb(skb_shinfo(skb)->frag_list);
+		skb_shinfo(skb)->frag_list = NULL;
+	}
+
 err:
 	kvfree(nlh64);
 	return err;
-- 
2.30.2



