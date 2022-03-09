Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28754D3311
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbiCIQMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235769AbiCIQJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E36141479;
        Wed,  9 Mar 2022 08:06:40 -0800 (PST)
Date:   Wed, 09 Mar 2022 16:06:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646841971;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9XDSOfBkJW9KT2uV7flb2vyVjv+XayBbqoN39U7/is=;
        b=sT2qn68SSRkHaABdLML8H0qWnrjD8vKOQsHzvB/Pf081ac5Pk3BscVsz1EiFwA4seZWeAr
        6IfcEmsLZPEH4UvhclXPuEK3MAkAgDTqAMJ3aE7MH7W8wd/+DGxPPNMvTIb6TVaihDYsLP
        tDjRHhFthWlpKZHPW1obn9wvJ6lx48IvHkZ/4DYsDXqoKRP3uehlUsafTNKOfn50g9rYQK
        ITVaNEsFlJ/n7sPmqM2MpzNjYrsTeNMUpZiNeTKlJS6DKGmSRRgqaQjrbClU6JmSpwfCrI
        HaPRW1MqLVCzB420TafJ858AdDD3XSXcGBfvHPI2NN2ZkCZjP6XBy9awXBe03Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646841971;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9XDSOfBkJW9KT2uV7flb2vyVjv+XayBbqoN39U7/is=;
        b=KdWWqc+OH6DG5f3Oyj0xNKtrHRqDzBbUhEma/kUV7eXwBBaNhz+fOEuDYqGdxqojeUUDWW
        we4NN9sOET20REAQ==
From:   "tip-bot2 for Ross Philipson" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/boot: Fix memremap of setup_indirect structures
Cc:     Ross Philipson <ross.philipson@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1645668456-22036-2-git-send-email-ross.philipson@oracle.com>
References: <1645668456-22036-2-git-send-email-ross.philipson@oracle.com>
MIME-Version: 1.0
Message-ID: <164684197045.16921.8900620444174308462.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     7228918b34615ef6317edcd9a058a057bc54aa32
Gitweb:        https://git.kernel.org/tip/7228918b34615ef6317edcd9a058a057bc54aa32
Author:        Ross Philipson <ross.philipson@oracle.com>
AuthorDate:    Wed, 23 Feb 2022 21:07:35 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 09 Mar 2022 12:49:44 +01:00

x86/boot: Fix memremap of setup_indirect structures

As documented, the setup_indirect structure is nested inside
the setup_data structures in the setup_data list. The code currently
accesses the fields inside the setup_indirect structure but only
the sizeof(struct setup_data) is being memremapped. No crash
occurred but this is just due to how the area is remapped under the
covers.

Properly memremap both the setup_data and setup_indirect structures
in these cases before accessing them.

Fixes: b3c72fc9a78e ("x86/boot: Introduce setup_indirect")
Signed-off-by: Ross Philipson <ross.philipson@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1645668456-22036-2-git-send-email-ross.philipson@oracle.com
---
 arch/x86/kernel/e820.c     | 41 ++++++++++++++------
 arch/x86/kernel/kdebugfs.c | 37 +++++++++++++-----
 arch/x86/kernel/ksysfs.c   | 77 +++++++++++++++++++++++++++++--------
 arch/x86/kernel/setup.c    | 34 ++++++++++++----
 arch/x86/mm/ioremap.c      | 24 ++++++++++--
 5 files changed, 166 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index bc0657f..f267205 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -995,8 +995,10 @@ early_param("memmap", parse_memmap_opt);
  */
 void __init e820__reserve_setup_data(void)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
-	u64 pa_data;
+	u64 pa_data, pa_next;
+	u32 len;
 
 	pa_data = boot_params.hdr.setup_data;
 	if (!pa_data)
@@ -1004,6 +1006,14 @@ void __init e820__reserve_setup_data(void)
 
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
+		if (!data) {
+			pr_warn("e820: failed to memremap setup_data entry\n");
+			return;
+		}
+
+		len = sizeof(*data);
+		pa_next = data->next;
+
 		e820__range_update(pa_data, sizeof(*data)+data->len, E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
 
 		/*
@@ -1015,18 +1025,27 @@ void __init e820__reserve_setup_data(void)
 						 sizeof(*data) + data->len,
 						 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
 
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-			e820__range_update(((struct setup_indirect *)data->data)->addr,
-					   ((struct setup_indirect *)data->data)->len,
-					   E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
-			e820__range_update_kexec(((struct setup_indirect *)data->data)->addr,
-						 ((struct setup_indirect *)data->data)->len,
-						 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
+		if (data->type == SETUP_INDIRECT) {
+			len += data->len;
+			early_memunmap(data, sizeof(*data));
+			data = early_memremap(pa_data, len);
+			if (!data) {
+				pr_warn("e820: failed to memremap indirect setup_data\n");
+				return;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				e820__range_update(indirect->addr, indirect->len,
+						   E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
+				e820__range_update_kexec(indirect->addr, indirect->len,
+							 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
+			}
 		}
 
-		pa_data = data->next;
-		early_memunmap(data, sizeof(*data));
+		pa_data = pa_next;
+		early_memunmap(data, len);
 	}
 
 	e820__update_table(e820_table);
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 64b6da9..e2e89be 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -88,11 +88,13 @@ create_setup_data_node(struct dentry *parent, int no,
 
 static int __init create_setup_data_nodes(struct dentry *parent)
 {
+	struct setup_indirect *indirect;
 	struct setup_data_node *node;
 	struct setup_data *data;
-	int error;
+	u64 pa_data, pa_next;
 	struct dentry *d;
-	u64 pa_data;
+	int error;
+	u32 len;
 	int no = 0;
 
 	d = debugfs_create_dir("setup_data", parent);
@@ -112,12 +114,29 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 			error = -ENOMEM;
 			goto err_dir;
 		}
-
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-			node->paddr = ((struct setup_indirect *)data->data)->addr;
-			node->type  = ((struct setup_indirect *)data->data)->type;
-			node->len   = ((struct setup_indirect *)data->data)->len;
+		pa_next = data->next;
+
+		if (data->type == SETUP_INDIRECT) {
+			len = sizeof(*data) + data->len;
+			memunmap(data);
+			data = memremap(pa_data, len, MEMREMAP_WB);
+			if (!data) {
+				kfree(node);
+				error = -ENOMEM;
+				goto err_dir;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				node->paddr = indirect->addr;
+				node->type  = indirect->type;
+				node->len   = indirect->len;
+			} else {
+				node->paddr = pa_data;
+				node->type  = data->type;
+				node->len   = data->len;
+			}
 		} else {
 			node->paddr = pa_data;
 			node->type  = data->type;
@@ -125,7 +144,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 		}
 
 		create_setup_data_node(d, no, node);
-		pa_data = data->next;
+		pa_data = pa_next;
 
 		memunmap(data);
 		no++;
diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
index d0a1912..257892f 100644
--- a/arch/x86/kernel/ksysfs.c
+++ b/arch/x86/kernel/ksysfs.c
@@ -91,26 +91,41 @@ static int get_setup_data_paddr(int nr, u64 *paddr)
 
 static int __init get_setup_data_size(int nr, size_t *size)
 {
-	int i = 0;
+	u64 pa_data = boot_params.hdr.setup_data, pa_next;
+	struct setup_indirect *indirect;
 	struct setup_data *data;
-	u64 pa_data = boot_params.hdr.setup_data;
+	int i = 0;
+	u32 len;
 
 	while (pa_data) {
 		data = memremap(pa_data, sizeof(*data), MEMREMAP_WB);
 		if (!data)
 			return -ENOMEM;
+		pa_next = data->next;
+
 		if (nr == i) {
-			if (data->type == SETUP_INDIRECT &&
-			    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT)
-				*size = ((struct setup_indirect *)data->data)->len;
-			else
+			if (data->type == SETUP_INDIRECT) {
+				len = sizeof(*data) + data->len;
+				memunmap(data);
+				data = memremap(pa_data, len, MEMREMAP_WB);
+				if (!data)
+					return -ENOMEM;
+
+				indirect = (struct setup_indirect *)data->data;
+
+				if (indirect->type != SETUP_INDIRECT)
+					*size = indirect->len;
+				else
+					*size = data->len;
+			} else {
 				*size = data->len;
+			}
 
 			memunmap(data);
 			return 0;
 		}
 
-		pa_data = data->next;
+		pa_data = pa_next;
 		memunmap(data);
 		i++;
 	}
@@ -120,9 +135,11 @@ static int __init get_setup_data_size(int nr, size_t *size)
 static ssize_t type_show(struct kobject *kobj,
 			 struct kobj_attribute *attr, char *buf)
 {
+	struct setup_indirect *indirect;
+	struct setup_data *data;
 	int nr, ret;
 	u64 paddr;
-	struct setup_data *data;
+	u32 len;
 
 	ret = kobj_to_setup_data_nr(kobj, &nr);
 	if (ret)
@@ -135,10 +152,20 @@ static ssize_t type_show(struct kobject *kobj,
 	if (!data)
 		return -ENOMEM;
 
-	if (data->type == SETUP_INDIRECT)
-		ret = sprintf(buf, "0x%x\n", ((struct setup_indirect *)data->data)->type);
-	else
+	if (data->type == SETUP_INDIRECT) {
+		len = sizeof(*data) + data->len;
+		memunmap(data);
+		data = memremap(paddr, len, MEMREMAP_WB);
+		if (!data)
+			return -ENOMEM;
+
+		indirect = (struct setup_indirect *)data->data;
+
+		ret = sprintf(buf, "0x%x\n", indirect->type);
+	} else {
 		ret = sprintf(buf, "0x%x\n", data->type);
+	}
+
 	memunmap(data);
 	return ret;
 }
@@ -149,9 +176,10 @@ static ssize_t setup_data_data_read(struct file *fp,
 				    char *buf,
 				    loff_t off, size_t count)
 {
+	struct setup_indirect *indirect;
+	struct setup_data *data;
 	int nr, ret = 0;
 	u64 paddr, len;
-	struct setup_data *data;
 	void *p;
 
 	ret = kobj_to_setup_data_nr(kobj, &nr);
@@ -165,10 +193,27 @@ static ssize_t setup_data_data_read(struct file *fp,
 	if (!data)
 		return -ENOMEM;
 
-	if (data->type == SETUP_INDIRECT &&
-	    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-		paddr = ((struct setup_indirect *)data->data)->addr;
-		len = ((struct setup_indirect *)data->data)->len;
+	if (data->type == SETUP_INDIRECT) {
+		len = sizeof(*data) + data->len;
+		memunmap(data);
+		data = memremap(paddr, len, MEMREMAP_WB);
+		if (!data)
+			return -ENOMEM;
+
+		indirect = (struct setup_indirect *)data->data;
+
+		if (indirect->type != SETUP_INDIRECT) {
+			paddr = indirect->addr;
+			len = indirect->len;
+		} else {
+			/*
+			 * Even though this is technically undefined, return
+			 * the data as though it is a normal setup_data struct.
+			 * This will at least allow it to be inspected.
+			 */
+			paddr += sizeof(*data);
+			len = data->len;
+		}
 	} else {
 		paddr += sizeof(*data);
 		len = data->len;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f7a132e..90d7e17 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -369,21 +369,41 @@ static void __init parse_setup_data(void)
 
 static void __init memblock_x86_reserve_range_setup_data(void)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
-	u64 pa_data;
+	u64 pa_data, pa_next;
+	u32 len;
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
+		if (!data) {
+			pr_warn("setup: failed to memremap setup_data entry\n");
+			return;
+		}
+
+		len = sizeof(*data);
+		pa_next = data->next;
+
 		memblock_reserve(pa_data, sizeof(*data) + data->len);
 
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT)
-			memblock_reserve(((struct setup_indirect *)data->data)->addr,
-					 ((struct setup_indirect *)data->data)->len);
+		if (data->type == SETUP_INDIRECT) {
+			len += data->len;
+			early_memunmap(data, sizeof(*data));
+			data = early_memremap(pa_data, len);
+			if (!data) {
+				pr_warn("setup: failed to memremap indirect setup_data\n");
+				return;
+			}
 
-		pa_data = data->next;
-		early_memunmap(data, sizeof(*data));
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT)
+				memblock_reserve(indirect->addr, indirect->len);
+		}
+
+		pa_data = pa_next;
+		early_memunmap(data, len);
 	}
 }
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 026031b..ab666c4 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -615,6 +615,7 @@ static bool memremap_is_efi_data(resource_size_t phys_addr,
 static bool memremap_is_setup_data(resource_size_t phys_addr,
 				   unsigned long size)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
 	u64 paddr, paddr_next;
 
@@ -627,6 +628,10 @@ static bool memremap_is_setup_data(resource_size_t phys_addr,
 
 		data = memremap(paddr, sizeof(*data),
 				MEMREMAP_WB | MEMREMAP_DEC);
+		if (!data) {
+			pr_warn("failed to memremap setup_data entry\n");
+			return false;
+		}
 
 		paddr_next = data->next;
 		len = data->len;
@@ -636,10 +641,21 @@ static bool memremap_is_setup_data(resource_size_t phys_addr,
 			return true;
 		}
 
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-			paddr = ((struct setup_indirect *)data->data)->addr;
-			len = ((struct setup_indirect *)data->data)->len;
+		if (data->type == SETUP_INDIRECT) {
+			memunmap(data);
+			data = memremap(paddr, sizeof(*data) + len,
+					MEMREMAP_WB | MEMREMAP_DEC);
+			if (!data) {
+				pr_warn("failed to memremap indirect setup_data\n");
+				return false;
+			}
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT) {
+				paddr = indirect->addr;
+				len = indirect->len;
+			}
 		}
 
 		memunmap(data);
