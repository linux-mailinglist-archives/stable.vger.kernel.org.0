Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC9E8DA43
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbfHNRN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730968AbfHNRNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:13:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB7CD20665;
        Wed, 14 Aug 2019 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802833;
        bh=qDZva4gHxim8jnTlgaNdRKpb8F1TlaMNJ/vRHk0cXAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdSmfCtfexmrHkilbF9AQ2u6CndZ2VcYorRL2X9nczHLZcq7jKsy51ODDfEcjrJkA
         llySAa27hcCxjSIuyPB32yXuIo48L8IzdxXS4SjTOBw/WARhHwwetP9LITmDUTywFc
         aOEKqGwLwMiLJpeb/OjRCf1pp8xbkKi1Fzuv8q8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 4.14 17/69] mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()
Date:   Wed, 14 Aug 2019 19:01:15 +0200
Message-Id: <20190814165746.789352202@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
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
@@ -1766,6 +1766,12 @@ void *__vmalloc_node_range(unsigned long
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
@@ -2314,6 +2320,9 @@ EXPORT_SYMBOL(remap_vmalloc_range);
 /*
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
  * have one.
+ *
+ * The purpose of this function is to make sure the vmalloc area
+ * mappings are identical in all page-tables in the system.
  */
 void __weak vmalloc_sync_all(void)
 {


