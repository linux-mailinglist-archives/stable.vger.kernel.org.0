Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E68069CD0A
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjBTNpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjBTNpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:45:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54841DBA6
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:45:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5400E60EAE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6BCC4339B;
        Mon, 20 Feb 2023 13:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900720;
        bh=8hRMQ6bZQJsw02+QUUXFgA84wnwQFFFcs0e9GmSIC4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AznMI/+YrIl8jCKX+Ehiij+tHZMcjoXKN/qYIxYX2zznivStSKmH79SGLvxnSpUej
         1IrqBwm6QFM//xz72hdvpnKXhx9XFbGuZJiXkEgJVJF4XcUhBAWhWK/esPPmz5humq
         fz6ftNa7pmdeanwPyuiDeCSClyedJoXgZajlminY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <healych@amazon.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/156] net: phy: meson-gxl: Add generic dummy stubs for MMD register access
Date:   Mon, 20 Feb 2023 14:34:17 +0100
Message-Id: <20230220133603.021263041@linuxfoundation.org>
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

From: Chris Healy <healych@amazon.com>

[ Upstream commit afc2336f89dc0fc0ef25b92366814524b0fd90fb ]

The Meson G12A Internal PHY does not support standard IEEE MMD extended
register access, therefore add generic dummy stubs to fail the read and
write MMD calls. This is necessary to prevent the core PHY code from
erroneously believing that EEE is supported by this PHY even though this
PHY does not support EEE, as MMD register access returns all FFFFs.

Fixes: 5c3407abb338 ("net: phy: meson-gxl: add g12a support")
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Chris Healy <healych@amazon.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20230130231402.471493-1-cphealy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/meson-gxl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index e8f2ca625837..f7a9e6599a64 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -245,6 +245,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.config_intr	= meson_gxl_config_intr,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	},
 };
 
-- 
2.39.0



