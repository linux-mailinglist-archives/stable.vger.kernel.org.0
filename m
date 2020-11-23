Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7B2C067F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgKWMba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:31:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730846AbgKWMb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:31:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 486972158C;
        Mon, 23 Nov 2020 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134687;
        bh=auOGuJEDLaPCw2VKr2jkrhSJZxgBd7PTB515B4OxbrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyM1Fk28cgOogdKx1lWDuODe/wUtGF5RXRTPfly4b7wM9w2hT0eUR0W3Yfrgp7oxX
         PydFwZAzD7/rU9JMKfAlciVtZ+O7RieRKuhcCjynTqM9/w5JoBnKaMyAsPPSwOC1iF
         +rqijopkhEM3yngYsSHPJdVpkZIEiaQ7YPvmcShQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi-Hung Wei <yihung.wei@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/91] ip_tunnels: Set tunnel option flag when tunnel metadata is present
Date:   Mon, 23 Nov 2020 13:22:07 +0100
Message-Id: <20201123121811.605089318@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
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
index d0b5844c8a315..2e2afc824a6a8 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -223,8 +223,7 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 	if (ip_tunnel_collect_metadata() || gs->collect_md) {
 		__be16 flags;
 
-		flags = TUNNEL_KEY | TUNNEL_GENEVE_OPT |
-			(gnvh->oam ? TUNNEL_OAM : 0) |
+		flags = TUNNEL_KEY | (gnvh->oam ? TUNNEL_OAM : 0) |
 			(gnvh->critical ? TUNNEL_CRIT_OPT : 0);
 
 		tun_dst = udp_tun_rx_dst(skb, geneve_get_sk_family(gs), flags,
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index e11423530d642..f8873c4eb003a 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -489,9 +489,11 @@ static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
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
@@ -537,7 +539,6 @@ static inline void ip_tunnel_info_opts_set(struct ip_tunnel_info *info,
 					   __be16 flags)
 {
 	info->options_len = 0;
-	info->key.tun_flags |= flags;
 }
 
 #endif /* CONFIG_INET */
-- 
2.27.0



