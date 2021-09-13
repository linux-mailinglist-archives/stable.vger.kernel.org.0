Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE084095BA
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344332AbhIMOnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345135AbhIMOlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6FB06124A;
        Mon, 13 Sep 2021 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541381;
        bh=3HgTSiSenMZLALV6ean9E0Invt9sKdJ7P5fruDSHcSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWOx+lVVVXpnLzxJi6CdA3PX0klx66SX3uT/UDKK5xK7TBV849bvXISsdC2L5UvG8
         D7BNQt+hfW8p4Gr2ukezVQo2tANSrGdzIHntrv5qPhaMmtuGeF8KsGtyG/1AYsDunQ
         +5CzmR53vvj2WOLeb8LTWb6qjZKzvn3yWM7xeUlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 242/334] octeontx2-af: Check capability flag while freeing ipolicer memory
Date:   Mon, 13 Sep 2021 15:14:56 +0200
Message-Id: <20210913131121.583008323@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 07cccffdbdd37820ba13c645af8e74a78a266557 ]

Bandwidth profiles (ipolicer structure)is implemented only on CN10K
platform. But current code try to free the ipolicer memory without
checking the capibility flag leading to driver crash on OCTEONTX2
platform. This patch fixes the issue by add capability flag check.

Fixes: e8e095b3b3700 ("octeontx2-af: cn10k: Bandwidth profiles config support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 4bfbbdf38770..c32195073e8a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -25,7 +25,7 @@ static int nix_update_mce_rule(struct rvu *rvu, u16 pcifunc,
 			       int type, bool add);
 static int nix_setup_ipolicers(struct rvu *rvu,
 			       struct nix_hw *nix_hw, int blkaddr);
-static void nix_ipolicer_freemem(struct nix_hw *nix_hw);
+static void nix_ipolicer_freemem(struct rvu *rvu, struct nix_hw *nix_hw);
 static int nix_verify_bandprof(struct nix_cn10k_aq_enq_req *req,
 			       struct nix_hw *nix_hw, u16 pcifunc);
 static int nix_free_all_bandprof(struct rvu *rvu, u16 pcifunc);
@@ -3849,7 +3849,7 @@ static void rvu_nix_block_freemem(struct rvu *rvu, int blkaddr,
 			kfree(txsch->schq.bmap);
 		}
 
-		nix_ipolicer_freemem(nix_hw);
+		nix_ipolicer_freemem(rvu, nix_hw);
 
 		vlan = &nix_hw->txvlan;
 		kfree(vlan->rsrc.bmap);
@@ -4225,11 +4225,14 @@ static int nix_setup_ipolicers(struct rvu *rvu,
 	return 0;
 }
 
-static void nix_ipolicer_freemem(struct nix_hw *nix_hw)
+static void nix_ipolicer_freemem(struct rvu *rvu, struct nix_hw *nix_hw)
 {
 	struct nix_ipolicer *ipolicer;
 	int layer;
 
+	if (!rvu->hw->cap.ipolicer)
+		return;
+
 	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
 		ipolicer = &nix_hw->ipolicer[layer];
 
-- 
2.30.2



