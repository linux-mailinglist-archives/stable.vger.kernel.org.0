Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D63F412645
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355007AbhITS4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385808AbhITSw2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 378BD6338F;
        Mon, 20 Sep 2021 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159313;
        bh=RUUjT3Q4wXHxoRVxBTxEpZMSXzGwZ0qSU8FMOJdgt+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZFRU8oPzpDxQwspRpv8rjXZnONBDD9TwyD2uj/fiSo9OxG4OVgdMqMMx+d19XE1z
         tPtFSmh+/4T5xBtFzl8j/JK3SWKdNaz+Sn8jLARz+18an7DCSCaDmNGRGcarnE0KpB
         DqJa2xs67kSaPpWlqMZUp+idJdzaB6+jke19LfGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 167/168] cxgb3: fix oops on module removal
Date:   Mon, 20 Sep 2021 18:45:05 +0200
Message-Id: <20210920163927.168432640@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit be27a47a760e3ad8ce979a680558776f672efffd ]

When removing the driver module w/o bringing an interface up before
the error below occurs. Reason seems to be that cancel_work_sync() is
called in t3_sge_stop() for a queue that hasn't been initialized yet.

[10085.941785] ------------[ cut here ]------------
[10085.941799] WARNING: CPU: 1 PID: 5850 at kernel/workqueue.c:3074 __flush_work+0x3ff/0x480
[10085.941819] Modules linked in: vfat snd_hda_codec_hdmi fat snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio led_class ee1004 iTCO_
wdt intel_tcc_cooling x86_pkg_temp_thermal coretemp aesni_intel crypto_simd cryptd snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core r
8169 snd_pcm realtek mdio_devres snd_timer snd i2c_i801 i2c_smbus libphy i915 i2c_algo_bit cxgb3(-) intel_gtt ttm mdio drm_kms_helper mei_me s
yscopyarea sysfillrect sysimgblt mei fb_sys_fops acpi_pad sch_fq_codel crypto_user drm efivarfs ext4 mbcache jbd2 crc32c_intel
[10085.941944] CPU: 1 PID: 5850 Comm: rmmod Not tainted 5.14.0-rc7-next-20210826+ #6
[10085.941974] Hardware name: System manufacturer System Product Name/PRIME H310I-PLUS, BIOS 2603 10/21/2019
[10085.941992] RIP: 0010:__flush_work+0x3ff/0x480
[10085.942003] Code: c0 74 6b 65 ff 0d d1 bd 78 75 e8 bc 2f 06 00 48 c7 c6 68 b1 88 8a 48 c7 c7 e0 5f b4 8b 45 31 ff e8 e6 66 04 00 e9 4b fe ff ff <0f> 0b 45 31 ff e9 41 fe ff ff e8 72 c1 79 00 85 c0 74 87 80 3d 22
[10085.942036] RSP: 0018:ffffa1744383fc08 EFLAGS: 00010246
[10085.942048] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000923
[10085.942062] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff91c901710a88
[10085.942076] RBP: ffffa1744383fce8 R08: 0000000000000001 R09: 0000000000000001
[10085.942090] R10: 00000000000000c2 R11: 0000000000000000 R12: ffff91c901710a88
[10085.942104] R13: 0000000000000000 R14: ffff91c909a96100 R15: 0000000000000001
[10085.942118] FS:  00007fe417837740(0000) GS:ffff91c969d00000(0000) knlGS:0000000000000000
[10085.942134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10085.942146] CR2: 000055a8d567ecd8 CR3: 0000000121690003 CR4: 00000000003706e0
[10085.942160] Call Trace:
[10085.942166]  ? __lock_acquire+0x3af/0x22e0
[10085.942177]  ? cancel_work_sync+0xb/0x10
[10085.942187]  __cancel_work_timer+0x128/0x1b0
[10085.942197]  ? __pm_runtime_resume+0x5b/0x90
[10085.942208]  cancel_work_sync+0xb/0x10
[10085.942217]  t3_sge_stop+0x2f/0x50 [cxgb3]
[10085.942234]  remove_one+0x26/0x190 [cxgb3]
[10085.942248]  pci_device_remove+0x39/0xa0
[10085.942258]  __device_release_driver+0x15e/0x240
[10085.942269]  driver_detach+0xd9/0x120
[10085.942278]  bus_remove_driver+0x53/0xd0
[10085.942288]  driver_unregister+0x2c/0x50
[10085.942298]  pci_unregister_driver+0x31/0x90
[10085.942307]  cxgb3_cleanup_module+0x10/0x18c [cxgb3]
[10085.942324]  __do_sys_delete_module+0x191/0x250
[10085.942336]  ? syscall_enter_from_user_mode+0x21/0x60
[10085.942347]  ? trace_hardirqs_on+0x2a/0xe0
[10085.942357]  __x64_sys_delete_module+0x13/0x20
[10085.942368]  do_syscall_64+0x40/0x90
[10085.942377]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[10085.942389] RIP: 0033:0x7fe41796323b

Fixes: 5e0b8928927f ("net:cxgb3: replace tasklets with works")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index cb5c79c43bc9..7bb81e08f953 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -3306,6 +3306,9 @@ void t3_sge_stop(struct adapter *adap)
 
 	t3_sge_stop_dma(adap);
 
+	/* workqueues aren't initialized otherwise */
+	if (!(adap->flags & FULL_INIT_DONE))
+		return;
 	for (i = 0; i < SGE_QSETS; ++i) {
 		struct sge_qset *qs = &adap->sge.qs[i];
 
-- 
2.30.2



