Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0083E44AAB7
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 10:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbhKIJpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 04:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbhKIJp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 04:45:29 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB497C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 01:42:43 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so1422444wme.0
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 01:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZlOrsEkoUVb7bqgr7Sfqn6tP5yW/fniHUca7AhR1Joc=;
        b=j6lTuleaVQuysWTJmBVAUX5Vi1a0CJeW0a+VLQ2KMqtSpvOcDEaenjASpqzecBusRG
         v9ynWNxXelEhUpZir4U8oZcAwa2tdCRwdqDWVtD4bMJEX77V/xm5v13SgZVKRmzcfH0w
         4diD/jolcXISi1kNIwmedQ+vQuBpIDYXJPGmV7haDYEKzEWhLRyepEDPamiZ0BT1mafQ
         PY3YK4BI4int135w3Z2lp2jRsM5Swm7RpDDVli+9mmcInAI2bg5FyI+gVoQQIJAKp7C8
         zJR/O3R05WYy8ZZ78FNVO+ynh6olx6GsLL5QjwxAS+6CJ+qEv2LI8fyyBQnnCwcaJ6MK
         U68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZlOrsEkoUVb7bqgr7Sfqn6tP5yW/fniHUca7AhR1Joc=;
        b=aR6UyUIpl24LOdBnGUO+MMwWFqJ5FgIdypb7ZxJ/0uAEFwWdfz6LKvLLo55BBtlsbU
         P37u5Umqn8NprTJnckP0gclhCNEFjiuk16y4rvNlps3gO+pBLEHtHvzU6QJKWJesMsWr
         i6RmY6yet5NB9fDN+ROxMiZiU/SxtFN2WR99eZZu0U24ZHRE/elkO/TI772U1AWihvrz
         EdLQeLJtX/5L6lD60VSrMtuV6vnRHnAA6eygRyElSCvglQfyis9/MBjdRaKtstEBjSPz
         3jLCPdlrGPR5Uwr6sI8f7dwMyI0qw4nv50I0DKKyPmJ3m7+pRj+XHgsDnnig3ngXgC58
         attA==
X-Gm-Message-State: AOAM5308olNhW4l45h+d8hXrPQckrl4YE1m6z7vGIFBgXy4XneG8cYoC
        mmJy0kBD8sJADLKJz3F7pU2RIg==
X-Google-Smtp-Source: ABdhPJxKJKRWBtBIE9hg4QEOm/PlO31qKJRKN3GLEHuR83ElWb+USW1S9VR8EGGle3BJUfsLY5fmhQ==
X-Received: by 2002:a05:600c:1d01:: with SMTP id l1mr5770302wms.44.1636450962416;
        Tue, 09 Nov 2021 01:42:42 -0800 (PST)
Received: from localhost.localdomain ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id l18sm20224726wrt.81.2021.11.09.01.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 01:42:42 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Kemnade <andreas@kemnade.info>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Johan Hovold <johan@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 1/2] net: hso: register netdev later to avoid a race condition
Date:   Tue,  9 Nov 2021 09:42:36 +0000
Message-Id: <20211109094237.174741-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 4c761daf8bb9a2cbda9facf53ea85d9061f4281e ]

If the netdev is accessed before the urbs are initialized,
there will be NULL pointer dereferences. That is avoided by
registering it when it is fully initialized.

This case occurs e.g. if dhcpcd is running in the background
and the device is probed, either after insmod hso or
when the device appears on the usb bus.

A backtrace is the following:

[ 1357.356048] usb 1-2: new high-speed USB device number 12 using ehci-omap
[ 1357.551177] usb 1-2: New USB device found, idVendor=0af0, idProduct=8800
[ 1357.558654] usb 1-2: New USB device strings: Mfr=3, Product=2, SerialNumber=0
[ 1357.568572] usb 1-2: Product: Globetrotter HSUPA Modem
[ 1357.574096] usb 1-2: Manufacturer: Option N.V.
[ 1357.685882] hso 1-2:1.5: Not our interface
[ 1460.886352] hso: unloaded
[ 1460.889984] usbcore: deregistering interface driver hso
[ 1513.769134] hso: ../drivers/net/usb/hso.c: Option Wireless
[ 1513.846771] Unable to handle kernel NULL pointer dereference at virtual address 00000030
[ 1513.887664] hso 1-2:1.5: Not our interface
[ 1513.906890] usbcore: registered new interface driver hso
[ 1513.937988] pgd = ecdec000
[ 1513.949890] [00000030] *pgd=acd15831, *pte=00000000, *ppte=00000000
[ 1513.956573] Internal error: Oops: 817 [#1] PREEMPT SMP ARM
[ 1513.962371] Modules linked in: hso usb_f_ecm omap2430 bnep bluetooth g_ether usb_f_rndis u_ether libcomposite configfs ipv6 arc4 wl18xx wlcore mac80211 cfg80211 bq27xxx_battery panel_tpo_td028ttec1 omapdrm drm_kms_helper cfbfillrect snd_soc_simple_card syscopyarea cfbimgblt snd_soc_simple_card_utils sysfillrect sysimgblt fb_sys_fops snd_soc_omap_twl4030 cfbcopyarea encoder_opa362 drm twl4030_madc_hwmon wwan_on_off snd_soc_gtm601 pwm_omap_dmtimer generic_adc_battery connector_analog_tv pwm_bl extcon_gpio omap3_isp wlcore_sdio videobuf2_dma_contig videobuf2_memops w1_bq27000 videobuf2_v4l2 videobuf2_core omap_hdq snd_soc_omap_mcbsp ov9650 snd_soc_omap bmp280_i2c bmg160_i2c v4l2_common snd_pcm_dmaengine bmp280 bmg160_core at24 bmc150_magn_i2c nvmem_core videodev phy_twl4030_usb bmc150_accel_i2c tsc2007
[ 1514.037384]  bmc150_magn bmc150_accel_core media leds_tca6507 bno055 industrialio_triggered_buffer kfifo_buf gpio_twl4030 musb_hdrc snd_soc_twl4030 twl4030_vibra twl4030_madc twl4030_pwrbutton twl4030_charger industrialio w2sg0004 ehci_omap omapdss [last unloaded: hso]
[ 1514.062622] CPU: 0 PID: 3433 Comm: dhcpcd Tainted: G        W       4.11.0-rc8-letux+ #1
[ 1514.071136] Hardware name: Generic OMAP36xx (Flattened Device Tree)
[ 1514.077758] task: ee748240 task.stack: ecdd6000
[ 1514.082580] PC is at hso_start_net_device+0x50/0xc0 [hso]
[ 1514.088287] LR is at hso_net_open+0x68/0x84 [hso]
[ 1514.093231] pc : [<bf79c304>]    lr : [<bf79ced8>]    psr: a00f0013
sp : ecdd7e20  ip : 00000000  fp : ffffffff
[ 1514.105316] r10: 00000000  r9 : ed0e080c  r8 : ecd8fe2c
[ 1514.110839] r7 : bf79cef4  r6 : ecd8fe00  r5 : 00000000  r4 : ed0dbd80
[ 1514.117706] r3 : 00000000  r2 : c0020c80  r1 : 00000000  r0 : ecdb7800
[ 1514.124572] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[ 1514.132110] Control: 10c5387d  Table: acdec019  DAC: 00000051
[ 1514.138153] Process dhcpcd (pid: 3433, stack limit = 0xecdd6218)
[ 1514.144470] Stack: (0xecdd7e20 to 0xecdd8000)
[ 1514.149078] 7e20: ed0dbd80 ecd8fe98 00000001 00000000 ecd8f800 ecd8fe00 ecd8fe60 00000000
[ 1514.157714] 7e40: ed0e080c bf79ced8 bf79ce70 ecd8f800 00000001 bf7a0258 ecd8f830 c068d958
[ 1514.166320] 7e60: c068d8b8 ecd8f800 00000001 00001091 00001090 c068dba4 ecd8f800 00001090
[ 1514.174926] 7e80: ecd8f940 ecd8f800 00000000 c068dc60 00000000 00000001 ed0e0800 ecd8f800
[ 1514.183563] 7ea0: 00000000 c06feaa8 c0ca39c2 beea57dc 00000020 00000000 306f7368 00000000
[ 1514.192169] 7ec0: 00000000 00000000 00001091 00000000 00000000 00000000 00000000 00008914
[ 1514.200805] 7ee0: eaa9ab60 beea57dc c0c9bfc0 eaa9ab40 00000006 00000000 00046858 c066a948
[ 1514.209411] 7f00: beea57dc eaa9ab60 ecc6b0c0 c02837b0 00000006 c0282c90 0000c000 c0283654
[ 1514.218017] 7f20: c09b0c00 c098bc31 00000001 c0c5e513 c0c5e513 00000000 c0151354 c01a20c0
[ 1514.226654] 7f40: c0c5e513 c01a3134 ecdd6000 c01a3160 ee7487f0 600f0013 00000000 ee748240
[ 1514.235260] 7f60: ee748734 00000000 ecc6b0c0 ecc6b0c0 beea57dc 00008914 00000006 00000000
[ 1514.243896] 7f80: 00046858 c02837b0 00001091 0003a1f0 00046608 0003a248 00000036 c01071e4
[ 1514.252502] 7fa0: ecdd6000 c0107040 0003a1f0 00046608 00000006 00008914 beea57dc 00001091
[ 1514.261108] 7fc0: 0003a1f0 00046608 0003a248 00000036 0003ac0c 00046608 00046610 00046858
[ 1514.269744] 7fe0: 0003a0ac beea57d4 000167eb b6f23106 400f0030 00000006 00000000 00000000
[ 1514.278411] [<bf79c304>] (hso_start_net_device [hso]) from [<bf79ced8>] (hso_net_open+0x68/0x84 [hso])
[ 1514.288238] [<bf79ced8>] (hso_net_open [hso]) from [<c068d958>] (__dev_open+0xa0/0xf4)
[ 1514.296600] [<c068d958>] (__dev_open) from [<c068dba4>] (__dev_change_flags+0x8c/0x130)
[ 1514.305023] [<c068dba4>] (__dev_change_flags) from [<c068dc60>] (dev_change_flags+0x18/0x48)
[ 1514.313934] [<c068dc60>] (dev_change_flags) from [<c06feaa8>] (devinet_ioctl+0x348/0x714)
[ 1514.322540] [<c06feaa8>] (devinet_ioctl) from [<c066a948>] (sock_ioctl+0x2b0/0x308)
[ 1514.330627] [<c066a948>] (sock_ioctl) from [<c0282c90>] (vfs_ioctl+0x20/0x34)
[ 1514.338165] [<c0282c90>] (vfs_ioctl) from [<c0283654>] (do_vfs_ioctl+0x82c/0x93c)
[ 1514.346038] [<c0283654>] (do_vfs_ioctl) from [<c02837b0>] (SyS_ioctl+0x4c/0x74)
[ 1514.353759] [<c02837b0>] (SyS_ioctl) from [<c0107040>] (ret_fast_syscall+0x0/0x1c)
[ 1514.361755] Code: e3822103 e3822080 e1822781 e5981014 (e5832030)
[ 1514.510833] ---[ end trace dfb3e53c657f34a0 ]---

Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/usb/hso.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index e6f272019da0d..fa3f1b8700aa8 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2546,13 +2546,6 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	SET_NETDEV_DEV(net, &interface->dev);
 	SET_NETDEV_DEVTYPE(net, &hso_type);
 
-	/* registering our net device */
-	result = register_netdev(net);
-	if (result) {
-		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
-	}
-
 	/* start allocating */
 	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
 		hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
@@ -2576,6 +2569,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 
 	add_net_device(hso_dev);
 
+	/* registering our net device */
+	result = register_netdev(net);
+	if (result) {
+		dev_err(&interface->dev, "Failed to register device\n");
+		goto exit;
+	}
+
 	hso_log_port(hso_dev);
 
 	hso_create_rfkill(hso_dev, interface);
-- 
2.34.0.rc0.344.g81b53c2807-goog

