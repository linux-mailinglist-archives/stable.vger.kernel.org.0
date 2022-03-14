Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B6C4D834A
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbiCNMNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240881AbiCNMM2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:12:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AD734645;
        Mon, 14 Mar 2022 05:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FDACB80DFE;
        Mon, 14 Mar 2022 12:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87958C36AE3;
        Mon, 14 Mar 2022 12:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259839;
        bh=conldt1voxjhpmkOdR9hdxYh4lfzrwEexWhvChmj+3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZWO5kYZmT5DqiX7TaCWCLoncpawE4jNJhSxauYwO4WmwmOAcNNIgUa6Ui20X18Rl
         iFvNcarcC8KvUBAnzhZEUmH5pokVQeBFoKdQ84WVUaF/qRz1gcSS91DQfCRttivxJ9
         VTRhxDYFnsMeq6nrgwwKLQWRDv6780HaV3PKSqBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Philipson <ross.philipson@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 5.15 101/110] x86/boot: Fix memremap of setup_indirect structures
Date:   Mon, 14 Mar 2022 12:54:43 +0100
Message-Id: <20220314112745.845524741@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Philipson <ross.philipson@oracle.com>

commit 7228918b34615ef6317edcd9a058a057bc54aa32 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/e820.c     |   41 +++++++++++++++++------
 arch/x86/kernel/kdebugfs.c |   35 +++++++++++++++-----
 arch/x86/kernel/ksysfs.c   |   77 +++++++++++++++++++++++++++++++++++----------
 arch/x86/kernel/setup.c    |   34 +++++++++++++++----
 arch/x86/mm/ioremap.c      |   24 +++++++++++---
 5 files changed, 165 insertions(+), 46 deletions(-)

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
@@ -1004,6 +1006,14 @@ void __init e820__reserve_setup_data(voi
 
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
@@ -1015,18 +1025,27 @@ void __init e820__reserve_setup_data(voi
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
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -88,11 +88,13 @@ create_setup_data_node(struct dentry *pa
 
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
@@ -112,12 +114,29 @@ static int __init create_setup_data_node
 			error = -ENOMEM;
 			goto err_dir;
 		}
+		pa_next = data->next;
 
-		if (data->type == SETUP_INDIRECT &&
-		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT) {
-			node->paddr = ((struct setup_indirect *)data->data)->addr;
-			node->type  = ((struct setup_indirect *)data->data)->type;
-			node->len   = ((struct setup_indirect *)data->data)->len;
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
@@ -125,7 +144,7 @@ static int __init create_setup_data_node
 		}
 
 		create_setup_data_node(d, no, node);
-		pa_data = data->next;
+		pa_data = pa_next;
 
 		memunmap(data);
 		no++;
--- a/arch/x86/kernel/ksysfs.c
+++ b/arch/x86/kernel/ksysfs.c
@@ -91,26 +91,41 @@ static int get_setup_data_paddr(int nr,
 
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
@@ -120,9 +135,11 @@ static int __init get_setup_data_size(in
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
@@ -135,10 +152,20 @@ static ssize_t type_show(struct kobject
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
@@ -149,9 +176,10 @@ static ssize_t setup_data_data_read(stru
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
@@ -165,10 +193,27 @@ static ssize_t setup_data_data_read(stru
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
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -368,21 +368,41 @@ static void __init parse_setup_data(void
 
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
+
+			indirect = (struct setup_indirect *)data->data;
+
+			if (indirect->type != SETUP_INDIRECT)
+				memblock_reserve(indirect->addr, indirect->len);
+		}
 
-		pa_data = data->next;
-		early_memunmap(data, sizeof(*data));
+		pa_data = pa_next;
+		early_memunmap(data, len);
 	}
 }
 
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -614,6 +614,7 @@ static bool memremap_is_efi_data(resourc
 static bool memremap_is_setup_data(resource_size_t phys_addr,
 				   unsigned long size)
 {
+	struct setup_indirect *indirect;
 	struct setup_data *data;
 	u64 paddr, paddr_next;
 
@@ -626,6 +627,10 @@ static bool memremap_is_setup_data(resou
 
 		data = memremap(paddr, sizeof(*data),
 				MEMREMAP_WB | MEMREMAP_DEC);
+		if (!data) {
+			pr_warn("failed to memremap setup_data entry\n");
+			return false;
+		}
 
 		paddr_next = data->next;
 		len = data->len;
@@ -635,10 +640,21 @@ static bool memremap_is_setup_data(resou
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


