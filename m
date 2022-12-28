Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77F2658297
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiL1Qim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbiL1Qhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:37:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6281DA41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:33:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA43761576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F83C433EF;
        Wed, 28 Dec 2022 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245223;
        bh=QxSUR4nYeki/U9OxdIBOBvWP0VUu4Wb6oL8wXCjPKmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2y+9hteMkiSnqfypRcoGBt33BeSrjMc+dcDH6rjS0JZsRAykGPw7eGYMIYboKK7C
         GzD/Mr0kQapGPND0ipYodn+5JONZzjKLl552H6gYV9lwk0+sDkErlQ7OCUZqS5IK3b
         ciHQaX8OyjKiMvJhzixwf8jP8J3s8qn+HAkFLyds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0818/1146] phy: usb: Use slow clock for wake enabled suspend
Date:   Wed, 28 Dec 2022 15:39:17 +0100
Message-Id: <20221228144352.371246441@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Justin Chen <justinpopo6@gmail.com>

[ Upstream commit 700c44b508020a3ea29d297c677f8d4ab14b7e6a ]

The logic was incorrect when switching to slow clock. We want the slow
clock if wake_enabled is set.

Fixes: ae532b2b7aa5 ("phy: usb: Add "wake on" functionality for newer Synopsis XHCI controllers")
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/1665005418-15807-6-git-send-email-justinpopo6@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
index d2524b70ea16..b3386e458dd4 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -331,13 +331,12 @@ static void usb_uninit_common_7216(struct brcm_usb_init_params *params)
 
 	pr_debug("%s\n", __func__);
 
-	if (!params->wake_enabled) {
-		USB_CTRL_SET(ctrl, USB_PM, USB_PWRDN);
-
+	if (params->wake_enabled) {
 		/* Switch to using slower clock during suspend to save power */
 		USB_CTRL_SET(ctrl, USB_PM, XHC_S2_CLK_SWITCH_EN);
-	} else {
 		usb_wake_enable_7216(params, true);
+	} else {
+		USB_CTRL_SET(ctrl, USB_PM, USB_PWRDN);
 	}
 }
 
-- 
2.35.1



