Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27CA4A4518
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377048AbiAaLg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378536AbiAaLeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:34:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9485C06174A;
        Mon, 31 Jan 2022 03:22:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB3C3B82A69;
        Mon, 31 Jan 2022 11:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0377C36AE7;
        Mon, 31 Jan 2022 11:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628155;
        bh=gcYyTcJKXsCNTGorvNFgbVZx0KUSS/vOqfkMNNgbiUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxegkQSAeen3sXnF7K6gpb6Pl1e9H3QFCi2J9d2MEsd8tbjeLy4ohyw8cFsSEvptS
         vJSXIqLtMA7oiYob9pwpvbVGYOYbi+AOQ9UK+pNyAXvOkd/dRbDMPpxGKSXZ28BkTT
         UgebRQjVf2j+6IDtaJ5pmYI1aboWaXslD1jtVvd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 143/200] octeontx2-af: Fix LBK backpressure id count
Date:   Mon, 31 Jan 2022 11:56:46 +0100
Message-Id: <20220131105238.365327349@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
index d8b1948aaa0ae..b74ab0dae10dc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -512,11 +512,11 @@ static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
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



