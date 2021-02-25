Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17BA323D21
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbhBXNEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235533AbhBXM6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:58:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18DD464F43;
        Wed, 24 Feb 2021 12:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171154;
        bh=NBzIZBlBXkBTBBNLLiHUkujDJP9GyEM8FuGXqFnj0ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/dS+wF/v3Yvo6NlRiVA1v5Tb8d3nzRzxJEM8JFEvMgh7MaYPL2W9aNF9QgvFBPoe
         3jUnmoMidDwM3Tj7OmXs6HlOOAlICdsCbqV30czFzbeZRDn4RbKbaWhtuKuFlPaxhb
         CWylUw14HFy+ft0Td6UntnxZaE0dcDvn+3RZXFIWUq3KdSkxZ7NYTWHfkLhuf3XgYc
         4Px7zoVDFqCqUjEIOxZLZ4iSVmzCjHtYCkD72Yuhfx6zjBn7U3w9tfYrw7fMzTxp5M
         6/i5bGsOKxxq5a2DxzZMsyrO55f0YcsIvkxqC1YdNhcF5L1nSsMJtnrGDpJVPFLb99
         B0SN0k4MJmWnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juerg Haefliger <juerg.haefliger@canonical.com>,
        Juerg Haefliger <juergh@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 16/56] staging: bcm2835-audio: Replace unsafe strcpy() with strscpy()
Date:   Wed, 24 Feb 2021 07:51:32 -0500
Message-Id: <20210224125212.482485-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juerg Haefliger <juerg.haefliger@canonical.com>

[ Upstream commit 4964a4300660d27907ceb655f219ac47e5941534 ]

Replace strcpy() with strscpy() in bcm2835-audio/bcm2835.c to prevent the
following when loading snd-bcm2835:

[   58.480634] ------------[ cut here ]------------
[   58.485321] kernel BUG at lib/string.c:1149!
[   58.489650] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[   58.495214] Modules linked in: snd_bcm2835(COE+) snd_pcm snd_timer snd dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua btsdio bluetooth ecdh_generic ecc bcm2835_v4l2(CE) bcm2835_codec(CE) brcmfmac bcm2835_isp(CE) bcm2835_mmal_vchiq(CE) brcmutil cfg80211 v4l2_mem2mem videobuf2_vmalloc videobuf2_dma_contig videobuf2_memops raspberrypi_hwmon videobuf2_v4l2 videobuf2_common videodev bcm2835_gpiomem mc vc_sm_cma(CE) rpivid_mem uio_pdrv_genirq uio sch_fq_codel drm ip_tables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor xor_neon raid6_pq libcrc32c raid1 raid0 multipath linear dwc2 roles spidev udc_core crct10dif_ce xhci_pci xhci_pci_renesas phy_generic aes_neon_bs aes_neon_blk crypto_simd cryptd
[   58.563787] CPU: 3 PID: 1959 Comm: insmod Tainted: G         C OE     5.11.0-1001-raspi #1
[   58.572172] Hardware name: Raspberry Pi 4 Model B Rev 1.2 (DT)
[   58.578086] pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--)
[   58.584178] pc : fortify_panic+0x20/0x24
[   58.588161] lr : fortify_panic+0x20/0x24
[   58.592136] sp : ffff800010a83990
[   58.595491] x29: ffff800010a83990 x28: 0000000000000002
[   58.600879] x27: ffffb0b07cb72928 x26: 0000000000000000
[   58.606268] x25: ffff39e884973838 x24: ffffb0b07cb74190
[   58.611655] x23: ffffb0b07cb72030 x22: 0000000000000000
[   58.617042] x21: ffff39e884973014 x20: ffff39e88b793010
[   58.622428] x19: ffffb0b07cb72670 x18: 0000000000000030
[   58.627814] x17: 0000000000000000 x16: ffffb0b092ce2c1c
[   58.633200] x15: ffff39e88b901500 x14: 0720072007200720
[   58.638588] x13: 0720072007200720 x12: 0720072007200720
[   58.643979] x11: ffffb0b0936cbdf0 x10: 00000000fffff000
[   58.649366] x9 : ffffb0b09220cfa8 x8 : 0000000000000000
[   58.654752] x7 : ffffb0b093673df0 x6 : ffffb0b09364e000
[   58.660140] x5 : 0000000000000000 x4 : ffff39e93b7db948
[   58.665526] x3 : ffff39e93b7ebcf0 x2 : 0000000000000000
[   58.670913] x1 : 0000000000000000 x0 : 0000000000000022
[   58.676299] Call trace:
[   58.678775]  fortify_panic+0x20/0x24
[   58.682402]  snd_bcm2835_alsa_probe+0x5b8/0x7d8 [snd_bcm2835]
[   58.688247]  platform_probe+0x74/0xe4
[   58.691963]  really_probe+0xf0/0x510
[   58.695585]  driver_probe_device+0xe0/0x100
[   58.699826]  device_driver_attach+0xcc/0xd4
[   58.704068]  __driver_attach+0xb0/0x17c
[   58.707956]  bus_for_each_dev+0x7c/0xd4
[   58.711843]  driver_attach+0x30/0x40
[   58.715467]  bus_add_driver+0x154/0x250
[   58.719354]  driver_register+0x84/0x140
[   58.723242]  __platform_driver_register+0x34/0x40
[   58.728013]  bcm2835_alsa_driver_init+0x30/0x1000 [snd_bcm2835]
[   58.734024]  do_one_initcall+0x54/0x300
[   58.737914]  do_init_module+0x60/0x280
[   58.741719]  load_module+0x680/0x770
[   58.745344]  __do_sys_finit_module+0xbc/0x130
[   58.749761]  __arm64_sys_finit_module+0x2c/0x40
[   58.754356]  el0_svc_common.constprop.0+0x88/0x220
[   58.759216]  do_el0_svc+0x30/0xa0
[   58.762575]  el0_svc+0x28/0x70
[   58.765669]  el0_sync_handler+0x1a4/0x1b0
[   58.769732]  el0_sync+0x178/0x180
[   58.773095] Code: aa0003e1 91366040 910003fd 97ffee21 (d4210000)
[   58.779275] ---[ end trace 29be5b17497bd898 ]---
[   58.783955] note: insmod[1959] exited with preempt_count 1
[   58.791921] ------------[ cut here ]------------

For the sake of it, replace all the other occurences of strcpy() under
bcm2835-audio/ as well.

Signed-off-by: Juerg Haefliger <juergh@canonical.com>
Link: https://lore.kernel.org/r/20210205072502.10907-1-juergh@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-ctl.c | 6 +++---
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c | 2 +-
 drivers/staging/vc04_services/bcm2835-audio/bcm2835.c     | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-ctl.c b/drivers/staging/vc04_services/bcm2835-audio/bcm2835-ctl.c
index 4c2cae99776b9..3703409715dab 100644
--- a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-ctl.c
+++ b/drivers/staging/vc04_services/bcm2835-audio/bcm2835-ctl.c
@@ -224,7 +224,7 @@ int snd_bcm2835_new_ctl(struct bcm2835_chip *chip)
 {
 	int err;
 
-	strcpy(chip->card->mixername, "Broadcom Mixer");
+	strscpy(chip->card->mixername, "Broadcom Mixer", sizeof(chip->card->mixername));
 	err = create_ctls(chip, ARRAY_SIZE(snd_bcm2835_ctl), snd_bcm2835_ctl);
 	if (err < 0)
 		return err;
@@ -261,7 +261,7 @@ static const struct snd_kcontrol_new snd_bcm2835_headphones_ctl[] = {
 
 int snd_bcm2835_new_headphones_ctl(struct bcm2835_chip *chip)
 {
-	strcpy(chip->card->mixername, "Broadcom Mixer");
+	strscpy(chip->card->mixername, "Broadcom Mixer", sizeof(chip->card->mixername));
 	return create_ctls(chip, ARRAY_SIZE(snd_bcm2835_headphones_ctl),
 			   snd_bcm2835_headphones_ctl);
 }
@@ -295,7 +295,7 @@ static const struct snd_kcontrol_new snd_bcm2835_hdmi[] = {
 
 int snd_bcm2835_new_hdmi_ctl(struct bcm2835_chip *chip)
 {
-	strcpy(chip->card->mixername, "Broadcom Mixer");
+	strscpy(chip->card->mixername, "Broadcom Mixer", sizeof(chip->card->mixername));
 	return create_ctls(chip, ARRAY_SIZE(snd_bcm2835_hdmi),
 			   snd_bcm2835_hdmi);
 }
diff --git a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c b/drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c
index f783b632141b5..096f2c54258aa 100644
--- a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c
+++ b/drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c
@@ -334,7 +334,7 @@ int snd_bcm2835_new_pcm(struct bcm2835_chip *chip, const char *name,
 
 	pcm->private_data = chip;
 	pcm->nonatomic = true;
-	strcpy(pcm->name, name);
+	strscpy(pcm->name, name, sizeof(pcm->name));
 	if (!spdif) {
 		chip->dest = route;
 		chip->volume = 0;
diff --git a/drivers/staging/vc04_services/bcm2835-audio/bcm2835.c b/drivers/staging/vc04_services/bcm2835-audio/bcm2835.c
index cf5f80f5ca6b0..c250fbef2fa3d 100644
--- a/drivers/staging/vc04_services/bcm2835-audio/bcm2835.c
+++ b/drivers/staging/vc04_services/bcm2835-audio/bcm2835.c
@@ -185,9 +185,9 @@ static int snd_add_child_device(struct device *dev,
 		goto error;
 	}
 
-	strcpy(card->driver, audio_driver->driver.name);
-	strcpy(card->shortname, audio_driver->shortname);
-	strcpy(card->longname, audio_driver->longname);
+	strscpy(card->driver, audio_driver->driver.name, sizeof(card->driver));
+	strscpy(card->shortname, audio_driver->shortname, sizeof(card->shortname));
+	strscpy(card->longname, audio_driver->longname, sizeof(card->longname));
 
 	err = audio_driver->newpcm(chip, audio_driver->shortname,
 		audio_driver->route,
-- 
2.27.0

