Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5786227C74E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbgI2Lw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730619AbgI2LrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:47:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA753208B8;
        Tue, 29 Sep 2020 11:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380029;
        bh=2u+W+Nwpm0wasmw6uAfef1aBHKvMSSs/OI59KwFlWi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYnipV+lEokxqLq4qyoa5VrwTCHMAs7Fx3gBWy/fGtmn3mGc4+NLvEojPSpcghNVB
         PJpoC49eAaUj4wEY1WQRQeAwLPTb9b+wWgQ00GLm/0Bt/j6C07/Rl8nDwj5GkPbSF5
         LSQc9a0fqOJYV/5BzgQMucKTlvFQ5XMoWAxp0/Rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 36/99] drm/vc4/vc4_hdmi: fill ASoC card owner
Date:   Tue, 29 Sep 2020 13:01:19 +0200
Message-Id: <20200929105931.512197267@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit ec653df2a0cbc306a4bfcb0e3484d318fa779002 ]

card->owner is a required property and since commit 81033c6b584b ("ALSA:
core: Warn on empty module") a warning is issued if it is empty. Fix lack
of it. This fixes following warning observed on RaspberryPi 3B board
with ARM 32bit kernel and multi_v7_defconfig:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 210 at sound/core/init.c:207 snd_card_new+0x378/0x398 [snd]
Modules linked in: vc4(+) snd_soc_core ac97_bus snd_pcm_dmaengine bluetooth snd_pcm snd_timer crc32_arm_ce raspberrypi_hwmon snd soundcore ecdh_generic ecc bcm2835_thermal phy_generic
CPU: 1 PID: 210 Comm: systemd-udevd Not tainted 5.8.0-rc1-00027-g81033c6b584b #1087
Hardware name: BCM2835
[<c03113c0>] (unwind_backtrace) from [<c030bcb4>] (show_stack+0x10/0x14)
[<c030bcb4>] (show_stack) from [<c071cef8>] (dump_stack+0xd4/0xe8)
[<c071cef8>] (dump_stack) from [<c0345bfc>] (__warn+0xdc/0xf4)
[<c0345bfc>] (__warn) from [<c0345cc4>] (warn_slowpath_fmt+0xb0/0xb8)
[<c0345cc4>] (warn_slowpath_fmt) from [<bf02ff74>] (snd_card_new+0x378/0x398 [snd])
[<bf02ff74>] (snd_card_new [snd]) from [<bf11f0b4>] (snd_soc_bind_card+0x280/0x99c [snd_soc_core])
[<bf11f0b4>] (snd_soc_bind_card [snd_soc_core]) from [<bf12f000>] (devm_snd_soc_register_card+0x34/0x6c [snd_soc_core])
[<bf12f000>] (devm_snd_soc_register_card [snd_soc_core]) from [<bf165654>] (vc4_hdmi_bind+0x43c/0x5f4 [vc4])
[<bf165654>] (vc4_hdmi_bind [vc4]) from [<c09d660c>] (component_bind_all+0xec/0x24c)
[<c09d660c>] (component_bind_all) from [<bf15c44c>] (vc4_drm_bind+0xd4/0x174 [vc4])
[<bf15c44c>] (vc4_drm_bind [vc4]) from [<c09d6ac0>] (try_to_bring_up_master+0x160/0x1b0)
[<c09d6ac0>] (try_to_bring_up_master) from [<c09d6f38>] (component_master_add_with_match+0xd0/0x104)
[<c09d6f38>] (component_master_add_with_match) from [<bf15c588>] (vc4_platform_drm_probe+0x9c/0xbc [vc4])
[<bf15c588>] (vc4_platform_drm_probe [vc4]) from [<c09df740>] (platform_drv_probe+0x6c/0xa4)
[<c09df740>] (platform_drv_probe) from [<c09dd6f0>] (really_probe+0x210/0x350)
[<c09dd6f0>] (really_probe) from [<c09dd940>] (driver_probe_device+0x5c/0xb4)
[<c09dd940>] (driver_probe_device) from [<c09ddb38>] (device_driver_attach+0x58/0x60)
[<c09ddb38>] (device_driver_attach) from [<c09ddbc0>] (__driver_attach+0x80/0xbc)
[<c09ddbc0>] (__driver_attach) from [<c09db820>] (bus_for_each_dev+0x68/0xb4)
[<c09db820>] (bus_for_each_dev) from [<c09dc9f8>] (bus_add_driver+0x130/0x1e8)
[<c09dc9f8>] (bus_add_driver) from [<c09de648>] (driver_register+0x78/0x110)
[<c09de648>] (driver_register) from [<c0302038>] (do_one_initcall+0x50/0x220)
[<c0302038>] (do_one_initcall) from [<c03db544>] (do_init_module+0x60/0x210)
[<c03db544>] (do_init_module) from [<c03da4f8>] (load_module+0x1e34/0x2338)
[<c03da4f8>] (load_module) from [<c03dac00>] (sys_finit_module+0xac/0xbc)
[<c03dac00>] (sys_finit_module) from [<c03000c0>] (ret_fast_syscall+0x0/0x54)
Exception stack(0xeded9fa8 to 0xeded9ff0)
...
---[ end trace 6414689569c2bc08 ]---

Fixes: bb7d78568814 ("drm/vc4: Add HDMI audio support")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200701073949.28941-1-m.szyprowski@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 625bfcf52dc4d..bdcc54c87d7e8 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1117,6 +1117,7 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *hdmi)
 	card->num_links = 1;
 	card->name = "vc4-hdmi";
 	card->dev = dev;
+	card->owner = THIS_MODULE;
 
 	/*
 	 * Be careful, snd_soc_register_card() calls dev_set_drvdata() and
-- 
2.25.1



