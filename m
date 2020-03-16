Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB291862A5
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgCPCes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbgCPCer (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B58CE20722;
        Mon, 16 Mar 2020 02:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326086;
        bh=4rTwBD89a4CagL9gDyOgg/0Xk9ZXmPQVpF4kNNBT5fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vH0S2dgY16ObjVwqmZeVbdRVBnI6dvzb9vnR1/CMuFoARFLKybAR/ki4jB/cmQitv
         YlUGENi2I6BgUgYf3xeq3AKiAtA1pa2eUr3XZacek8BURD6OXf+NZUyLt0dQ26iMfk
         9YSxEjFbhiT/TYUht5H9vg+kjby6NASHGfwCDHb8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 30/35] drm/amd/display: Clear link settings on MST disable connector
Date:   Sun, 15 Mar 2020 22:34:06 -0400
Message-Id: <20200316023411.1263-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>

[ Upstream commit 5ac7fd2f597b88ee81f4748ee50cab06192a8dc3 ]

[Why]
If we have a single MST display and we disconnect it, we dont disable that
link. This causes the old link settings to still exist

Now on a replug for MST we think its a link loss and will try to reallocate
mst payload which will fail, throwing warning below.

[  129.374192] [drm] Failed to updateMST allocation table forpipe idx:0
[  129.374206] ------------[ cut here ]------------
[  129.374284] WARNING: CPU: 14 PID: 1710 at
drivers/gpu/drm/amd/amdgpu/../dal-dev/dc/core/dc_link.c:3153
dc_link_allocate_mst_payload+0x1f7/0x220 [amdgpu]

[  129.374285] Modules linked in: amdgpu(OE) amd_iommu_v2 gpu_sched ttm
drm_kms_helper drm fb_sys_fops syscopyarea sysfillrect sysimgblt
binfmt_misc nls_iso8859_1 edac_mce_amd snd_hda_codec_realtek
snd_hda_codec_generic ledtrig_audio kvm snd_hda_codec_hdmi snd_hda_intel
snd_intel_nhlt snd_hda_codec irqbypass snd_hda_core snd_hwdep snd_pcm
snd_seq_midi snd_seq_midi_event snd_rawmidi crct10dif_pclmul snd_seq
crc32_pclmul ghash_clmulni_intel snd_seq_device snd_timer snd aesni_intel
eeepc_wmi crypto_simd asus_wmi joydev cryptd sparse_keymap input_leds
soundcore video glue_helper wmi_bmof mxm_wmi k10temp ccp mac_hid
sch_fq_codel parport_pc ppdev lp parport ip_tables x_tables autofs4
hid_generic usbhid hid igb i2c_algo_bit ahci dca i2c_piix4 libahci
gpio_amdpt wmi gpio_generic

[  129.374318] CPU: 14 PID: 1710 Comm: kworker/14:2 Tainted: G        W  OE     5.4.0-rc7bhawan+ #480
[  129.374318] Hardware name: System manufacturer System Product Name/PRIME X370-PRO, BIOS 0515 03/30/2017
[  129.374397] Workqueue: events dm_irq_work_func [amdgpu]
[  129.374468] RIP: 0010:dc_link_allocate_mst_payload+0x1f7/0x220 [amdgpu]
[  129.374470] Code: 52 20 e8 1c 63 ad f4 48 8b 5d d0 65 48 33 1c 25 28 00
00 00 b8 01 00 00 00 75 16 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3
<0f> 0b e9 fa fe ff ff e8 ed 5b d6 f3 41 0f b6 b6 c4 02 00 00 48 c7
[  129.374471] RSP: 0018:ffff9f9141e7fcc0 EFLAGS: 00010246
[  129.374472] RAX: 0000000000000000 RBX: ffff91ef0762f800 RCX: 0000000000000000
[  129.374473] RDX: 0000000000000005 RSI: ffffffffc0c4a988 RDI: 0000000000000004
[  129.374474] RBP: ffff9f9141e7fd10 R08: 0000000000000005 R09: 0000000000000000
[  129.374475] R10: 0000000000000002 R11: 0000000000000001 R12: ffff91eebd510c00
[  129.374475] R13: ffff91eebd510e58 R14: ffff91ef052c01b8 R15: 0000000000000006
[  129.374476] FS:  0000000000000000(0000) GS:ffff91ef0ef80000(0000) knlGS:0000000000000000
[  129.374477] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  129.374478] CR2: 000055623ea01d50 CR3: 0000000408a8c000 CR4: 00000000003406e0
[  129.374479] Call Trace:
[  129.374550]  dc_link_reallocate_mst_payload+0x12e/0x150 [amdgpu]
[  129.374617]  dc_link_handle_hpd_rx_irq+0x6d4/0x6e0 [amdgpu]
[  129.374693]  handle_hpd_rx_irq+0x77/0x310 [amdgpu]
[  129.374768]  dm_irq_work_func+0x53/0x70 [amdgpu]
[  129.374774]  process_one_work+0x1fd/0x3f0
[  129.374776]  worker_thread+0x255/0x410
[  129.374778]  kthread+0x121/0x140
[  129.374780]  ? process_one_work+0x3f0/0x3f0
[  129.374781]  ? kthread_park+0x90/0x90
[  129.374785]  ret_from_fork+0x22/0x40

[How]
when we disable MST we should clear the cur link settings (lane_count=0 is
good enough). This will cause us to not reallocate payloads earlier than
expected and not throw the warning

Signed-off-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 16218a202b591..28a6c7b2ef4bb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -379,6 +379,7 @@ static void dm_dp_destroy_mst_connector(struct drm_dp_mst_topology_mgr *mgr,
 					   aconnector->dc_sink);
 		dc_sink_release(aconnector->dc_sink);
 		aconnector->dc_sink = NULL;
+		aconnector->dc_link->cur_link_settings.lane_count = 0;
 	}
 
 	drm_connector_unregister(connector);
-- 
2.20.1

