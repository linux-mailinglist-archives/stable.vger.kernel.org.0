Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAAA412590
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384013AbhITSqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382807AbhITSm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5DBA63344;
        Mon, 20 Sep 2021 17:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159118;
        bh=G0yWxee8sWhPe+DfRiOp12xOteHQ5FHmPimc8+eYH0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfaxTGlfF5KKrVyYVnyQPWBr+fKpZJ6UCqE5pf+4iO3U4ari4sFYJjjahI3cuVMyD
         sSNJ6pLZEY5tAzjTM5rE387aQKNmSVwVMTbk3eFqhyxRnqrz54jAH1H/aPuku+BGV9
         IrPaXlCMxY/GwqT5FrixLci/ehXBchGwoQFZribE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 084/168] net: dsa: lantiq_gswip: Add 200ms assert delay
Date:   Mon, 20 Sep 2021 18:43:42 +0200
Message-Id: <20210920163924.397678210@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 111b64e35ea03d58c882832744f571a88bb2e2e2 ]

The delay is especially needed by the xRX300 and xRX330 SoCs. Without
this patch, some phys are sometimes not properly detected.

The patch was tested on BT Home Hub 5A and D-Link DWR-966.

Fixes: a09d042b0862 ("net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 64d6dfa83122..267324889dd6 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1885,6 +1885,12 @@ static int gswip_gphy_fw_load(struct gswip_priv *priv, struct gswip_gphy_fw *gph
 
 	reset_control_assert(gphy_fw->reset);
 
+	/* The vendor BSP uses a 200ms delay after asserting the reset line.
+	 * Without this some users are observing that the PHY is not coming up
+	 * on the MDIO bus.
+	 */
+	msleep(200);
+
 	ret = request_firmware(&fw, gphy_fw->fw_name, dev);
 	if (ret) {
 		dev_err(dev, "failed to load firmware: %s, error: %i\n",
-- 
2.30.2



