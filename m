Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807A02E6793
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbgL1Q0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbgL1NIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:08:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF3F020728;
        Mon, 28 Dec 2020 13:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160878;
        bh=RVRSKHUm7Oe7jCTjTNiJDphWHyMo4X6b0b450u8zxzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9gb32/eEYNbPX7naVmb6zz8BCkM8Feo5P3AAdfPC9cTNB5rXjsebGMNdXuVEEk65
         KagXS/orjnryZmDLZnosMuBWHMWlom+LWQwOXBa1FpKn/YqfZJE4K7OK19RcoAYBhQ
         No4kXoMfmFCkDKYET2VIfAGNGw5jynlwkUwMBx5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Si <si.hao@zte.com.cn>,
        Lin Chen <chen.lin5@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>, Li Yang <leoyang.li@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 008/242] soc: fsl: dpio: Get the cpumask through cpumask_of(cpu)
Date:   Mon, 28 Dec 2020 13:46:53 +0100
Message-Id: <20201228124905.076775254@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Si <si.hao@zte.com.cn>

[ Upstream commit 2663b3388551230cbc4606a40fabf3331ceb59e4 ]

The local variable 'cpumask_t mask' is in the stack memory, and its address
is assigned to 'desc->affinity' in 'irq_set_affinity_hint()'.
But the memory area where this variable is located is at risk of being
modified.

During LTP testing, the following error was generated:

Unable to handle kernel paging request at virtual address ffff000012e9b790
Mem abort info:
  ESR = 0x96000007
  Exception class = DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000007
  CM = 0, WnR = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp = 0000000075ac5e07
[ffff000012e9b790] pgd=00000027dbffe003, pud=00000027dbffd003,
pmd=00000027b6d61003, pte=0000000000000000
Internal error: Oops: 96000007 [#1] PREEMPT SMP
Modules linked in: xt_conntrack
Process read_all (pid: 20171, stack limit = 0x0000000044ea4095)
CPU: 14 PID: 20171 Comm: read_all Tainted: G    B   W
Hardware name: NXP Layerscape LX2160ARDB (DT)
pstate: 80000085 (Nzcv daIf -PAN -UAO)
pc : irq_affinity_hint_proc_show+0x54/0xb0
lr : irq_affinity_hint_proc_show+0x4c/0xb0
sp : ffff00001138bc10
x29: ffff00001138bc10 x28: 0000ffffd131d1e0
x27: 00000000007000c0 x26: ffff8025b9480dc0
x25: ffff8025b9480da8 x24: 00000000000003ff
x23: ffff8027334f8300 x22: ffff80272e97d000
x21: ffff80272e97d0b0 x20: ffff8025b9480d80
x19: ffff000009a49000 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000
x15: 0000000000000000 x14: 0000000000000000
x13: 0000000000000000 x12: 0000000000000040
x11: 0000000000000000 x10: ffff802735b79b88
x9 : 0000000000000000 x8 : 0000000000000000
x7 : ffff000009a49848 x6 : 0000000000000003
x5 : 0000000000000000 x4 : ffff000008157d6c
x3 : ffff00001138bc10 x2 : ffff000012e9b790
x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 irq_affinity_hint_proc_show+0x54/0xb0
 seq_read+0x1b0/0x440
 proc_reg_read+0x80/0xd8
 __vfs_read+0x60/0x178
 vfs_read+0x94/0x150
 ksys_read+0x74/0xf0
 __arm64_sys_read+0x24/0x30
 el0_svc_common.constprop.0+0xd8/0x1a0
 el0_svc_handler+0x34/0x88
 el0_svc+0x10/0x14
Code: f9001bbf 943e0732 f94066c2 b4000062 (f9400041)
---[ end trace b495bdcb0b3b732b ]---
Kernel panic - not syncing: Fatal exception
SMP: stopping secondary CPUs
SMP: failed to stop secondary CPUs 0,2-4,6,8,11,13-15
Kernel Offset: disabled
CPU features: 0x0,21006008
Memory Limit: none
---[ end Kernel panic - not syncing: Fatal exception ]---

Fix it by using 'cpumask_of(cpu)' to get the cpumask.

Signed-off-by: Hao Si <si.hao@zte.com.cn>
Signed-off-by: Lin Chen <chen.lin5@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fsl-mc/bus/dpio/dpio-driver.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/fsl-mc/bus/dpio/dpio-driver.c b/drivers/staging/fsl-mc/bus/dpio/dpio-driver.c
index e36da20a2796b..e7856a9e685f4 100644
--- a/drivers/staging/fsl-mc/bus/dpio/dpio-driver.c
+++ b/drivers/staging/fsl-mc/bus/dpio/dpio-driver.c
@@ -77,7 +77,6 @@ static int register_dpio_irq_handlers(struct fsl_mc_device *dpio_dev, int cpu)
 	struct dpio_priv *priv;
 	int error;
 	struct fsl_mc_device_irq *irq;
-	cpumask_t mask;
 
 	priv = dev_get_drvdata(&dpio_dev->dev);
 
@@ -96,9 +95,7 @@ static int register_dpio_irq_handlers(struct fsl_mc_device *dpio_dev, int cpu)
 	}
 
 	/* set the affinity hint */
-	cpumask_clear(&mask);
-	cpumask_set_cpu(cpu, &mask);
-	if (irq_set_affinity_hint(irq->msi_desc->irq, &mask))
+	if (irq_set_affinity_hint(irq->msi_desc->irq, cpumask_of(cpu)))
 		dev_err(&dpio_dev->dev,
 			"irq_set_affinity failed irq %d cpu %d\n",
 			irq->msi_desc->irq, cpu);
-- 
2.27.0



