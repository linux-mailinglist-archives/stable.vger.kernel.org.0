Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E635EA4F6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbiIZL4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238933AbiIZLyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF851CFFC;
        Mon, 26 Sep 2022 03:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 291C7B80171;
        Mon, 26 Sep 2022 10:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8409FC433D6;
        Mon, 26 Sep 2022 10:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189297;
        bh=9oFRFRIYT/AScc+7IeOp9jcmRxFBv+WVHTU+h3hZUaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgGgdIxIm50jzphqYoI1dFB7IHoaPWw3DNGlq7O9nzRtLpwv0SstXOU28Z1hFXpLT
         6bOeFdKEopMV1p84DUTS7wpOsqeFGtG0Bef0OttLnFs8DCeXLByCQMpScgGNnhb6KA
         bvELjwhrX1jFhSrxaIVgBAMYKWlN9iYyL4pAdRTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 098/207] arm64: dts: imx8mp-venice-gw74xx: fix CAN STBY polarity
Date:   Mon, 26 Sep 2022 12:11:27 +0200
Message-Id: <20220926100810.977543818@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit e4ef0885632ed485961ac0962ad01be4ec9ec658 ]

The CAN STBY poarlity is active-low. Specify it as such by removing the
'enable-active-high' property and updating the gpio property.

Fixes: 7899eb6cb15d ("arm64: dts: imx: Add i.MX8M Plus Gateworks gw7400 dts support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
index 6630ec561dc2..4c729ac89625 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw74xx.dts
@@ -123,8 +123,7 @@ reg_can2_stby: regulator-can2-stby {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_reg_can>;
 		regulator-name = "can2_stby";
-		gpio = <&gpio3 19 GPIO_ACTIVE_HIGH>;
-		enable-active-high;
+		gpio = <&gpio3 19 GPIO_ACTIVE_LOW>;
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 	};
-- 
2.35.1



