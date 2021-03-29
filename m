Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440BC34C8AC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhC2IXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233969AbhC2IWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0107C6044F;
        Mon, 29 Mar 2021 08:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006153;
        bh=nkqi4Jbyl0Uzy75QU92FnrknwYWEDlHlfIZNVoCIv+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2eOCleY14GS3a3UHsCclPhhcpbCqtesKu12pLppcMgyjwh92s/Tq52lXlYWBaC6o
         jxRZbus/jA1C0TZ9K6Fp2fR2TOuqsQrU7UVWP5amVShBJ50ZLGqygD+7nFORH/KZ63
         v2vtON3ZREpO2FGIg7J430RYDFBc7+ppJWaUvvAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/221] nfp: flower: fix unsupported pre_tunnel flows
Date:   Mon, 29 Mar 2021 09:57:47 +0200
Message-Id: <20210329075633.723005706@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

[ Upstream commit 982e5ee23d764fe6158f67a7813d416335e978b0 ]

There are some pre_tunnel flows combinations which are incorrectly being
offloaded without proper support, fix these.

- Matching on MPLS is not supported for pre_tun.
- Match on IPv4/IPv6 layer must be present.
- Destination MAC address must match pre_tun.dev MAC

Fixes: 120ffd84a9ec ("nfp: flower: verify pre-tunnel rules")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/netronome/nfp/flower/offload.c    | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 1c59aff2163c..d72225d64a75 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1142,6 +1142,12 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 		return -EOPNOTSUPP;
 	}
 
+	if (!(key_layer & NFP_FLOWER_LAYER_IPV4) &&
+	    !(key_layer & NFP_FLOWER_LAYER_IPV6)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: match on ipv4/ipv6 eth_type must be present");
+		return -EOPNOTSUPP;
+	}
+
 	/* Skip fields known to exist. */
 	mask += sizeof(struct nfp_flower_meta_tci);
 	ext += sizeof(struct nfp_flower_meta_tci);
@@ -1152,6 +1158,13 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 	mask += sizeof(struct nfp_flower_in_port);
 	ext += sizeof(struct nfp_flower_in_port);
 
+	/* Ensure destination MAC address matches pre_tun_dev. */
+	mac = (struct nfp_flower_mac_mpls *)ext;
+	if (memcmp(&mac->mac_dst[0], flow->pre_tun_rule.dev->dev_addr, 6)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: dest MAC must match output dev MAC");
+		return -EOPNOTSUPP;
+	}
+
 	/* Ensure destination MAC address is fully matched. */
 	mac = (struct nfp_flower_mac_mpls *)mask;
 	if (!is_broadcast_ether_addr(&mac->mac_dst[0])) {
@@ -1159,6 +1172,11 @@ nfp_flower_validate_pre_tun_rule(struct nfp_app *app,
 		return -EOPNOTSUPP;
 	}
 
+	if (mac->mpls_lse) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported pre-tunnel rule: MPLS not supported");
+		return -EOPNOTSUPP;
+	}
+
 	mask += sizeof(struct nfp_flower_mac_mpls);
 	ext += sizeof(struct nfp_flower_mac_mpls);
 	if (key_layer & NFP_FLOWER_LAYER_IPV4 ||
-- 
2.30.1



