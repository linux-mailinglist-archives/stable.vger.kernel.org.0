Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D068BCF85
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfIXQ6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633339AbfIXQsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:48:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 974A920673;
        Tue, 24 Sep 2019 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343681;
        bh=cHqYgbigJfROhlyBdcrTmz1tt2vh7ZpYE1w0/e5Fieg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wkpHemb36Lm+a0IRAaceFOh14/cIQZyYW6DVxMG6De6d617UvjUMNC/bqORSLLdGg
         C0EJIwQPKdE2mbNWrlp+Fi1C8fE1XKlht9/HhqjTbcTUjUEXZtn1qAxQ5R9+IzzPT/
         gCEAUjQOBzeFJl4cuCKQ3uWH2c6ZxuMfa+yF4Fjo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Qian Cai <cai@lca.pw>, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.2 53/70] powerpc/imc: Dont create debugfs files for cpu-less nodes
Date:   Tue, 24 Sep 2019 12:45:32 -0400
Message-Id: <20190924164549.27058-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164549.27058-1-sashal@kernel.org>
References: <20190924164549.27058-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>

[ Upstream commit 41ba17f20ea835c489e77bd54e2da73184e22060 ]

Commit <684d984038aa> ('powerpc/powernv: Add debugfs interface for
imc-mode and imc') added debugfs interface for the nest imc pmu
devices to support changing of different ucode modes. Primarily adding
this capability for debug. But when doing so, the code did not
consider the case of cpu-less nodes. So when reading the _cmd_ or
_mode_ file of a cpu-less node will create this crash.

  Faulting instruction address: 0xc0000000000d0d58
  Oops: Kernel access of bad area, sig: 11 [#1]
  ...
  CPU: 67 PID: 5301 Comm: cat Not tainted 5.2.0-rc6-next-20190627+ #19
  NIP:  c0000000000d0d58 LR: c00000000049aa18 CTR:c0000000000d0d50
  REGS: c00020194548f9e0 TRAP: 0300   Not tainted  (5.2.0-rc6-next-20190627+)
  MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR:28022822  XER: 00000000
  CFAR: c00000000049aa14 DAR: 000000000003fc08 DSISR:40000000 IRQMASK: 0
  ...
  NIP imc_mem_get+0x8/0x20
  LR  simple_attr_read+0x118/0x170
  Call Trace:
    simple_attr_read+0x70/0x170 (unreliable)
    debugfs_attr_read+0x6c/0xb0
    __vfs_read+0x3c/0x70
     vfs_read+0xbc/0x1a0
    ksys_read+0x7c/0x140
    system_call+0x5c/0x70

Patch fixes the issue with a more robust check for vbase to NULL.

Before patch, ls output for the debugfs imc directory

  # ls /sys/kernel/debug/powerpc/imc/
  imc_cmd_0    imc_cmd_251  imc_cmd_253  imc_cmd_255  imc_mode_0    imc_mode_251  imc_mode_253  imc_mode_255
  imc_cmd_250  imc_cmd_252  imc_cmd_254  imc_cmd_8    imc_mode_250  imc_mode_252  imc_mode_254  imc_mode_8

After patch, ls output for the debugfs imc directory

  # ls /sys/kernel/debug/powerpc/imc/
  imc_cmd_0  imc_cmd_8  imc_mode_0  imc_mode_8

Actual bug here is that, we have two loops with potentially different
loop counts. That is, in imc_get_mem_addr_nest(), loop count is
obtained from the dt entries. But in case of export_imc_mode_and_cmd(),
loop was based on for_each_nid() count. Patch fixes the loop count in
latter based on the struct mem_info. Ideally it would be better to
have array size in struct imc_pmu.

Fixes: 684d984038aa ('powerpc/powernv: Add debugfs interface for imc-mode and imc')
Reported-by: Qian Cai <cai@lca.pw>
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190827101635.6942-1-maddy@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-imc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-imc.c b/arch/powerpc/platforms/powernv/opal-imc.c
index 186109bdd41be..e04b20625cb94 100644
--- a/arch/powerpc/platforms/powernv/opal-imc.c
+++ b/arch/powerpc/platforms/powernv/opal-imc.c
@@ -53,9 +53,9 @@ static void export_imc_mode_and_cmd(struct device_node *node,
 				    struct imc_pmu *pmu_ptr)
 {
 	static u64 loc, *imc_mode_addr, *imc_cmd_addr;
-	int chip = 0, nid;
 	char mode[16], cmd[16];
 	u32 cb_offset;
+	struct imc_mem_info *ptr = pmu_ptr->mem_info;
 
 	imc_debugfs_parent = debugfs_create_dir("imc", powerpc_debugfs_root);
 
@@ -69,20 +69,20 @@ static void export_imc_mode_and_cmd(struct device_node *node,
 	if (of_property_read_u32(node, "cb_offset", &cb_offset))
 		cb_offset = IMC_CNTL_BLK_OFFSET;
 
-	for_each_node(nid) {
-		loc = (u64)(pmu_ptr->mem_info[chip].vbase) + cb_offset;
+	while (ptr->vbase != NULL) {
+		loc = (u64)(ptr->vbase) + cb_offset;
 		imc_mode_addr = (u64 *)(loc + IMC_CNTL_BLK_MODE_OFFSET);
-		sprintf(mode, "imc_mode_%d", nid);
+		sprintf(mode, "imc_mode_%d", (u32)(ptr->id));
 		if (!imc_debugfs_create_x64(mode, 0600, imc_debugfs_parent,
 					    imc_mode_addr))
 			goto err;
 
 		imc_cmd_addr = (u64 *)(loc + IMC_CNTL_BLK_CMD_OFFSET);
-		sprintf(cmd, "imc_cmd_%d", nid);
+		sprintf(cmd, "imc_cmd_%d", (u32)(ptr->id));
 		if (!imc_debugfs_create_x64(cmd, 0600, imc_debugfs_parent,
 					    imc_cmd_addr))
 			goto err;
-		chip++;
+		ptr++;
 	}
 	return;
 
-- 
2.20.1

