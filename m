Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A601969CC96
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjBTNmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjBTNmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:42:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CB81C7D4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:41:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6070F60CBA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB18C433EF;
        Mon, 20 Feb 2023 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900497;
        bh=3YA1cYvi95M4vnbDdWGKJkq432QkVDK4VS3Onenko7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGgsXyIK37/xTGqiOmVf1lNYwfxMVNtL/Pyh+3+xri1irpUalbHrAOfem+NFOpjIy
         t7UoqvuRUgLXjfdZDo3JM2GDCpnAn/RO3WPX8FZExnPHvaaghIuZC2KvtYPhWC2mi2
         wyYaeXKITHo+RrCuklHGFXwKWOsn8F9KfYj9hRHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jerome Brunet <jbrunet@baylibre.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/89] net: phy: meson-gxl: add g12a support
Date:   Mon, 20 Feb 2023 14:35:46 +0100
Message-Id: <20230220133554.788326637@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 5c3407abb3382fb0621a503662d00495f7ab65c4 ]

The g12a SoC family uses the type of internal PHY that was used on the
gxl family. The quirks of gxl family, like the LPA register corruption,
appear to have been resolved on this new SoC generation.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 69ff53e4a4c9 ("net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/meson-gxl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 7ceebbc4bcc21..e061dfa34ae0d 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -246,11 +246,22 @@ static struct phy_driver meson_gxl_phy[] = {
 		.config_intr	= meson_gxl_config_intr,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+	}, {
+		PHY_ID_MATCH_EXACT(0x01803301),
+		.name		= "Meson G12A Internal PHY",
+		.features	= PHY_BASIC_FEATURES,
+		.flags		= PHY_IS_INTERNAL,
+		.soft_reset     = genphy_soft_reset,
+		.ack_interrupt	= meson_gxl_ack_interrupt,
+		.config_intr	= meson_gxl_config_intr,
+		.suspend        = genphy_suspend,
+		.resume         = genphy_resume,
 	},
 };
 
 static struct mdio_device_id __maybe_unused meson_gxl_tbl[] = {
 	{ 0x01814400, 0xfffffff0 },
+	{ PHY_ID_MATCH_VENDOR(0x01803301) },
 	{ }
 };
 
-- 
2.39.0



