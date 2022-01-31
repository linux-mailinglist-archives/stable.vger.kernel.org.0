Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837A44A42AC
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376497AbiAaLMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43930 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358774AbiAaLKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE0961187;
        Mon, 31 Jan 2022 11:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B5DC340EE;
        Mon, 31 Jan 2022 11:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627449;
        bh=YHrvJnXa5X1wfQtF+Ogrm85EqxRyOSldBMesQslQ2Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8C+PCkr2c/s2DhjFw7Ulpt4akd/8DbKXeoV76ETlUmQ0ZyFQHLRYyrprF3RBK4Yp
         yLaQp+hX7cECIp3iajgWuLJLinP2VHWgBipBsJjifALo/CQCZqaWZk39HHW0CUxrbq
         nYcxMiM+ePwoq1JxNKoJBq305iZ9fJ0KhBFNtuoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Congyu Liu <liu3101@purdue.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/171] net: fix information leakage in /proc/net/ptype
Date:   Mon, 31 Jan 2022 11:55:52 +0100
Message-Id: <20220131105232.971619785@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
@@ -2636,6 +2636,7 @@ struct packet_type {
 					      struct net_device *);
 	bool			(*id_match)(struct packet_type *ptype,
 					    struct sock *sk);
+	struct net		*af_packet_net;
 	void			*af_packet_priv;
 	struct list_head	list;
 };
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -260,7 +260,8 @@ static int ptype_seq_show(struct seq_fil
 
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
@@ -1738,6 +1738,7 @@ static int fanout_add(struct sock *sk, s
 		match->prot_hook.dev = po->prot_hook.dev;
 		match->prot_hook.func = packet_rcv_fanout;
 		match->prot_hook.af_packet_priv = match;
+		match->prot_hook.af_packet_net = read_pnet(&match->net);
 		match->prot_hook.id_match = match_fanout_group;
 		match->max_num_members = args->max_num_members;
 		list_add(&match->list, &fanout_list);
@@ -3323,6 +3324,7 @@ static int packet_create(struct net *net
 		po->prot_hook.func = packet_rcv_spkt;
 
 	po->prot_hook.af_packet_priv = sk;
+	po->prot_hook.af_packet_net = sock_net(sk);
 
 	if (proto) {
 		po->prot_hook.type = proto;


