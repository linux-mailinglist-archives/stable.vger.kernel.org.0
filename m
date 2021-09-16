Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A0140E847
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354041AbhIPRiY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:38:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348046AbhIPRgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF39F6322A;
        Thu, 16 Sep 2021 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810970;
        bh=AQ1AXbf3TXp0Se5YbZsSSuS8QQ/TcHAk528OBfqdgds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIjpFxGvRPy+VSL/LiKoBJCiud7KizIMCsPmmo44Fny8UbrDmeLR4g8VtRrbrC8yO
         6Cyt9PvNx8iExXKY+4wpJoriEs/oefsPoBnO+c/Ym5/cGqAJQQGCCkFCtS7udNcpgp
         2To/63RfOtlz8qx19Nuy/Ww6r5KvY6TNDz6WlbTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 334/432] octeontx2-pf: Fix NIX1_RX interface backpressure
Date:   Thu, 16 Sep 2021 18:01:23 +0200
Message-Id: <20210916155822.163226949@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit e8fb4df1f5d84bc08dd4f4827821a851d2eab241 ]

'bp_ena' in Aura context is NIX block index, setting it
zero will always backpressure NIX0 block, even if NIXLF
belongs to NIX1. Hence fix this by setting it appropriately
based on NIX block address.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 94dfd64f526f..9c8aa1f3dbbb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1204,7 +1204,22 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 	/* Enable backpressure for RQ aura */
 	if (aura_id < pfvf->hw.rqpool_cnt && !is_otx2_lbkvf(pfvf->pdev)) {
 		aq->aura.bp_ena = 0;
+		/* If NIX1 LF is attached then specify NIX1_RX.
+		 *
+		 * Below NPA_AURA_S[BP_ENA] is set according to the
+		 * NPA_BPINTF_E enumeration given as:
+		 * 0x0 + a*0x1 where 'a' is 0 for NIX0_RX and 1 for NIX1_RX so
+		 * NIX0_RX is 0x0 + 0*0x1 = 0
+		 * NIX1_RX is 0x0 + 1*0x1 = 1
+		 * But in HRM it is given that
+		 * "NPA_AURA_S[BP_ENA](w1[33:32]) - Enable aura backpressure to
+		 * NIX-RX based on [BP] level. One bit per NIX-RX; index
+		 * enumerated by NPA_BPINTF_E."
+		 */
+		if (pfvf->nix_blkaddr == BLKADDR_NIX1)
+			aq->aura.bp_ena = 1;
 		aq->aura.nix0_bpid = pfvf->bpid[0];
+
 		/* Set backpressure level for RQ's Aura */
 		aq->aura.bp = RQ_BP_LVL_AURA;
 	}
-- 
2.30.2



