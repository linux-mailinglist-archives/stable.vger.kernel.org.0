Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E9B43A22A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhJYTpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237419AbhJYTnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E007A603E7;
        Mon, 25 Oct 2021 19:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190670;
        bh=O6RKhaHCpbPbq6neyxwN8pIl6QLp43Csy0OudiyRjb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SL3dxTSG8LydfNa8XOe5nWmXUtoVvL3MqHAlXEd9JPkKwPBMvXyCHQCbIe2kQ/KUf
         +2WXq10ofXgZZH3ZghzpotjuJJIOe9/OPjLGBnKtfVY1gUmUlxhJOVqhmB5XWte8xk
         YGoTfwGGu/z4jBpanRDUCiOYmy+7w0++WDup3qFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
Subject: [PATCH 5.14 025/169] netfilter: nf_tables: skip netdev events generated on netns removal
Date:   Mon, 25 Oct 2021 21:13:26 +0200
Message-Id: <20211025191021.006572464@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 68a3765c659f809dcaac20030853a054646eb739 ]

syzbot reported following (harmless) WARN:

 WARNING: CPU: 1 PID: 2648 at net/netfilter/core.c:468
  nft_netdev_unregister_hooks net/netfilter/nf_tables_api.c:230 [inline]
  nf_tables_unregister_hook include/net/netfilter/nf_tables.h:1090 [inline]
  __nft_release_basechain+0x138/0x640 net/netfilter/nf_tables_api.c:9524
  nft_netdev_event net/netfilter/nft_chain_filter.c:351 [inline]
  nf_tables_netdev_event+0x521/0x8a0 net/netfilter/nft_chain_filter.c:382

reproducer:
unshare -n bash -c 'ip link add br0 type bridge; nft add table netdev t ; \
 nft add chain netdev t ingress \{ type filter hook ingress device "br0" \
 priority 0\; policy drop\; \}'

Problem is that when netns device exit hooks create the UNREGISTER
event, the .pre_exit hook for nf_tables core has already removed the
base hook.  Notifier attempts to do this again.

The need to do base hook unregister unconditionally was needed in the past,
because notifier was last stage where reg->dev dereference was safe.

Now that nf_tables does the hook removal in .pre_exit, this isn't
needed anymore.

Reported-and-tested-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com
Fixes: 767d1216bff825 ("netfilter: nftables: fix possible UAF over chains from packet path in netns")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_chain_filter.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 5b02408a920b..3ced0eb6b7c3 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -342,12 +342,6 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		return;
 	}
 
-	/* UNREGISTER events are also happening on netns exit.
-	 *
-	 * Although nf_tables core releases all tables/chains, only this event
-	 * handler provides guarantee that hook->ops.dev is still accessible,
-	 * so we cannot skip exiting net namespaces.
-	 */
 	__nft_release_basechain(ctx);
 }
 
@@ -366,6 +360,9 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
+	if (!check_net(ctx.net))
+		return NOTIFY_DONE;
+
 	nft_net = nft_pernet(ctx.net);
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
-- 
2.33.0



