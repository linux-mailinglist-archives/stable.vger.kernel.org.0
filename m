Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B732356FB73
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbiGKJay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiGKJaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:30:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5717C71706;
        Mon, 11 Jul 2022 02:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39E92B80DB7;
        Mon, 11 Jul 2022 09:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93531C34115;
        Mon, 11 Jul 2022 09:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530999;
        bh=xJbSYnmH/54BOp4rxr0Fm4HlFwlIftTdla6newmm24M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfXvE5PdqKPnSXReKP8ntnszD4bxOApJQa0a5XQJ3m+6pGGeKhipoFCpJcDw/rL4o
         m8mTy61WpEr7CJz740VcfqAEkuprW/T/K69i9oKfZiD6oaX19fL6CDgtahoDIlswcT
         vYBLoRPtdy2pVcmxaFp3gQf3WlKldhkjj0WBnZOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 060/112] arm64: dts: imx8mp-evk: correct vbus pad settings
Date:   Mon, 11 Jul 2022 11:07:00 +0200
Message-Id: <20220711090551.276566045@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit e2c00820a99c55c9bb40642d5818a904a1e0d664 ]

0x19 is not a valid setting. According to RM bit layout, BIT3 and BIT0
are reserved.
  8  7   6   5   4   3  2 1  0
 PE HYS PUE ODE FSEL X  DSE  X

Not set reserved bit.

Fixes: 43da4f92a611 ("arm64: dts: imx8mp-evk: enable usb1 as host mode")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index 4ff75c4cbddc..a28ce8af61bd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -513,7 +513,7 @@
 
 	pinctrl_usb1_vbus: usb1grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO14__USB2_OTG_PWR	0x19
+			MX8MP_IOMUXC_GPIO1_IO14__USB2_OTG_PWR	0x10
 		>;
 	};
 
-- 
2.35.1



