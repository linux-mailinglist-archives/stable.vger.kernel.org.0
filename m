Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E133B200D
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389588AbfIMNOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389580AbfIMNOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:50 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9DD6206BB;
        Fri, 13 Sep 2019 13:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380489;
        bh=/N9vNHyJ62fHqq/U/ZDEMWzOun9X69wsYY2TODK4cS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqQKHIrn+DcJJpadtF01CokJHStHoe1PY7wMxyhtRAp5gkG4ZnVKgQ+Pp2IhSJnT1
         op+QL5a0WshFNk0l2tCogrBtgP8R0ff0nZqoHc7o0I41RTZcYgoCB1dNnXQRaIdo1T
         DVZVDkJs0HUA8H3dpOB7ocnwOkW4ROedUa7kxBv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/190] drm/i915/ilk: Fix warning when reading emon_status with no output
Date:   Fri, 13 Sep 2019 14:05:37 +0100
Message-Id: <20190913130606.076310779@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cab870b7fdf3c4be747d88de5248b28db7d4055e ]

When there is no output no one will hold a runtime_pm reference
causing a warning when trying to read emom_status in debugfs.

[22.756480] ------------[ cut here ]------------
[22.756489] RPM wakelock ref not held during HW access
[22.756578] WARNING: CPU: 0 PID: 1058 at drivers/gpu/drm/i915/intel_drv.h:2104 gen5_read32+0x16b/0x1a0 [i915]
[22.756580] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic i915 coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core e1000e snd_pcm mei_me prime_numbers mei lpc_ich
[22.756595] CPU: 0 PID: 1058 Comm: debugfs_test Not tainted 4.20.0-rc1-CI-Trybot_3219+ #1
[22.756597] Hardware name: Hewlett-Packard HP Compaq 8100 Elite SFF PC/304Ah, BIOS 786H1 v01.13 07/14/2011
[22.756634] RIP: 0010:gen5_read32+0x16b/0x1a0 [i915]
[22.756637] Code: a4 ea e0 0f 0b e9 d2 fe ff ff 80 3d a5 71 19 00 00 0f 85 d3 fe ff ff 48 c7 c7 48 d0 2d a0 c6 05 91 71 19 00 01 e8 35 a4 ea e0 <0f> 0b e9 b9 fe ff ff e8 69 c6 f2 e0 85 c0 75 92 48 c7 c2 78 d0 2d
[22.756639] RSP: 0018:ffffc90000f1fd38 EFLAGS: 00010282
[22.756642] RAX: 0000000000000000 RBX: ffff8801f7ab0000 RCX: 0000000000000006
[22.756643] RDX: 0000000000000006 RSI: ffffffff8212886a RDI: ffffffff820d6d57
[22.756645] RBP: 0000000000011020 R08: 0000000043e3d1a8 R09: 0000000000000000
[22.756647] R10: ffffc90000f1fd80 R11: 0000000000000000 R12: 0000000000000001
[22.756649] R13: ffff8801f7ab0068 R14: 0000000000000001 R15: ffff88020d53d188
[22.756651] FS:  00007f2878849980(0000) GS:ffff880213a00000(0000) knlGS:0000000000000000
[22.756653] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22.756655] CR2: 00005638deedf028 CR3: 0000000203292001 CR4: 00000000000206f0
[22.756657] Call Trace:
[22.756689]  i915_mch_val+0x1b/0x60 [i915]
[22.756721]  i915_emon_status+0x45/0xd0 [i915]
[22.756730]  seq_read+0xdb/0x3c0
[22.756736]  ? lockdep_hardirqs_off+0x94/0xd0
[22.756740]  ? __slab_free+0x24e/0x510
[22.756746]  full_proxy_read+0x52/0x90
[22.756752]  __vfs_read+0x31/0x170
[22.756759]  ? do_sys_open+0x13b/0x240
[22.756763]  ? rcu_read_lock_sched_held+0x6f/0x80
[22.756766]  vfs_read+0x9e/0x140
[22.756770]  ksys_read+0x50/0xc0
[22.756775]  do_syscall_64+0x55/0x190
[22.756781]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[22.756783] RIP: 0033:0x7f28781dc34e
[22.756786] Code: 00 00 00 00 48 8b 15 71 8c 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 0f 1f 40 00 8b 05 ba d0 20 00 85 c0 75 16 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 5a f3 c3 0f 1f 84 00 00 00 00 00 41 54 55 49
[22.756787] RSP: 002b:00007ffd33fa0d08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[22.756790] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f28781dc34e
[22.756792] RDX: 0000000000000200 RSI: 00007ffd33fa0d50 RDI: 0000000000000008
[22.756794] RBP: 00007ffd33fa0f60 R08: 0000000000000000 R09: 0000000000000020
[22.756796] R10: 0000000000000000 R11: 0000000000000246 R12: 00005638de45c2c0
[22.756797] R13: 00007ffd33fa14b0 R14: 0000000000000000 R15: 0000000000000000
[22.756806] irq event stamp: 47950
[22.756811] hardirqs last  enabled at (47949): [<ffffffff810fba74>] vprintk_emit+0x124/0x320
[22.756813] hardirqs last disabled at (47950): [<ffffffff810019b0>] trace_hardirqs_off_thunk+0x1a/0x1c
[22.756816] softirqs last  enabled at (47518): [<ffffffff81c0033a>] __do_softirq+0x33a/0x4b9
[22.756820] softirqs last disabled at (47479): [<ffffffff8108df29>] irq_exit+0xa9/0xc0
[22.756858] WARNING: CPU: 0 PID: 1058 at drivers/gpu/drm/i915/intel_drv.h:2104 gen5_read32+0x16b/0x1a0 [i915]
[22.756860] ---[ end trace bf56fa7d6a3cbf7a ]

Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181119230101.32460-1-jose.souza@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index f9ce35da4123e..e063e98d1e82e 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1788,6 +1788,8 @@ static int i915_emon_status(struct seq_file *m, void *unused)
 	if (!IS_GEN5(dev_priv))
 		return -ENODEV;
 
+	intel_runtime_pm_get(dev_priv);
+
 	ret = mutex_lock_interruptible(&dev->struct_mutex);
 	if (ret)
 		return ret;
@@ -1802,6 +1804,8 @@ static int i915_emon_status(struct seq_file *m, void *unused)
 	seq_printf(m, "GFX power: %ld\n", gfx);
 	seq_printf(m, "Total power: %ld\n", chipset + gfx);
 
+	intel_runtime_pm_put(dev_priv);
+
 	return 0;
 }
 
-- 
2.20.1



