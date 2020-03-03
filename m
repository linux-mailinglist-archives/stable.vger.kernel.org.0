Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40501178185
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbgCCSDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388132AbgCCSCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B9F22B48;
        Tue,  3 Mar 2020 18:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258525;
        bh=ysInNcKLbdIsDEaCJnZKFs/gLT63skhNXoWP42kIxjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ci7yKt3uAjxwXWOVE2+mUDK/QBEBFh0nw+S8C4jVaUFKjdss7+cHUa1GoLaBAKKxw
         GW9jpac+/saNZ8+Esx5adhDCUeyIl/i1UaYdDS4rpLXeMs72s8Xj1txqzxJFsN8Tvk
         JgIajuWFCadQC4Z89riYg2iQoDcEWSuq2JnxtCvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 83/87] netfilter: nft_tunnel: no need to call htons() when dumping ports
Date:   Tue,  3 Mar 2020 18:44:14 +0100
Message-Id: <20200303174357.754083000@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit cf3e204a1ca5442190018a317d9ec181b4639bd6 upstream.

info->key.tp_src and tp_dst are __be16, when using nla_put_be16()
to dump them, htons() is not needed, so remove it in this patch.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_tunnel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -467,8 +467,8 @@ static int nft_tunnel_opts_dump(struct s
 static int nft_tunnel_ports_dump(struct sk_buff *skb,
 				 struct ip_tunnel_info *info)
 {
-	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, htons(info->key.tp_src)) < 0 ||
-	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, htons(info->key.tp_dst)) < 0)
+	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, info->key.tp_src) < 0 ||
+	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, info->key.tp_dst) < 0)
 		return -1;
 
 	return 0;


