Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAD7383778
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243709AbhEQPoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241722AbhEQPln (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F79561221;
        Mon, 17 May 2021 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262534;
        bh=hrb9+TXRvjZ0nlaKhvvIk5PQ76JinV5bQW2nJNr+cFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rn6EE26XfzmDEaxbuIQhn4115bC/PJEs4wfg1z3OU7dM/gubDoMH1Pjc53qfFbswF
         MbzB+6/8rfA/abyZmzfL66gmpJ545gcQ+KrNdObucv5PBa5CU8ZkEreXxAJG6bqMcj
         +rWSz/8jSJExNSA3scBdM4jevuMM+89IFC5hfJm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.11 315/329] drm/i915: Fix crash in auto_retire
Date:   Mon, 17 May 2021 16:03:46 +0200
Message-Id: <20210517140312.745970897@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: St=C3=A9phane Marchesin <marcheu@chromium.org>

commit 402be8a101190969fc7ff122d07e262df86e132b upstream.

The retire logic uses the 2 lower bits of the pointer to the retire
function to store flags. However, the auto_retire function is not
guaranteed to be aligned to a multiple of 4, which causes crashes as
we jump to the wrong address, for example like this:

2021-04-24T18:03:53.804300Z WARNING kernel: [  516.876901] invalid opcode: =
0000 [#1] PREEMPT SMP NOPTI
2021-04-24T18:03:53.804310Z WARNING kernel: [  516.876906] CPU: 7 PID: 146 =
Comm: kworker/u16:6 Tainted: G     U            5.4.105-13595-g3cd84167b2df=
 #1
2021-04-24T18:03:53.804311Z WARNING kernel: [  516.876907] Hardware name: G=
oogle Volteer2/Volteer2, BIOS Google_Volteer2.13672.76.0 02/22/2021
2021-04-24T18:03:53.804312Z WARNING kernel: [  516.876911] Workqueue: event=
s_unbound active_work
2021-04-24T18:03:53.804313Z WARNING kernel: [  516.876914] RIP: 0010:auto_r=
etire+0x1/0x20
2021-04-24T18:03:53.804314Z WARNING kernel: [  516.876916] Code: e8 01 f2 f=
f ff eb 02 31 db 48 89 d8 5b 5d c3 0f 1f 44 00 00 55 48 89 e5 f0 ff 87 c8 0=
0 00 00 0f 88 ab 47 4a 00 31 c0 5d c3 0f <1f> 44 00 00 55 48 89 e5 f0 ff 8f=
 c8 00 00 00 0f 88 9a 47 4a 00 74
2021-04-24T18:03:53.804319Z WARNING kernel: [  516.876918] RSP: 0018:ffff9b=
4d809fbe38 EFLAGS: 00010286
2021-04-24T18:03:53.804320Z WARNING kernel: [  516.876919] RAX: 00000000000=
00007 RBX: ffff927915079600 RCX: 0000000000000007
2021-04-24T18:03:53.804320Z WARNING kernel: [  516.876921] RDX: ffff9b4d809=
fbe40 RSI: 0000000000000286 RDI: ffff927915079600
2021-04-24T18:03:53.804321Z WARNING kernel: [  516.876922] RBP: ffff9b4d809=
fbe68 R08: 8080808080808080 R09: fefefefefefefeff
2021-04-24T18:03:53.804321Z WARNING kernel: [  516.876924] R10: 00000000000=
00010 R11: ffffffff92e44bd8 R12: ffff9279150796a0
2021-04-24T18:03:53.804322Z WARNING kernel: [  516.876925] R13: ffff92791c3=
68180 R14: ffff927915079640 R15: 000000001c867605
2021-04-24T18:03:53.804323Z WARNING kernel: [  516.876926] FS:  00000000000=
00000(0000) GS:ffff92791ffc0000(0000) knlGS:0000000000000000
2021-04-24T18:03:53.804323Z WARNING kernel: [  516.876928] CS:  0010 DS: 00=
00 ES: 0000 CR0: 0000000080050033
2021-04-24T18:03:53.804324Z WARNING kernel: [  516.876929] CR2: 00002395149=
55000 CR3: 00000007f82da001 CR4: 0000000000760ee0
2021-04-24T18:03:53.804325Z WARNING kernel: [  516.876930] PKRU: 55555554
2021-04-24T18:03:53.804325Z WARNING kernel: [  516.876931] Call Trace:
2021-04-24T18:03:53.804326Z WARNING kernel: [  516.876935]  __active_retire=
+0x77/0xcf
2021-04-24T18:03:53.804326Z WARNING kernel: [  516.876939]  process_one_wor=
k+0x1da/0x394
2021-04-24T18:03:53.804327Z WARNING kernel: [  516.876941]  worker_thread+0=
x216/0x375
2021-04-24T18:03:53.804327Z WARNING kernel: [  516.876944]  kthread+0x147/0=
x156
2021-04-24T18:03:53.804335Z WARNING kernel: [  516.876946]  ? pr_cont_work+=
0x58/0x58
2021-04-24T18:03:53.804335Z WARNING kernel: [  516.876948]  ? kthread_blkcg=
+0x2e/0x2e
2021-04-24T18:03:53.804336Z WARNING kernel: [  516.876950]  ret_from_fork+0=
x1f/0x40
2021-04-24T18:03:53.804336Z WARNING kernel: [  516.876952] Modules linked i=
n: cdc_mbim cdc_ncm cdc_wdm xt_cgroup rfcomm cmac algif_hash algif_skcipher=
 af_alg xt_MASQUERADE uinput snd_soc_rt5682_sdw snd_soc_rt5682 snd_soc_max9=
8373_sdw snd_soc_max98373 snd_soc_rl6231 regmap_sdw snd_soc_sof_sdw snd_soc=
_hdac_hdmi snd_soc_dmic snd_hda_codec_hdmi snd_sof_pci snd_sof_intel_hda_co=
mmon intel_ipu6_psys snd_sof_xtensa_dsp soundwire_intel soundwire_generic_a=
llocation soundwire_cadence snd_sof_intel_hda snd_sof snd_soc_hdac_hda snd_=
soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core soundwire_bus snd_hda_in=
tel snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core intel_ipu6_isys v=
ideobuf2_dma_contig videobuf2_v4l2 videobuf2_common videobuf2_memops mei_hd=
cp intel_ipu6 ov2740 ov8856 at24 sx9310 dw9768 v4l2_fwnode cros_ec_typec in=
tel_pmc_mux roles acpi_als typec fuse iio_trig_sysfs cros_ec_light_prox cro=
s_ec_lid_angle cros_ec_sensors cros_ec_sensors_core industrialio_triggered_=
buffer cros_ec_sensors_ring kfifo_buf industrialio cros_ec_sensorhub
2021-04-24T18:03:53.804337Z WARNING kernel: [  516.876972]  cdc_ether usbne=
t iwlmvm lzo_rle lzo_compress iwl7000_mac80211 iwlwifi zram cfg80211 r8152 =
mii btusb btrtl btintel btbcm bluetooth ecdh_generic ecc joydev
2021-04-24T18:03:53.804337Z EMERG kernel: [  516.879169] gsmi: Log Shutdown=
 Reason 0x03

This change fixes this by aligning the function.

Signed-off-by: St=C3=A9phane Marchesin <marcheu@chromium.org>
Fixes: 229007e02d69 ("drm/i915: Wrap i915_active in a simple kreffed struct=
")
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210429031021.1218091-=
1-marcheu@chromium.org
(cherry picked from commit ca419f407b43cc89942ebc297c7a63d94abbcae4)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_active.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -1159,7 +1159,8 @@ static int auto_active(struct i915_activ
 	return 0;
 }
=20
-static void auto_retire(struct i915_active *ref)
+__i915_active_call static void
+auto_retire(struct i915_active *ref)
 {
 	i915_active_put(ref);
 }


