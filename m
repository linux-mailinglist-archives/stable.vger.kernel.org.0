Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AFC3AEE7C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhFUQ3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhFUQ2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA774613D5;
        Mon, 21 Jun 2021 16:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292595;
        bh=WljdLn6tRNJfLSvBbkYFZ/02+HzyG99SGElEelraxj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLupuQ3DXKlo65rzHcfS9s0hx1wh8EUOoc3/Yf3+HWz7AcYRuBl8fqBu7gRsVZelf
         rad5QlN2omY77WhOmYYEu30dDpT+awZweVM8TxpnP301wB8Tdzl5mDQAkShQuc8kef
         im6VbdHUw/yLSwKhG+6OVpW5pG8e4dni2SXm2LHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/146] net: fec_ptp: fix issue caused by refactor the fec_devtype
Date:   Mon, 21 Jun 2021 18:14:49 +0200
Message-Id: <20210621154914.370644792@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1753807cbf97..ce8e5555f3e0 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -215,15 +215,13 @@ static u64 fec_ptp_read(const struct cyclecounter *cc)
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



