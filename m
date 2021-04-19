Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFAC363DB0
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 10:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhDSIiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 04:38:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18264 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237487AbhDSIhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 04:37:17 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13J8YOSi056165;
        Mon, 19 Apr 2021 04:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=tRYSWsNP+svWVV1swIa1Z/9jXYAhNNC2D0eB2BJbZpg=;
 b=XQykrj/uYmAimh42/ZYd2GQdEYoJNKYNL360x/V2BjQ5wl7qA1gjf91ujmLyWMnFrKvP
 m/0lKf0wfL/C8ArVCRv+uTUgImCheDwiQPNPTFkAtMOppFSEm6+rANSuvWl1S1tb8ByB
 gKtJEDKR78j2VNyGWTgt+4Fvr10yyXz9clcHlXvYl3Mc1YOB7XK6n7pg7bPPzwEbmmAR
 bpfTXduqUrPZRKobde01XaBLm5mRpHEK9rtvhSf+XoTYIFMbgt+cBu+pwLOuRSjI03VN
 7xi1BZmaQGzEGTeu6oiYMU7L8BSVu47hMvllKcueE9Pe+NLn5KSFJN85ucNM/0jsdspO GA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 380crb93ty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 04:36:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13J8VpQd026385;
        Mon, 19 Apr 2021 08:36:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 37yqa8gy0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Apr 2021 08:36:33 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13J8aUXT37093710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 08:36:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3950C4C040;
        Mon, 19 Apr 2021 08:36:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E7E44C04A;
        Mon, 19 Apr 2021 08:36:27 +0000 (GMT)
Received: from sjain014.ibmuc.com (unknown [9.199.34.247])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 19 Apr 2021 08:36:27 +0000 (GMT)
From:   Sourabh Jain <sourabhjain@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     hbathini@linux.ibm.com, mahesh@linux.vnet.ibm.com,
        bauerman@linux.ibm.com, linuxppc-dev@ozlabs.org,
        stable@vger.kernel.org, Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: [PATCH v4] powerpc/kexec_file: use current CPU info while setting up FDT
Date:   Mon, 19 Apr 2021 14:06:24 +0530
Message-Id: <20210419083624.1124390-1-sourabhjain@linux.ibm.com>
X-Mailer: git-send-email 2.26.3
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t6pP9IU6A9g7HE1eZVygyuUkAnoeesU1
X-Proofpoint-ORIG-GUID: t6pP9IU6A9g7HE1eZVygyuUkAnoeesU1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-19_02:2021-04-16,2021-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190059
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kexec_file_load uses initial_boot_params in setting up the device-tree
for the kernel to be loaded. Though initial_boot_params holds info
about CPUs at the time of boot, it doesn't account for hot added CPUs.

So, kexec'ing with kexec_file_load syscall would leave the kexec'ed
kernel with inaccurate CPU info. Also, if kdump kernel is loaded with
kexec_file_load syscall and the system crashes on a hot added CPU,
capture kernel hangs failing to identify the boot CPU.

 Kernel panic - not syncing: sysrq triggered crash
 CPU: 24 PID: 6065 Comm: echo Kdump: loaded Not tainted 5.12.0-rc5upstream #54
 Call Trace:
 [c0000000e590fac0] [c0000000007b2400] dump_stack+0xc4/0x114 (unreliable)
 [c0000000e590fb00] [c000000000145290] panic+0x16c/0x41c
 [c0000000e590fba0] [c0000000008892e0] sysrq_handle_crash+0x30/0x40
 [c0000000e590fc00] [c000000000889cdc] __handle_sysrq+0xcc/0x1f0
 [c0000000e590fca0] [c00000000088a538] write_sysrq_trigger+0xd8/0x178
 [c0000000e590fce0] [c0000000005e9b7c] proc_reg_write+0x10c/0x1b0
 [c0000000e590fd10] [c0000000004f26d0] vfs_write+0xf0/0x330
 [c0000000e590fd60] [c0000000004f2aec] ksys_write+0x7c/0x140
 [c0000000e590fdb0] [c000000000031ee0] system_call_exception+0x150/0x290
 [c0000000e590fe10] [c00000000000ca5c] system_call_common+0xec/0x278
 --- interrupt: c00 at 0x7fff905b9664
 NIP:  00007fff905b9664 LR: 00007fff905320c4 CTR: 0000000000000000
 REGS: c0000000e590fe80 TRAP: 0c00   Not tainted  (5.12.0-rc5upstream)
 MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 28000242
       XER: 00000000
 IRQMASK: 0
 GPR00: 0000000000000004 00007ffff5fedf30 00007fff906a7300 0000000000000001
 GPR04: 000001002a7355b0 0000000000000002 0000000000000001 00007ffff5fef616
 GPR08: 0000000000000001 0000000000000000 0000000000000000 0000000000000000
 GPR12: 0000000000000000 00007fff9073a160 0000000000000000 0000000000000000
 GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
 GPR20: 0000000000000000 00007fff906a4ee0 0000000000000002 0000000000000001
 GPR24: 00007fff906a0898 0000000000000000 0000000000000002 000001002a7355b0
 GPR28: 0000000000000002 00007fff906a1790 000001002a7355b0 0000000000000002
 NIP [00007fff905b9664] 0x7fff905b9664
 LR [00007fff905320c4] 0x7fff905320c4
 --- interrupt: c00

To avoid this from happening, extract current CPU info from of_root
device node and use it for setting up the fdt in kexec_file_load case.

Fixes: 6ecd0163d360 ("powerpc/kexec_file: Add appropriate regions for memory reserve map")

Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Cc: <stable@vger.kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 98 +++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

 ---
Changelog:

v1 -> v3
  - https://lists.ozlabs.org/pipermail/linuxppc-dev/2021-April/227756.html

v3 -> v4
  - Rearranged if-else statement in update_cpus_node function to avoid
    redundant checks for positive cpus_offset. 
 ---

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 02b9e4d0dc40..195ef303d530 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -960,6 +960,99 @@ unsigned int kexec_fdt_totalsize_ppc64(struct kimage *image)
 	return fdt_size;
 }
 
+/**
+ * add_node_prop - Read property from device node structure and add
+ *			them to fdt.
+ * @fdt:		Flattened device tree of the kernel
+ * @node_offset:	offset of the node to add a property at
+ * np:			device node pointer
+ *
+ * Returns 0 on success, negative errno on error.
+ */
+static int add_node_prop(void *fdt, int node_offset, const struct device_node *np)
+{
+	int ret = 0;
+	struct property *pp;
+	unsigned long flags;
+
+	if (!np)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&devtree_lock, flags);
+	for (pp = np->properties; pp; pp = pp->next) {
+		ret = fdt_setprop(fdt, node_offset, pp->name,
+				  pp->value, pp->length);
+		if (ret < 0) {
+			pr_err("Unable to add %s property: %s\n",
+			       pp->name, fdt_strerror(ret));
+			goto out;
+		}
+	}
+out:
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
+	return ret;
+}
+
+/**
+ * update_cpus_node - Update cpus node of flattened device-tree using of_root
+ *			device node.
+ * @fdt:		Flattened device tree of the kernel.
+ *
+ * Returns 0 on success, negative errno on error.
+ */
+static int update_cpus_node(void *fdt)
+{
+	struct device_node *cpus_node, *dn;
+	int cpus_offset, cpus_subnode_off, ret = 0;
+
+	cpus_offset = fdt_path_offset(fdt, "/cpus");
+	if (cpus_offset < 0 && cpus_offset != -FDT_ERR_NOTFOUND) {
+		pr_err("Malformed device tree: error reading /cpus node: %s\n",
+		       fdt_strerror(cpus_offset));
+		return cpus_offset;
+	} else {
+		if (cpus_offset > 0) {
+			ret = fdt_del_node(fdt, cpus_offset);
+			if (ret < 0) {
+				pr_err("Error deleting /cpus node: %s\n",
+				       fdt_strerror(ret));
+				return -EINVAL;
+			}
+		}
+
+		/* Add cpus node to fdt */
+		cpus_offset = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"),
+					      "cpus");
+		if (cpus_offset < 0) {
+			pr_err("Error creating /cpus node: %s\n",
+			       fdt_strerror(cpus_offset));
+			return -EINVAL;
+		}
+
+		/* Add cpus node properties */
+		cpus_node = of_find_node_by_path("/cpus");
+		ret = add_node_prop(fdt, cpus_offset, cpus_node);
+		if (ret < 0)
+			return ret;
+
+		/* Loop through all subnodes of cpus and add them to fdt */
+		for_each_node_by_type(dn, "cpu") {
+			cpus_subnode_off = fdt_add_subnode(fdt,
+							   cpus_offset,
+							   dn->full_name);
+			if (cpus_subnode_off < 0) {
+				pr_err("Unable to add %s subnode: %s\n",
+				       dn->full_name, fdt_strerror(cpus_subnode_off));
+				return cpus_subnode_off;
+			}
+			ret = add_node_prop(fdt, cpus_subnode_off, dn);
+			if (ret < 0)
+				return ret;
+		}
+	}
+	return ret;
+}
+
 /**
  * setup_new_fdt_ppc64 - Update the flattend device-tree of the kernel
  *                       being loaded.
@@ -1020,6 +1113,11 @@ int setup_new_fdt_ppc64(const struct kimage *image, void *fdt,
 		}
 	}
 
+	/* Update cpus nodes information to account hotplug CPUs. */
+	ret =  update_cpus_node(fdt);
+	if (ret < 0)
+		return ret;
+
 	/* Update memory reserve map */
 	ret = get_reserved_memory_ranges(&rmem);
 	if (ret)
-- 
2.26.3

