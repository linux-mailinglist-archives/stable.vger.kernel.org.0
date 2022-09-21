Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D940F5C0313
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiIUQAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiIUP7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:59:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF58DF07;
        Wed, 21 Sep 2022 08:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33CB2B830BE;
        Wed, 21 Sep 2022 15:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88397C433D6;
        Wed, 21 Sep 2022 15:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775515;
        bh=6oQzxkb02QcR3Mx59Ou0InQg5DA/3T7eaiqyxw073nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pBXPY5VNXPGQxdgddE01nEHp+441Pv/Dq+E37oipfotxpFoj+a7gMhpMlPhz8ZmMs
         5lbMmCiDg2kpCKwwSScUDFgmCLwngVFiyq2itm9X46Vl1QE9qN1lGaVv/L5iCaLw0o
         3Da5xq4HAxNV7u+Ecjn2/E8rT+M+RBast6w4OLPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/39] powerpc/pseries/mobility: ignore ibm, platform-facilities updates
Date:   Wed, 21 Sep 2022 17:46:13 +0200
Message-Id: <20220921153646.013669582@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 319fa1a52e438a6e028329187783a25ad498c4e6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/mobility.c | 34 +++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index acf1664d1ad7..f386a7bc3811 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -61,6 +61,27 @@ static int mobility_rtas_call(int token, char *buf, s32 scope)
 
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
@@ -219,6 +240,19 @@ static int add_dt_node(struct device_node *parent_dn, __be32 drc_index)
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
-- 
2.35.1



