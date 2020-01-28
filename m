Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5263314B945
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733307AbgA1O3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:29:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387511AbgA1O3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:29:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 508EA2468D;
        Tue, 28 Jan 2020 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221782;
        bh=WDEqqVHpmjTaWCXdgUoLsTdZaPyCrws2lmy+k6Hx9BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZeUw7VjxsRZybmdiLSbJvW9PWTDzLe0lHs54eiaA5NvdR918Mw/SjaIvWRiSrDtc
         FDUNeLOBULRE3hqMHaeL+MWVzJhAPcg9bb9iUBTI6xP3HO/v6ENZqA40bStf0QNB5f
         scg7GRjkEko2M6JMaqPtvHceYYDLgDiOOhH6v1kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 4.19 79/92] powerpc/mm: Fix section mismatch warning
Date:   Tue, 28 Jan 2020 15:08:47 +0100
Message-Id: <20200128135819.605560942@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 26ad26718dfaa7cf49d106d212ebf2370076c253 upstream.

This patch fix the below section mismatch warnings.

WARNING: vmlinux.o(.text+0x2d1f44): Section mismatch in reference from the function devm_memremap_pages_release() to the function .meminit.text:arch_remove_memory()
WARNING: vmlinux.o(.text+0x2d265c): Section mismatch in reference from the function devm_memremap_pages() to the function .meminit.text:arch_add_memory()

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/mem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -118,8 +118,8 @@ int __weak remove_section_mapping(unsign
 	return -ENODEV;
 }
 
-int __meminit arch_add_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap,
-		bool want_memblock)
+int __ref arch_add_memory(int nid, u64 start, u64 size, struct vmem_altmap *altmap,
+			  bool want_memblock)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -140,8 +140,8 @@ int __meminit arch_add_memory(int nid, u
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int __meminit arch_remove_memory(int nid, u64 start, u64 size,
-					struct vmem_altmap *altmap)
+int __ref arch_remove_memory(int nid, u64 start, u64 size,
+			     struct vmem_altmap *altmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;


