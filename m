Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0704A43E5
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245523AbiAaLYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:24:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52560 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377274AbiAaLWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:22:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E67A611E3;
        Mon, 31 Jan 2022 11:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC18C340E8;
        Mon, 31 Jan 2022 11:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628158;
        bh=WbNPvf9fPdTSG1gQ5NTJjcnoAUVPuHZ4gNLdjHQIV3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2L6VchRBSoThSyJu34052tZ3mNw7XiBF7A6l80otxayT9uLQL9PwuCQsFi/7g4oR
         Hdz9E5bC7nR4t97wibwJfGmLsMANF3ZOKhwkO3kmASt0798jObNAVgnIyMc26qhtC3
         K5s1LfMCXm4Bsu5hVxpPqASTS6J2RAI/NFC2BJDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 144/200] octeontx2-af: Retry until RVU block reset complete
Date:   Mon, 31 Jan 2022 11:56:47 +0100
Message-Id: <20220131105238.401824516@linuxfoundation.org>
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

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 03ffbc9914bd1130fba464f0a41c01372e5fc359 ]

Few RVU blocks like SSO require more time for reset on some
silicons. Hence retrying the block reset until success.

Fixes: c0fa2cff8822c ("octeontx2-af: Handle return value in block reset")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3ca6b942ebe25..54e1b27a7dfec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -520,8 +520,11 @@ static void rvu_block_reset(struct rvu *rvu, int blkaddr, u64 rst_reg)
 
 	rvu_write64(rvu, blkaddr, rst_reg, BIT_ULL(0));
 	err = rvu_poll_reg(rvu, blkaddr, rst_reg, BIT_ULL(63), true);
-	if (err)
-		dev_err(rvu->dev, "HW block:%d reset failed\n", blkaddr);
+	if (err) {
+		dev_err(rvu->dev, "HW block:%d reset timeout retrying again\n", blkaddr);
+		while (rvu_poll_reg(rvu, blkaddr, rst_reg, BIT_ULL(63), true) == -EBUSY)
+			;
+	}
 }
 
 static void rvu_reset_all_blocks(struct rvu *rvu)
-- 
2.34.1



