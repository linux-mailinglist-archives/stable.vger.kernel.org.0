Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2841E99A90
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390500AbfHVRIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390435AbfHVRIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:46 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42E9233FE;
        Thu, 22 Aug 2019 17:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493724;
        bh=9osRuY4T+wfFbKLgaPIwnyCnSR6hoLP/X3xvDr7EnVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTBBp17lFQG8CIl3SWnAmRHa9sJL4WYPUMNaHpzbrrCq0QgNLuZs05wjuW7uuCJjm
         lZfe9bv0AVqCDM7OFGGN5twsJiGYNKceTQojJTf38JyT3FIwWdtenNHI5NnRu8PK1l
         skniChCWcd8F73vosL4oRR8LDQPsHdHX4VPRN09g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 056/135] powerpc/nvdimm: Pick nearby online node if the device node is not online
Date:   Thu, 22 Aug 2019 13:06:52 -0400
Message-Id: <20190822170811.13303-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit da1115fdbd6e86c62185cdd2b4bf7add39f2f82b ]

Currently, nvdimm subsystem expects the device numa node for SCM device to be
an online node. It also doesn't try to bring the device numa node online. Hence
if we use a non-online numa node as device node we hit crashes like below. This
is because we try to access uninitialized NODE_DATA in different code paths.

cpu 0x0: Vector: 300 (Data Access) at [c0000000fac53170]
    pc: c0000000004bbc50: ___slab_alloc+0x120/0xca0
    lr: c0000000004bc834: __slab_alloc+0x64/0xc0
    sp: c0000000fac53400
   msr: 8000000002009033
   dar: 73e8
 dsisr: 80000
  current = 0xc0000000fabb6d80
  paca    = 0xc000000003870000   irqmask: 0x03   irq_happened: 0x01
    pid   = 7, comm = kworker/u16:0
Linux version 5.2.0-06234-g76bd729b2644 (kvaneesh@ltc-boston123) (gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04.1)) #135 SMP Thu Jul 11 05:36:30 CDT 2019
enter ? for help
[link register   ] c0000000004bc834 __slab_alloc+0x64/0xc0
[c0000000fac53400] c0000000fac53480 (unreliable)
[c0000000fac53500] c0000000004bc818 __slab_alloc+0x48/0xc0
[c0000000fac53560] c0000000004c30a0 __kmalloc_node_track_caller+0x3c0/0x6b0
[c0000000fac535d0] c000000000cfafe4 devm_kmalloc+0x74/0xc0
[c0000000fac53600] c000000000d69434 nd_region_activate+0x144/0x560
[c0000000fac536d0] c000000000d6b19c nd_region_probe+0x17c/0x370
[c0000000fac537b0] c000000000d6349c nvdimm_bus_probe+0x10c/0x230
[c0000000fac53840] c000000000cf3cc4 really_probe+0x254/0x4e0
[c0000000fac538d0] c000000000cf429c driver_probe_device+0x16c/0x1e0
[c0000000fac53950] c000000000cf0b44 bus_for_each_drv+0x94/0x130
[c0000000fac539b0] c000000000cf392c __device_attach+0xdc/0x200
[c0000000fac53a50] c000000000cf231c bus_probe_device+0x4c/0xf0
[c0000000fac53a90] c000000000ced268 device_add+0x528/0x810
[c0000000fac53b60] c000000000d62a58 nd_async_device_register+0x28/0xa0
[c0000000fac53bd0] c0000000001ccb8c async_run_entry_fn+0xcc/0x1f0
[c0000000fac53c50] c0000000001bcd9c process_one_work+0x46c/0x860
[c0000000fac53d20] c0000000001bd4f4 worker_thread+0x364/0x5f0
[c0000000fac53db0] c0000000001c7260 kthread+0x1b0/0x1c0
[c0000000fac53e20] c00000000000b954 ret_from_kernel_thread+0x5c/0x68

The patch tries to fix this by picking the nearest online node as the SCM node.
This does have a problem of us losing the information that SCM node is
equidistant from two other online nodes. If applications need to understand these
fine-grained details we should express then like x86 does via
/sys/devices/system/node/nodeX/accessY/initiators/

With the patch we get

 # numactl -H
available: 2 nodes (0-1)
node 0 cpus:
node 0 size: 0 MB
node 0 free: 0 MB
node 1 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
node 1 size: 130865 MB
node 1 free: 129130 MB
node distances:
node   0   1
  0:  10  20
  1:  20  10
 # cat /sys/bus/nd/devices/region0/numa_node
0
 # dmesg | grep papr_scm
[   91.332305] papr_scm ibm,persistent-memory:ibm,pmemory@44104001: Region registered with target node 2 and online node 0

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190729095128.23707-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 29 +++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index dad9825e40874..3c17fc7c2b936 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -199,12 +199,32 @@ static const struct attribute_group *papr_scm_dimm_groups[] = {
 	NULL,
 };
 
+static inline int papr_scm_node(int node)
+{
+	int min_dist = INT_MAX, dist;
+	int nid, min_node;
+
+	if ((node == NUMA_NO_NODE) || node_online(node))
+		return node;
+
+	min_node = first_online_node;
+	for_each_online_node(nid) {
+		dist = node_distance(node, nid);
+		if (dist < min_dist) {
+			min_dist = dist;
+			min_node = nid;
+		}
+	}
+	return min_node;
+}
+
 static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
 {
 	struct device *dev = &p->pdev->dev;
 	struct nd_mapping_desc mapping;
 	struct nd_region_desc ndr_desc;
 	unsigned long dimm_flags;
+	int target_nid, online_nid;
 
 	p->bus_desc.ndctl = papr_scm_ndctl;
 	p->bus_desc.module = THIS_MODULE;
@@ -243,8 +263,10 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
 
 	memset(&ndr_desc, 0, sizeof(ndr_desc));
 	ndr_desc.attr_groups = region_attr_groups;
-	ndr_desc.numa_node = dev_to_node(&p->pdev->dev);
-	ndr_desc.target_node = ndr_desc.numa_node;
+	target_nid = dev_to_node(&p->pdev->dev);
+	online_nid = papr_scm_node(target_nid);
+	ndr_desc.numa_node = online_nid;
+	ndr_desc.target_node = target_nid;
 	ndr_desc.res = &p->res;
 	ndr_desc.of_node = p->dn;
 	ndr_desc.provider_data = p;
@@ -259,6 +281,9 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
 				ndr_desc.res, p->dn);
 		goto err;
 	}
+	if (target_nid != online_nid)
+		dev_info(dev, "Region registered with target node %d and online node %d",
+			 target_nid, online_nid);
 
 	return 0;
 
-- 
2.20.1

