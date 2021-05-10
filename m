Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA5A37890A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbhEJLZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237686AbhEJLP6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:15:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14DE76146E;
        Mon, 10 May 2021 11:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645079;
        bh=acsZ0fQWrgwm+atbVh3Rw83PjOyKrKmsInSFMqaBH00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsZkOOuy9iCanXY9ldR5eA86IRHXdcKQpJ/GcVovb3wRfMg7K5Zx4O/OQaEwRWZqt
         wt5tK2xtEAEBcNl+Yg//ENeA6KeuizJLx+3ZaeNfofODUGy0uKMb/nUKIHeCe7yysU
         VSd5bz9awdoKQFY28BQRqRcvks+1r3CNU6p6sBwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sourabh Jain <sourabhjain@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.12 308/384] powerpc/kexec_file: Use current CPU info while setting up FDT
Date:   Mon, 10 May 2021 12:21:37 +0200
Message-Id: <20210510102024.954402051@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sourabh Jain <sourabhjain@linux.ibm.com>

commit 40c753993e3aad51a12c21233486e2037417a4d6 upstream.

kexec_file_load() uses initial_boot_params in setting up the device tree
for the kernel to be loaded. Though initial_boot_params holds info about
CPUs at the time of boot, it doesn't account for hot added CPUs.

So, kexec'ing with kexec_file_load() syscall leaves the kexec'ed kernel
with inaccurate CPU info.

If kdump kernel is loaded with kexec_file_load() syscall and the system
crashes on a hot added CPU, the capture kernel hangs failing to identify
the boot CPU, with no output.

To avoid this from happening, extract current CPU info from of_root
device node and use it for setting up the fdt in kexec_file_load case.

Fixes: 6ecd0163d360 ("powerpc/kexec_file: Add appropriate regions for memory reserve map")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210429060256.199714-1-sourabhjain@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kexec/file_load_64.c |   92 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -961,6 +961,93 @@ unsigned int kexec_fdt_totalsize_ppc64(s
 }
 
 /**
+ * add_node_props - Reads node properties from device node structure and add
+ *                  them to fdt.
+ * @fdt:            Flattened device tree of the kernel
+ * @node_offset:    offset of the node to add a property at
+ * @dn:             device node pointer
+ *
+ * Returns 0 on success, negative errno on error.
+ */
+static int add_node_props(void *fdt, int node_offset, const struct device_node *dn)
+{
+	int ret = 0;
+	struct property *pp;
+
+	if (!dn)
+		return -EINVAL;
+
+	for_each_property_of_node(dn, pp) {
+		ret = fdt_setprop(fdt, node_offset, pp->name, pp->value, pp->length);
+		if (ret < 0) {
+			pr_err("Unable to add %s property: %s\n", pp->name, fdt_strerror(ret));
+			return ret;
+		}
+	}
+	return ret;
+}
+
+/**
+ * update_cpus_node - Update cpus node of flattened device tree using of_root
+ *                    device node.
+ * @fdt:              Flattened device tree of the kernel.
+ *
+ * Returns 0 on success, negative errno on error.
+ */
+static int update_cpus_node(void *fdt)
+{
+	struct device_node *cpus_node, *dn;
+	int cpus_offset, cpus_subnode_offset, ret = 0;
+
+	cpus_offset = fdt_path_offset(fdt, "/cpus");
+	if (cpus_offset < 0 && cpus_offset != -FDT_ERR_NOTFOUND) {
+		pr_err("Malformed device tree: error reading /cpus node: %s\n",
+		       fdt_strerror(cpus_offset));
+		return cpus_offset;
+	}
+
+	if (cpus_offset > 0) {
+		ret = fdt_del_node(fdt, cpus_offset);
+		if (ret < 0) {
+			pr_err("Error deleting /cpus node: %s\n", fdt_strerror(ret));
+			return -EINVAL;
+		}
+	}
+
+	/* Add cpus node to fdt */
+	cpus_offset = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"), "cpus");
+	if (cpus_offset < 0) {
+		pr_err("Error creating /cpus node: %s\n", fdt_strerror(cpus_offset));
+		return -EINVAL;
+	}
+
+	/* Add cpus node properties */
+	cpus_node = of_find_node_by_path("/cpus");
+	ret = add_node_props(fdt, cpus_offset, cpus_node);
+	of_node_put(cpus_node);
+	if (ret < 0)
+		return ret;
+
+	/* Loop through all subnodes of cpus and add them to fdt */
+	for_each_node_by_type(dn, "cpu") {
+		cpus_subnode_offset = fdt_add_subnode(fdt, cpus_offset, dn->full_name);
+		if (cpus_subnode_offset < 0) {
+			pr_err("Unable to add %s subnode: %s\n", dn->full_name,
+			       fdt_strerror(cpus_subnode_offset));
+			ret = cpus_subnode_offset;
+			goto out;
+		}
+
+		ret = add_node_props(fdt, cpus_subnode_offset, dn);
+		if (ret < 0)
+			goto out;
+	}
+out:
+	of_node_put(dn);
+	return ret;
+}
+
+/**
  * setup_new_fdt_ppc64 - Update the flattend device-tree of the kernel
  *                       being loaded.
  * @image:               kexec image being loaded.
@@ -1020,6 +1107,11 @@ int setup_new_fdt_ppc64(const struct kim
 		}
 	}
 
+	/* Update cpus nodes information to account hotplug CPUs. */
+	ret =  update_cpus_node(fdt);
+	if (ret < 0)
+		goto out;
+
 	/* Update memory reserve map */
 	ret = get_reserved_memory_ranges(&rmem);
 	if (ret)


