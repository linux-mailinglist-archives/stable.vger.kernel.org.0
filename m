Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC313FA4F7
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfKMByo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbfKMBym (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:54:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07129204EC;
        Wed, 13 Nov 2019 01:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610081;
        bh=JwI+ye/StYPrNa8sOUciLaZ827yPQ6ei7loGtgzAWQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXZITimnUDuC2ItCBw1hrWhqCl4E6MaA6WVgY0z2p6Z2hK7Ko2Z3AxnyO64dGIt31
         mhOyfG5oWrm/OxP74BzVadcD3UnusIMGvVuwu986sKOE3B09TLr/3EgR5VvJkPmSgq
         3M7s3RhNCAr/G0GDEsiXLHZZVjmk0UE7kTeH1wow=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, tony.luck@intel.com,
        gavin.hindman@intel.com, dave.hansen@intel.com, hpa@zytor.com,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 154/209] x86/intel_rdt: CBM overlap should also check for overlap with CDP peer
Date:   Tue, 12 Nov 2019 20:49:30 -0500
Message-Id: <20191113015025.9685-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit e5f3530c391105fdd6174852e3ea6136d073b45a ]

The CBM overlap test is used to manage the allocations of RDT resources
where overlap is possible between resource groups. When a resource group
is in exclusive mode then there should be no overlap between resource
groups.

The current overlap test only considers overlap between the same
resources, for example, that usage of a RDT_RESOURCE_L2DATA resource
in one resource group does not overlap with usage of a RDT_RESOURCE_L2DATA
resource in another resource group. The problem with this is that it
allows overlap between a RDT_RESOURCE_L2DATA resource in one resource
group with a RDT_RESOURCE_L2CODE resource in another resource group -
even if both resource groups are in exclusive mode. This is a problem
because even though these appear to be different resources they end up
sharing the same underlying hardware and thus does not fulfill the
user's request for exclusive use of hardware resources.

Fix this by including the CDP peer (if there is one) in every CBM
overlap test. This does not impact the overlap between resources
within the same exclusive resource group that is allowed.

Fixes: 49f7b4efa110 ("x86/intel_rdt: Enable setting of exclusive mode")
Reported-by: Jithu Joseph <jithu.joseph@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jithu Joseph <jithu.joseph@intel.com>
Acked-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: tony.luck@intel.com
Cc: gavin.hindman@intel.com
Cc: dave.hansen@intel.com
Cc: hpa@zytor.com
Link: https://lkml.kernel.org/r/e538b7f56f7ca15963dce2e00ac3be8edb8a68e1.1538603665.git.reinette.chatre@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c | 48 ++++++++++++++++++++----
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
index bf15ffc1248fd..0d8ea82acd930 100644
--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -987,10 +987,9 @@ static int rdtgroup_mode_show(struct kernfs_open_file *of,
  *         If a CDP peer was found, @r_cdp will point to the peer RDT resource
  *         and @d_cdp will point to the peer RDT domain.
  */
-static int __attribute__((unused)) rdt_cdp_peer_get(struct rdt_resource *r,
-						    struct rdt_domain *d,
-						    struct rdt_resource **r_cdp,
-						    struct rdt_domain **d_cdp)
+static int rdt_cdp_peer_get(struct rdt_resource *r, struct rdt_domain *d,
+			    struct rdt_resource **r_cdp,
+			    struct rdt_domain **d_cdp)
 {
 	struct rdt_resource *_r_cdp = NULL;
 	struct rdt_domain *_d_cdp = NULL;
@@ -1037,7 +1036,7 @@ static int __attribute__((unused)) rdt_cdp_peer_get(struct rdt_resource *r,
 }
 
 /**
- * rdtgroup_cbm_overlaps - Does CBM for intended closid overlap with other
+ * __rdtgroup_cbm_overlaps - Does CBM for intended closid overlap with other
  * @r: Resource to which domain instance @d belongs.
  * @d: The domain instance for which @closid is being tested.
  * @cbm: Capacity bitmask being tested.
@@ -1056,8 +1055,8 @@ static int __attribute__((unused)) rdt_cdp_peer_get(struct rdt_resource *r,
  *
  * Return: false if CBM does not overlap, true if it does.
  */
-bool rdtgroup_cbm_overlaps(struct rdt_resource *r, struct rdt_domain *d,
-			   unsigned long cbm, int closid, bool exclusive)
+static bool __rdtgroup_cbm_overlaps(struct rdt_resource *r, struct rdt_domain *d,
+				    unsigned long cbm, int closid, bool exclusive)
 {
 	enum rdtgrp_mode mode;
 	unsigned long ctrl_b;
@@ -1092,6 +1091,41 @@ bool rdtgroup_cbm_overlaps(struct rdt_resource *r, struct rdt_domain *d,
 	return false;
 }
 
+/**
+ * rdtgroup_cbm_overlaps - Does CBM overlap with other use of hardware
+ * @r: Resource to which domain instance @d belongs.
+ * @d: The domain instance for which @closid is being tested.
+ * @cbm: Capacity bitmask being tested.
+ * @closid: Intended closid for @cbm.
+ * @exclusive: Only check if overlaps with exclusive resource groups
+ *
+ * Resources that can be allocated using a CBM can use the CBM to control
+ * the overlap of these allocations. rdtgroup_cmb_overlaps() is the test
+ * for overlap. Overlap test is not limited to the specific resource for
+ * which the CBM is intended though - when dealing with CDP resources that
+ * share the underlying hardware the overlap check should be performed on
+ * the CDP resource sharing the hardware also.
+ *
+ * Refer to description of __rdtgroup_cbm_overlaps() for the details of the
+ * overlap test.
+ *
+ * Return: true if CBM overlap detected, false if there is no overlap
+ */
+bool rdtgroup_cbm_overlaps(struct rdt_resource *r, struct rdt_domain *d,
+			   unsigned long cbm, int closid, bool exclusive)
+{
+	struct rdt_resource *r_cdp;
+	struct rdt_domain *d_cdp;
+
+	if (__rdtgroup_cbm_overlaps(r, d, cbm, closid, exclusive))
+		return true;
+
+	if (rdt_cdp_peer_get(r, d, &r_cdp, &d_cdp) < 0)
+		return false;
+
+	return  __rdtgroup_cbm_overlaps(r_cdp, d_cdp, cbm, closid, exclusive);
+}
+
 /**
  * rdtgroup_mode_test_exclusive - Test if this resource group can be exclusive
  *
-- 
2.20.1

