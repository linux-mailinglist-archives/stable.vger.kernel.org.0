Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE863C4A19
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbhGLGsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:48:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236581AbhGLGrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B925E611CD;
        Mon, 12 Jul 2021 06:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072215;
        bh=0XxLR067xjdj3N3B0PBqMxIOrZIeoZWBRiaOTylEpz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwtmcFWtEy/y+zPa5rXct1OtDDLIRtHMaHX1yMLt4meYPLNnSDhUrLRkKOUJp5ndl
         HN1eA9EdHqKrIe8d2oYKZhDs4S3/OTUYCTpQTRAgcejMoaKqq0veZDUHrBkOBVWQVH
         T1arXoD/RyTBdxG3Qs900rriMzlsA375Q6Tfevy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/593] net: macsec: fix the length used to copy the key for offloading
Date:   Mon, 12 Jul 2021 08:09:23 +0200
Message-Id: <20210712060932.012759405@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 1f7fe5121127e037b86592ba42ce36515ea0e3f7 ]

The key length used when offloading macsec to Ethernet or PHY drivers
was set to MACSEC_KEYID_LEN (16), which is an issue as:
- This was never meant to be the key length.
- The key length can be > 16.

Fix this by using MACSEC_MAX_KEY_LEN to store the key (the max length
accepted in uAPI) and secy->key_len to copy it.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Reported-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 4 ++--
 include/net/macsec.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 11ca5fa902a1..c601d3df2722 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1818,7 +1818,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		ctx.sa.rx_sa = rx_sa;
 		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
-		       MACSEC_KEYID_LEN);
+		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_rxsa, &ctx);
 		if (err)
@@ -2060,7 +2060,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		ctx.sa.tx_sa = tx_sa;
 		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
-		       MACSEC_KEYID_LEN);
+		       secy->key_len);
 
 		err = macsec_offload(ops->mdo_add_txsa, &ctx);
 		if (err)
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 52874cdfe226..d6fa6b97f6ef 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -241,7 +241,7 @@ struct macsec_context {
 	struct macsec_rx_sc *rx_sc;
 	struct {
 		unsigned char assoc_num;
-		u8 key[MACSEC_KEYID_LEN];
+		u8 key[MACSEC_MAX_KEY_LEN];
 		union {
 			struct macsec_rx_sa *rx_sa;
 			struct macsec_tx_sa *tx_sa;
-- 
2.30.2



