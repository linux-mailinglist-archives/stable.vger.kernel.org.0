Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D3B505686
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242713AbiDRNjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244176AbiDRNjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:39:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997B42B24B;
        Mon, 18 Apr 2022 05:58:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 808BEB80EE1;
        Mon, 18 Apr 2022 12:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D92C385BA;
        Mon, 18 Apr 2022 12:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286718;
        bh=1QRcX/A4WIcaruqASXRf3Sm4GWxpgwIVhPZdk2Sj+Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5RqGEehNlKMwWJHP0nVB4rJJ5hvLZU1Mrkyd/r8QwHMUuCKwY4AqANgJAE+AYHCO
         L0PDc/lFPrjtXWaBI59hC729L0rWm3m7q97yFI9onLHP5PJjK12xyDgF4VDMBNYKVA
         jCLRxaaCrQABiFchwLLwe2oUu44E6MzzqCRa4UNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 224/284] usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm
Date:   Mon, 18 Apr 2022 14:13:25 +0200
Message-Id: <20220418121218.081164118@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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

From: H. Nikolaus Schaller <hns@goldelico.com>

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
index 830ef7333750..6fbaa0d1bcd2 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -245,7 +245,7 @@ static void dwc3_omap_set_mailbox(struct dwc3_omap *omap,
 		break;
 
 	case OMAP_DWC3_ID_FLOAT:
-		if (omap->vbus_reg)
+		if (omap->vbus_reg && regulator_is_enabled(omap->vbus_reg))
 			regulator_disable(omap->vbus_reg);
 		val = dwc3_omap_read_utmi_ctrl(omap);
 		val |= USBOTGSS_UTMI_OTG_CTRL_IDDIG;
-- 
2.35.1



