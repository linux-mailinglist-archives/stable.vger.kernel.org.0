Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8877A451E8C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344852AbhKPAg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345059AbhKOT0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82CA360F38;
        Mon, 15 Nov 2021 19:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003376;
        bh=bSgIhRePCc28dupEac6N+hchNWkE+0iUREw4EIFhCxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRTkCO/ZEOwxYEhirXL562Xq+oKxULixcPWbHBjbFYfW9TSbAFd/GG08nQjkxg4gB
         q8Oy0syUMtDDN4dq2PyLOiuY2OOmMq+KBbDpFbG4CRx54fAYAlnzsKD5s9BBHiJKzD
         U8nWftzqN0kNt1JrIPadSvajCuktU5lhhe93etLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 911/917] powerpc/pseries/mobility: ignore ibm, platform-facilities updates
Date:   Mon, 15 Nov 2021 18:06:46 +0100
Message-Id: <20211115165459.938170780@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

commit 319fa1a52e438a6e028329187783a25ad498c4e6 upstream.

On VMs with NX encryption, compression, and/or RNG offload, these
capabilities are described by nodes in the ibm,platform-facilities device
tree hierarchy:

  $ tree -d /sys/firmware/devicetree/base/ibm,platform-facilities/
  /sys/firmware/devicetree/base/ibm,platform-facilities/
  ├── ibm,compression-v1
  ├── ibm,random-v1
  └── ibm,sym-encryption-v1

  3 directories

The acceleration functions that these nodes describe are not disrupted by
live migration, not even temporarily.

But the post-migration ibm,update-nodes sequence firmware always sends
"delete" messages for this hierarchy, followed by an "add" directive to
reconstruct it via ibm,configure-connector (log with debugging statements
enabled in mobility.c):

  mobility: removing node /ibm,platform-facilities/ibm,random-v1:4294967285
  mobility: removing node /ibm,platform-facilities/ibm,compression-v1:4294967284
  mobility: removing node /ibm,platform-facilities/ibm,sym-encryption-v1:4294967283
  mobility: removing node /ibm,platform-facilities:4294967286
  ...
  mobility: added node /ibm,platform-facilities:4294967286

Note we receive a single "add" message for the entire hierarchy, and what
we receive from the ibm,configure-connector sequence is the top-level
platform-facilities node along with its three children. The debug message
simply reports the parent node and not the whole subtree.

Also, significantly, the nodes added are almost completely equivalent to
the ones removed; even phandles are unchanged. ibm,shared-interrupt-pool in
the leaf nodes is the only property I've observed to differ, and Linux does
not use that. So in practice, the sum of update messages Linux receives for
this hierarchy is equivalent to minor property updates.

We succeed in removing the original hierarchy from the device tree. But the
vio bus code is ignorant of this, and does not unbind or relinquish its
references. The leaf nodes, still reachable through sysfs, of course still
refer to the now-freed ibm,platform-facilities parent node, which makes
use-after-free possible:

  refcount_t: addition on 0; use-after-free.
  WARNING: CPU: 3 PID: 1706 at lib/refcount.c:25 refcount_warn_saturate+0x164/0x1f0
  refcount_warn_saturate+0x160/0x1f0 (unreliable)
  kobject_get+0xf0/0x100
  of_node_get+0x30/0x50
  of_get_parent+0x50/0xb0
  of_fwnode_get_parent+0x54/0x90
  fwnode_count_parents+0x50/0x150
  fwnode_full_name_string+0x30/0x110
  device_node_string+0x49c/0x790
  vsnprintf+0x1c0/0x4c0
  sprintf+0x44/0x60
  devspec_show+0x34/0x50
  dev_attr_show+0x40/0xa0
  sysfs_kf_seq_show+0xbc/0x200
  kernfs_seq_show+0x44/0x60
  seq_read_iter+0x2a4/0x740
  kernfs_fop_read_iter+0x254/0x2e0
  new_sync_read+0x120/0x190
  vfs_read+0x1d0/0x240

Moreover, the "new" replacement subtree is not correctly added to the
device tree, resulting in ibm,platform-facilities parent node without the
appropriate leaf nodes, and broken symlinks in the sysfs device hierarchy:

  $ tree -d /sys/firmware/devicetree/base/ibm,platform-facilities/
  /sys/firmware/devicetree/base/ibm,platform-facilities/

  0 directories

  $ cd /sys/devices/vio ; find . -xtype l -exec file {} +
  ./ibm,sym-encryption-v1/of_node: broken symbolic link to
    ../../../firmware/devicetree/base/ibm,platform-facilities/ibm,sym-encryption-v1
  ./ibm,random-v1/of_node:         broken symbolic link to
    ../../../firmware/devicetree/base/ibm,platform-facilities/ibm,random-v1
  ./ibm,compression-v1/of_node:    broken symbolic link to
    ../../../firmware/devicetree/base/ibm,platform-facilities/ibm,compression-v1

This is because add_dt_node() -> dlpar_attach_node() attaches only the
parent node returned from configure-connector, ignoring any children. This
should be corrected for the general case, but fixing that won't help with
the stale OF node references, which is the more urgent problem.

One way to address that would be to make the drivers respond to node
removal notifications, so that node references can be dropped
appropriately. But this would likely force the drivers to disrupt active
clients for no useful purpose: equivalent nodes are immediately re-added.
And recall that the acceleration capabilities described by the nodes remain
available throughout the whole process.

The solution I believe to be robust for this situation is to convert
remove+add of a node with an unchanged phandle to an update of the node's
properties in the Linux device tree structure. That would involve changing
and adding a fair amount of code, and may take several iterations to land.

Until that can be realized we have a confirmed use-after-free and the
possibility of memory corruption. So add a limited workaround that
discriminates on the node type, ignoring adds and removes. This should be
amenable to backporting in the meantime.

Fixes: 410bccf97881 ("powerpc/pseries: Partition migration in the kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211020194703.2613093-1-nathanl@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/mobility.c |   34 ++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -63,6 +63,27 @@ static int mobility_rtas_call(int token,
 
 static int delete_dt_node(struct device_node *dn)
 {
+	struct device_node *pdn;
+	bool is_platfac;
+
+	pdn = of_get_parent(dn);
+	is_platfac = of_node_is_type(dn, "ibm,platform-facilities") ||
+		     of_node_is_type(pdn, "ibm,platform-facilities");
+	of_node_put(pdn);
+
+	/*
+	 * The drivers that bind to nodes in the platform-facilities
+	 * hierarchy don't support node removal, and the removal directive
+	 * from firmware is always followed by an add of an equivalent
+	 * node. The capability (e.g. RNG, encryption, compression)
+	 * represented by the node is never interrupted by the migration.
+	 * So ignore changes to this part of the tree.
+	 */
+	if (is_platfac) {
+		pr_notice("ignoring remove operation for %pOFfp\n", dn);
+		return 0;
+	}
+
 	pr_debug("removing node %pOFfp\n", dn);
 	dlpar_detach_node(dn);
 	return 0;
@@ -222,6 +243,19 @@ static int add_dt_node(struct device_nod
 	if (!dn)
 		return -ENOENT;
 
+	/*
+	 * Since delete_dt_node() ignores this node type, this is the
+	 * necessary counterpart. We also know that a platform-facilities
+	 * node returned from dlpar_configure_connector() has children
+	 * attached, and dlpar_attach_node() only adds the parent, leaking
+	 * the children. So ignore these on the add side for now.
+	 */
+	if (of_node_is_type(dn, "ibm,platform-facilities")) {
+		pr_notice("ignoring add operation for %pOF\n", dn);
+		dlpar_free_cc_nodes(dn);
+		return 0;
+	}
+
 	rc = dlpar_attach_node(dn, parent_dn);
 	if (rc)
 		dlpar_free_cc_nodes(dn);


