Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F1F35BDA6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238622AbhDLIwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238824AbhDLIuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7520960241;
        Mon, 12 Apr 2021 08:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217437;
        bh=5dUKah1bdQNvIoxcur52AVkECx1VtD2HMvMx/M/8RKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc6/+5rUCN9mHdFCCbFZgK6nvfpqxNneC748smf9z6ziUHU+Nn2AsbKclahtY0/E5
         M+mo7Ge0OrUG6cxyRRC5ATBzwLV7RAlgHhxmEjm3aLYe2ZatzfC5eMY4SfczWJDyoM
         J2rFXFA+qvvWgJnPcSQnv/ThT4oMzYkdK4ykFXS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 015/188] net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock
Date:   Mon, 12 Apr 2021 10:38:49 +0200
Message-Id: <20210412084014.162672229@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit 3e6fdeb28f4c331acbd27bdb0effc4befd4ef8e8 upstream.

The xMII interface clock depends on the PHY interface (MII, RMII, RGMII)
as well as the current link speed. Explicitly configure the GSWIP to
automatically select the appropriate xMII interface clock.

This fixes an issue seen by some users where ports using an external
RMII or RGMII PHY were deaf (no RX or TX traffic could be seen). Most
likely this is due to an "invalid" xMII clock being selected either by
the bootloader or hardware-defaults.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -811,10 +811,15 @@ static int gswip_setup(struct dsa_switch
 	/* Configure the MDIO Clock 2.5 MHz */
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
-	/* Disable the xMII link */
-	for (i = 0; i < priv->hw_info->max_ports; i++)
+	for (i = 0; i < priv->hw_info->max_ports; i++) {
+		/* Disable the xMII link */
 		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
 
+		/* Automatically select the xMII interface clock */
+		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_RATE_MASK,
+				   GSWIP_MII_CFG_RATE_AUTO, i);
+	}
+
 	/* enable special tag insertion on cpu port */
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
 			  GSWIP_FDMA_PCTRLp(cpu_port));


