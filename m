Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45E15B7030
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbiIMOUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiIMOSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:18:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF9B6524E;
        Tue, 13 Sep 2022 07:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F266614AA;
        Tue, 13 Sep 2022 14:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A3EC433D6;
        Tue, 13 Sep 2022 14:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078414;
        bh=2ti9X9WwjDTAkBSwh1iUUYgN/hHlj9kXUbxKVV83/9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+m8ELjEaGozFMmpZ2UzNDGJHnsw4sDmMt0NqNvxJZ3ZFeVmv46VIVyLXVSN+PEXv
         HUiNLlYjQfRWEK6mLJ3PYPep+PyRyEgM3LKCjVpYOII0udCw/QBBGRoZ461ZrPRNo2
         wahDbLXrdWAtEbM8EN+Qv0PB5wwe4JpH0hLZpFaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5fcdbfab6d6744c57418@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 104/192] netfilter: nf_tables: clean up hook list when offload flags check fails
Date:   Tue, 13 Sep 2022 16:03:30 +0200
Message-Id: <20220913140415.151210025@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

[ Upstream commit 77972a36ecc4db7fc7c68f0e80714263c5f03f65 ]

splice back the hook list so nft_chain_release_hook() has a chance to
release the hooks.

BUG: memory leak
unreferenced object 0xffff88810180b100 (size 96):
  comm "syz-executor133", pid 3619, jiffies 4294945714 (age 12.690s)
  hex dump (first 32 bytes):
    28 64 23 02 81 88 ff ff 28 64 23 02 81 88 ff ff  (d#.....(d#.....
    90 a8 aa 83 ff ff ff ff 00 00 b5 0f 81 88 ff ff  ................
  backtrace:
    [<ffffffff83a8c59b>] kmalloc include/linux/slab.h:600 [inline]
    [<ffffffff83a8c59b>] nft_netdev_hook_alloc+0x3b/0xc0 net/netfilter/nf_tables_api.c:1901
    [<ffffffff83a9239a>] nft_chain_parse_netdev net/netfilter/nf_tables_api.c:1998 [inline]
    [<ffffffff83a9239a>] nft_chain_parse_hook+0x33a/0x530 net/netfilter/nf_tables_api.c:2073
    [<ffffffff83a9b14b>] nf_tables_addchain.constprop.0+0x10b/0x950 net/netfilter/nf_tables_api.c:2218
    [<ffffffff83a9c41b>] nf_tables_newchain+0xa8b/0xc60 net/netfilter/nf_tables_api.c:2593
    [<ffffffff83a3d6a6>] nfnetlink_rcv_batch+0xa46/0xd20 net/netfilter/nfnetlink.c:517
    [<ffffffff83a3db79>] nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:638 [inline]
    [<ffffffff83a3db79>] nfnetlink_rcv+0x1f9/0x220 net/netfilter/nfnetlink.c:656
    [<ffffffff83a13b17>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff83a13b17>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff83a13fd6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff83865ab6>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff83865ab6>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff8386601c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2482
    [<ffffffff8386a918>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff8386aaa8>] __sys_sendmsg+0x88/0x100 net/socket.c:2565
    [<ffffffff845e5955>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845e5955>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: d54725cd11a5 ("netfilter: nf_tables: support for multiple devices per netdev hook")
Reported-by: syzbot+5fcdbfab6d6744c57418@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bc690238a3c56..848cc81d69926 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2166,8 +2166,10 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	chain->flags |= NFT_CHAIN_BASE | flags;
 	basechain->policy = NF_ACCEPT;
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
-	    !nft_chain_offload_support(basechain))
+	    !nft_chain_offload_support(basechain)) {
+		list_splice_init(&basechain->hook_list, &hook->list);
 		return -EOPNOTSUPP;
+	}
 
 	flow_block_init(&basechain->flow_block);
 
-- 
2.35.1



