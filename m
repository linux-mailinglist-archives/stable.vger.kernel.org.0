Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF95177F92
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbgCCRvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732022AbgCCRvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32EE2146E;
        Tue,  3 Mar 2020 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257899;
        bh=Y4W9atvGmn4hDWb8DGFHdTnSI/IULFfUCaj1/x46eFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3RFpG3WtU7x8CiiMx1/lWZvIj24ICCaSdWs/3Vx3HrnsLm9E65SabV6GRDwjIwph
         HcdFIZLIqRa/aG1kotleMWUaSqVdlGZLg6ZAtLn6GIfbxD+6mn4hvkZ4W4b8IznTMh
         ZXPEVrn5kfRIexH3z0zNEU/62hSDv4OjrYLgln7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 164/176] netfilter: nft_tunnel: no need to call htons() when dumping ports
Date:   Tue,  3 Mar 2020 18:43:48 +0100
Message-Id: <20200303174323.157054013@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
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
@@ -505,8 +505,8 @@ static int nft_tunnel_opts_dump(struct s
 static int nft_tunnel_ports_dump(struct sk_buff *skb,
 				 struct ip_tunnel_info *info)
 {
-	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, htons(info->key.tp_src)) < 0 ||
-	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, htons(info->key.tp_dst)) < 0)
+	if (nla_put_be16(skb, NFTA_TUNNEL_KEY_SPORT, info->key.tp_src) < 0 ||
+	    nla_put_be16(skb, NFTA_TUNNEL_KEY_DPORT, info->key.tp_dst) < 0)
 		return -1;
 
 	return 0;


