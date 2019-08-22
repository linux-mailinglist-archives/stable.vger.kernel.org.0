Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF9A99E1D
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391348AbfHVRWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391337AbfHVRWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:31 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51A6B2341C;
        Thu, 22 Aug 2019 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494550;
        bh=qSF4n7mlumXwjAgU9FmLZbWGKyJSMaST2PdnW7kPMn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LU5PMDT0/K1Tgay/dG1Pgf9O5y68ESnBgtKEG/siAsO0JdgIlQzHZKLTjg1vlzaww
         +d69cfG+oqPrRzLNvOxxjg54E9MRJ+MeWKu7RyRsd/3TCbLaBu9icamkJ5i/SrPFJG
         7C4sUz3fkOlRVN4DCOaUzunzvuS9lv00uwETOlA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 4.4 05/78] mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()
Date:   Thu, 22 Aug 2019 10:18:09 -0700
Message-Id: <20190822171832.201416107@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 3f8fd02b1bf1d7ba964485a56f2f4b53ae88c167 upstream.

On x86-32 with PTI enabled, parts of the kernel page-tables are not shared
between processes. This can cause mappings in the vmalloc/ioremap area to
persist in some page-tables after the region is unmapped and released.

When the region is re-used the processes with the old mappings do not fault
in the new mappings but still access the old ones.

This causes undefined behavior, in reality often data corruption, kernel
oopses and panics and even spontaneous reboots.

Fix this problem by activly syncing unmaps in the vmalloc/ioremap area to
all page-tables in the system before the regions can be re-used.

Fixes: 5d72b4fba40ef ('x86, mm: support huge I/O mapping capability I/F')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20190719184652.11391-4-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmalloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1678,6 +1678,12 @@ void *__vmalloc_node_range(unsigned long
 		return NULL;
 
 	/*
+	 * First make sure the mappings are removed from all page-tables
+	 * before they are freed.
+	 */
+	vmalloc_sync_all();
+
+	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
 	 * flag. It means that vm_struct is not fully initialized.
 	 * Now, it is fully initialized, so remove this flag here.
@@ -2214,6 +2220,9 @@ EXPORT_SYMBOL(remap_vmalloc_range);
 /*
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
  * have one.
+ *
+ * The purpose of this function is to make sure the vmalloc area
+ * mappings are identical in all page-tables in the system.
  */
 void __weak vmalloc_sync_all(void)
 {


