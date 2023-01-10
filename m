Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B9F663ADD
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjAJIW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjAJIWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:22:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F4D43A08
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:22:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF9E5614EC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29580C433D2;
        Tue, 10 Jan 2023 08:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673338943;
        bh=ZYCRJ7q50p8s323UA6b9Azw5JbNPCxPWwheRDUs68uE=;
        h=Subject:To:Cc:From:Date:From;
        b=weAXEyCknso6rYUI33NX8yNB4GDKsxUHfFbmH9Tfr3/wafScvunBkK/pvWdVubiLR
         BH8klNkAxZ8rfMM7X7OuFdtF5TcYFqAuNF0seyEWjTHfM6Qe/3ZHWVvFkClxBofxfh
         PZNn0dLHBBq9Q3peP4aCljyO8eDTkcOBc5hOClPs=
Subject: FAILED: patch "[PATCH] drm/i915/gvt: fix gvt debugfs destroy" failed to apply to 5.4-stable tree
To:     zhenyuw@linux.intel.com, yu.he@intel.com, zhi.a.wang@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 09:22:12 +0100
Message-ID: <167333893220411@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c4b850d1f448 ("drm/i915/gvt: fix gvt debugfs destroy")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c4b850d1f448a901fbf4f7f36dec38c84009b489 Mon Sep 17 00:00:00 2001
From: Zhenyu Wang <zhenyuw@linux.intel.com>
Date: Mon, 19 Dec 2022 22:03:56 +0800
Subject: [PATCH] drm/i915/gvt: fix gvt debugfs destroy

When gvt debug fs is destroyed, need to have a sane check if drm
minor's debugfs root is still available or not, otherwise in case like
device remove through unbinding, drm minor's debugfs directory has
already been removed, then intel_gvt_debugfs_clean() would act upon
dangling pointer like below oops.

i915 0000:00:02.0: Direct firmware load for i915/gvt/vid_0x8086_did_0x1926_rid_0x0a.golden_hw_state failed with error -2
i915 0000:00:02.0: MDEV: Registered
Console: switching to colour dummy device 80x25
i915 0000:00:02.0: MDEV: Unregistering
BUG: kernel NULL pointer dereference, address: 00000000000000a0
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP PTI
CPU: 2 PID: 2486 Comm: gfx-unbind.sh Tainted: G          I        6.1.0-rc8+ #15
Hardware name: Dell Inc. XPS 13 9350/0JXC1H, BIOS 1.13.0 02/10/2020
RIP: 0010:down_write+0x1f/0x90
Code: 1d ff ff 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 53 48 89 fb e8 62 c0 ff ff bf 01 00 00 00 e8 28 5e 31 ff 31 c0 ba 01 00 00 00 <f0> 48 0f b1 13 75 33 65 48 8b 04 25 c0 bd 01 00 48 89 43 08 bf 01
RSP: 0018:ffff9eb3036ffcc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000000a0 RCX: ffffff8100000000
RDX: 0000000000000001 RSI: 0000000000000064 RDI: ffffffffa48787a8
RBP: ffff9eb3036ffd30 R08: ffffeb1fc45a0608 R09: ffffeb1fc45a05c0
R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
R13: ffff91acc33fa328 R14: ffff91acc033f080 R15: ffff91acced533e0
FS:  00007f6947bba740(0000) GS:ffff91ae36d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000a0 CR3: 00000001133a2002 CR4: 00000000003706e0
Call Trace:
 <TASK>
 simple_recursive_removal+0x9f/0x2a0
 ? start_creating.part.0+0x120/0x120
 ? _raw_spin_lock+0x13/0x40
 debugfs_remove+0x40/0x60
 intel_gvt_debugfs_clean+0x15/0x30 [kvmgt]
 intel_gvt_clean_device+0x49/0xe0 [kvmgt]
 intel_gvt_driver_remove+0x2f/0xb0
 i915_driver_remove+0xa4/0xf0
 i915_pci_remove+0x1a/0x30
 pci_device_remove+0x33/0xa0
 device_release_driver_internal+0x1b2/0x230
 unbind_store+0xe0/0x110
 kernfs_fop_write_iter+0x11b/0x1f0
 vfs_write+0x203/0x3d0
 ksys_write+0x63/0xe0
 do_syscall_64+0x37/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6947cb5190
Code: 40 00 48 8b 15 71 9c 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 80 3d 51 24 0e 00 00 74 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
RSP: 002b:00007ffcbac45a28 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007f6947cb5190
RDX: 000000000000000d RSI: 0000555e35c866a0 RDI: 0000000000000001
RBP: 0000555e35c866a0 R08: 0000000000000002 R09: 0000555e358cb97c
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
R13: 000000000000000d R14: 0000000000000000 R15: 0000555e358cb8e0
 </TASK>
Modules linked in: kvmgt
CR2: 00000000000000a0
---[ end trace 0000000000000000 ]---

Cc: Wang, Zhi <zhi.a.wang@intel.com>
Cc: He, Yu <yu.he@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
Fixes: bc7b0be316ae ("drm/i915/gvt: Add basic debugfs infrastructure")
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20221219140357.769557-1-zhenyuw@linux.intel.com

diff --git a/drivers/gpu/drm/i915/gvt/debugfs.c b/drivers/gpu/drm/i915/gvt/debugfs.c
index 9f1c209d9251..d7df27feee8c 100644
--- a/drivers/gpu/drm/i915/gvt/debugfs.c
+++ b/drivers/gpu/drm/i915/gvt/debugfs.c
@@ -199,6 +199,10 @@ void intel_gvt_debugfs_init(struct intel_gvt *gvt)
  */
 void intel_gvt_debugfs_clean(struct intel_gvt *gvt)
 {
-	debugfs_remove_recursive(gvt->debugfs_root);
-	gvt->debugfs_root = NULL;
+	struct drm_minor *minor = gvt->gt->i915->drm.primary;
+
+	if (minor->debugfs_root) {
+		debugfs_remove_recursive(gvt->debugfs_root);
+		gvt->debugfs_root = NULL;
+	}
 }

