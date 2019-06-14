Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC86469DC
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfFNUfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbfFNU3v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:51 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 430A221881;
        Fri, 14 Jun 2019 20:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544190;
        bh=FqcG3wUkPQsaEhW8wvKE3O+8ur9HAjvykZLDlIpwrNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYvagsxzJqEhqxtWMPa8NCj3DRMwQVVJqhj/5BOeZEYVxG8S2pdqa+bG/d9Uj5scY
         CAjdx85cv/21mWZX7oz6Q6JfF2//XTbvC8dRiC5VAlXkYkibI9MbSxsyNN3wIAVrGx
         cLWyQYufD7suwXsbImCVkXPF9owcAY/c8aUMmK+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Wood <swood@redhat.com>, Wu Hao <hao.wu@intel.com>,
        Alan Tull <atull@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fpga@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/39] fpga: dfl: Add lockdep classes for pdata->lock
Date:   Fri, 14 Jun 2019 16:29:12 -0400
Message-Id: <20190614202946.27385-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Wood <swood@redhat.com>

[ Upstream commit dfe3de8d397bf878b31864d4e489d41118ec475f ]

struct dfl_feature_platform_data (and it's mutex) is used
by both fme and port devices, and when lockdep is enabled it
complains about nesting between these locks.  Tell lockdep about
the difference so it can track each class separately.

Here's the lockdep complaint:
[  409.680668] WARNING: possible recursive locking detected
[  409.685983] 5.1.0-rc3.fpga+ #1 Tainted: G            E
[  409.691469] --------------------------------------------
[  409.696779] fpgaconf/9348 is trying to acquire lock:
[  409.701746] 00000000a443fe2e (&pdata->lock){+.+.}, at: port_enable_set+0x24/0x60 [dfl_afu]
[  409.710006]
[  409.710006] but task is already holding lock:
[  409.715837] 0000000063b78782 (&pdata->lock){+.+.}, at: fme_pr_ioctl+0x21d/0x330 [dfl_fme]
[  409.724012]
[  409.724012] other info that might help us debug this:
[  409.730535]  Possible unsafe locking scenario:
[  409.730535]
[  409.736457]        CPU0
[  409.738910]        ----
[  409.741360]   lock(&pdata->lock);
[  409.744679]   lock(&pdata->lock);
[  409.747999]
[  409.747999]  *** DEADLOCK ***
[  409.747999]
[  409.753920]  May be due to missing lock nesting notation
[  409.753920]
[  409.760704] 4 locks held by fpgaconf/9348:
[  409.764805]  #0: 0000000063b78782 (&pdata->lock){+.+.}, at: fme_pr_ioctl+0x21d/0x330 [dfl_fme]
[  409.773408]  #1: 00000000213c8a66 (&region->mutex){+.+.}, at: fpga_region_program_fpga+0x24/0x200 [fpga_region]
[  409.783489]  #2: 00000000fe63afb9 (&mgr->ref_mutex){+.+.}, at: fpga_mgr_lock+0x15/0x40 [fpga_mgr]
[  409.792354]  #3: 000000000b2285c5 (&bridge->mutex){+.+.}, at: __fpga_bridge_get+0x26/0xa0 [fpga_bridge]
[  409.801740]
[  409.801740] stack backtrace:
[  409.806102] CPU: 45 PID: 9348 Comm: fpgaconf Kdump: loaded Tainted: G            E     5.1.0-rc3.fpga+ #1
[  409.815658] Hardware name: Intel Corporation S2600BT/S2600BT, BIOS SE5C620.86B.01.00.0763.022420181017 02/24/2018
[  409.825911] Call Trace:
[  409.828369]  dump_stack+0x5e/0x8b
[  409.831686]  __lock_acquire+0xf3d/0x10e0
[  409.835612]  ? find_held_lock+0x3c/0xa0
[  409.839451]  lock_acquire+0xbc/0x1d0
[  409.843030]  ? port_enable_set+0x24/0x60 [dfl_afu]
[  409.847823]  ? port_enable_set+0x24/0x60 [dfl_afu]
[  409.852616]  __mutex_lock+0x86/0x970
[  409.856195]  ? port_enable_set+0x24/0x60 [dfl_afu]
[  409.860989]  ? port_enable_set+0x24/0x60 [dfl_afu]
[  409.865777]  ? __mutex_unlock_slowpath+0x4b/0x290
[  409.870486]  port_enable_set+0x24/0x60 [dfl_afu]
[  409.875106]  fpga_bridges_disable+0x36/0x50 [fpga_bridge]
[  409.880502]  fpga_region_program_fpga+0xea/0x200 [fpga_region]
[  409.886338]  fme_pr_ioctl+0x13e/0x330 [dfl_fme]
[  409.890870]  fme_ioctl+0x66/0xe0 [dfl_fme]
[  409.894973]  do_vfs_ioctl+0xa9/0x720
[  409.898548]  ? lockdep_hardirqs_on+0xf0/0x1a0
[  409.902907]  ksys_ioctl+0x60/0x90
[  409.906225]  __x64_sys_ioctl+0x16/0x20
[  409.909981]  do_syscall_64+0x5a/0x220
[  409.913644]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  409.918698] RIP: 0033:0x7f9d31b9b8d7
[  409.922276] Code: 44 00 00 48 8b 05 b9 15 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 89 15 2d 00 f7 d8 64 89 01 48
[  409.941020] RSP: 002b:00007ffe4cae0d68 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[  409.948588] RAX: ffffffffffffffda RBX: 00007f9d32ade6a0 RCX: 00007f9d31b9b8d7
[  409.955719] RDX: 00007ffe4cae0df0 RSI: 000000000000b680 RDI: 0000000000000003
[  409.962852] RBP: 0000000000000003 R08: 00007f9d2b70a177 R09: 00007ffe4cae0e40
[  409.969984] R10: 00007ffe4cae0160 R11: 0000000000000202 R12: 00007ffe4cae0df0
[  409.977115] R13: 000000000000b680 R14: 0000000000000000 R15: 00007ffe4cae0f60

Signed-off-by: Scott Wood <swood@redhat.com>
Acked-by: Wu Hao <hao.wu@intel.com>
Acked-by: Alan Tull <atull@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index a9b521bccb06..ab361ec78df4 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -40,6 +40,13 @@ enum dfl_fpga_devt_type {
 	DFL_FPGA_DEVT_MAX,
 };
 
+static struct lock_class_key dfl_pdata_keys[DFL_ID_MAX];
+
+static const char *dfl_pdata_key_strings[DFL_ID_MAX] = {
+	"dfl-fme-pdata",
+	"dfl-port-pdata",
+};
+
 /**
  * dfl_dev_info - dfl feature device information.
  * @name: name string of the feature platform device.
@@ -443,11 +450,16 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
 	struct platform_device *fdev = binfo->feature_dev;
 	struct dfl_feature_platform_data *pdata;
 	struct dfl_feature_info *finfo, *p;
+	enum dfl_id_type type;
 	int ret, index = 0;
 
 	if (!fdev)
 		return 0;
 
+	type = feature_dev_id_type(fdev);
+	if (WARN_ON_ONCE(type >= DFL_ID_MAX))
+		return -EINVAL;
+
 	/*
 	 * we do not need to care for the memory which is associated with
 	 * the platform device. After calling platform_device_unregister(),
@@ -463,6 +475,8 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
 	pdata->num = binfo->feature_num;
 	pdata->dfl_cdev = binfo->cdev;
 	mutex_init(&pdata->lock);
+	lockdep_set_class_and_name(&pdata->lock, &dfl_pdata_keys[type],
+				   dfl_pdata_key_strings[type]);
 
 	/*
 	 * the count should be initialized to 0 to make sure
@@ -497,7 +511,7 @@ static int build_info_commit_dev(struct build_feature_devs_info *binfo)
 
 	ret = platform_device_add(binfo->feature_dev);
 	if (!ret) {
-		if (feature_dev_id_type(binfo->feature_dev) == PORT_ID)
+		if (type == PORT_ID)
 			dfl_fpga_cdev_add_port_dev(binfo->cdev,
 						   binfo->feature_dev);
 		else
-- 
2.20.1

