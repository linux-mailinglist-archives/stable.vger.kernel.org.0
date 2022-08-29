Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799E85A4859
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiH2LJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiH2LId (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:08:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCB86527E;
        Mon, 29 Aug 2022 04:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17E35B80F10;
        Mon, 29 Aug 2022 11:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75156C433C1;
        Mon, 29 Aug 2022 11:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771063;
        bh=g4os0/ez26nrauGumgFQEHoy+Q8e4jwx5m8oNhza+Lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/Bqmj6bhOLYopsz0AbL8bWz5foTlyKB331h8V+QWc+rljkwD9mXocMa2sAgJFFbA
         dwTgO5g6R5FlxXbSs42RL184zno0JGnk+rgY5bSdtFX/h6/2QFK8ixLuZR9MqkhaxL
         0G1mh4bten/FqKCzbM30rQNTjNrmY9Ymx4PTHxYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Shah <abhishek.shah@columbia.edu>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/136] netfilter: nf_tables: make table handle allocation per-netns friendly
Date:   Mon, 29 Aug 2022 12:58:43 +0200
Message-Id: <20220829105806.923199963@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ab482c6b66a4a8c0a8c0b0f577a785cf9ff1c2e2 ]

mutex is per-netns, move table_netns to the pernet area.

*read-write* to 0xffffffff883a01e8 of 8 bytes by task 6542 on cpu 0:
 nf_tables_newtable+0x6dc/0xc00 net/netfilter/nf_tables_api.c:1221
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0xa6a/0x13a0 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x652/0x730 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x643/0x740 net/netlink/af_netlink.c:1921

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 1 +
 net/netfilter/nf_tables_api.c     | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f56a1071c0052..af4d9f1049528 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1595,6 +1595,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	u64			table_handle;
 	unsigned int		base_seq;
 	u8			validate_state;
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58f9513bd1419..96903c72ebb45 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -32,7 +32,6 @@ static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
 static LIST_HEAD(nf_tables_destroy_list);
 static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
-static u64 table_handle;
 
 enum {
 	NFT_VALIDATE_SKIP	= 0,
@@ -1156,7 +1155,7 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	INIT_LIST_HEAD(&table->flowtables);
 	table->family = family;
 	table->flags = flags;
-	table->handle = ++table_handle;
+	table->handle = ++nft_net->table_handle;
 	if (table->flags & NFT_TABLE_F_OWNER)
 		table->nlpid = NETLINK_CB(skb).portid;
 
-- 
2.35.1



