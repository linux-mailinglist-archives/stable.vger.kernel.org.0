Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC56AF086
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjCGSbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjCGSap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:30:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325BEAA26A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:24:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAA98B819D6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15915C433EF;
        Tue,  7 Mar 2023 18:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213444;
        bh=7yWxaMxHdI68XXXm8a7ajbUrP39xIKgSSg6qiaqnVr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBxmEY87sH4kOLlNAJgT/h5+o/N1e2owI+pWT4FbVwLBSqqKVCMwjhj3V9c+j/D6m
         HjI/FMpHlwN70y5kQvcsGBORpM5iRVac3HPf6frnKiRlLOY1SErIMxglo94bWYjkOk
         yPzABaTXT5WKMQtN3lRhhOgBIy8RqxeXoOJI65wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Neill Kapron <nkapron@google.com>,
        Lee Jones <lee@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 479/885] phy: rockchip-typec: fix tcphy_get_mode error case
Date:   Tue,  7 Mar 2023 17:56:53 +0100
Message-Id: <20230307170023.293754404@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index d76440ae10ff4..6aea512e5d4ee 100644
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



