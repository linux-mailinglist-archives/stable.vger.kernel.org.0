Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A693C4ABA73
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383742AbiBGLXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237088AbiBGLKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:10:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EA2C043181;
        Mon,  7 Feb 2022 03:10:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B0BC61261;
        Mon,  7 Feb 2022 11:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5CCC004E1;
        Mon,  7 Feb 2022 11:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232202;
        bh=gbyAKXsbC5SPrKputzXQk9L9aO0b3TlGKjbBqOfbqL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0C9FFEfWWAbIUzkkyBha679wol64kr45rJYHD159DGasgDqqWLPsRed9hEa9lXi9
         jMTic4Emj7VAj95vP8YqLaI4qzqm+6WvQjowCdlw4XERNziEGi+08mFg9pCQwTXw5w
         wGeqcQ02fl+ECESugrCgmpoSnd6o72y0SwejjNFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Congyu Liu <liu3101@purdue.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/48] net: fix information leakage in /proc/net/ptype
Date:   Mon,  7 Feb 2022 12:05:50 +0100
Message-Id: <20220207103752.904332308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Congyu Liu <liu3101@purdue.edu>

commit 47934e06b65637c88a762d9c98329ae6e3238888 upstream.

In one net namespace, after creating a packet socket without binding
it to a device, users in other net namespaces can observe the new
`packet_type` added by this packet socket by reading `/proc/net/ptype`
file. This is minor information leakage as packet socket is
namespace aware.

Add a net pointer in `packet_type` to keep the net namespace of
of corresponding packet socket. In `ptype_seq_show`, this net pointer
must be checked when it is not NULL.

Fixes: 2feb27dbe00c ("[NETNS]: Minor information leak via /proc/net/ptype file.")
Signed-off-by: Congyu Liu <liu3101@purdue.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |    1 +
 net/core/net-procfs.c     |    3 ++-
 net/packet/af_packet.c    |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2237,6 +2237,7 @@ struct packet_type {
 					 struct net_device *);
 	bool			(*id_match)(struct packet_type *ptype,
 					    struct sock *sk);
+	struct net		*af_packet_net;
 	void			*af_packet_priv;
 	struct list_head	list;
 };
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -278,7 +278,8 @@ static int ptype_seq_show(struct seq_fil
 
 	if (v == SEQ_START_TOKEN)
 		seq_puts(seq, "Type Device      Function\n");
-	else if (pt->dev == NULL || dev_net(pt->dev) == seq_file_net(seq)) {
+	else if ((!pt->af_packet_net || net_eq(pt->af_packet_net, seq_file_net(seq))) &&
+		 (!pt->dev || net_eq(dev_net(pt->dev), seq_file_net(seq)))) {
 		if (pt->type == htons(ETH_P_ALL))
 			seq_puts(seq, "ALL ");
 		else
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1705,6 +1705,7 @@ static int fanout_add(struct sock *sk, u
 		match->prot_hook.dev = po->prot_hook.dev;
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
+		match->prot_hook.af_packet_net = read_pnet(&match->net);
 		match->prot_hook.id_match = match_fanout_group;
 		list_add(&match->list, &fanout_list);
 	}
@@ -3310,6 +3311,7 @@ static int packet_create(struct net *net
 		po->prot_hook.func = packet_rcv_spkt;
 
 	po->prot_hook.af_packet_priv = sk;
+	po->prot_hook.af_packet_net = sock_net(sk);
 
 	if (proto) {
 		po->prot_hook.type = proto;


