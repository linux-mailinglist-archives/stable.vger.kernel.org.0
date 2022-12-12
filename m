Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D7D64A1B8
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiLLNoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiLLNn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E9B13F92
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:43:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D8A61035
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214D2C433F2;
        Mon, 12 Dec 2022 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852625;
        bh=oZePgDg1nOWEoqIu4i1oofNd1Fu1iTnOQS6vwbfsp2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgHG9a38OgOKHMqdrGbULksVBMEiROa4VKZuHQU6CSPFNVG9Obk1dOWHQIOk88C2q
         tIHvW/yEolAI4PZ25/N1XuxOvAkTdbyS3oSAHpBPd9s+/ccMBEIGP/msWpJnQki08W
         fK/FTXoSJVTgRkJcqhtCrqgW7BMxwB6m7vCL3weE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 093/157] netfilter: conntrack: fix using __this_cpu_add in preemptible
Date:   Mon, 12 Dec 2022 14:17:21 +0100
Message-Id: <20221212130938.551731347@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 9464d0b68f11a9bc768370c3260ec02b3550447b ]

Currently in nf_conntrack_hash_check_insert(), when it fails in
nf_ct_ext_valid_pre/post(), NF_CT_STAT_INC() will be called in the
preemptible context, a call trace can be triggered:

   BUG: using __this_cpu_add() in preemptible [00000000] code: conntrack/1636
   caller is nf_conntrack_hash_check_insert+0x45/0x430 [nf_conntrack]
   Call Trace:
    <TASK>
    dump_stack_lvl+0x33/0x46
    check_preemption_disabled+0xc3/0xf0
    nf_conntrack_hash_check_insert+0x45/0x430 [nf_conntrack]
    ctnetlink_create_conntrack+0x3cd/0x4e0 [nf_conntrack_netlink]
    ctnetlink_new_conntrack+0x1c0/0x450 [nf_conntrack_netlink]
    nfnetlink_rcv_msg+0x277/0x2f0 [nfnetlink]
    netlink_rcv_skb+0x50/0x100
    nfnetlink_rcv+0x65/0x144 [nfnetlink]
    netlink_unicast+0x1ae/0x290
    netlink_sendmsg+0x257/0x4f0
    sock_sendmsg+0x5f/0x70

This patch is to fix it by changing to use NF_CT_STAT_INC_ATOMIC() for
nf_ct_ext_valid_pre/post() check in nf_conntrack_hash_check_insert(),
as well as nf_ct_ext_valid_post() in __nf_conntrack_confirm().

Note that nf_ct_ext_valid_pre() check in __nf_conntrack_confirm() is
safe to use NF_CT_STAT_INC(), as it's under local_bh_disable().

Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 60289c074eef..df46e9a35e47 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -891,7 +891,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	zone = nf_ct_zone(ct);
 
 	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC(net, insert_failed);
+		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
 		return -ETIMEDOUT;
 	}
 
@@ -938,7 +938,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(net, drop);
 		return -ETIMEDOUT;
 	}
 
@@ -1275,7 +1275,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 */
 	if (!nf_ct_ext_valid_post(ct->ext)) {
 		nf_ct_kill(ct);
-		NF_CT_STAT_INC(net, drop);
+		NF_CT_STAT_INC_ATOMIC(net, drop);
 		return NF_DROP;
 	}
 
-- 
2.35.1



