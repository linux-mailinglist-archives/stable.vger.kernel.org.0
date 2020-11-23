Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3662C0B3E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbgKWNWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731840AbgKWMg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:36:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0C420857;
        Mon, 23 Nov 2020 12:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135017;
        bh=NloPI28+U5uT9HfwbMIsGovgtDmuJDWGVYeZ5ho+LwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bqcMCJpIVdVARUbsQa7bfyAfxAATeGD7VyAgwZjHUGVPQy2JxxO+/3AxpaX47Qeh
         YjO1/JtEnjFpbKRzLheN+EQ0Jhy6e5ke+iJoHVoXV5CQqGISTKC8uH58wLanyeA1YH
         6PjGdXX4OcFXNgNOFEbN31AbK/L+cvuojlwx7DJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi-Hung Wei <yihung.wei@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/158] ip_tunnels: Set tunnel option flag when tunnel metadata is present
Date:   Mon, 23 Nov 2020 13:21:42 +0100
Message-Id: <20201123121823.508265910@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>

[ Upstream commit 9c2e14b48119b39446031d29d994044ae958d8fc ]

Currently, we may set the tunnel option flag when the size of metadata
is zero.  For example, we set TUNNEL_GENEVE_OPT in the receive function
no matter the geneve option is present or not.  As this may result in
issues on the tunnel flags consumers, this patch fixes the issue.

Related discussion:
* https://lore.kernel.org/netdev/1604448694-19351-1-git-send-email-yihung.wei@gmail.com/T/#u

Fixes: 256c87c17c53 ("net: check tunnel option type in tunnel flags")
Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
Link: https://lore.kernel.org/r/1605053800-74072-1-git-send-email-yihung.wei@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c     | 3 +--
 include/net/ip_tunnels.h | 7 ++++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index fcb7a6b4cc02a..c7ec3d24eabc8 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -221,8 +221,7 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 	if (ip_tunnel_collect_metadata() || gs->collect_md) {
 		__be16 flags;
 
-		flags = TUNNEL_KEY | TUNNEL_GENEVE_OPT |
-			(gnvh->oam ? TUNNEL_OAM : 0) |
+		flags = TUNNEL_KEY | (gnvh->oam ? TUNNEL_OAM : 0) |
 			(gnvh->critical ? TUNNEL_CRIT_OPT : 0);
 
 		tun_dst = udp_tun_rx_dst(skb, geneve_get_sk_family(gs), flags,
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index af645604f3289..56deb2501e962 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -472,9 +472,11 @@ static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
 					   const void *from, int len,
 					   __be16 flags)
 {
-	memcpy(ip_tunnel_info_opts(info), from, len);
 	info->options_len = len;
-	info->key.tun_flags |= flags;
+	if (len > 0) {
+		memcpy(ip_tunnel_info_opts(info), from, len);
+		info->key.tun_flags |= flags;
+	}
 }
 
 static inline struct ip_tunnel_info *lwt_tun_info(struct lwtunnel_state *lwtstate)
@@ -520,7 +522,6 @@ static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
 					   __be16 flags)
 {
 	info->options_len = 0;
-	info->key.tun_flags |= flags;
 }
 
 #endif /* CONFIG_INET */
-- 
2.27.0



