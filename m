Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2808A4A4523
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377568AbiAaLgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378561AbiAaLeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:34:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6717AC0698C2;
        Mon, 31 Jan 2022 03:22:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26D5BB82A66;
        Mon, 31 Jan 2022 11:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42723C340E8;
        Mon, 31 Jan 2022 11:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628167;
        bh=lTRCL94DPMWIznAA7wVaKBlQOmSr1xSULJkcqcdiaSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGlabOyNJgcn3LVLf3G0uldI7uWgMfwI75qzbB1blcMBk6scLVYs1ZuK8YvsUElNW
         sS2tFiN7DJVZsUxyOqY9Y362R5PC4yJml/B1n/AP7Kd69XVJHM2/sNtLBHizV7sUFV
         M6NrzpxDShyaX4KeU0Vmu2uiD2R9sT0Rum+f+S/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 147/200] octeontx2-af: Increase link credit restore polling timeout
Date:   Mon, 31 Jan 2022 11:56:50 +0100
Message-Id: <20220131105238.505663336@linuxfoundation.org>
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

[ Upstream commit 1581d61b42d985cefe7b71eea67ab3bfcbf34d0f ]

It's been observed that sometimes link credit restore takes
a lot of time than the current timeout. This patch increases
the default timeout value and return the proper error value
on failure.

Fixes: 1c74b89171c3 ("octeontx2-af: Wait for TX link idle for credits change")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    | 1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 4e79e918a1617..58e2aeebc14f8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -732,6 +732,7 @@ enum nix_af_status {
 	NIX_AF_ERR_BANDPROF_INVAL_REQ  = -428,
 	NIX_AF_ERR_CQ_CTX_WRITE_ERR  = -429,
 	NIX_AF_ERR_AQ_CTX_RETRY_WRITE  = -430,
+	NIX_AF_ERR_LINK_CREDITS  = -431,
 };
 
 /* For NIX RX vtag action  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index de6e5a1288640..97fb61915379a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3891,8 +3891,8 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 			    NIX_AF_TL1X_SW_XOFF(schq), BIT_ULL(0));
 	}
 
-	rc = -EBUSY;
-	poll_tmo = jiffies + usecs_to_jiffies(10000);
+	rc = NIX_AF_ERR_LINK_CREDITS;
+	poll_tmo = jiffies + usecs_to_jiffies(200000);
 	/* Wait for credits to return */
 	do {
 		if (time_after(jiffies, poll_tmo))
-- 
2.34.1



