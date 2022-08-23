Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF06459E3A8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiHWM1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243483AbiHWMYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:24:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADC8D86D6;
        Tue, 23 Aug 2022 02:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 846AEB81C9B;
        Tue, 23 Aug 2022 09:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53CCC433D6;
        Tue, 23 Aug 2022 09:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247802;
        bh=a51phjWIfwW2YreCMWUbWI9Pi+BxAfY/35+0vzi9uNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwZPreRAsPIGKcf9n0ng3Xr7mJ+EOQ3zm4qsyTkjFBKtpNLPx0/6IHHnCMywiQTam
         fSsjbEGjb33wds7jze/SCeDtdObAWBGev8H5Fjn3IwUNuDSGBJm6ImjwumVONLvfZ2
         lKlYOQF/zC5mnWv929MA9QB0D5jwFUwVWn8BTuiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        kernel test robot <lkp@intel.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 152/158] netfilter: nf_tables: fix audit memory leak in nf_tables_commit
Date:   Tue, 23 Aug 2022 10:28:04 +0200
Message-Id: <20220823080051.934545112@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit cfbe3650dd3ef2ea9a4420ca89d9a4df98af3fb6 upstream.

In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
free the adp variable.

Fix this by adding nf_tables_commit_audit_free which frees
the linked list with the head node adl.

backtrace:
  kmalloc include/linux/slab.h:591 [inline]
  kzalloc include/linux/slab.h:721 [inline]
  nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
  nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
  nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
  nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
  netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
  netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
  sock_sendmsg_nosec net/socket.c:702 [inline]
  sock_sendmsg+0x56/0x80 net/socket.c:722

Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7819,6 +7819,16 @@ static int nf_tables_commit_audit_alloc(
 	return 0;
 }
 
+static void nf_tables_commit_audit_free(struct list_head *adl)
+{
+	struct nft_audit_data *adp, *adn;
+
+	list_for_each_entry_safe(adp, adn, adl, list) {
+		list_del(&adp->list);
+		kfree(adp);
+	}
+}
+
 static void nf_tables_commit_audit_collect(struct list_head *adl,
 					   struct nft_table *table, u32 op)
 {
@@ -7882,6 +7892,7 @@ static int nf_tables_commit(struct net *
 		ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
 		if (ret) {
 			nf_tables_commit_chain_prepare_cancel(net);
+			nf_tables_commit_audit_free(&adl);
 			return ret;
 		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
@@ -7891,6 +7902,7 @@ static int nf_tables_commit(struct net *
 			ret = nf_tables_commit_chain_prepare(net, chain);
 			if (ret < 0) {
 				nf_tables_commit_chain_prepare_cancel(net);
+				nf_tables_commit_audit_free(&adl);
 				return ret;
 			}
 		}


