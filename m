Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BED912C95F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbfL2SGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731665AbfL2Rti (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6608C206DB;
        Sun, 29 Dec 2019 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641777;
        bh=x2r+e3JdB2qUFXvnUBjJV4lqIGf/0i+xV8Ab4Od/bOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPfCmMnAczddwlyYiS38QPeiC03BPnHNuX4lD7wVQc14ReQc2uNLW+d+J7B+w0EQg
         ubs8Co5hP6xZND6eEtZJTa0r7hZ4p7cxh5lAFQDsuBax0osMUDnYgSOWFEGpPqu9+1
         kb6/fcVumTQjhcdTAUG1wtZV223AijazH/pF1vxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/434] phy: renesas: phy-rcar-gen2: Fix the array off by one warning
Date:   Sun, 29 Dec 2019 18:24:20 +0100
Message-Id: <20191229172715.577487969@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das@bp.renesas.com>

[ Upstream commit c9baab38fe0e28762d0d67611cbe2aef0fb3fc72 ]

Fix the below smatch warning by adding variable check rather than the
hardcoded value.
warn: array off by one? 'data->select_value[channel_num]'

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen2.c b/drivers/phy/renesas/phy-rcar-gen2.c
index 2926e4937301..2e279ac0fa4d 100644
--- a/drivers/phy/renesas/phy-rcar-gen2.c
+++ b/drivers/phy/renesas/phy-rcar-gen2.c
@@ -71,6 +71,7 @@ struct rcar_gen2_phy_driver {
 struct rcar_gen2_phy_data {
 	const struct phy_ops *gen2_phy_ops;
 	const u32 (*select_value)[PHYS_PER_CHANNEL];
+	const u32 num_channels;
 };
 
 static int rcar_gen2_phy_init(struct phy *p)
@@ -271,11 +272,13 @@ static const u32 usb20_select_value[][PHYS_PER_CHANNEL] = {
 static const struct rcar_gen2_phy_data rcar_gen2_usb_phy_data = {
 	.gen2_phy_ops = &rcar_gen2_phy_ops,
 	.select_value = pci_select_value,
+	.num_channels = ARRAY_SIZE(pci_select_value),
 };
 
 static const struct rcar_gen2_phy_data rz_g1c_usb_phy_data = {
 	.gen2_phy_ops = &rz_g1c_phy_ops,
 	.select_value = usb20_select_value,
+	.num_channels = ARRAY_SIZE(usb20_select_value),
 };
 
 static const struct of_device_id rcar_gen2_phy_match_table[] = {
@@ -389,7 +392,7 @@ static int rcar_gen2_phy_probe(struct platform_device *pdev)
 		channel->selected_phy = -1;
 
 		error = of_property_read_u32(np, "reg", &channel_num);
-		if (error || channel_num > 2) {
+		if (error || channel_num >= data->num_channels) {
 			dev_err(dev, "Invalid \"reg\" property\n");
 			of_node_put(np);
 			return error;
-- 
2.20.1



