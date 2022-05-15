Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE788527954
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbiEOSsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238591AbiEOSsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:48:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B217713D67;
        Sun, 15 May 2022 11:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25B1F61127;
        Sun, 15 May 2022 18:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D77C385B8;
        Sun, 15 May 2022 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640465;
        bh=aeZJVNgi4JQKnACTN8gGui5roz65wqit1K2XsC5yAjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QM7QhkK1wgJo8Ee33CSgDQE+X2bdE34/an5wztIShBBt5cWDDjLjZjERVW/MzBFe/
         2W+OcWJimTijHotOUjrAm7niT5SLaNi42C6Uk8cNXMSMkF+AVilO7wcx+XRHwIUZGF
         3QPbFsC8Jl10HLI6+jzgcnd5oh9BfgQ0gn77p8YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.17.8
Date:   Sun, 15 May 2022 20:47:35 +0200
Message-Id: <165264045411776@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <16526404542247@kroah.com>
References: <16526404542247@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index ce65b393a2b4..3cf179812f0f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 17
-SUBLEVEL = 7
+SUBLEVEL = 8
 EXTRAVERSION =
 NAME = Superb Owl
 
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 0ed4861b038f..b3d5f97f16cd 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -75,11 +75,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 
 	if (fileident) {
 		if (adinicb || (offset + lfi < 0)) {
-			memcpy(udf_get_fi_ident(sfi), fileident, lfi);
+			memcpy(sfi->impUse + liu, fileident, lfi);
 		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
 		} else {
-			memcpy(udf_get_fi_ident(sfi), fileident, -offset);
+			memcpy(sfi->impUse + liu, fileident, -offset);
 			memcpy(fibh->ebh->b_data, fileident - offset,
 				lfi + offset);
 		}
@@ -88,11 +88,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 	offset += lfi;
 
 	if (adinicb || (offset + padlen < 0)) {
-		memset(udf_get_fi_ident(sfi) + lfi, 0x00, padlen);
+		memset(sfi->impUse + liu + lfi, 0x00, padlen);
 	} else if (offset >= 0) {
 		memset(fibh->ebh->b_data + offset, 0x00, padlen);
 	} else {
-		memset(udf_get_fi_ident(sfi) + lfi, 0x00, -offset);
+		memset(sfi->impUse + liu + lfi, 0x00, -offset);
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}
 
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 36d727f94ac2..131514913430 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -36,6 +36,9 @@
 /* HCI priority */
 #define HCI_PRIO_MAX	7
 
+/* HCI maximum id value */
+#define HCI_MAX_ID 10000
+
 /* HCI Core structures */
 struct inquiry_data {
 	bdaddr_t	bdaddr;
diff --git a/include/uapi/linux/rfkill.h b/include/uapi/linux/rfkill.h
index 283c5a7b3f2c..db6c8588c1d0 100644
--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -184,7 +184,7 @@ struct rfkill_event_ext {
 #define RFKILL_IOC_NOINPUT	1
 #define RFKILL_IOCTL_NOINPUT	_IO(RFKILL_IOC_MAGIC, RFKILL_IOC_NOINPUT)
 #define RFKILL_IOC_MAX_SIZE	2
-#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_EXT_SIZE, __u32)
+#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_MAX_SIZE, __u32)
 
 /* and that's all userspace gets */
 
diff --git a/mm/gup.c b/mm/gup.c
index 7bc1ba9ce440..41da0bd61bec 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -465,7 +465,7 @@ static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, unsigned int flags)
 {
 	/* No page to get reference */
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return -EFAULT;
 
 	if (flags & FOLL_TOUCH) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a1da8757cc9c..e2dc190c6725 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5820,7 +5820,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 			*pagep = NULL;
 			goto out;
 		}
-		folio_copy(page_folio(page), page_folio(*pagep));
+		copy_user_huge_page(page, *pagep, dst_addr, dst_vma,
+				    pages_per_huge_page(h));
 		put_page(*pagep);
 		*pagep = NULL;
 	}
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 15dcedbc1730..682eedb5ea75 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -707,8 +707,10 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 			      (void *)&priv);
 	if (ret == 1 && priv.tk.addr)
 		kill_proc(&priv.tk, pfn, flags);
+	else
+		ret = 0;
 	mmap_read_unlock(p->mm);
-	return ret ? -EFAULT : -EHWPOISON;
+	return ret > 0 ? -EHWPOISON : -EFAULT;
 }
 
 static const char *action_name[] = {
diff --git a/mm/memory.c b/mm/memory.c
index b69afe3dd597..886925d97759 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5475,6 +5475,8 @@ long copy_huge_page_from_user(struct page *dst_page,
 		if (rc)
 			break;
 
+		flush_dcache_page(subpage);
+
 		cond_resched();
 	}
 	return ret_val;
diff --git a/mm/migrate.c b/mm/migrate.c
index 086a36637467..ac7673e43dda 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -916,9 +916,12 @@ static int move_to_new_page(struct page *newpage, struct page *page,
 		if (!PageMappingFlags(page))
 			page->mapping = NULL;
 
-		if (likely(!is_zone_device_page(newpage)))
-			flush_dcache_page(newpage);
+		if (likely(!is_zone_device_page(newpage))) {
+			int i, nr = compound_nr(newpage);
 
+			for (i = 0; i < nr; i++)
+				flush_dcache_page(newpage + i);
+		}
 	}
 out:
 	return rc;
@@ -3082,18 +3085,21 @@ static int establish_migrate_target(int node, nodemask_t *used,
 	if (best_distance != -1) {
 		val = node_distance(node, migration_target);
 		if (val > best_distance)
-			return NUMA_NO_NODE;
+			goto out_clear;
 	}
 
 	index = nd->nr;
 	if (WARN_ONCE(index >= DEMOTION_TARGET_NODES,
 		      "Exceeds maximum demotion target nodes\n"))
-		return NUMA_NO_NODE;
+		goto out_clear;
 
 	nd->nodes[index] = migration_target;
 	nd->nr++;
 
 	return migration_target;
+out_clear:
+	node_clear(migration_target, *used);
+	return NUMA_NO_NODE;
 }
 
 /*
diff --git a/mm/mlock.c b/mm/mlock.c
index 37f969ec68fa..b565b1aac8d4 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -838,6 +838,7 @@ int user_shm_lock(size_t size, struct ucounts *ucounts)
 	}
 	if (!get_ucounts(ucounts)) {
 		dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, locked);
+		allowed = 0;
 		goto out;
 	}
 	allowed = 1;
diff --git a/mm/shmem.c b/mm/shmem.c
index a09b29ec2b45..7a46419d331d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2357,8 +2357,10 @@ int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
 				/* don't free the page */
 				goto out_unacct_blocks;
 			}
+
+			flush_dcache_page(page);
 		} else {		/* ZEROPAGE */
-			clear_highpage(page);
+			clear_user_highpage(page, dst_addr);
 		}
 	} else {
 		page = *pagep;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 885e5adb0168..7259f96faaa0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -153,6 +153,8 @@ static int mcopy_atomic_pte(struct mm_struct *dst_mm,
 			/* don't free the page */
 			goto out;
 		}
+
+		flush_dcache_page(page);
 	} else {
 		page = *pagep;
 		*pagep = NULL;
@@ -628,6 +630,7 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 				err = -EFAULT;
 				goto out;
 			}
+			flush_dcache_page(page);
 			goto retry;
 		} else
 			BUG_ON(page);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2882bc7d79d7..9e9713f7ddb8 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2554,10 +2554,10 @@ int hci_register_dev(struct hci_dev *hdev)
 	 */
 	switch (hdev->dev_type) {
 	case HCI_PRIMARY:
-		id = ida_simple_get(&hci_index_ida, 0, 0, GFP_KERNEL);
+		id = ida_simple_get(&hci_index_ida, 0, HCI_MAX_ID, GFP_KERNEL);
 		break;
 	case HCI_AMP:
-		id = ida_simple_get(&hci_index_ida, 1, 0, GFP_KERNEL);
+		id = ida_simple_get(&hci_index_ida, 1, HCI_MAX_ID, GFP_KERNEL);
 		break;
 	default:
 		return -EINVAL;
@@ -2566,7 +2566,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	if (id < 0)
 		return id;
 
-	sprintf(hdev->name, "hci%d", id);
+	snprintf(hdev->name, sizeof(hdev->name), "hci%d", id);
 	hdev->id = id;
 
 	BT_DBG("%p name %s bus %d", hdev, hdev->name, hdev->bus);
