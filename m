Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264182F335
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbfE3E1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729831AbfE3DOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:21 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56F7E2455C;
        Thu, 30 May 2019 03:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186061;
        bh=LUA98mtYbLoFF5SBGBxmbooAGm/0s25pCjeNGGv4PpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IM006jd649+7jBfOmexSHxLaadh/eiPrMlY91wWnqW50uQIa/rP3s0iJyS2MLV8qN
         GRb6gfrJJtvZoau27/nnbOC/kJ6d5EcamIXoW/XGdCw745E5EPQfyTiAtZ61Shx2Vj
         gbcac7roH5ukaBZQKEQf2N2n1NWYkjOsHPqjn9i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 168/346] phy: sun4i-usb: Make sure to disable PHY0 passby for peripheral mode
Date:   Wed, 29 May 2019 20:04:01 -0700
Message-Id: <20190530030549.669050168@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e6f32efb1b128344a2c7df9875bc1a1abaa1d395 ]

On platforms where the MUSB and HCI controllers share PHY0, PHY passby
is required when using the HCI controller with the PHY, but it must be
disabled when the MUSB controller is used instead.

Without this, PHY0 passby is always enabled, which results in broken
peripheral mode on such platforms (e.g. H3/H5).

Fixes: ba4bdc9e1dc0 ("PHY: sunxi: Add driver for sunxi usb phy")

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/allwinner/phy-sun4i-usb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/phy/allwinner/phy-sun4i-usb.c b/drivers/phy/allwinner/phy-sun4i-usb.c
index 4bbd9ede38c83..cc5af961778d6 100644
--- a/drivers/phy/allwinner/phy-sun4i-usb.c
+++ b/drivers/phy/allwinner/phy-sun4i-usb.c
@@ -554,6 +554,7 @@ static void sun4i_usb_phy0_id_vbus_det_scan(struct work_struct *work)
 	struct sun4i_usb_phy_data *data =
 		container_of(work, struct sun4i_usb_phy_data, detect.work);
 	struct phy *phy0 = data->phys[0].phy;
+	struct sun4i_usb_phy *phy = phy_get_drvdata(phy0);
 	bool force_session_end, id_notify = false, vbus_notify = false;
 	int id_det, vbus_det;
 
@@ -610,6 +611,9 @@ static void sun4i_usb_phy0_id_vbus_det_scan(struct work_struct *work)
 			mutex_unlock(&phy0->mutex);
 		}
 
+		/* Enable PHY0 passby for host mode only. */
+		sun4i_usb_phy_passby(phy, !id_det);
+
 		/* Re-route PHY0 if necessary */
 		if (data->cfg->phy0_dual_route)
 			sun4i_usb_phy0_reroute(data, id_det);
-- 
2.20.1



