Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81DF3B629E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhF1Osv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235753AbhF1Opg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36E6B61D1A;
        Mon, 28 Jun 2021 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890858;
        bh=VVchExoAPTeIuPMwSacbuUQymmmNAMmSLo8bg0pOISU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rncJmINn3qMt0aWhiu+dqMjBxV4j6gfmTTYDsDTcmaVSSP+l7Xq84YeyM9/oU/PBu
         MvLS0zvYYWUuf7kj+FSpacclIu8xLd86JFBU7co80WyE4jSdKyAH353saxg4MOMTws
         AShUQEYMEjfKswdS/aDOwjg6Q8glMgzxdwx3eDGEDeaCy5FQQaSZf2DYHV6rPQ06wq
         UcmMrLsXt/xooCPssLLU9vrfftdwGSiH955rD67wUh+G+6zG22RcshOK+6Feiq9Mbn
         ZXFiKuj4X7Smutld51ju2lYz30GUPLAjCWHsPF9zdvOpuNR4RNa2cyKx5WdTkAiEbz
         t9yzf7PtCRing==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 081/109] usb: dwc3: core: fix kernel panic when do reboot
Date:   Mon, 28 Jun 2021 10:32:37 -0400
Message-Id: <20210628143305.32978-82-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@kernel.org>

commit 4bf584a03eec674975ee9fe36c8583d9d470dab1 upstream.

When do system reboot, it calls dwc3_shutdown and the whole debugfs
for dwc3 has removed first, when the gadget tries to do deinit, and
remove debugfs for its endpoints, it meets NULL pointer dereference
issue when call debugfs_lookup. Fix it by removing the whole dwc3
debugfs later than dwc3_drd_exit.

[ 2924.958838] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000002
....
[ 2925.030994] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[ 2925.037005] pc : inode_permission+0x2c/0x198
[ 2925.041281] lr : lookup_one_len_common+0xb0/0xf8
[ 2925.045903] sp : ffff80001276ba70
[ 2925.049218] x29: ffff80001276ba70 x28: ffff0000c01f0000 x27: 0000000000000000
[ 2925.056364] x26: ffff800011791e70 x25: 0000000000000008 x24: dead000000000100
[ 2925.063510] x23: dead000000000122 x22: 0000000000000000 x21: 0000000000000001
[ 2925.070652] x20: ffff8000122c6188 x19: 0000000000000000 x18: 0000000000000000
[ 2925.077797] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000004
[ 2925.084943] x14: ffffffffffffffff x13: 0000000000000000 x12: 0000000000000030
[ 2925.092087] x11: 0101010101010101 x10: 7f7f7f7f7f7f7f7f x9 : ffff8000102b2420
[ 2925.099232] x8 : 7f7f7f7f7f7f7f7f x7 : feff73746e2f6f64 x6 : 0000000000008080
[ 2925.106378] x5 : 61c8864680b583eb x4 : 209e6ec2d263dbb7 x3 : 000074756f307065
[ 2925.113523] x2 : 0000000000000001 x1 : 0000000000000000 x0 : ffff8000122c6188
[ 2925.120671] Call trace:
[ 2925.123119]  inode_permission+0x2c/0x198
[ 2925.127042]  lookup_one_len_common+0xb0/0xf8
[ 2925.131315]  lookup_one_len_unlocked+0x34/0xb0
[ 2925.135764]  lookup_positive_unlocked+0x14/0x50
[ 2925.140296]  debugfs_lookup+0x68/0xa0
[ 2925.143964]  dwc3_gadget_free_endpoints+0x84/0xb0
[ 2925.148675]  dwc3_gadget_exit+0x28/0x78
[ 2925.152518]  dwc3_drd_exit+0x100/0x1f8
[ 2925.156267]  dwc3_remove+0x11c/0x120
[ 2925.159851]  dwc3_shutdown+0x14/0x20
[ 2925.163432]  platform_shutdown+0x28/0x38
[ 2925.167360]  device_shutdown+0x15c/0x378
[ 2925.171291]  kernel_restart_prepare+0x3c/0x48
[ 2925.175650]  kernel_restart+0x1c/0x68
[ 2925.179316]  __do_sys_reboot+0x218/0x240
[ 2925.183247]  __arm64_sys_reboot+0x28/0x30
[ 2925.187262]  invoke_syscall+0x48/0x100
[ 2925.191017]  el0_svc_common.constprop.0+0x48/0xc8
[ 2925.195726]  do_el0_svc+0x28/0x88
[ 2925.199045]  el0_svc+0x20/0x30
[ 2925.202104]  el0_sync_handler+0xa8/0xb0
[ 2925.205942]  el0_sync+0x148/0x180
[ 2925.209270] Code: a9025bf5 2a0203f5 121f0056 370802b5 (79400660)
[ 2925.215372] ---[ end trace 124254d8e485a58b ]---
[ 2925.220012] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[ 2925.227676] Kernel Offset: disabled
[ 2925.231164] CPU features: 0x00001001,20000846
[ 2925.235521] Memory Limit: none
[ 2925.238580] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---

Fixes: 8d396bb0a5b6 ("usb: dwc3: debugfs: Add and remove endpoint dirs dynamically")
Cc: Jack Pham <jackp@codeaurora.org>
Tested-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20210608105656.10795-1-peter.chen@kernel.org
(cherry picked from commit 2a042767814bd0edf2619f06fecd374e266ea068)
Link: https://lore.kernel.org/r/20210615080847.GA10432@jackp-linux.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index e890c26b6c82..e223502eafca 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1550,8 +1550,8 @@ static int dwc3_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 
-	dwc3_debugfs_exit(dwc);
 	dwc3_core_exit_mode(dwc);
+	dwc3_debugfs_exit(dwc);
 
 	dwc3_core_exit(dwc);
 	dwc3_ulpi_exit(dwc);
-- 
2.30.2

