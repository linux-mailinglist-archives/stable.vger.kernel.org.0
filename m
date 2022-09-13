Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775ED5B7435
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbiIMPTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbiIMPSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:18:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EF2796A3;
        Tue, 13 Sep 2022 07:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 586F9614C1;
        Tue, 13 Sep 2022 14:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2B9C433C1;
        Tue, 13 Sep 2022 14:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079636;
        bh=fwCZWdOyCDS6UONenHmEV250O9wKOBrXLdEiwoMjMAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDx5NEhNQaTLQci9A8fwxgzarCrWygfc/xPdc2p+nxWlLut6CrlJPvZ1MT/HzO4zS
         S4CrHqKK/xMZjLzmsCBtohAX/VQ7Hv/HQ8gozPZZT9Ip1lfXrY4GaGaXNBo2HhLLAq
         WrVoMrQ9WdBt3FmAD4VOahci3z+C94oGXaDMMfp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 16/61] hwmon: (gpio-fan) Fix array out of bounds access
Date:   Tue, 13 Sep 2022 16:07:18 +0200
Message-Id: <20220913140347.332169099@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit f233d2be38dbbb22299192292983037f01ab363c ]

The driver does not check if the cooling state passed to
gpio_fan_set_cur_state() exceeds the maximum cooling state as
stored in fan_data->num_speeds. Since the cooling state is later
used as an array index in set_fan_speed(), an array out of bounds
access can occur.
This can be exploited by setting the state of the thermal cooling device
to arbitrary values, causing for example a kernel oops when unavailable
memory is accessed this way.

Example kernel oops:
[  807.987276] Unable to handle kernel paging request at virtual address ffffff80d0588064
[  807.987369] Mem abort info:
[  807.987398]   ESR = 0x96000005
[  807.987428]   EC = 0x25: DABT (current EL), IL = 32 bits
[  807.987477]   SET = 0, FnV = 0
[  807.987507]   EA = 0, S1PTW = 0
[  807.987536]   FSC = 0x05: level 1 translation fault
[  807.987570] Data abort info:
[  807.987763]   ISV = 0, ISS = 0x00000005
[  807.987801]   CM = 0, WnR = 0
[  807.987832] swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000001165000
[  807.987872] [ffffff80d0588064] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
[  807.987961] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[  807.987992] Modules linked in: cmac algif_hash aes_arm64 algif_skcipher af_alg bnep hci_uart btbcm bluetooth ecdh_generic ecc 8021q garp stp llc snd_soc_hdmi_codec brcmfmac vc4 brcmutil cec drm_kms_helper snd_soc_core cfg80211 snd_compress bcm2835_codec(C) snd_pcm_dmaengine syscopyarea bcm2835_isp(C) bcm2835_v4l2(C) sysfillrect v4l2_mem2mem bcm2835_mmal_vchiq(C) raspberrypi_hwmon sysimgblt videobuf2_dma_contig videobuf2_vmalloc fb_sys_fops videobuf2_memops rfkill videobuf2_v4l2 videobuf2_common i2c_bcm2835 snd_bcm2835(C) videodev snd_pcm snd_timer snd mc vc_sm_cma(C) gpio_fan uio_pdrv_genirq uio drm fuse drm_panel_orientation_quirks backlight ip_tables x_tables ipv6
[  807.988508] CPU: 0 PID: 1321 Comm: bash Tainted: G         C        5.15.56-v8+ #1575
[  807.988548] Hardware name: Raspberry Pi 3 Model B Rev 1.2 (DT)
[  807.988574] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  807.988608] pc : set_fan_speed.part.5+0x34/0x80 [gpio_fan]
[  807.988654] lr : gpio_fan_set_cur_state+0x34/0x50 [gpio_fan]
[  807.988691] sp : ffffffc008cf3bd0
[  807.988710] x29: ffffffc008cf3bd0 x28: ffffff80019edac0 x27: 0000000000000000
[  807.988762] x26: 0000000000000000 x25: 0000000000000000 x24: ffffff800747c920
[  807.988787] x23: 000000000000000a x22: ffffff800369f000 x21: 000000001999997c
[  807.988854] x20: ffffff800369f2e8 x19: ffffff8002ae8080 x18: 0000000000000000
[  807.988877] x17: 0000000000000000 x16: 0000000000000000 x15: 000000559e271b70
[  807.988938] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  807.988960] x11: 0000000000000000 x10: ffffffc008cf3c20 x9 : ffffffcfb60c741c
[  807.989018] x8 : 000000000000000a x7 : 00000000ffffffc9 x6 : 0000000000000009
[  807.989040] x5 : 000000000000002a x4 : 0000000000000000 x3 : ffffff800369f2e8
[  807.989062] x2 : 000000000000e780 x1 : 0000000000000001 x0 : ffffff80d0588060
[  807.989084] Call trace:
[  807.989091]  set_fan_speed.part.5+0x34/0x80 [gpio_fan]
[  807.989113]  gpio_fan_set_cur_state+0x34/0x50 [gpio_fan]
[  807.989199]  cur_state_store+0x84/0xd0
[  807.989221]  dev_attr_store+0x20/0x38
[  807.989262]  sysfs_kf_write+0x4c/0x60
[  807.989282]  kernfs_fop_write_iter+0x130/0x1c0
[  807.989298]  new_sync_write+0x10c/0x190
[  807.989315]  vfs_write+0x254/0x378
[  807.989362]  ksys_write+0x70/0xf8
[  807.989379]  __arm64_sys_write+0x24/0x30
[  807.989424]  invoke_syscall+0x4c/0x110
[  807.989442]  el0_svc_common.constprop.3+0xfc/0x120
[  807.989458]  do_el0_svc+0x2c/0x90
[  807.989473]  el0_svc+0x24/0x60
[  807.989544]  el0t_64_sync_handler+0x90/0xb8
[  807.989558]  el0t_64_sync+0x1a0/0x1a4
[  807.989579] Code: b9403801 f9402800 7100003f 8b35cc00 (b9400416)
[  807.989627] ---[ end trace 8ded4c918658445b ]---

Fix this by checking the cooling state and return an error if it
exceeds the maximum cooling state.

Tested on a Raspberry Pi 3.

Fixes: b5cf88e46bad ("(gpio-fan): Add thermal control hooks")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20220830011101.178843-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpio-fan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 9c355b9d31c57..d1b47d20f2fab 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -422,6 +422,9 @@ static int gpio_fan_set_cur_state(struct thermal_cooling_device *cdev,
 	if (!fan_data)
 		return -EINVAL;
 
+	if (state >= fan_data->num_speed)
+		return -EINVAL;
+
 	set_fan_speed(fan_data, state);
 	return 0;
 }
-- 
2.35.1



