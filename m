Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6459F6AA36B
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbjCCV6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbjCCV6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:58:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677DD6C8A4;
        Fri,  3 Mar 2023 13:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 952A761899;
        Fri,  3 Mar 2023 21:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7B3C433EF;
        Fri,  3 Mar 2023 21:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880205;
        bh=rxUMK70MvtSzuzWFte5GlKjbu70mteuFz1d4DXEHADo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niyo2FfoI/uigNoJv/tvFzviPhWihQwMjf9eKdX3gfNEm9gP+C9NBRL6JOfzuDYeC
         znCoEfpoKyhpTzr1B6n1bPtxFIklaSiV+bya0O0QHIm7Z+dSnePTFxHpw2c4fTJzuH
         +yBPavbU03KWs9HU5KGfxn5oFsQRnjrdqD/3Z1OdSNDXQWRXJJ6lu3UbD3BXElGOme
         rsUq5z2FZ2DYVCa/EEz9nZtDndeX2rYA2RB8XAtVTLe+NhWFApOsMkCCSWtizVbKuY
         P/ngRHSs6ISSR0eTz4if9gHlBzV8JLlwLkOIj7OMF2Fa+n3ljMxNcyfn8UA9VgQeKW
         n9/VaIFdscm4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kishon@kernel.org, heiko@sntech.de, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 11/11] phy: rockchip-typec: Fix unsigned comparison with less than zero
Date:   Fri,  3 Mar 2023 16:49:37 -0500
Message-Id: <20230303214938.1454767-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214938.1454767-1-sashal@kernel.org>
References: <20230303214938.1454767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit f765c59c5a72546a2d74a92ae5d0eb0329d8e247 ]

The dp and ufp are defined as bool type, the return value type of
function extcon_get_state should be int, so the type of dp and ufp
are modified to int.

./drivers/phy/rockchip/phy-rockchip-typec.c:827:12-14: WARNING: Unsigned expression compared with zero: dp > 0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3962
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230213035709.99027-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-typec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-typec.c b/drivers/phy/rockchip/phy-rockchip-typec.c
index a958c9bced019..6e3916424012a 100644
--- a/drivers/phy/rockchip/phy-rockchip-typec.c
+++ b/drivers/phy/rockchip/phy-rockchip-typec.c
@@ -645,9 +645,8 @@ static int tcphy_get_mode(struct rockchip_typec_phy *tcphy)
 	struct extcon_dev *edev = tcphy->extcon;
 	union extcon_property_value property;
 	unsigned int id;
-	bool ufp, dp;
 	u8 mode;
-	int ret;
+	int ret, ufp, dp;
 
 	ufp = extcon_get_state(edev, EXTCON_USB);
 	dp = extcon_get_state(edev, EXTCON_DISP_DP);
-- 
2.39.2

