Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F61218B6B4
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbgCSN0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbgCSN0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:26:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0776207FC;
        Thu, 19 Mar 2020 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624373;
        bh=1dSUJg0oKYYNWkqUqhi26j4u7MPwVcWmQRJ7yr6Z41E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmOqPyQ63xOZcYaIzUnDXS0eiUb2xOLxDGjfdvffY9L69zAwrtj5gnSmtrsaA1y4f
         +YaFPBLJAsQKnOCrHH2EELNtEEj5xxtjCwzZF5N69vHGyDK4kkejVAok5HTQprlkDs
         ymFZj3R2DyqmPw0POh7d8GA21CpAY6UCmt5bIJ7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 40/65] net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed
Date:   Thu, 19 Mar 2020 14:04:22 +0100
Message-Id: <20200319123939.199190560@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit 402482a6a78e5c61d8a2ec6311fc5b4aca392cd6 ]

Outdated Raspberry Pi 4 firmware might configure the external PHY as
rgmii although the kernel currently sets it as rgmii-rxid. This makes
connections unreliable as ID_MODE_DIS is left enabled. To avoid this,
explicitly clear that bit whenever we don't need it.

Fixes: da38802211cc ("net: bcmgenet: Add RGMII_RXID support")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 6392a25301838..10244941a7a60 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -294,6 +294,7 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 	 */
 	if (priv->ext_phy) {
 		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
+		reg &= ~ID_MODE_DIS;
 		reg |= id_mode_dis;
 		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
 			reg |= RGMII_MODE_EN_V123;
-- 
2.20.1



