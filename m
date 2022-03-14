Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686F64D82E4
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240880AbiCNMLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241535AbiCNMIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B074EF70;
        Mon, 14 Mar 2022 05:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B1616130F;
        Mon, 14 Mar 2022 12:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29757C340E9;
        Mon, 14 Mar 2022 12:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259524;
        bh=p4EKcTt07OqmThVWmyMD0BmzwIgGQvP1W3AY+ND+VVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6i8l4NhiMB/kHjKp21jh8SJ2E8D7qa2RRNOIMt1LTLu5+zl45MNz4gfMWJYB09r8
         XEjArXiFfIN8gC09WXrj//H2BvCIBRLaS+NMDBBtaDuuTT8dhG4sruVDWx7eCDvZLE
         ru79FdnYpFQbyfdCSIBJ7Rllyu77DVBT5/5fDnP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/110] ARM: dts: aspeed: Fix AST2600 quad spi group
Date:   Mon, 14 Mar 2022 12:53:29 +0100
Message-Id: <20220314112743.793035407@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit 2f6edb6bcb2f3f41d876e0eba2ba97f87a0296ea ]

Requesting quad mode for the FMC resulted in an error:

  &fmc {
         status = "okay";
 +       pinctrl-names = "default";
 +       pinctrl-0 = <&pinctrl_fwqspi_default>'

[    0.742963] aspeed-g6-pinctrl 1e6e2000.syscon:pinctrl: invalid function FWQSPID in map table
￼

This is because the quad mode pins are a group of pins, not a function.

After applying this patch we can request the pins and the QSPI data
lines are muxed:

 # cat /sys/kernel/debug/pinctrl/1e6e2000.syscon\:pinctrl-aspeed-g6-pinctrl/pinmux-pins |grep 1e620000.spi
 pin 196 (AE12): device 1e620000.spi function FWSPID group FWQSPID
 pin 197 (AF12): device 1e620000.spi function FWSPID group FWQSPID
 pin 240 (Y1): device 1e620000.spi function FWSPID group FWQSPID
 pin 241 (Y2): device 1e620000.spi function FWSPID group FWQSPID
 pin 242 (Y3): device 1e620000.spi function FWSPID group FWQSPID
 pin 243 (Y4): device 1e620000.spi function FWSPID group FWQSPID

Fixes: f510f04c8c83 ("ARM: dts: aspeed: Add AST2600 pinmux nodes")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Link: https://lore.kernel.org/r/20220304011010.974863-1-joel@jms.id.au
Link: https://lore.kernel.org/r/20220304011010.974863-1-joel@jms.id.au'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
index 6dde51c2aed3..e4775bbceecc 100644
--- a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
@@ -118,7 +118,7 @@ pinctrl_fwspid_default: fwspid_default {
 	};
 
 	pinctrl_fwqspid_default: fwqspid_default {
-		function = "FWQSPID";
+		function = "FWSPID";
 		groups = "FWQSPID";
 	};
 
-- 
2.34.1



