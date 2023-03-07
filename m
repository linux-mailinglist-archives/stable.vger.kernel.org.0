Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59966AEB28
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjCGRkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjCGRk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:40:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856599F05B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:36:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34AF4B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726BAC433D2;
        Tue,  7 Mar 2023 17:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210594;
        bh=7yWxaMxHdI68XXXm8a7ajbUrP39xIKgSSg6qiaqnVr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7CuqmySIdDPYsRgGHaQjpMy/I2gNNMam3q7Y70zuGaC/ldBlOauy6LSlkGau9/m+
         NKljsoDfUS3oElyO9E5wV7w601m0o1YtTqSADs1LmiF53zq6yny3bG7MwXyz9eDV35
         KVRVJOjM5ve9cuUIFusebo+3QqbAiT5WZv+QsNck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Neill Kapron <nkapron@google.com>,
        Lee Jones <lee@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0560/1001] phy: rockchip-typec: fix tcphy_get_mode error case
Date:   Tue,  7 Mar 2023 17:55:32 +0100
Message-Id: <20230307170045.779697102@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



