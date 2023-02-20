Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D0069CC98
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjBTNmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbjBTNmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:42:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2202F1D902
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:41:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B466E60EA6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C496AC433EF;
        Mon, 20 Feb 2023 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900503;
        bh=FF+2G2gwvXAg77M93MFw7r//bbNldVUQk9ivowm48Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5AM3xlrsm9Q6XHQfl3gwpuUsxX5kJRdU/BAND2GwFJvMDXYlR/pFDfhTbkfzh/hS
         +cFgXy6T8YKZ+FG1RsOjAc52kW6n/Mqyu5t4fgDGjtHTA2xa1tjV516mrg4tpU6Gsq
         wOXDkkH+B6gmj5f+Y07nLFeBH/lDIB/L81O03z6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jerome Brunet <jbrunet@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/89] net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY
Date:   Mon, 20 Feb 2023 14:35:47 +0100
Message-Id: <20230220133554.822781692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index e061dfa34ae0d..b6436e7dabbc6 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -246,6 +246,8 @@ static struct phy_driver meson_gxl_phy[] = {
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



