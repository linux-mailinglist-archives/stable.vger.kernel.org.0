Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0A438A4D3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbhETKKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhETKHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CF386194B;
        Thu, 20 May 2021 09:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503723;
        bh=v4aY7inSMc/C3eMfCeE6JVbr0ojkhQCKKeA8OlsU+Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjW8FnHDUIWLRkSzphzI5dPmlSVPdVzTw8NS5kd9x8K3RWlVwpDHEqqy9nv+IzbM9
         DHymsIUF1+LICAojvDziavuhOCxMiwiaIOuG3VuEJ7Ds9CFS43XtEoVw3/KK6/ugcn
         DhvcWW/mh3fCuUy0LRoquLcRXOjIFbeBKoAMSJ7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Kees Cook <keescook@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 350/425] drm/radeon: Fix off-by-one power_state index heap overwrite
Date:   Thu, 20 May 2021 11:21:59 +0200
Message-Id: <20210520092142.910102643@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 5bbf219328849e83878bddb7c226d8d42e84affc ]

An out of bounds write happens when setting the default power state.
KASAN sees this as:

[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 131072, num gpu pages 131072
==================================================================
BUG: KASAN: slab-out-of-bounds in
radeon_atombios_parse_power_table_1_3+0x1837/0x1998 [radeon]
Write of size 4 at addr ffff88810178d858 by task systemd-udevd/157

CPU: 0 PID: 157 Comm: systemd-udevd Not tainted 5.12.0-E620 #50
Hardware name: eMachines        eMachines E620  /Nile       , BIOS V1.03 09/30/2008
Call Trace:
 dump_stack+0xa5/0xe6
 print_address_description.constprop.0+0x18/0x239
 kasan_report+0x170/0x1a8
 radeon_atombios_parse_power_table_1_3+0x1837/0x1998 [radeon]
 radeon_atombios_get_power_modes+0x144/0x1888 [radeon]
 radeon_pm_init+0x1019/0x1904 [radeon]
 rs690_init+0x76e/0x84a [radeon]
 radeon_device_init+0x1c1a/0x21e5 [radeon]
 radeon_driver_load_kms+0xf5/0x30b [radeon]
 drm_dev_register+0x255/0x4a0 [drm]
 radeon_pci_probe+0x246/0x2f6 [radeon]
 pci_device_probe+0x1aa/0x294
 really_probe+0x30e/0x850
 driver_probe_device+0xe6/0x135
 device_driver_attach+0xc1/0xf8
 __driver_attach+0x13f/0x146
 bus_for_each_dev+0xfa/0x146
 bus_add_driver+0x2b3/0x447
 driver_register+0x242/0x2c1
 do_one_initcall+0x149/0x2fd
 do_init_module+0x1ae/0x573
 load_module+0x4dee/0x5cca
 __do_sys_finit_module+0xf1/0x140
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Without KASAN, this will manifest later when the kernel attempts to
allocate memory that was stomped, since it collides with the inline slab
freelist pointer:

invalid opcode: 0000 [#1] SMP NOPTI
CPU: 0 PID: 781 Comm: openrc-run.sh Tainted: G        W 5.10.12-gentoo-E620 #2
Hardware name: eMachines        eMachines E620  /Nile , BIOS V1.03       09/30/2008
RIP: 0010:kfree+0x115/0x230
Code: 89 c5 e8 75 ea ff ff 48 8b 00 0f ba e0 09 72 63 e8 1f f4 ff ff 41 89 c4 48 8b 45 00 0f ba e0 10 72 0a 48 8b 45 08 a8 01 75 02 <0f> 0b 44 89 e1 48 c7 c2 00 f0 ff ff be 06 00 00 00 48 d3 e2 48 c7
RSP: 0018:ffffb42f40267e10 EFLAGS: 00010246
RAX: ffffd61280ee8d88 RBX: 0000000000000004 RCX: 000000008010000d
RDX: 4000000000000000 RSI: ffffffffba1360b0 RDI: ffffd61280ee8d80
RBP: ffffd61280ee8d80 R08: ffffffffb91bebdf R09: 0000000000000000
R10: ffff8fe2c1047ac8 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000100
FS:  00007fe80eff6b68(0000) GS:ffff8fe339c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe80eec7bc0 CR3: 0000000038012000 CR4: 00000000000006f0
Call Trace:
 __free_fdtable+0x16/0x1f
 put_files_struct+0x81/0x9b
 do_exit+0x433/0x94d
 do_group_exit+0xa6/0xa6
 __x64_sys_exit_group+0xf/0xf
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fe80ef64bea
Code: Unable to access opcode bytes at RIP 0x7fe80ef64bc0.
RSP: 002b:00007ffdb1c47528 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fe80ef64bea
RDX: 00007fe80ef64f60 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 00007fe80ee2c620 R11: 0000000000000246 R12: 00007fe80eff41e0
R13: 00000000ffffffff R14: 0000000000000024 R15: 00007fe80edf9cd0
Modules linked in: radeon(+) ath5k(+) snd_hda_codec_realtek ...

Use a valid power_state index when initializing the "flags" and "misc"
and "misc2" fields.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211537
Reported-by: Erhard F. <erhard_f@mailbox.org>
Fixes: a48b9b4edb8b ("drm/radeon/kms/pm: add asic specific callbacks for getting power state (v2)")
Fixes: 79daedc94281 ("drm/radeon/kms: minor pm cleanups")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index f422a8d6aec4..ffeacaa269e8 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2263,10 +2263,10 @@ static int radeon_atombios_parse_power_table_1_3(struct radeon_device *rdev)
 		rdev->pm.default_power_state_index = state_index - 1;
 		rdev->pm.power_state[state_index - 1].default_clock_mode =
 			&rdev->pm.power_state[state_index - 1].clock_info[0];
-		rdev->pm.power_state[state_index].flags &=
+		rdev->pm.power_state[state_index - 1].flags &=
 			~RADEON_PM_STATE_SINGLE_DISPLAY_ONLY;
-		rdev->pm.power_state[state_index].misc = 0;
-		rdev->pm.power_state[state_index].misc2 = 0;
+		rdev->pm.power_state[state_index - 1].misc = 0;
+		rdev->pm.power_state[state_index - 1].misc2 = 0;
 	}
 	return state_index;
 }
-- 
2.30.2



