Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F25F564E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391072AbfKHTH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390608AbfKHTH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C251421D7B;
        Fri,  8 Nov 2019 19:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240078;
        bh=X9HWCaLCercJBd4XdeEGlmWRQSpVMAL5+BGZy2UtPmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UczalmWLMLlcqTtDMTcPKBulaL0zwYE/c82BcaOHd0tPfOJfnzbmk0PFFl+Pkyne8
         YBskxNHUWGJj0tvBn9/toOxIbVLfx1dHp+4XKrA+ooxIQnRkSmqoUadzQwdeHM2BHi
         eO8FrPhhwC21nKxVW53K5NtbVVqpsHMBZGKo2eiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 082/140] erspan: fix the tun_info options_len check for erspan
Date:   Fri,  8 Nov 2019 19:50:10 +0100
Message-Id: <20191108174910.277000801@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2eb8d6d2910cfe3dc67dc056f26f3dd9c63d47cd ]

The check for !md doens't really work for ip_tunnel_info_opts(info) which
only does info + 1. Also to avoid out-of-bounds access on info, it should
ensure options_len is not less than erspan_metadata in both erspan_xmit()
and ip6erspan_tunnel_xmit().

Fixes: 1a66a836da ("gre: add collect_md mode to ERSPAN tunnel")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c  |    4 ++--
 net/ipv6/ip6_gre.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -509,9 +509,9 @@ static void erspan_fb_xmit(struct sk_buf
 	key = &tun_info->key;
 	if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
 		goto err_free_skb;
-	md = ip_tunnel_info_opts(tun_info);
-	if (!md)
+	if (tun_info->options_len < sizeof(*md))
 		goto err_free_skb;
+	md = ip_tunnel_info_opts(tun_info);
 
 	/* ERSPAN has fixed 8 byte GRE header */
 	version = md->version;
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -980,9 +980,9 @@ static netdev_tx_t ip6erspan_tunnel_xmit
 		dsfield = key->tos;
 		if (!(tun_info->key.tun_flags & TUNNEL_ERSPAN_OPT))
 			goto tx_err;
-		md = ip_tunnel_info_opts(tun_info);
-		if (!md)
+		if (tun_info->options_len < sizeof(*md))
 			goto tx_err;
+		md = ip_tunnel_info_opts(tun_info);
 
 		tun_id = tunnel_id_to_key32(key->tun_id);
 		if (md->version == 1) {


