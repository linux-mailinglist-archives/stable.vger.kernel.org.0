Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F1369CD2C
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjBTNrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjBTNrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:47:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7EA1E1C8
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:46:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F08A60C03
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E4BC433EF;
        Mon, 20 Feb 2023 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900817;
        bh=8hRCDvWrHjQaw+mLJCbtZcE2R4q5fq8DiJjB7kBomkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy7iKZRokEgsP9tf01CrlOY3gShKRRChMliA450GBBv1QMiIEcnzk2R7pMp10JnFo
         78Laos8/wlvUvNsnbIeeytAW0zvMrU1LeswnOEDOZM1yOJzi/m/7BsVR7rwwNlt26g
         vZajSchxx6CGOUoIPykC9ANd32QrFrq8/IG7FJTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jerome Brunet <jbrunet@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/156] net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY
Date:   Mon, 20 Feb 2023 14:35:15 +0100
Message-Id: <20230220133605.342208478@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 69ff53e4a4c9498eeed7d1441f68a1481dc69251 ]

Jerome provided the information that also the GXL internal PHY doesn't
support MMD register access and EEE. MMD reads return 0xffff, what
results in e.g. completely wrong ethtool --show-eee output.
Therefore use the MMD dummy stubs.

Fixes: d853d145ea3e ("net: phy: add an option to disable EEE advertisement")
Suggested-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/84432fe4-0be4-bc82-4e5c-557206b40f56@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/meson-gxl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index f7a9e6599a642..39151ec6f65e2 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -235,6 +235,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.config_intr	= meson_gxl_config_intr,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	}, {
 		PHY_ID_MATCH_EXACT(0x01803301),
 		.name		= "Meson G12A Internal PHY",
-- 
2.39.0



