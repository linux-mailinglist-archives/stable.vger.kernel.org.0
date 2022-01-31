Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDACE4A4395
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376784AbiAaLWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378547AbiAaLUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5FCC0604D3;
        Mon, 31 Jan 2022 03:12:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A5E0B82A61;
        Mon, 31 Jan 2022 11:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978B3C340E8;
        Mon, 31 Jan 2022 11:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627556;
        bh=fSaPjkaBX8uP1JANbpgChwr8VuMwKXYx2urdUv8ufbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPHwvoXw0950FT4lIud/n9O80v7lfH3+cDFDp3qevCzpcNjlqeWuhFjdM6TszQj2X
         2bhf927yxc3ID/NXjhNkmRjRDJfrJSVtu47yyMJ9Pq/HDDY/Z6ixS6kurTmUUfTlQF
         TKy6zzFM3K1H+pz3p8NKnjKUHV/ON+q5HzrLM2bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/171] octeontx2-af: Retry until RVU block reset complete
Date:   Mon, 31 Jan 2022 11:56:27 +0100
Message-Id: <20220131105234.165213139@linuxfoundation.org>
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
index 90dc5343827f0..11ef46e72ddd9 100644
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



