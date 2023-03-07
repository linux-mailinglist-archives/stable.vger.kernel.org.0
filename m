Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8024E6AF4B8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbjCGTTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbjCGTSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:18:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64403C3E24
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:02:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC2F861522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B903C4339B;
        Tue,  7 Mar 2023 19:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215753;
        bh=nlSLG2/61Fvgh8HhWLfZ4Zmfdvr9oDK4xnaRNhrBHQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ak96GpXqYoxOnx6CNzOL3JKAGhTDmxrzSiic82o1263u3X/NdZVlM98Pa5aCbqzNP
         3MYqtOGC3Ca7YVTUW4T8zm3tpGFkdGJ+aiuBj7sT6BwjZ8ZrcX4+hYPrj9Y+fOvvGS
         t7qbJdnnVA8DY8FXP7qLvl0e8eqYEZQJ4LFI04pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Neill Kapron <nkapron@google.com>,
        Lee Jones <lee@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 332/567] phy: rockchip-typec: fix tcphy_get_mode error case
Date:   Tue,  7 Mar 2023 18:01:08 +0100
Message-Id: <20230307165920.283065057@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neill Kapron <nkapron@google.com>

[ Upstream commit 4ca651df07183e29cdad7272255e23aec0169a1b ]

The existing logic in tcphy_get_mode() can cause the phy to be
incorrectly configured to USB UFP or DisplayPort mode when
extcon_get_state returns an error code.

extcon_get_state() can return 0, 1, or a negative error code.

It is possible to get into the failing state with an extcon driver
which does not support the extcon connector id specified as the
second argument to extcon_get_state().

tcphy_get_mode()
->extcon_get_state()
-->find_cable_index_by_id()
--->return -EINVAL;

Fixes: e96be45cb84e ("phy: Add USB Type-C PHY driver for rk3399")
Signed-off-by: Neill Kapron <nkapron@google.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230126001013.3707873-1-nkapron@google.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-typec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-typec.c b/drivers/phy/rockchip/phy-rockchip-typec.c
index d2bbdc96a1672..5b9a254c45524 100644
--- a/drivers/phy/rockchip/phy-rockchip-typec.c
+++ b/drivers/phy/rockchip/phy-rockchip-typec.c
@@ -821,10 +821,10 @@ static int tcphy_get_mode(struct rockchip_typec_phy *tcphy)
 	mode = MODE_DFP_USB;
 	id = EXTCON_USB_HOST;
 
-	if (ufp) {
+	if (ufp > 0) {
 		mode = MODE_UFP_USB;
 		id = EXTCON_USB;
-	} else if (dp) {
+	} else if (dp > 0) {
 		mode = MODE_DFP_DP;
 		id = EXTCON_DISP_DP;
 
-- 
2.39.2



