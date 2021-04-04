Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB5E353799
	for <lists+stable@lfdr.de>; Sun,  4 Apr 2021 11:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhDDJ3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Apr 2021 05:29:25 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:10556 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhDDJ3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Apr 2021 05:29:24 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617528542; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=R+DEFoVN2DioITMF1H0Iq67bopqJaJkABqvzHmJuw9epQ5+y1rzxHLhULZPlbnYtl6
    sQ9wd0v8ye0CgVR4h3290BMBcjZFt8Vp+VkorMAKVEgnAlpMS45xdABuc9WdtsO3pN+P
    55SOKErhX2vO9NfJSgcQJcJ1KNYqnx/HulwfsARGo4Vpv8N06U8axtGEX5aQ975xQkWB
    ufzaTNUEW7arawcGqW4E6aYgnMA52BxaZVqB7fWP0z94MK7pBveyU6PlQnmos33FLFng
    5nUKusbWIz3q+UWQgQT2DGB+mwo9+TXJlLTzlEn1isO1oulIuuHR1RO6ZxlcfR0DIUQh
    oezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617528542;
    s=strato-dkim-0002; d=strato.com;
    h=To:Message-Id:Cc:Date:From:Subject:Cc:Date:From:Subject:Sender;
    bh=vheUZJVF0feN1TKEn+8lH0fQzPyppUUJbX3XenMUmNE=;
    b=UerUIEyPBftgHynxcmjLLhnjpg21RoaszuIWfo+EyA1I/rYe0bv/5AFvMaSYoK4gz+
    dA0U/7ghWsnOzhmbG7YW6HgKCT/Y/wlVpC/5FamWpVkXdPGjzcIrtROw1JD1ZVi3UuXB
    u+07ypxh4CI8Xel/AcxWgiC40pCjOrSslTPBYK7vi/d9d5citg/gxABUVhK3zUE8ml5b
    wOih9dNANXbtWo32BmU+1Z4P8E9cnxiJZIzcqNtrzcbsHsQr2ZKp8WU1kBuatukHPhUi
    2nsUUGVfgfhS762C82fkTLSZ1ax6oCAQpQmhKM4RVSRYZ7O7crPkV/EXDhC+JPYkwWK5
    TsfQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617528542;
    s=strato-dkim-0002; d=goldelico.com;
    h=To:Message-Id:Cc:Date:From:Subject:Cc:Date:From:Subject:Sender;
    bh=vheUZJVF0feN1TKEn+8lH0fQzPyppUUJbX3XenMUmNE=;
    b=s+pBYSHocm+Ao5xKS9fb3J+AIe7pz7tkWYOiBCBearUgjorU9MlT9bIglPRHZPhaky
    odXkzZLy4v6tN6y8xoVSIbGQV2f2DKoXpVMq3RpkpglHSYWRDSF12hPM2w+t0kRS67sZ
    0TGs30x1xF0w+YdQSKJRg3rsh6L38qIhyARaAHED3NyOSdykN57fuNJuujMpFQzLrEi+
    lq/2iF3pIfuIhp6z38ZMmBjbcam+xb6XGEXwDJCrv4Rwdz21O51h/cF+uLqHITkuR8Xs
    fuPJWWFwKjXv11PE7NCnfJow+QP/bsbZjc54feAtVe4ryvM02EKQ37fKUB58+n8A/ZMB
    XF+A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGH/zuwDOioLY="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
    by smtp.strato.de (RZmta 47.23.1 DYNA|AUTH)
    with ESMTPSA id h03350x349T1bgH
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Sun, 4 Apr 2021 11:29:01 +0200 (CEST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: [BUG]: usb: dwc3: gadget: Prevent EP queuing while stopping transfers
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
Date:   Sun, 4 Apr 2021 11:29:00 +0200
Cc:     stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        kernel@pyra-handheld.com,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, linux-usb@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DF98BCBA-E13B-4E33-98AD-216816625F3B@goldelico.com>
To:     Wesley Cheng <wcheng@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>, gregkh@linuxfoundation.org
X-Mailer: Apple Mail (2.3124)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

it seems as if the patch

	9de499997c37 ("usb: dwc3: gadget: Prevent EP queuing while =
stopping transfers") in v5.11.y
	f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while =
stopping transfers") in v5.12-rc5

reproducible breaks dwc3 RNDIS gadget, at least on the Pyra Handheld =
(OMAP5).

The symptom of having this patch in tree (v5.11.10 or v5.12) is that
rndis/gadget initially works after boot.

But after unplugging the cable, a replug gives warnings like the =
following
and RNDIS isn't up and running any more:

[   72.009811] ------------[ cut here ]------------
[   72.014768] WARNING: CPU: 0 PID: 2499 at =
drivers/usb/dwc3/gadget.c:361 dwc3_send_gadget_ep_cmd+0x1f8/0x330 [dwc3]
[   72.025846] dwc3 4a030000.usb: No resource for ep2in
[   72.031125] Modules linked in: bnep usb_f_ecm g_ether usb_f_rndis =
u_ether libcomposite configfs ipv6 snd_soc_omap_hdmi wl18xx wlcore =
panel_boe_btl507212_w677l mac80211 snd_soc_spdif_tx snd_soc_dmic dwc3 =
roles cfg80211 libarc4 snd_soc_omap_abe_twl6040 snd_soc_simple_card =
omapdrm pvrsrvkm_omap5_sgx544_116 snd_soc_omap_mcpdm =
snd_soc_simple_card_utils etnaviv wwan_on_off snd_soc_twl6040 leds_gpio =
snd_soc_gtm601 drm_kms_helper pwm_bl pwm_omap_dmtimer ti_tpd12s015 =
display_connector generic_adc_battery snd_soc_w2cbw003_bt gpu_sched =
syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm =
drm_panel_orientation_quirks omap_sham omap_aes_driver crypto_engine =
omap_crypto ehci_omap dwc3_omap wlcore_sdio snd_soc_ts3a227e ina2xx_adc =
leds_is31fl319x tsc2007 bq2429x_charger bq27xxx_battery_i2c =
bq27xxx_battery ina2xx as5013 tca8418_keypad twl6040_vibra bmp280_spi =
clk_twl6040 gpio_twl6040 hci_uart btbcm palmas_pwrbutton palmas_gpadc =
usb3503 bluetooth bmc150_accel_i2c bmc150_magn_i2c bmp280_i2c bmg160_
i2c
[   72.032887]  bmc150_accel_core bmc150_magn bmg160_core bmp280 =
ecdh_generic bno055 industrialio_triggered_buffer ecc kfifo_buf =
industrialio snd_soc_omap_aess snd_soc_omap_mcbsp snd_soc_ti_sdma
[   72.143285] CPU: 0 PID: 2499 Comm: irq/200-dwc3 Not tainted =
5.12.0-rc5-letux-lpae+ #5479
[   72.151914] Hardware name: Generic OMAP5 (Flattened Device Tree)
[   72.158300] [<c020ec60>] (unwind_backtrace) from [<c020a1d0>] =
(show_stack+0x10/0x14)
[   72.166595] [<c020a1d0>] (show_stack) from [<c096aa34>] =
(dump_stack+0x8c/0xac)
[   72.174325] [<c096aa34>] (dump_stack) from [<c022ba94>] =
(__warn+0xcc/0xf4)
[   72.181668] [<c022ba94>] (__warn) from [<c022bb2c>] =
(warn_slowpath_fmt+0x70/0x9c)
[   72.189664] [<c022bb2c>] (warn_slowpath_fmt) from [<bf41ef44>] =
(dwc3_send_gadget_ep_cmd+0x1f8/0x330 [dwc3])
[   72.200223] [<bf41ef44>] (dwc3_send_gadget_ep_cmd [dwc3]) from =
[<bf41f55c>] (__dwc3_gadget_ep_enable+0x344/0x420 [dwc3])
[   72.212003] [<bf41f55c>] (__dwc3_gadget_ep_enable [dwc3]) from =
[<bf41f6f0>] (dwc3_gadget_ep_enable+0xb8/0xe8 [dwc3])
[   72.223420] [<bf41f6f0>] (dwc3_gadget_ep_enable [dwc3]) from =
[<c078eef8>] (usb_ep_enable+0x3c/0xd4)
[   72.233182] [<c078eef8>] (usb_ep_enable) from [<bf57497c>] =
(ecm_set_alt+0x48/0x13c [usb_f_ecm])
[   72.242490] [<bf57497c>] (ecm_set_alt [usb_f_ecm]) from [<bf5450b4>] =
(composite_setup+0xa88/0x152c [libcomposite])

[   72.253629] [<bf5450b4>] (composite_setup [libcomposite]) from =
[<bf421edc>] (dwc3_ep0_delegate_req+0x2c/0x40 [dwc3])
[   72.264981] [<bf421edc>] (dwc3_ep0_delegate_req [dwc3]) from =
[<bf422d9c>] (dwc3_ep0_interrupt+0x31c/0x824 [dwc3])
[   72.276122] [<bf422d9c>] (dwc3_ep0_interrupt [dwc3]) from =
[<bf420698>] (dwc3_process_event_buf+0x11c/0xa50 [dwc3])

[   72.287357] [<bf420698>] (dwc3_process_event_buf [dwc3]) from =
[<bf420ff0>] (dwc3_thread_interrupt+0x24/0x3c [dwc3])
[   72.298679] [<bf420ff0>] (dwc3_thread_interrupt [dwc3]) from =
[<c027972c>] (irq_thread_fn+0x1c/0x5c)
[   72.308440] [<c027972c>] (irq_thread_fn) from [<c0279a54>] =
(irq_thread+0x158/0x1e8)
[   72.316617] [<c0279a54>] (irq_thread) from [<c02492d8>] =
(kthread+0x138/0x148)
[   72.324254] [<c02492d8>] (kthread) from [<c0200140>] =
(ret_from_fork+0x14/0x34)
[   72.331968] Exception stack(0xc2e99fb0 to 0xc2e99ff8)
[   72.337339] 9fa0:                                     00000000 =
00000000 00000000 00000000
[   72.346022] 9fc0: 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000 00000000
[   72.354716] 9fe0: 00000000 00000000 00000000 00000000 00000013 =
00000000
[   72.361753] ---[ end trace d949466d43afc2cb ]---
[   72.366675] ------------[ cut here ]------------
[   72.371579] WARNING: CPU: 0 PID: 2499 at =
drivers/usb/gadget/udc/core.c:278 usb_ep_queue+0xe8/0x108
[   72.381131] Modules linked in: bnep usb_f_ecm g_ether usb_f_rndis =
u_ether libcomposite configfs ipv6 snd_soc_omap_hdmi wl18xx wlcore =
panel_boe_btl507212_w677l mac80211 snd_soc_spdif_tx snd_soc_dmic dwc3 =
roles cfg80211 libarc4 snd_soc_omap_abe_twl6040 snd_soc_simple_card =
omapdrm pvrsrvkm_omap5_sgx544_116 snd_soc_omap_mcpdm =
snd_soc_simple_card_utils etnaviv wwan_on_off snd_soc_twl6040 leds_gpio =
snd_soc_gtm601 drm_kms_helper pwm_bl pwm_omap_dmtimer ti_tpd12s015 =
display_connector generic_adc_battery snd_soc_w2cbw003_bt gpu_sched =
syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm =
drm_panel_orientation_quirks omap_sham omap_aes_driver crypto_engine =
omap_crypto ehci_omap dwc3_omap wlcore_sdio snd_soc_ts3a227e ina2xx_adc =
leds_is31fl319x tsc2007 bq2429x_charger bq27xxx_battery_i2c =
bq27xxx_battery ina2xx as5013 tca8418_keypad twl6040_vibra bmp280_spi =
clk_twl6040 gpio_twl6040 hci_uart btbcm palmas_pwrbutton palmas_gpadc =
usb3503 bluetooth bmc150_accel_i2c bmc150_magn_i2c bmp280_i2c bmg160_
i2c
[   72.382817]  bmc150_accel_core bmc150_magn bmg160_core bmp280 =
ecdh_generic bno055 industrialio_triggered_buffer ecc kfifo_buf =
industrialio snd_soc_omap_aess snd_soc_omap_mcbsp snd_soc_ti_sdma
[   72.493132] CPU: 0 PID: 2499 Comm: irq/200-dwc3 Tainted: G        W   =
      5.12.0-rc5-letux-lpae+ #5479
[   72.503202] Hardware name: Generic OMAP5 (Flattened Device Tree)
[   72.509581] [<c020ec60>] (unwind_backtrace) from [<c020a1d0>] =
(show_stack+0x10/0x14)
[   72.517852] [<c020a1d0>] (show_stack) from [<c096aa34>] =
(dump_stack+0x8c/0xac)
[   72.525571] [<c096aa34>] (dump_stack) from [<c022ba94>] =
(__warn+0xcc/0xf4)
[   72.532926] [<c022ba94>] (__warn) from [<c022bb2c>] =
(warn_slowpath_fmt+0x70/0x9c)
[   72.540921] [<c022bb2c>] (warn_slowpath_fmt) from [<c078ee9c>] =
(usb_ep_queue+0xe8/0x108)
[   72.549558] [<c078ee9c>] (usb_ep_queue) from [<bf574914>] =
(ecm_do_notify+0x138/0x158 [usb_f_ecm])
[   72.559049] [<bf574914>] (ecm_do_notify [usb_f_ecm]) from =
[<bf574a68>] (ecm_set_alt+0x134/0x13c [usb_f_ecm])
[   72.569524] [<bf574a68>] (ecm_set_alt [usb_f_ecm]) from [<bf5450b4>] =
(composite_setup+0xa88/0x152c [libcomposite])

[   72.580626] [<bf5450b4>] (composite_setup [libcomposite]) from =
[<bf421edc>] (dwc3_ep0_delegate_req+0x2c/0x40 [dwc3])
[   72.592038] [<bf421edc>] (dwc3_ep0_delegate_req [dwc3]) from =
[<bf422d9c>] (dwc3_ep0_interrupt+0x31c/0x824 [dwc3])
[   72.603209] [<bf422d9c>] (dwc3_ep0_interrupt [dwc3]) from =
[<bf420698>] (dwc3_process_event_buf+0x11c/0xa50 [dwc3])

[   72.614469] [<bf420698>] (dwc3_process_event_buf [dwc3]) from =
[<bf420ff0>] (dwc3_thread_interrupt+0x24/0x3c [dwc3])
[   72.625793] [<bf420ff0>] (dwc3_thread_interrupt [dwc3]) from =
[<c027972c>] (irq_thread_fn+0x1c/0x5c)
[   72.635556] [<c027972c>] (irq_thread_fn) from [<c0279a54>] =
(irq_thread+0x158/0x1e8)
[   72.643705] [<c0279a54>] (irq_thread) from [<c02492d8>] =
(kthread+0x138/0x148)
[   72.651334] [<c02492d8>] (kthread) from [<c0200140>] =
(ret_from_fork+0x14/0x34)
[   72.659055] Exception stack(0xc2e99fb0 to 0xc2e99ff8)
[   72.664437] 9fa0:                                     00000000 =
00000000 00000000 00000000
[   72.673123] 9fc0: 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000 00000000
[   72.681821] 9fe0: 00000000 00000000 00000000 00000000 00000013 =
00000000
[   72.688840] ---[ end trace d949466d43afc2cc ]---
[   72.708346] bq2429x_charger 1-006b: bq2429x_usb_detect: state =
changed: state->[ HOST FCHG INDPM PWRGOOD] fault->[]

[   72.719587] bq2429x_charger 1-006b: bq2429x: VBUS became available
[   72.920591] ------------[ cut here ]------------
[   72.925514] WARNING: CPU: 0 PID: 2499 at =
drivers/usb/dwc3/gadget.c:361 dwc3_send_gadget_ep_cmd+0x1f8/0x330 [dwc3]
[   72.936612] dwc3 4a030000.usb: No resource for ep1in
[   72.941892] Modules linked in: bnep usb_f_ecm g_ether usb_f_rndis =
u_ether libcomposite configfs ipv6 snd_soc_omap_hdmi wl18xx wlcore =
panel_boe_btl507212_w677l mac80211 snd_soc_spdif_tx snd_soc_dmic dwc3 =
roles cfg80211 libarc4 snd_soc_omap_abe_twl6040 snd_soc_simple_card =
omapdrm pvrsrvkm_omap5_sgx544_116 snd_soc_omap_mcpdm =
snd_soc_simple_card_utils etnaviv wwan_on_off snd_soc_twl6040 leds_gpio =
snd_soc_gtm601 drm_kms_helper pwm_bl pwm_omap_dmtimer ti_tpd12s015 =
display_connector generic_adc_battery snd_soc_w2cbw003_bt gpu_sched =
syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm =
drm_panel_orientation_quirks omap_sham omap_aes_driver crypto_engine =
omap_crypto ehci_omap dwc3_omap wlcore_sdio snd_soc_ts3a227e ina2xx_adc =
leds_is31fl319x tsc2007 bq2429x_charger bq27xxx_battery_i2c =
bq27xxx_battery ina2xx as5013 tca8418_keypad twl6040_vibra bmp280_spi =
clk_twl6040 gpio_twl6040 hci_uart btbcm palmas_pwrbutton palmas_gpadc =
usb3503 bluetooth bmc150_accel_i2c bmc150_magn_i2c bmp280_i2c bmg160_
i2c
[   72.943662]  bmc150_accel_core bmc150_magn bmg160_core bmp280 =
ecdh_generic bno055 industrialio_triggered_buffer ecc kfifo_buf =
industrialio snd_soc_omap_aess snd_soc_omap_mcbsp snd_soc_ti_sdma
[   73.054078] CPU: 0 PID: 2499 Comm: irq/200-dwc3 Tainted: G        W   =
      5.12.0-rc5-letux-lpae+ #5479
[   73.064176] Hardware name: Generic OMAP5 (Flattened Device Tree)
[   73.070582] [<c020ec60>] (unwind_backtrace) from [<c020a1d0>] =
(show_stack+0x10/0x14)
[   73.078867] [<c020a1d0>] (show_stack) from [<c096aa34>] =
(dump_stack+0x8c/0xac)
[   73.086585] [<c096aa34>] (dump_stack) from [<c022ba94>] =
(__warn+0xcc/0xf4)
[   73.093930] [<c022ba94>] (__warn) from [<c022bb2c>] =
(warn_slowpath_fmt+0x70/0x9c)
[   73.101926] [<c022bb2c>] (warn_slowpath_fmt) from [<bf41ef44>] =
(dwc3_send_gadget_ep_cmd+0x1f8/0x330 [dwc3])
[   73.112425] [<bf41ef44>] (dwc3_send_gadget_ep_cmd [dwc3]) from =
[<bf41f55c>] (__dwc3_gadget_ep_enable+0x344/0x420 [dwc3])
[   73.124234] [<bf41f55c>] (__dwc3_gadget_ep_enable [dwc3]) from =
[<bf41f6f0>] (dwc3_gadget_ep_enable+0xb8/0xe8 [dwc3])
[   73.135678] [<bf41f6f0>] (dwc3_gadget_ep_enable [dwc3]) from =
[<c078eef8>] (usb_ep_enable+0x3c/0xd4)
[   73.145444] [<c078eef8>] (usb_ep_enable) from [<bf558f40>] =
(gether_connect+0x24/0x19c [u_ether])
[   73.154873] [<bf558f40>] (gether_connect [u_ether]) from [<bf574a50>] =
(ecm_set_alt+0x11c/0x13c [usb_f_ecm])
[   73.165258] [<bf574a50>] (ecm_set_alt [usb_f_ecm]) from [<bf5451d4>] =
(composite_setup+0xba8/0x152c [libcomposite])

[   73.176368] [<bf5451d4>] (composite_setup [libcomposite]) from =
[<bf421edc>] (dwc3_ep0_delegate_req+0x2c/0x40 [dwc3])
[   73.187772] [<bf421edc>] (dwc3_ep0_delegate_req [dwc3]) from =
[<bf422eb0>] (dwc3_ep0_interrupt+0x430/0x824 [dwc3])
[   73.198919] [<bf422eb0>] (dwc3_ep0_interrupt [dwc3]) from =
[<bf420698>] (dwc3_process_event_buf+0x11c/0xa50 [dwc3])

[   73.210172] [<bf420698>] (dwc3_process_event_buf [dwc3]) from =
[<bf420ff0>] (dwc3_thread_interrupt+0x24/0x3c [dwc3])
[   73.221494] [<bf420ff0>] (dwc3_thread_interrupt [dwc3]) from =
[<c027972c>] (irq_thread_fn+0x1c/0x5c)
[   73.231260] [<c027972c>] (irq_thread_fn) from [<c0279a54>] =
(irq_thread+0x158/0x1e8)
[   73.239411] [<c0279a54>] (irq_thread) from [<c02492d8>] =
(kthread+0x138/0x148)
[   73.247041] [<c02492d8>] (kthread) from [<c0200140>] =
(ret_from_fork+0x14/0x34)
[   73.254758] Exception stack(0xc2e99fb0 to 0xc2e99ff8)
[   73.260135] 9fa0:                                     00000000 =
00000000 00000000 00000000
[   73.268815] 9fc0: 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000 00000000
[   73.277476] 9fe0: 00000000 00000000 00000000 00000000 00000013 =
00000000
[   73.284490] ---[ end trace d949466d43afc2cd ]---

Even once I was able to trigger a kernel panic just by =
unplugging/replugging
the cable.

Reverting this patch makes DWC3 work again after cable unplug/replug.
On both, v5.11.10 and 5.12-rc5.

Please suggest a fix for testing.

BR and thanks,
Nikolaus Schaller

