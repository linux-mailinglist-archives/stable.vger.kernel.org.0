Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0B64B45FE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbiBNJbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:31:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243504AbiBNJbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:31:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71497BF64;
        Mon, 14 Feb 2022 01:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05B5D60F8F;
        Mon, 14 Feb 2022 09:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9270C340EF;
        Mon, 14 Feb 2022 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831018;
        bh=nwAcgOvUUbyu0b9uqfYy5jUAsPqE5sOsSIj2K8lsWbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ny0O3+gUmhLJKOQYRXewrbFKp3kadr+oKHF59i9ihypUlnjJHGaRlbaYGIxzUphuP
         NskXIz24yXy/Cm8yVpxJYGNPJVZtzZRH0ygn00/rMcMZj+Ief71I9028hnn4oal4YN
         62q9rUF9dXhfynFXSF436ISb/mutVobPLdKL6xj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.14 18/44] ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group
Date:   Mon, 14 Feb 2022 10:25:41 +0100
Message-Id: <20220214092448.505375269@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 42c9b28e6862d16db82a56f5667cf4d1f6658cf6 upstream.

Currently, SD card fails to mount due to the following pinctrl error:

[   11.170000] imx23-pinctrl 80018000.pinctrl: pin SSP1_DETECT already requested by 80018000.pinctrl; cannot claim for 80010000.spi
[   11.180000] imx23-pinctrl 80018000.pinctrl: pin-65 (80010000.spi) status -22
[   11.190000] imx23-pinctrl 80018000.pinctrl: could not request pin 65 (SSP1_DETECT) from group mmc0-pins-fixup.0  on device 80018000.pinctrl
[   11.200000] mxs-mmc 80010000.spi: Error applying setting, reverse things back

Fix it by removing the MX23_PAD_SSP1_DETECT pin from the hog group as it
is already been used by the mmc0-pins-fixup pinctrl group.

With this change the rootfs can be mounted and the imx23-evk board can
boot successfully.

Cc: <stable@vger.kernel.org>
Fixes: bc3875f1a61e ("ARM: dts: mxs: modify mx23/mx28 dts files to use pinctrl headers")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx23-evk.dts |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm/boot/dts/imx23-evk.dts
+++ b/arch/arm/boot/dts/imx23-evk.dts
@@ -48,7 +48,6 @@
 						MX23_PAD_LCD_RESET__GPIO_1_18
 						MX23_PAD_PWM3__GPIO_1_29
 						MX23_PAD_PWM4__GPIO_1_30
-						MX23_PAD_SSP1_DETECT__SSP1_DETECT
 					>;
 					fsl,drive-strength = <MXS_DRIVE_4mA>;
 					fsl,voltage = <MXS_VOLTAGE_HIGH>;


