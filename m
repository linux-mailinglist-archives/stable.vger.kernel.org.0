Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771F2409289
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245339AbhIMOMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345157AbhIMOKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41AFD6127C;
        Mon, 13 Sep 2021 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540506;
        bh=xbe0RSPYdKoFwBw5BLuEHqD/RHXyvym9ZB+DHR8IeS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2ZAsffEnU5x3JdaJbUoNaH0bS+ozwTvagk4758duAHd6mirvffEHtomvgVb3ccnH
         rLoEH8stgbZRWnaDwhxog0P/GSry3iN2nnw6+bPkQ11zo20uec6QbaLfQTkjUtz/Ef
         2IcHrBgLCKrsgm6nHOyvm3gnOHzUl4Wk3vyfWzDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 221/300] octeontx2-pf: Fix algorithm index in MCAM rules with RSS action
Date:   Mon, 13 Sep 2021 15:14:42 +0200
Message-Id: <20210913131116.823632502@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

[ Upstream commit e7938365459f3a6d4edf212f435c4ad635621450 ]

Otherthan setting action as RSS in NPC MCAM entry, RSS flowkey
algorithm index also needs to be set. Otherwise whatever algorithm
is defined at flowkey index '0' will be considered by HW and pkt
flows will be distributed as such.

Fix this by saving the flowkey index sent by admin function while
initializing RSS and then use it when framing MCAM rules.

Fixes: 81a4362016e7 ("octeontx2-pf: Add RSS multi group support")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  | 11 +++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  3 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_flows.c   |  1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 871404f3b8d3..25f84ad50dba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -266,6 +266,7 @@ unlock:
 int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	struct nix_rss_flowkey_cfg_rsp *rsp;
 	struct nix_rss_flowkey_cfg *req;
 	int err;
 
@@ -280,6 +281,16 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 	req->group = DEFAULT_RSS_CONTEXT_GROUP;
 
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto fail;
+
+	rsp = (struct nix_rss_flowkey_cfg_rsp *)
+			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp))
+		goto fail;
+
+	pfvf->hw.flowkey_alg_idx = rsp->alg_idx;
+fail:
 	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 45730d0d92f2..c652c27cd345 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -195,6 +195,9 @@ struct otx2_hw {
 	u8			lso_udpv4_idx;
 	u8			lso_udpv6_idx;
 
+	/* RSS */
+	u8			flowkey_alg_idx;
+
 	/* MSI-X */
 	u8			cint_cnt; /* CQ interrupt count */
 	u16			npa_msixoff; /* Offset of NPA vectors */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 0b4fa92ba821..81265dbf91e2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -682,6 +682,7 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
 		if (flow->flow_spec.flow_type & FLOW_RSS) {
 			req->op = NIX_RX_ACTIONOP_RSS;
 			req->index = flow->rss_ctx_id;
+			req->flow_key_alg = pfvf->hw.flowkey_alg_idx;
 		} else {
 			req->op = NIX_RX_ACTIONOP_UCAST;
 			req->index = ethtool_get_flow_spec_ring(ring_cookie);
-- 
2.30.2



