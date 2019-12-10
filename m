Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8D611969F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfLJVKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbfLJVKb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15C78246AF;
        Tue, 10 Dec 2019 21:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012231;
        bh=aC3eF3AXy1D1tdrKUgWEMgfafwOFEfwvJ0RSRxPOri8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgNDheJT2t4UbySnwFMde2nXRrLOBenU7Z2BwQc8t+r4qRej4u9zidKW8a5UB7hiz
         6U5tJ9thYK9EmlR8yqSPHgy6Xljua2SxJK+ozKhSG3+YiZNsKr+DukdsILU117pfAA
         lduHAMHY3z/Am++6E6kXmMinmDxAlw+iEM4LjnrU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das@bp.renesas.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 180/350] phy: renesas: phy-rcar-gen2: Fix the array off by one warning
Date:   Tue, 10 Dec 2019 16:04:45 -0500
Message-Id: <20191210210735.9077-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2926e49373017..2e279ac0fa4d6 100644
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

