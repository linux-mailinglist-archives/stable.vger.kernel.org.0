Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85BFCDB41
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 07:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfJGFND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 01:13:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46756 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfJGFNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 01:13:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id q5so7827249pfg.13;
        Sun, 06 Oct 2019 22:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P8LRlFFGZmYBRMTbewjbYilwO+sTUeallQ/xrYOZnaw=;
        b=HtMunkj5ZxhO3glggW9EGcbZYGPNxB59XB7cPCmUQejL6dhEx6gylXkpCvv6ZWx3l0
         sn/QoYvLTzQpMaUAWux2/pSVDY+OxJnqjDOnDgiw3gXw0vV3HwUtDzuwBCsbMfGw17a2
         +qc95u85Pprw8rU5IaEFxQxSgOdG9rC6Q4HssjYUFVUx9qPryH6eGYL4AXvmVDnFBSFQ
         QDkZpnZ1COkQ3ih5hOaDSGwdrIjeR/lqc5esrkK57pCmOvsVmvsAh7RzgO3cF9/ezTUL
         1cv/ggrVGacoHiVIbX4kxDhcLc9rk7JFRKoQScsMZd/swNzESp+gq84SSRzPebTOygFM
         qSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P8LRlFFGZmYBRMTbewjbYilwO+sTUeallQ/xrYOZnaw=;
        b=MSkXQM1YrLm/x6GedRPEU2/OsFFM/gup6MGuV8kzwOVKDCvyAaf3wCe3z2tntQyldY
         w5ar2qdmKsOWutUoKOKwaqHzQT5meYYJD1xd+DrHhnnmXpEQ+qryjMbCI27WlAGED3z9
         tDTaDCn3zjpetxcvH5Bhh2hvLyYBltjZrxgoQhPwl1G0eFS7k4rvOSrSlCDukgqXe96f
         qLjEvye7lmYH8Vcpjioq/gxblJ5px6NMjFFrXpYC6WHa5Ibx4SnMgomtuhTjXYxOmd9Q
         wM0I/kR/E943dSSWXmkbBYK8RmNt7saVnwQO5gYNHsI1V0rOn7xqsa1XQar69TUbxkog
         Dggw==
X-Gm-Message-State: APjAAAW9EUX5xXDD/I9oMtzX4KFxgKP1htJFiwE4GUef7naVjk3pCc0W
        VaYqCzqO6Lt7cfp+0XGx9cG7u2+xPL4=
X-Google-Smtp-Source: APXvYqwaP1556FaUx+1Wiauh/RJ2eJiyURpih/P7fy2qnStASgaS9N1QAo6J43po2OkK1W1eZxnyqg==
X-Received: by 2002:a17:90a:bb97:: with SMTP id v23mr30030523pjr.84.1570425181016;
        Sun, 06 Oct 2019 22:13:01 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id v133sm2209680pgb.74.2019.10.06.22.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 22:13:00 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/3] HID: logitech-hidpp: split g920_get_config()
Date:   Sun,  6 Oct 2019 22:12:39 -0700
Message-Id: <20191007051240.4410-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007051240.4410-1-andrew.smirnov@gmail.com>
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Original version of g920_get_config() contained two kind of actions:

    1. Device specific communication to query/set some parameters
       which requires active communication channel with the device,
       or, put in other way, for the call to be sandwiched between
       hid_device_io_start() and hid_device_io_stop().

    2. Input subsystem specific FF controller initialization which, in
       order to access a valid 'struct hid_input' via
       'hid->inputs.next', requires claimed hidinput which means be
       executed after the call to hid_hw_start() with connect_mask
       containing HID_CONNECT_HIDINPUT.

Location of g920_get_config() can only fulfill requirements for #1 and
not #2, which result in following backtrace:

[   88.312258] logitech-hidpp-device 0003:046D:C262.0005: HID++ 4.2 device =
connected.
[   88.320298] BUG: kernel NULL pointer dereference, address: 0000000000000=
018
[   88.320304] #PF: supervisor read access in kernel mode
[   88.320307] #PF: error_code(0x0000) - not-present page
[   88.320309] PGD 0 P4D 0
[   88.320315] Oops: 0000 [#1] SMP PTI
[   88.320320] CPU: 1 PID: 3080 Comm: systemd-udevd Not tainted 5.4.0-rc1+ =
#31
[   88.320322] Hardware name: Apple Inc. MacBookPro11,1/Mac-189A3D4F975D5FF=
C, BIOS 149.0.0.0.0 09/17/2018
[   88.320334] RIP: 0010:hidpp_probe+0x61f/0x948 [hid_logitech_hidpp]
[   88.320338] Code: 81 00 00 48 89 ef e8 f0 d6 ff ff 41 89 c6 85 c0 75 b5 =
0f b6 44 24 28 48 8b 5d 00 88 44 24 1e 89 44 24 0c 48 8b 83 18 1c 00 00 <48=
> 8b 48 18 48 8b 83 10 19 00 00 48 8b 40 40 48 89 0c 24 0f b7 80
[   88.320341] RSP: 0018:ffffb0a6824aba68 EFLAGS: 00010246
[   88.320345] RAX: 0000000000000000 RBX: ffff93a50756e000 RCX: 00000000000=
10408
[   88.320347] RDX: 0000000000000000 RSI: ffff93a51f0ad0a0 RDI: 00000000000=
2d0a0
[   88.320350] RBP: ffff93a50416da28 R08: ffff93a50416da70 R09: ffff93a5041=
6da70
[   88.320352] R10: 000000148ae9e60c R11: 00000000000f1525 R12: ffff93a5075=
6e000
[   88.320354] R13: ffff93a50756f8d0 R14: 0000000000000000 R15: ffff93a5075=
6fc38
[   88.320358] FS:  00007f8d8c1e0940(0000) GS:ffff93a51f080000(0000) knlGS:=
0000000000000000
[   88.320361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   88.320363] CR2: 0000000000000018 CR3: 00000003996d8003 CR4: 00000000001=
606e0
[   88.320366] Call Trace:
[   88.320377]  ? _cond_resched+0x15/0x30
[   88.320387]  ? create_pinctrl+0x2f/0x3c0
[   88.320393]  ? kernfs_link_sibling+0x94/0xe0
[   88.320398]  ? _cond_resched+0x15/0x30
[   88.320402]  ? kernfs_activate+0x5f/0x80
[   88.320406]  ? kernfs_add_one+0xe2/0x130
[   88.320411]  hid_device_probe+0x106/0x170
[   88.320419]  really_probe+0x147/0x3c0
[   88.320424]  driver_probe_device+0xb6/0x100
[   88.320428]  device_driver_attach+0x53/0x60
[   88.320433]  __driver_attach+0x8a/0x150
[   88.320437]  ? device_driver_attach+0x60/0x60
[   88.320440]  bus_for_each_dev+0x78/0xc0
[   88.320445]  bus_add_driver+0x14d/0x1f0
[   88.320450]  driver_register+0x6c/0xc0
[   88.320453]  ? 0xffffffffc0d67000
[   88.320457]  __hid_register_driver+0x4c/0x80
[   88.320464]  do_one_initcall+0x46/0x1f4
[   88.320469]  ? _cond_resched+0x15/0x30
[   88.320474]  ? kmem_cache_alloc_trace+0x162/0x220
[   88.320481]  ? do_init_module+0x23/0x230
[   88.320486]  do_init_module+0x5c/0x230
[   88.320491]  load_module+0x26e1/0x2990
[   88.320502]  ? ima_post_read_file+0xf0/0x100
[   88.320508]  ? __do_sys_finit_module+0xaa/0x110
[   88.320512]  __do_sys_finit_module+0xaa/0x110
[   88.320520]  do_syscall_64+0x5b/0x180
[   88.320525]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   88.320528] RIP: 0033:0x7f8d8d1f01fd
[   88.320532] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5b 8c 0c 00 f7 d8 64 89 01 48
[   88.320535] RSP: 002b:00007ffefa3bb068 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[   88.320539] RAX: ffffffffffffffda RBX: 000055922040cb40 RCX: 00007f8d8d1=
f01fd
[   88.320541] RDX: 0000000000000000 RSI: 00007f8d8ce4984d RDI: 00000000000=
00006
[   88.320543] RBP: 0000000000020000 R08: 0000000000000000 R09: 00000000000=
00007
[   88.320545] R10: 0000000000000006 R11: 0000000000000246 R12: 00007f8d8ce=
4984d
[   88.320547] R13: 0000000000000000 R14: 000055922040efc0 R15: 00005592204=
0cb40
[   88.320551] Modules linked in: hid_logitech_hidpp(+) fuse rfcomm ccm xt_=
CHECKSUM xt_MASQUERADE bridge stp llc nf_nat_tftp nf_conntrack_tftp nf_conn=
track_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_=
reject_ipv6 xt_conntrack ebtable_nat ip6table_nat ip6table_mangle ip6table_=
raw ip6table_security iptable_nat nf_nat tun iptable_mangle iptable_raw ipt=
able_security nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c ip_set n=
fnetlink ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep sunrp=
c dm_crypt nls_utf8 hfsplus intel_rapl_msr intel_rapl_common ath9k_htc ath9=
k_common x86_pkg_temp_thermal intel_powerclamp b43 ath9k_hw coretemp snd_hd=
a_codec_hdmi cordic kvm_intel snd_hda_codec_cirrus mac80211 snd_hda_codec_g=
eneric ledtrig_audio kvm snd_hda_intel snd_intel_nhlt irqbypass snd_hda_cod=
ec btusb btrtl snd_hda_core ath btbcm ssb snd_hwdep btintel snd_seq crct10d=
if_pclmul iTCO_wdt snd_seq_device crc32_pclmul bluetooth mmc_core iTCO_vend=
or_support joydev cfg80211
[   88.320602]  applesmc ghash_clmulni_intel ecdh_generic snd_pcm input_pol=
ldev intel_cstate ecc intel_uncore thunderbolt snd_timer i2c_i801 libarc4 r=
fkill intel_rapl_perf lpc_ich mei_me pcspkr bcm5974 snd bcma mei soundcore =
acpi_als sbs kfifo_buf sbshc industrialio apple_bl i915 i2c_algo_bit drm_km=
s_helper drm uas crc32c_intel usb_storage video hid_apple
[   88.320630] CR2: 0000000000000018
[   88.320633] ---[ end trace 933491c8a4fadeb7 ]---
[   88.320642] RIP: 0010:hidpp_probe+0x61f/0x948 [hid_logitech_hidpp]
[   88.320645] Code: 81 00 00 48 89 ef e8 f0 d6 ff ff 41 89 c6 85 c0 75 b5 =
0f b6 44 24 28 48 8b 5d 00 88 44 24 1e 89 44 24 0c 48 8b 83 18 1c 00 00 <48=
> 8b 48 18 48 8b 83 10 19 00 00 48 8b 40 40 48 89 0c 24 0f b7 80
[   88.320647] RSP: 0018:ffffb0a6824aba68 EFLAGS: 00010246
[   88.320650] RAX: 0000000000000000 RBX: ffff93a50756e000 RCX: 00000000000=
10408
[   88.320652] RDX: 0000000000000000 RSI: ffff93a51f0ad0a0 RDI: 00000000000=
2d0a0
[   88.320655] RBP: ffff93a50416da28 R08: ffff93a50416da70 R09: ffff93a5041=
6da70
[   88.320657] R10: 000000148ae9e60c R11: 00000000000f1525 R12: ffff93a5075=
6e000
[   88.320659] R13: ffff93a50756f8d0 R14: 0000000000000000 R15: ffff93a5075=
6fc38
[   88.320662] FS:  00007f8d8c1e0940(0000) GS:ffff93a51f080000(0000) knlGS:=
0000000000000000
[   88.320664] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   88.320667] CR2: 0000000000000018 CR3: 00000003996d8003 CR4: 00000000001=
606e0

To solve this issue:

   1. Split g920_get_config() such that all of the device specific
      communication remains a part of the function and input subsystem
      initialization bits go to hidpp_ff_init()

   2. Move call to hidpp_ff_init() from being a part of
      g920_get_config() to be the last step of .probe(), right after a
      call to hid_hw_start() with connect_mask containing
      HID_CONNECT_HIDINPUT.

Fixes: 91cf9a98ae41 ("HID: logitech-hidpp: make .probe usbhid capable")
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Henrik Rydberg <rydberg@bitmath.org>
Cc: Sam Bazely <sambazley@fastmail.com>
Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Cc: Austin Palmer <austinp@valvesoftware.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 drivers/hid/hid-logitech-hidpp.c | 134 ++++++++++++++++++++-----------
 1 file changed, 85 insertions(+), 49 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hi=
dpp.c
index 58eb928224e5..cadf36d6c6f3 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -1669,6 +1669,7 @@ static void hidpp_touchpad_raw_xy_event(struct hidpp_=
device *hidpp_dev,
=20
 #define HIDPP_FF_EFFECTID_NONE		-1
 #define HIDPP_FF_EFFECTID_AUTOCENTER	-2
+#define HIDPP_AUTOCENTER_PARAMS_LENGTH	18
=20
 #define HIDPP_FF_MAX_PARAMS	20
 #define HIDPP_FF_RESERVED_SLOTS	1
@@ -2009,7 +2010,7 @@ static int hidpp_ff_erase_effect(struct input_dev *de=
v, int effect_id)
 static void hidpp_ff_set_autocenter(struct input_dev *dev, u16 magnitude)
 {
 	struct hidpp_ff_private_data *data =3D dev->ff->private;
-	u8 params[18];
+	u8 params[HIDPP_AUTOCENTER_PARAMS_LENGTH];
=20
 	dbg_hid("Setting autocenter to %d.\n", magnitude);
=20
@@ -2086,7 +2087,7 @@ static void hidpp_ff_destroy(struct ff_device *ff)
 	ff->private =3D NULL;
 }
=20
-static int hidpp_ff_init(struct hidpp_device *hidpp, u8 feature_index)
+static int hidpp_ff_init(struct hidpp_device *hidpp)
 {
 	struct hid_device *hid =3D hidpp->hid_dev;
 	struct hid_input *hidinput =3D list_entry(hid->inputs.next, struct hid_in=
put, list);
@@ -2094,9 +2095,8 @@ static int hidpp_ff_init(struct hidpp_device *hidpp, =
u8 feature_index)
 	const struct usb_device_descriptor *udesc =3D &(hid_to_usb_dev(hid)->desc=
riptor);
 	const u16 bcdDevice =3D le16_to_cpu(udesc->bcdDevice);
 	struct ff_device *ff;
-	struct hidpp_report response;
 	struct hidpp_ff_private_data *data =3D hidpp->private_data;
-	int error, j, num_slots;
+	int error, j, num_slots =3D data->num_effects;
 	u8 version;
=20
 	if (!dev) {
@@ -2114,19 +2114,6 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,=
 u8 feature_index)
 		for (j =3D 0; hidpp_ff_effects_v2[j] >=3D 0; j++)
 			set_bit(hidpp_ff_effects_v2[j], dev->ffbit);
=20
-	/* Read number of slots available in device */
-	error =3D hidpp_send_fap_command_sync(hidpp, feature_index,
-		HIDPP_FF_GET_INFO, NULL, 0, &response);
-	if (error) {
-		if (error < 0)
-			return error;
-		hid_err(hidpp->hid_dev, "%s: received protocol error 0x%02x\n",
-			__func__, error);
-		return -EPROTO;
-	}
-
-	num_slots =3D response.fap.params[0] - HIDPP_FF_RESERVED_SLOTS;
-
 	error =3D input_ff_create(dev, num_slots);
=20
 	if (error) {
@@ -2145,10 +2132,7 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,=
 u8 feature_index)
 	}
=20
 	data->hidpp =3D hidpp;
-	data->feature_index =3D feature_index;
 	data->version =3D version;
-	data->slot_autocenter =3D 0;
-	data->num_effects =3D num_slots;
 	for (j =3D 0; j < num_slots; j++)
 		data->effect_ids[j] =3D -1;
=20
@@ -2162,37 +2146,14 @@ static int hidpp_ff_init(struct hidpp_device *hidpp=
, u8 feature_index)
 	ff->set_autocenter =3D hidpp_ff_set_autocenter;
 	ff->destroy =3D hidpp_ff_destroy;
=20
-
-	/* reset all forces */
-	error =3D hidpp_send_fap_command_sync(hidpp, feature_index,
-		HIDPP_FF_RESET_ALL, NULL, 0, &response);
-
-	/* Read current Range */
-	error =3D hidpp_send_fap_command_sync(hidpp, feature_index,
-		HIDPP_FF_GET_APERTURE, NULL, 0, &response);
-	if (error)
-		hid_warn(hidpp->hid_dev, "Failed to read range from device!\n");
-	data->range =3D error ? 900 : get_unaligned_be16(&response.fap.params[0]);
-
 	/* Create sysfs interface */
 	error =3D device_create_file(&(hidpp->hid_dev->dev), &dev_attr_range);
 	if (error)
 		hid_warn(hidpp->hid_dev, "Unable to create sysfs interface for \"range\"=
, errno %d!\n", error);
=20
-	/* Read the current gain values */
-	error =3D hidpp_send_fap_command_sync(hidpp, feature_index,
-		HIDPP_FF_GET_GLOBAL_GAINS, NULL, 0, &response);
-	if (error)
-		hid_warn(hidpp->hid_dev, "Failed to read gain values from device!\n");
-	data->gain =3D error ? 0xffff : get_unaligned_be16(&response.fap.params[0=
]);
-	/* ignore boost value at response.fap.params[2] */
-
 	/* init the hardware command queue */
 	atomic_set(&data->workqueue_size, 0);
=20
-	/* initialize with zero autocenter to get wheel in usable state */
-	hidpp_ff_set_autocenter(dev, 0);
-
 	hid_info(hid, "Force feedback support loaded (firmware release %d).\n",
 		 version);
=20
@@ -2712,6 +2673,30 @@ static int k400_connect(struct hid_device *hdev, boo=
l connected)
=20
 #define HIDPP_PAGE_G920_FORCE_FEEDBACK			0x8123
=20
+static int g920_ff_set_autocenter(struct hidpp_device *hidpp)
+{
+	struct hidpp_report response;
+	struct hidpp_ff_private_data *data =3D hidpp->private_data;
+	u8 params[HIDPP_AUTOCENTER_PARAMS_LENGTH] =3D {
+		[1] =3D HIDPP_FF_EFFECT_SPRING | HIDPP_FF_EFFECT_AUTOSTART,
+	};
+	int ret;
+
+	/* initialize with zero autocenter to get wheel in usable state */
+
+	dbg_hid("Setting autocenter to 0.\n");
+	ret =3D hidpp_send_fap_command_sync(hidpp, data->feature_index,
+					  HIDPP_FF_DOWNLOAD_EFFECT,
+					  params, ARRAY_SIZE(params),
+					  &response);
+	if (ret)
+		hid_warn(hidpp->hid_dev, "Failed to autocenter device!\n");
+	else
+		data->slot_autocenter =3D response.fap.params[0];
+
+	return ret;
+}
+
 static int g920_allocate(struct hid_device *hdev)
 {
 	struct hidpp_device *hidpp =3D hid_get_drvdata(hdev);
@@ -2728,22 +2713,65 @@ static int g920_allocate(struct hid_device *hdev)
=20
 static int g920_get_config(struct hidpp_device *hidpp)
 {
+	struct hidpp_ff_private_data *data =3D hidpp->private_data;
+	struct hidpp_report response;
 	u8 feature_type;
-	u8 feature_index;
 	int ret;
=20
 	/* Find feature and store for later use */
 	ret =3D hidpp_root_get_feature(hidpp, HIDPP_PAGE_G920_FORCE_FEEDBACK,
-		&feature_index, &feature_type);
+				     &data->feature_index, &feature_type);
 	if (ret)
 		return ret;
=20
-	ret =3D hidpp_ff_init(hidpp, feature_index);
+	/* Read number of slots available in device */
+	ret =3D hidpp_send_fap_command_sync(hidpp, data->feature_index,
+					  HIDPP_FF_GET_INFO,
+					  NULL, 0,
+					  &response);
+	if (ret) {
+		if (ret < 0)
+			return ret;
+		hid_err(hidpp->hid_dev,
+			"%s: received protocol error 0x%02x\n", __func__, ret);
+		return -EPROTO;
+	}
+
+	data->num_effects =3D response.fap.params[0] - HIDPP_FF_RESERVED_SLOTS;
+
+	/* reset all forces */
+	ret =3D hidpp_send_fap_command_sync(hidpp, data->feature_index,
+					  HIDPP_FF_RESET_ALL,
+					  NULL, 0,
+					  &response);
 	if (ret)
-		hid_warn(hidpp->hid_dev, "Unable to initialize force feedback support, e=
rrno %d\n",
-				ret);
+		hid_warn(hidpp->hid_dev, "Failed to reset all forces!\n");
=20
-	return 0;
+	ret =3D hidpp_send_fap_command_sync(hidpp, data->feature_index,
+					  HIDPP_FF_GET_APERTURE,
+					  NULL, 0,
+					  &response);
+	if (ret) {
+		hid_warn(hidpp->hid_dev,
+			 "Failed to read range from device!\n");
+	}
+	data->range =3D ret ?
+		900 : get_unaligned_be16(&response.fap.params[0]);
+
+	/* Read the current gain values */
+	ret =3D hidpp_send_fap_command_sync(hidpp, data->feature_index,
+					  HIDPP_FF_GET_GLOBAL_GAINS,
+					  NULL, 0,
+					  &response);
+	if (ret)
+		hid_warn(hidpp->hid_dev,
+			 "Failed to read gain values from device!\n");
+	data->gain =3D ret ?
+		0xffff : get_unaligned_be16(&response.fap.params[0]);
+
+	/* ignore boost value at response.fap.params[2] */
+
+	return g920_ff_set_autocenter(hidpp);
 }
=20
 /* -----------------------------------------------------------------------=
--- */
@@ -3641,6 +3669,14 @@ static int hidpp_probe(struct hid_device *hdev, cons=
t struct hid_device_id *id)
 		goto hid_hw_start_fail;
 	}
=20
+	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920) {
+		ret =3D hidpp_ff_init(hidpp);
+		if (ret)
+			hid_warn(hidpp->hid_dev,
+		     "Unable to initialize force feedback support, errno %d\n",
+				 ret);
+	}
+
 	return ret;
=20
 hid_hw_init_fail:
--=20
2.21.0

