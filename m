Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C40E4E62
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 16:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505124AbfJYNzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 09:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505113AbfJYNzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3CC321D82;
        Fri, 25 Oct 2019 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011735;
        bh=jaoebFQ+mQjeTBDw9NyFsfRcNbaKuxfOprRtFceRTdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+3TLgx3By4BpIl6Mjjfdsw5dEDzv+VPV4WAxcvMVhR8YOzZNzDll6HKt3/AZ2APi
         GkdsE2KEQXTtmy+PyAVXz2CKs4B4AHCMTQ76UjiXX0kr00QUqtqM5RDJ3t/NppCcSM
         TX0PYzjuGWTDO9kCsu8YGNgCAwXX4A3TwsePpHv8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 17/33] usb: typec: fusb302: Call fusb302_debugfs_init earlier
Date:   Fri, 25 Oct 2019 09:54:49 -0400
Message-Id: <20191025135505.24762-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1e296b5be40d309a1585c14bc55da6ff6a29ecf0 ]

tcpm_register_port() will call some of the fusb302 code's callbacks
wich in turn will call fusb302_log(). So we need to call
fusb302_debugfs_init() before we call tcpm_register_port().

This fixes the following warning, which was caused by the logbuffer_lock
not yet being initialized (which is done by fusb302_debugfs_init):

 DEBUG_LOCKS_WARN_ON(lock->magic != lock)
 WARNING: CPU: 0 PID: 1306 at kernel/locking/mutex.c:912 __mutex_lock+0x978/0x9a0
 Modules linked in: fusb302(+) tcpm pi3usb30532 typec bq24190_charger snd_soc_sst_cht_bsw_rt5645 mei_hdcp dwc3 intel_rapl_msr udc_core ulpi gpio_keys intel_powerclamp coretemp kvm_intel brcmfmac kvm brcmutil joydev cfg80211 wdat_wdt irqbypass pcspkr intel_cstate extcon_intel_cht_wc i2c_cht_wc(E) snd_intel_sst_acpi snd_intel_sst_core snd_soc_rt5645 snd_soc_sst_atom_hifi2_platform snd_soc_acpi_intel_match snd_soc_rl6231 snd_soc_acpi intel_xhci_usb_role_switch roles hci_uart snd_soc_core btqca mei_txe btrtl processor_thermal_device mei snd_hdmi_lpe_audio lpc_ich snd_compress btbcm intel_rapl_common ac97_bus dwc3_pci snd_pcm_dmaengine intel_soc_dts_iosf btintel snd_seq bluetooth snd_seq_device snd_pcm intel_cht_int33fe_musb snd_timer intel_cht_int33fe_typec intel_hid intel_cht_int33fe_common sparse_keymap snd ecdh_generic goodix rfkill soundcore ecc spi_pxa2xx_platform max17042_battery dw_dmac int3406_thermal dptf_power acpi_pad soc_button_array int3400_thermal int3403_thermal
  gpd_pocket_fan intel_int0002_vgpio int340x_thermal_zone acpi_thermal_rel dm_crypt mmc_block i915 crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_algo_bit drm_kms_helper drm video sdhci_acpi sdhci mmc_core pwm_lpss_platform pwm_lpss i2c_dev
 CPU: 0 PID: 1306 Comm: systemd-udevd Tainted: G            E     5.3.0-rc4+ #83
 Hardware name: Default string Default string/Default string, BIOS 5.11 06/28/2017
 RIP: 0010:__mutex_lock+0x978/0x9a0
 Code: c0 0f 84 26 f7 ff ff 44 8b 05 24 25 c8 00 45 85 c0 0f 85 16 f7 ff ff 48 c7 c6 da 55 2f ae 48 c7 c7 98 8c 2d ae e8 a0 f9 5c ff <0f> 0b e9 fc f6 ff ff 4c 89 f0 4d 89 fe 49 89 c7 e9 cf fa ff ff e8
 RSP: 0018:ffffb7a8c0523800 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000002 RSI: 0000000000000001 RDI: 0000000000000246
 RBP: ffffb7a8c05238c0 R08: 0000000000000000 R09: 0000000000000000
 R10: ffffb7a8c0523648 R11: 0000000000000030 R12: 0000000000000000
 R13: ffffb7a8c0523990 R14: ffff9bf22f70c028 R15: ffff9bf22f70c360
 FS:  00007f39ca234940(0000) GS:ffff9bf237400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f1f108481a0 CR3: 0000000271f28000 CR4: 00000000001006f0
 Call Trace:
  ? find_held_lock+0x39/0x90
  ? _fusb302_log+0x81/0x1d0 [fusb302]
  ? vsnprintf+0x3aa/0x4f0
  ? _fusb302_log+0x81/0x1d0 [fusb302]
  _fusb302_log+0x81/0x1d0 [fusb302]
 ...

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20190817184340.64086-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/fusb302.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index c524088246ee3..2030ff8541783 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -1753,6 +1753,7 @@ static int fusb302_probe(struct i2c_client *client,
 	INIT_WORK(&chip->irq_work, fusb302_irq_work);
 	INIT_DELAYED_WORK(&chip->bc_lvl_handler, fusb302_bc_lvl_handler_work);
 	init_tcpc_dev(&chip->tcpc_dev);
+	fusb302_debugfs_init(chip);
 
 	if (client->irq) {
 		chip->gpio_int_n_irq = client->irq;
@@ -1778,7 +1779,6 @@ static int fusb302_probe(struct i2c_client *client,
 		goto tcpm_unregister_port;
 	}
 	enable_irq_wake(chip->gpio_int_n_irq);
-	fusb302_debugfs_init(chip);
 	i2c_set_clientdata(client, chip);
 
 	return ret;
@@ -1786,6 +1786,7 @@ static int fusb302_probe(struct i2c_client *client,
 tcpm_unregister_port:
 	tcpm_unregister_port(chip->tcpm_port);
 destroy_workqueue:
+	fusb302_debugfs_exit(chip);
 	destroy_workqueue(chip->wq);
 
 	return ret;
-- 
2.20.1

