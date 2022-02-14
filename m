Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899E34B45B4
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242978AbiBNJ22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:28:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242973AbiBNJ2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0260AAD;
        Mon, 14 Feb 2022 01:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC764B80DC4;
        Mon, 14 Feb 2022 09:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B30C340E9;
        Mon, 14 Feb 2022 09:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830893;
        bh=nwAcgOvUUbyu0b9uqfYy5jUAsPqE5sOsSIj2K8lsWbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EEzO5aoNTzMzQ+AKZjKGpCWLNC6DCqdqIiH860fhKEIOEq9pXuwDpuYIfzPb1oyol
         tywA4VCSomF6xGX/HLgwvEfKhSl4NjYEd5179MVxCls7qdEMDxBHOS39OmDZVQZm+j
         +9czlQOncz1nFd937IA6SrLMA9793jPRnkGaSDQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.9 14/34] ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group
Date:   Mon, 14 Feb 2022 10:25:40 +0100
Message-Id: <20220214092446.409556338@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
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


