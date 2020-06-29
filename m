Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3051620DED0
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbgF2U32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732495AbgF2TZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C088225328;
        Mon, 29 Jun 2020 15:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445159;
        bh=xW060RWo+YfnYM7oM17YdaGdbVKZX6R9bk/4a89M/4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyPChSQYYZ/F4TkjQC44cjP1ZG5nLQkIS69jIhK7HcqWaON+87pQ5aYtXzGfltABi
         X0PIfoGnE7/gcHxno8dsb2zgou0BLNVlcEKEMOeRGl6VQs1eQkF1nRGYTMtmoyc9C0
         vnH9zFPcnLqgw2MuqgxW8B8aNOtMldW4ye04O68o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        yuu ichii <byahu140@heisei.be>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 60/78] ACPI: sysfs: Fix pm_profile_attr type
Date:   Mon, 29 Jun 2020 11:37:48 -0400
Message-Id: <20200629153806.2494953-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit e6d701dca9893990d999fd145e3e07223c002b06 upstream.

When running a kernel with Clang's Control Flow Integrity implemented,
there is a violation that happens when accessing
/sys/firmware/acpi/pm_profile:

$ cat /sys/firmware/acpi/pm_profile
0

$ dmesg
...
[   17.352564] ------------[ cut here ]------------
[   17.352568] CFI failure (target: acpi_show_profile+0x0/0x8):
[   17.352572] WARNING: CPU: 3 PID: 497 at kernel/cfi.c:29 __cfi_check_fail+0x33/0x40
[   17.352573] Modules linked in:
[   17.352575] CPU: 3 PID: 497 Comm: cat Tainted: G        W         5.7.0-microsoft-standard+ #1
[   17.352576] RIP: 0010:__cfi_check_fail+0x33/0x40
[   17.352577] Code: 48 c7 c7 50 b3 85 84 48 c7 c6 50 0a 4e 84 e8 a4 d8 60 00 85 c0 75 02 5b c3 48 c7 c7 dc 5e 49 84 48 89 de 31 c0 e8 7d 06 eb ff <0f> 0b 5b c3 00 00 cc cc 00 00 cc cc 00 85 f6 74 25 41 b9 ea ff ff
[   17.352577] RSP: 0018:ffffaa6dc3c53d30 EFLAGS: 00010246
[   17.352578] RAX: 331267e0c06cee00 RBX: ffffffff83d85890 RCX: ffffffff8483a6f8
[   17.352579] RDX: ffff9cceabbb37c0 RSI: 0000000000000082 RDI: ffffffff84bb9e1c
[   17.352579] RBP: ffffffff845b2bc8 R08: 0000000000000001 R09: ffff9cceabbba200
[   17.352579] R10: 000000000000019d R11: 0000000000000000 R12: ffff9cc947766f00
[   17.352580] R13: ffffffff83d6bd50 R14: ffff9ccc6fa80000 R15: ffffffff845bd328
[   17.352582] FS:  00007fdbc8d13580(0000) GS:ffff9cce91ac0000(0000) knlGS:0000000000000000
[   17.352582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   17.352583] CR2: 00007fdbc858e000 CR3: 00000005174d0000 CR4: 0000000000340ea0
[   17.352584] Call Trace:
[   17.352586]  ? rev_id_show+0x8/0x8
[   17.352587]  ? __cfi_check+0x45bac/0x4b640
[   17.352589]  ? kobj_attr_show+0x73/0x80
[   17.352590]  ? sysfs_kf_seq_show+0xc1/0x140
[   17.352592]  ? ext4_seq_options_show.cfi_jt+0x8/0x8
[   17.352593]  ? seq_read+0x180/0x600
[   17.352595]  ? sysfs_create_file_ns.cfi_jt+0x10/0x10
[   17.352596]  ? tlbflush_read_file+0x8/0x8
[   17.352597]  ? __vfs_read+0x6b/0x220
[   17.352598]  ? handle_mm_fault+0xa23/0x11b0
[   17.352599]  ? vfs_read+0xa2/0x130
[   17.352599]  ? ksys_read+0x6a/0xd0
[   17.352601]  ? __do_sys_getpgrp+0x8/0x8
[   17.352602]  ? do_syscall_64+0x72/0x120
[   17.352603]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   17.352604] ---[ end trace 7b1fa81dc897e419 ]---

When /sys/firmware/acpi/pm_profile is read, sysfs_kf_seq_show is called,
which in turn calls kobj_attr_show, which gets the ->show callback
member by calling container_of on attr (casting it to struct
kobj_attribute) then calls it.

There is a CFI violation because pm_profile_attr is of type
struct device_attribute but kobj_attr_show calls ->show expecting it
to be from struct kobj_attribute. CFI checking ensures that function
pointer types match when doing indirect calls. Fix pm_profile_attr to
be defined in terms of kobj_attribute so there is no violation or
mismatch.

Fixes: 362b646062b2 ("ACPI: Export FADT pm_profile integer value to userspace")
Link: https://github.com/ClangBuiltLinux/linux/issues/1051
Reported-by: yuu ichii <byahu140@heisei.be>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index a663014cfa522..3b7e23866b42a 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -942,13 +942,13 @@ static void __exit interrupt_stats_exit(void)
 }
 
 static ssize_t
-acpi_show_profile(struct device *dev, struct device_attribute *attr,
+acpi_show_profile(struct kobject *kobj, struct kobj_attribute *attr,
 		  char *buf)
 {
 	return sprintf(buf, "%d\n", acpi_gbl_FADT.preferred_profile);
 }
 
-static const struct device_attribute pm_profile_attr =
+static const struct kobj_attribute pm_profile_attr =
 	__ATTR(pm_profile, S_IRUGO, acpi_show_profile, NULL);
 
 static ssize_t hotplug_enabled_show(struct kobject *kobj,
-- 
2.25.1

