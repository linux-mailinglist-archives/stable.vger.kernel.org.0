Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109B83B62C7
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbhF1Ot3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235034AbhF1OoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F45061CEE;
        Mon, 28 Jun 2021 14:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890828;
        bh=nqo5wYVshusn/Mgb71VBIPERmlG+APA5fganEMFEW0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nrv0LR/910wnmD610pL7g4gPOJmieQ2fvSxY8WLYHw4fr8dAg4u93CCQ5f3qs32fO
         O/s/SbSJ5/FD3MCbEvYGFFF3Oi+orjf4xxGRepqdGMCMe02zX4jlkAXqWmUPkYwetS
         C3LdnpKtQy3/58xZQFGb1R0oYKlqWTAQ2TKhGqqK2lV4Ho3+dqpwD3MheUSr/gDlYT
         Dtd72k1dYW+5shhEByCwTog2Hjh1c3rB9PvBSeRysDaOUsMdpHG5KF8f5El3j6BETk
         RkjqG27SFM0YM9tDTJA/eJdAcrfj/K5Azr9UdDilaxztoClERbPYG0Htj2UdKeaZ3b
         ZBKRVR8RnoN2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/109] net: fec_ptp: fix issue caused by refactor the fec_devtype
Date:   Mon, 28 Jun 2021 10:32:02 -0400
Message-Id: <20210628143305.32978-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit d23765646e71b43ed2b809930411ba5c0aadee7b ]

Commit da722186f654 ("net: fec: set GPR bit on suspend by DT configuration.")
refactor the fec_devtype, need adjust ptp driver accordingly.

Fixes: da722186f654 ("net: fec: set GPR bit on suspend by DT configuration.")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 09a762eb4f09..eca65d49decb 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -220,15 +220,13 @@ static u64 fec_ptp_read(const struct cyclecounter *cc)
 {
 	struct fec_enet_private *fep =
 		container_of(cc, struct fec_enet_private, cc);
-	const struct platform_device_id *id_entry =
-		platform_get_device_id(fep->pdev);
 	u32 tempval;
 
 	tempval = readl(fep->hwp + FEC_ATIME_CTRL);
 	tempval |= FEC_T_CTRL_CAPTURE;
 	writel(tempval, fep->hwp + FEC_ATIME_CTRL);
 
-	if (id_entry->driver_data & FEC_QUIRK_BUG_CAPTURE)
+	if (fep->quirks & FEC_QUIRK_BUG_CAPTURE)
 		udelay(1);
 
 	return readl(fep->hwp + FEC_ATIME);
-- 
2.30.2

