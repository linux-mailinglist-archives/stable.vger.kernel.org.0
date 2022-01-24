Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D269499A70
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378908AbiAXVoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46782 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454796AbiAXVdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F1D2B81233;
        Mon, 24 Jan 2022 21:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FFAC340E4;
        Mon, 24 Jan 2022 21:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060020;
        bh=yg7nmv7uay7Pj6NDNSVSmBGl9495vlN68aIKhTtxQGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JryVdkoJskiRSaJ+mlp07iig0a9C2hpf0YIyOTXj15pRJWrr3icUdCjH46gx9j3p3
         pGirozeVxzco9MaI9ckdMuv3x0YyhHCSSq0Swt9xvQcLj0P1g1iBr0WSe1eriwAEB/
         9x3EvICcTczPm9CRhKSCpUL1bVEGv2yCP55SrzD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Shawn C <shawn.c.lee@intel.com>,
        Juston Li <juston.li@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0813/1039] drm/i915/pxp: Hold RPM wakelock during PXP unbind
Date:   Mon, 24 Jan 2022 19:43:22 +0100
Message-Id: <20220124184152.635190440@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juston Li <juston.li@intel.com>

[ Upstream commit f9535d28ac93c3cc326f7215fccd0abe1d3a6083 ]

Similar to commit b8d8436840ca ("drm/i915/gt: Hold RPM wakelock during
PXP suspend") but to fix the same warning for unbind during shutdown:

------------[ cut here ]------------
RPM wakelock ref not held during HW access
WARNING: CPU: 0 PID: 4139 at drivers/gpu/drm/i915/intel_runtime_pm.h:115
gen12_fwtable_write32+0x1b7/0
Modules linked in: 8021q ccm rfcomm cmac algif_hash algif_skcipher
af_alg uinput snd_hda_codec_hdmi vf industrialio iwl7000_mac80211
cros_ec_sensorhub lzo_rle lzo_compress zram iwlwifi cfg80211 joydev
CPU: 0 PID: 4139 Comm: halt Tainted: G     U  W
5.10.84 #13 344e11e079c4a03940d949e537eab645f6
RIP: 0010:gen12_fwtable_write32+0x1b7/0x200
Code: 48 c7 c7 fc b3 b5 89 31 c0 e8 2c f3 ad ff 0f 0b e9 04 ff ff ff c6
05 71 e9 1d 01 01 48 c7 c7 d67
RSP: 0018:ffffa09ec0bb3bb0 EFLAGS: 00010246
RAX: 12dde97bbd260300 RBX: 00000000000320f0 RCX: ffffffff89e60ea0
RDX: 0000000000000000 RSI: 00000000ffffdfff RDI: ffffffff89e60e70
RBP: ffffa09ec0bb3bd8 R08: 0000000000000000 R09: ffffa09ec0bb3950
R10: 00000000ffffdfff R11: ffffffff89e91160 R12: 0000000000000000
R13: 0000000028121969 R14: ffff9515c32f0990 R15: 0000000040000000
FS:  0000790dcf225740(0000) GS:ffff951737800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000058b25efae147 CR3: 0000000133ea6001 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff07f0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 intel_pxp_fini_hw+0x2f/0x39
 i915_pxp_tee_component_unbind+0x1c/0x42
 component_unbind+0x32/0x48
 component_unbind_all+0x80/0x9d
 take_down_master+0x24/0x36
 component_master_del+0x56/0x70
 mei_pxp_remove+0x2c/0x68
 mei_cl_device_remove+0x35/0x68
 device_release_driver_internal+0x100/0x1a1
 mei_cl_bus_remove_device+0x21/0x79
 mei_cl_bus_remove_devices+0x3b/0x51
 mei_stop+0x3b/0xae
 mei_me_shutdown+0x23/0x58
 device_shutdown+0x144/0x1d3
 kernel_power_off+0x13/0x4c
 __se_sys_reboot+0x1d4/0x1e9
 do_syscall_64+0x43/0x55
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x790dcf316273
Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
00 89 fa be 69 19 12 28 bf ad8
RSP: 002b:00007ffca0df9198 EFLAGS: 00000202 ORIG_RAX: 00000000000000a9
RAX: ffffffffffffffda RBX: 000000004321fedc RCX: 0000790dcf316273
RDX: 000000004321fedc RSI: 0000000028121969 RDI: 00000000fee1dead
RBP: 00007ffca0df9200 R08: 0000000000000007 R09: 0000563ce8cd8970
R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffca0df9308
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000003
---[ end trace 2f501b01b348f114 ]---
ACPI: Preparing to enter system sleep state S5
reboot: Power down

Changes since v1:
 - Rebase to latest drm-tip

Fixes: 0cfab4cb3c4e ("drm/i915/pxp: Enable PXP power management")
Suggested-by: Lee Shawn C <shawn.c.lee@intel.com>
Signed-off-by: Juston Li <juston.li@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220106200236.489656-2-juston.li@intel.com
(cherry picked from commit 57ded5fc98b11d76dae505ca3591b61c9dbbbda7)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/pxp/intel_pxp_tee.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/pxp/intel_pxp_tee.c b/drivers/gpu/drm/i915/pxp/intel_pxp_tee.c
index 49508f31dcb73..d2980370d9297 100644
--- a/drivers/gpu/drm/i915/pxp/intel_pxp_tee.c
+++ b/drivers/gpu/drm/i915/pxp/intel_pxp_tee.c
@@ -103,9 +103,12 @@ static int i915_pxp_tee_component_bind(struct device *i915_kdev,
 static void i915_pxp_tee_component_unbind(struct device *i915_kdev,
 					  struct device *tee_kdev, void *data)
 {
+	struct drm_i915_private *i915 = kdev_to_i915(i915_kdev);
 	struct intel_pxp *pxp = i915_dev_to_pxp(i915_kdev);
+	intel_wakeref_t wakeref;
 
-	intel_pxp_fini_hw(pxp);
+	with_intel_runtime_pm_if_in_use(&i915->runtime_pm, wakeref)
+		intel_pxp_fini_hw(pxp);
 
 	mutex_lock(&pxp->tee_mutex);
 	pxp->pxp_component = NULL;
-- 
2.34.1



