Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21AD681141
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbjA3OLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbjA3OL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:11:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5533B3E0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8514161049
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CC1C433D2;
        Mon, 30 Jan 2023 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087886;
        bh=HXHQ3K+7VWf8N+rflSXKhLHMPLwqLCrk/zU4ysxEbnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtzlclOxTnBd9ARqzy5v4QB6Fx6KyDac0MmNfLwpnHPxlemxlO7ezzlwHwTZ5JcEj
         ceSsA3ZIynjXa6atcum/nvpdLSihcXFGPEKssxC7e77HQk44vndUomXhfG2pScBsdS
         EhEYE/JF8ZAdj6g6Di0dn+0MHbZWLAQBgot+4Zu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/204] arm64: dts: imx8mm-venice-gw7901: fix USB2 controller OC polarity
Date:   Mon, 30 Jan 2023 14:49:37 +0100
Message-Id: <20230130134316.843608187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit ae066f374687d7dd06bb8c732f66d6ab3c3fd480 ]

The GW7901 has USB2 routed to a USB VBUS supply with over-current
protection via an active-low pin. Define the OC pin polarity properly.

Fixes: 2b1649a83afc ("arm64: dts: imx: Add i.mx8mm Gateworks gw7901 dts support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
index bafd5c8ea4e2..f7e41e5c2c7b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
@@ -675,6 +675,7 @@ &usbotg1 {
 &usbotg2 {
 	dr_mode = "host";
 	vbus-supply = <&reg_usb2_vbus>;
+	over-current-active-low;
 	status = "okay";
 };
 
-- 
2.39.0



