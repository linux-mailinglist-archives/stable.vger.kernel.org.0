Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADC64EF2A9
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352847AbiDAPIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350504AbiDAPAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E68B5AECA;
        Fri,  1 Apr 2022 07:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B77F60C9B;
        Fri,  1 Apr 2022 14:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A8FC340EE;
        Fri,  1 Apr 2022 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824436;
        bh=m412H6kIN8dB47Jcoa1RdOziUEgVS7D2/x57PF8Y9AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsVgjFhZqJxJIbs1SrFCYp3zniL5WJi9hshKXbv76bbliBjIBqQvz0FIOiI1by/6U
         xUle3y3yPTEPRdElq7LRBMNAm626VqYz5CekaQnAJjTekU8kuRvOt9wcSn0MnOVj74
         4aSPm0F+Fa9wrb68zWSxUqELsjsKesTTYqDdX29gvPgNuCoDXN+cpg75wXSgEBrcm6
         nUcDgAKAfYHVn818GJjE2edCB/gVyN6W30iLuDZ8ZasZ57REWUyIWLOeC0u8dxfQe+
         I2Zr7B3PJmjLIaPiFWJSUl0ivMVM+Cqe0YZWHJxR7fpUPvehIs2K3+7cv2HD6D8iBu
         8WN05+SWXtqPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, balbi@kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 25/29] usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm
Date:   Fri,  1 Apr 2022 10:46:08 -0400
Message-Id: <20220401144612.1955177-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144612.1955177-1-sashal@kernel.org>
References: <20220401144612.1955177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "H. Nikolaus Schaller" <hns@goldelico.com>

[ Upstream commit ac01df343e5a6c6bcead2ed421af1fde30f73e7e ]

Usually, the vbus_regulator (smps10 on omap5evm) boots up disabled.

Hence calling regulator_disable() indirectly through dwc3_omap_set_mailbox()
during probe leads to:

[   10.332764] WARNING: CPU: 0 PID: 1628 at drivers/regulator/core.c:2853 _regulator_disable+0x40/0x164
[   10.351919] unbalanced disables for smps10_out1
[   10.361298] Modules linked in: dwc3_omap(+) clk_twl6040 at24 gpio_twl6040 palmas_gpadc palmas_pwrbutton
industrialio snd_soc_omap_mcbsp(+) snd_soc_ti_sdma display_connector ti_tpd12s015 drm leds_gpio
drm_panel_orientation_quirks ip_tables x_tables ipv6 autofs4
[   10.387818] CPU: 0 PID: 1628 Comm: systemd-udevd Not tainted 5.17.0-rc1-letux-lpae+ #8139
[   10.405129] Hardware name: Generic OMAP5 (Flattened Device Tree)
[   10.411455]  unwind_backtrace from show_stack+0x10/0x14
[   10.416970]  show_stack from dump_stack_lvl+0x40/0x4c
[   10.422313]  dump_stack_lvl from __warn+0xb8/0x170
[   10.427377]  __warn from warn_slowpath_fmt+0x70/0x9c
[   10.432595]  warn_slowpath_fmt from _regulator_disable+0x40/0x164
[   10.439037]  _regulator_disable from regulator_disable+0x30/0x64
[   10.445382]  regulator_disable from dwc3_omap_set_mailbox+0x8c/0xf0 [dwc3_omap]
[   10.453116]  dwc3_omap_set_mailbox [dwc3_omap] from dwc3_omap_probe+0x2b8/0x394 [dwc3_omap]
[   10.467021]  dwc3_omap_probe [dwc3_omap] from platform_probe+0x58/0xa8
[   10.481762]  platform_probe from really_probe+0x168/0x2fc
[   10.481782]  really_probe from __driver_probe_device+0xc4/0xd8
[   10.481782]  __driver_probe_device from driver_probe_device+0x24/0xa4
[   10.503762]  driver_probe_device from __driver_attach+0xc4/0xd8
[   10.510018]  __driver_attach from bus_for_each_dev+0x64/0xa0
[   10.516001]  bus_for_each_dev from bus_add_driver+0x148/0x1a4
[   10.524880]  bus_add_driver from driver_register+0xb4/0xf8
[   10.530678]  driver_register from do_one_initcall+0x90/0x1c4
[   10.536661]  do_one_initcall from do_init_module+0x4c/0x200
[   10.536683]  do_init_module from load_module+0x13dc/0x1910
[   10.551159]  load_module from sys_finit_module+0xc8/0xd8
[   10.561319]  sys_finit_module from __sys_trace_return+0x0/0x18
[   10.561336] Exception stack(0xc344bfa8 to 0xc344bff0)
[   10.561341] bfa0:                   b6fb5778 b6fab8d8 00000007 b6ecfbb8 00000000 b6ed0398
[   10.561341] bfc0: b6fb5778 b6fab8d8 855c0500 0000017b 00020000 b6f9a3cc 00000000 b6fb5778
[   10.595500] bfe0: bede18f8 bede18e8 b6ec9aeb b6dda1c2
[   10.601345] ---[ end trace 0000000000000000 ]---

Fix this unnecessary warning by checking if the regulator is enabled.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://lore.kernel.org/r/af3b750dc2265d875deaabcf5f80098c9645da45.1646744616.git.hns@goldelico.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 0dfb710f48b5..0b800bc6150d 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -237,7 +237,7 @@ static void dwc3_omap_set_mailbox(struct dwc3_omap *omap,
 		break;
 
 	case OMAP_DWC3_ID_FLOAT:
-		if (omap->vbus_reg)
+		if (omap->vbus_reg && regulator_is_enabled(omap->vbus_reg))
 			regulator_disable(omap->vbus_reg);
 		val = dwc3_omap_read_utmi_ctrl(omap);
 		val |= USBOTGSS_UTMI_OTG_CTRL_IDDIG;
-- 
2.34.1

