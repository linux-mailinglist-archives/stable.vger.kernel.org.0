Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A9360A742
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbiJXMsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbiJXMp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AB31B799;
        Mon, 24 Oct 2022 05:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51C1E61252;
        Mon, 24 Oct 2022 12:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67104C433C1;
        Mon, 24 Oct 2022 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613379;
        bh=RLkQdPDMRCOU/IECOAC2hHaLhoeqjEyfi9vzRWGTaUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBdXLzuprUjmSy2/h4z7DVI6w3/K1BFFhIV8/jcg49NL1xSI2mI/pkFrFnBc1lz23
         Ce8pBwkFqQVd7u8PMw4bv2LPttXEmKjBvh63yin1rKhkHlgruNfUq6VTawaANHBABv
         6f+2mWZMSBHzINJX2s6iA+C8huE2DcHqembXJ7ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/255] ARM: dts: kirkwood: lsxl: remove first ethernet port
Date:   Mon, 24 Oct 2022 13:30:24 +0200
Message-Id: <20221024113006.284226360@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 2d528eda7c96ce5c70f895854ecd5684bd5d80b9 ]

Both the Linkstation LS-CHLv2 and the LS-XHL have only one ethernet
port. This has always been wrong, i.e. the board code used to set up
both ports, but the driver will play nice and return -ENODEV if the
assiciated PHY is not found. Nevertheless, it is wrong. Remove it.

Fixes: 876e23333511 ("ARM: kirkwood: add gigabit ethernet and mvmdio device tree nodes")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/kirkwood-lsxl.dtsi | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-lsxl.dtsi b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
index 321a40a98ed2..88b70ba1c8fe 100644
--- a/arch/arm/boot/dts/kirkwood-lsxl.dtsi
+++ b/arch/arm/boot/dts/kirkwood-lsxl.dtsi
@@ -218,22 +218,11 @@
 &mdio {
 	status = "okay";
 
-	ethphy0: ethernet-phy@0 {
-		reg = <0>;
-	};
-
 	ethphy1: ethernet-phy@8 {
 		reg = <8>;
 	};
 };
 
-&eth0 {
-	status = "okay";
-	ethernet0-port@0 {
-		phy-handle = <&ethphy0>;
-	};
-};
-
 &eth1 {
 	status = "okay";
 	ethernet1-port@0 {
-- 
2.35.1



