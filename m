Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC01880E4
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgCQLOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgCQLOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:14:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FCC6205ED;
        Tue, 17 Mar 2020 11:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443657;
        bh=tF9zsP7B3zGjsnfoe0PRK5il9/3ztDtkXTIf9uhMMb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USJkCpEbz9732f/t9GWzxf2rign0ur+SulHmuO3ZoE1at2NnldK81/u2f6C7YTONL
         8fH73pDyLLlNHDkw0EmxSJGqWw40UaZLbEElHTCs2EiM22HTQUuRFFQn0smlcejFa6
         uIu9IaLpQDZ/jIkLTdWJfe6Swqpszt1Rfr9qRS2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 140/151] netfilter: nf_tables: free flowtable hooks on hook register error
Date:   Tue, 17 Mar 2020 11:55:50 +0100
Message-Id: <20200317103336.356029744@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 2d285f26ecd072800a29c5b71e63437f21ef830a upstream.

If hook registration fails, the hooks allocated via nft_netdev_hook_alloc
need to be freed.

We can't change the goto label to 'goto 5' -- while it does fix the memleak
it does cause a warning splat from the netfilter core (the hooks were not
registered).

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Reported-by: syzbot+a2ff6fa45162a5ed4dd3@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_api.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6172,8 +6172,13 @@ static int nf_tables_newflowtable(struct
 		goto err4;
 
 	err = nft_register_flowtable_net_hooks(ctx.net, table, flowtable);
-	if (err < 0)
+	if (err < 0) {
+		list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
+			list_del_rcu(&hook->list);
+			kfree_rcu(hook, rcu);
+		}
 		goto err4;
+	}
 
 	err = nft_trans_flowtable_add(&ctx, NFT_MSG_NEWFLOWTABLE, flowtable);
 	if (err < 0)


