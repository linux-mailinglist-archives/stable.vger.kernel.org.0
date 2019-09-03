Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E3CA5E6B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 02:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfICASm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 20:18:42 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:1534 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727884AbfICASf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 20:18:35 -0400
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83072gq006212;
        Tue, 3 Sep 2019 00:18:17 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 2us6yn1tp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 00:18:17 +0000
Received: from stormcage.eag.rdlabs.hpecorp.net (unknown [128.162.236.70])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id D294B65;
        Tue,  3 Sep 2019 00:18:16 +0000 (UTC)
Received: by stormcage.eag.rdlabs.hpecorp.net (Postfix, from userid 5508)
        id 66758201EA098; Mon,  2 Sep 2019 19:18:16 -0500 (CDT)
Message-Id: <20190903001816.288373651@stormcage.eag.rdlabs.hpecorp.net>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: quilt/0.46-1
Date:   Mon, 02 Sep 2019 19:18:20 -0500
From:   Mike Travis <mike.travis@hpe.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5/8] x86/platform/uv: Add UV Hubbed/Hubless Proc FS Files
Content-Disposition: inline; filename=add-procfs-files
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_10:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Indicate to UV user utilities that UV hubless support is available on
this system via the existing /proc infterface.  The current interface
is maintained with the addition of a new /proc leaves ("hubbed" and
"hubless") that contain the specific type of UV arch this one is.

Signed-off-by: Mike Travis <mike.travis@hpe.com>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
---
 arch/x86/include/asm/uv/uv.h       |    6 ++
 arch/x86/kernel/apic/x2apic_uv_x.c |   93 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 98 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/include/asm/uv/uv.h
+++ linux/arch/x86/include/asm/uv/uv.h
@@ -12,6 +12,8 @@ struct mm_struct;
 #ifdef CONFIG_X86_UV
 #include <linux/efi.h>
 
+#define	UV_PROC_NODE	"sgi_uv"
+
 static inline int uv(int uvtype)
 {
 	/* uv(0) is "any" */
@@ -25,6 +27,8 @@ static inline bool is_early_uv_system(vo
 	return !((efi.uv_systab == EFI_INVALID_TABLE_ADDR) || !efi.uv_systab);
 }
 extern int is_uv_system(void);
+extern int _is_uv_hubbed(int uvtype);
+#define is_uv_hubbed _is_uv_hubbed
 extern int _is_uv_hubless(int uvtype);
 #define is_uv_hubless _is_uv_hubless
 extern void uv_cpu_init(void);
@@ -38,6 +42,8 @@ extern const struct cpumask *uv_flush_tl
 static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
 static inline bool is_early_uv_system(void)	{ return 0; }
 static inline int is_uv_system(void)	{ return 0; }
+static inline int _is_uv_hubbed(int uv)	{ return 0; }
+#define is_uv_hubbed _is_uv_hubbed
 static inline int _is_uv_hubless(int uv) { return 0; }
 #define is_uv_hubless _is_uv_hubless
 static inline void uv_cpu_init(void)	{ }
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -46,6 +46,7 @@
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type	uv_system_type;
+static int			uv_hubbed_system;
 static int			uv_hubless_system;
 static u64			gru_start_paddr, gru_end_paddr;
 static u64			gru_dist_base, gru_first_node_paddr = -1LL, gru_last_node_paddr;
@@ -329,6 +330,24 @@ static int __init uv_acpi_madt_oem_check
 	if (uv_hub_info->hub_revision == 0)
 		goto badbios;
 
+	switch (uv_hub_info->hub_revision) {
+	case UV4_HUB_REVISION_BASE:
+		uv_hubbed_system = 0x11;
+		break;
+
+	case UV3_HUB_REVISION_BASE:
+		uv_hubbed_system = 0x9;
+		break;
+
+	case UV2_HUB_REVISION_BASE:
+		uv_hubbed_system = 0x5;
+		break;
+
+	case UV1_HUB_REVISION_BASE:
+		uv_hubbed_system = 0x3;
+		break;
+	}
+
 	pnodeid = early_get_pnodeid();
 	early_get_apic_socketid_shift();
 
@@ -379,6 +398,12 @@ int is_uv_system(void)
 }
 EXPORT_SYMBOL_GPL(is_uv_system);
 
+int _is_uv_hubbed(int uvtype)
+{
+	return (uv_hubbed_system & uvtype);
+}
+EXPORT_SYMBOL_GPL(_is_uv_hubbed);
+
 int _is_uv_hubless(int uvtype)
 {
 	return (uv_hubless_system & uvtype);
@@ -1477,6 +1502,68 @@ static void __init build_socket_tables(v
 	}
 }
 
+/* Setup user proc fs files */
+static int proc_hubbed_show(struct seq_file *file, void *data)
+{
+	seq_printf(file, "0x%x\n", uv_hubbed_system);
+	return 0;
+}
+
+static int proc_hubless_show(struct seq_file *file, void *data)
+{
+	seq_printf(file, "0x%x\n", uv_hubless_system);
+	return 0;
+}
+
+static int proc_oemid_show(struct seq_file *file, void *data)
+{
+	seq_printf(file, "%s/%s\n", oem_id, oem_table_id);
+	return 0;
+}
+
+static int proc_hubbed_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_hubbed_show, (void *)NULL);
+}
+
+static int proc_hubless_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_hubless_show, (void *)NULL);
+}
+
+static int proc_oemid_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_oemid_show, (void *)NULL);
+}
+
+/* (The open function is set to the hubbed or hubless version) */
+static struct file_operations proc_version_fops = {
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations proc_oemid_fops = {
+	.open		= proc_oemid_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static __init void uv_setup_proc_files(int hubless)
+{
+	struct proc_dir_entry *pde;
+	char *name = hubless ? "hubless" : "hubbed";
+
+	pde = proc_mkdir(UV_PROC_NODE, NULL);
+	proc_create(name, 0, pde, &proc_version_fops);
+	if (hubless)
+		proc_version_fops.open = proc_hubless_open;
+	else
+		proc_version_fops.open = proc_hubbed_open;
+	proc_create(name, 0, pde, &proc_oemid_fops);
+}
+
 /* Initialize UV hubless systems */
 static __init int uv_system_init_hubless(void)
 {
@@ -1488,6 +1575,10 @@ static __init int uv_system_init_hubless
 	/* Init kernel/BIOS interface */
 	rc = uv_bios_init();
 
+	/* Create user access node if UVsystab available */
+	if (rc >= 0)
+		uv_setup_proc_files(1);
+
 	return rc;
 }
 
@@ -1616,7 +1707,7 @@ static void __init uv_system_init_hub(vo
 	uv_nmi_setup();
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
-	proc_mkdir("sgi_uv", NULL);
+	uv_setup_proc_files(0);
 
 	/* Register Legacy VGA I/O redirection handler: */
 	pci_register_set_vga_state(uv_set_vga_state);

-- 
