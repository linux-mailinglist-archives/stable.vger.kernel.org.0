Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B93593B50
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346828AbiHOUXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347258AbiHOUWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:22:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A97D4B484;
        Mon, 15 Aug 2022 12:01:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A611161296;
        Mon, 15 Aug 2022 19:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE9FC433C1;
        Mon, 15 Aug 2022 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590107;
        bh=EixTL5yY3x6DpFjd9mtu7FvtvO6e++FT6rEJn0V1IyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mELj2/O8LoJS+J1ZLgkGSJZ/Ah76W2DNdOybKARD0B+wgdBp0xzWgYT3ilp+3ZpBI
         aSq/5GZrnm9igxAgrQVQbcX8ww3qjFS9pE5F+Z96t+jScXAvGam3HmqNbhydSqwxG4
         /gQLlQXzbGpH8CJAuTPuXgXa7zrsDwKUMuLY0UrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0153/1095] ARM: dts: imx6ul: fix csi node compatible
Date:   Mon, 15 Aug 2022 19:52:32 +0200
Message-Id: <20220815180435.910855448@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit e0aca931a2c7c29c88ebf37f9c3cd045e083483d ]

"fsl,imx6ul-csi" was never listed as compatible to "fsl,imx7-csi", neither
in yaml bindings, nor previous txt binding. Remove the imx7 part. Fixes
the dt schema check warning:
csi@21c4000: compatible: 'oneOf' conditional failed, one must be fixed:
['fsl,imx6ul-csi', 'fsl,imx7-csi'] is too long
Additional items are not allowed ('fsl,imx7-csi' was unexpected)
'fsl,imx8mm-csi' was expected

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index df8b4ad62418..367657a9a99f 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -999,7 +999,7 @@ cpu_speed_grade: speed-grade@10 {
 			};
 
 			csi: csi@21c4000 {
-				compatible = "fsl,imx6ul-csi", "fsl,imx7-csi";
+				compatible = "fsl,imx6ul-csi";
 				reg = <0x021c4000 0x4000>;
 				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6UL_CLK_CSI>;
-- 
2.35.1



