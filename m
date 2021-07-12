Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039A63C5507
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242529AbhGLIIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348606AbhGLH6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9015261883;
        Mon, 12 Jul 2021 07:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076370;
        bh=jLLKyQbGcR94mhr7nkAhK74b0FMOP2YMi8Q6DFDCnio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGeagVfV8w8E0F63xAg5OPxKdG9LXf2CsYf7yOS9h1rgpxq9x61PsuApHP1ukuooq
         Z7ghLYrpycPo07MA235+WucvQsW4ahhBqCwiINFSiKyRk4Re6CpMeGfpyJ+0vziIka
         peX+/m/nAlpssRDD/GeRnzGnHLxipD5RrVthEM/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 571/800] net: atlantic: fix the macsec key length
Date:   Mon, 12 Jul 2021 08:09:54 +0200
Message-Id: <20210712061028.149660855@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit d67fb4772d9a6cfd10f1109f0e7b1e6eb58c8e16 ]

The key length used to store the macsec key was set to MACSEC_KEYID_LEN
(16), which is an issue as:
- This was never meant to be the key length.
- The key length can be > 16.

Fix this by using MACSEC_MAX_KEY_LEN instead (the max length accepted in
uAPI).

Fixes: 27736563ce32 ("net: atlantic: MACSec egress offload implementation")
Fixes: 9ff40a751a6f ("net: atlantic: MACSec ingress offload implementation")
Reported-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
index f5fba8b8cdea..a47e2710487e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
@@ -91,7 +91,7 @@ struct aq_macsec_txsc {
 	u32 hw_sc_idx;
 	unsigned long tx_sa_idx_busy;
 	const struct macsec_secy *sw_secy;
-	u8 tx_sa_key[MACSEC_NUM_AN][MACSEC_KEYID_LEN];
+	u8 tx_sa_key[MACSEC_NUM_AN][MACSEC_MAX_KEY_LEN];
 	struct aq_macsec_tx_sc_stats stats;
 	struct aq_macsec_tx_sa_stats tx_sa_stats[MACSEC_NUM_AN];
 };
@@ -101,7 +101,7 @@ struct aq_macsec_rxsc {
 	unsigned long rx_sa_idx_busy;
 	const struct macsec_secy *sw_secy;
 	const struct macsec_rx_sc *sw_rxsc;
-	u8 rx_sa_key[MACSEC_NUM_AN][MACSEC_KEYID_LEN];
+	u8 rx_sa_key[MACSEC_NUM_AN][MACSEC_MAX_KEY_LEN];
 	struct aq_macsec_rx_sa_stats rx_sa_stats[MACSEC_NUM_AN];
 };
 
-- 
2.30.2



