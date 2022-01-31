Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD674A42D9
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359106AbiAaLOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:14:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60584 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376368AbiAaLMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:12:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6830CB82A4C;
        Mon, 31 Jan 2022 11:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889AAC340EE;
        Mon, 31 Jan 2022 11:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627553;
        bh=aEo9R4LgPqEQKePIly64t3WBTWHoW6E2ocSvBdF0Szk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V35Lx9IPLrQJyeAtnGtVI0Qt9ZfPGjHIewY4TfwU28fSCkxCo1Y2dqAqvQTvehbYV
         4Zf17qfQ3yPQ6DjYljQmIblpuqSE7wFQjOTAqPdUf1d75IEIxTTdCMpUaP3D/lGM4L
         MU8t6vOl8SdYdGLGQPmCYlZAGTX6skr4l9oNCmhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/171] octeontx2-af: Fix LBK backpressure id count
Date:   Mon, 31 Jan 2022 11:56:26 +0100
Message-Id: <20220131105234.134819720@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

[ Upstream commit 00bfe94e388fe12bfd0d4f6361b1b1343374ff5b ]

In rvu_nix_get_bpid() lbk_bpid_cnt is being read from
wrong register. Due to this backpressure enable is failing
for LBK VF32 onwards. This patch fixes that.

Fixes: fe1939bb2340 ("octeontx2-af: Add SDP interface support")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 6970540dc4709..8ee324aabf2d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -511,11 +511,11 @@ static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
 	lmac_chan_cnt = cfg & 0xFF;
 
-	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
-	sdp_chan_cnt = cfg & 0xFFF;
-
 	cgx_bpid_cnt = hw->cgx_links * lmac_chan_cnt;
 	lbk_bpid_cnt = hw->lbk_links * ((cfg >> 16) & 0xFF);
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
+	sdp_chan_cnt = cfg & 0xFFF;
 	sdp_bpid_cnt = hw->sdp_links * sdp_chan_cnt;
 
 	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
-- 
2.34.1



