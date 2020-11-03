Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B982A524E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731593AbgKCUss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:48:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731629AbgKCUsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F9E4223FD;
        Tue,  3 Nov 2020 20:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436525;
        bh=13wYM5hiUOT/GmIzWu4aVniKeTvXXf4/7Fi7zvDYtuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wg1gxKmLKU5HGemYt7tkNDb6wpPufRpmf0pMtglrWtM9D4ScQe4OLpoBDLWpuP7/w
         P+dD7Sy4QXa1zamwTDuXLgMl62Cl7luQwKukmhJX1/xZ9X2J5lzQ6ta+PF8yAy10l9
         HKHcFQWkt6Scqstu7kZqdxrrOVGvzmElzJfYPvdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 288/391] powerpc/memhotplug: Make lmb size 64bit
Date:   Tue,  3 Nov 2020 21:35:39 +0100
Message-Id: <20201103203406.481942387@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit 301d2ea6572386245c5d2d2dc85c3b5a737b85ac upstream.

Similar to commit 89c140bbaeee ("pseries: Fix 64 bit logical memory block panic")
make sure different variables tracking lmb_size are updated to be 64 bit.

This was found by code audit.

Cc: stable@vger.kernel.org
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201007114836.282468-3-aneesh.kumar@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/hotplug-memory.c |   43 ++++++++++++++++--------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -277,7 +277,7 @@ static int dlpar_offline_lmb(struct drme
 	return dlpar_change_lmb_state(lmb, false);
 }
 
-static int pseries_remove_memblock(unsigned long base, unsigned int memblock_size)
+static int pseries_remove_memblock(unsigned long base, unsigned long memblock_size)
 {
 	unsigned long block_sz, start_pfn;
 	int sections_per_block;
@@ -308,10 +308,11 @@ out:
 
 static int pseries_remove_mem_node(struct device_node *np)
 {
-	const __be32 *regs;
+	const __be32 *prop;
 	unsigned long base;
-	unsigned int lmb_size;
+	unsigned long lmb_size;
 	int ret = -EINVAL;
+	int addr_cells, size_cells;
 
 	/*
 	 * Check to see if we are actually removing memory
@@ -322,12 +323,19 @@ static int pseries_remove_mem_node(struc
 	/*
 	 * Find the base address and size of the memblock
 	 */
-	regs = of_get_property(np, "reg", NULL);
-	if (!regs)
+	prop = of_get_property(np, "reg", NULL);
+	if (!prop)
 		return ret;
 
-	base = be64_to_cpu(*(unsigned long *)regs);
-	lmb_size = be32_to_cpu(regs[3]);
+	addr_cells = of_n_addr_cells(np);
+	size_cells = of_n_size_cells(np);
+
+	/*
+	 * "reg" property represents (addr,size) tuple.
+	 */
+	base = of_read_number(prop, addr_cells);
+	prop += addr_cells;
+	lmb_size = of_read_number(prop, size_cells);
 
 	pseries_remove_memblock(base, lmb_size);
 	return 0;
@@ -564,7 +572,7 @@ static int dlpar_memory_remove_by_ic(u32
 
 #else
 static inline int pseries_remove_memblock(unsigned long base,
-					  unsigned int memblock_size)
+					  unsigned long memblock_size)
 {
 	return -EOPNOTSUPP;
 }
@@ -886,10 +894,11 @@ int dlpar_memory(struct pseries_hp_error
 
 static int pseries_add_mem_node(struct device_node *np)
 {
-	const __be32 *regs;
+	const __be32 *prop;
 	unsigned long base;
-	unsigned int lmb_size;
+	unsigned long lmb_size;
 	int ret = -EINVAL;
+	int addr_cells, size_cells;
 
 	/*
 	 * Check to see if we are actually adding memory
@@ -900,12 +909,18 @@ static int pseries_add_mem_node(struct d
 	/*
 	 * Find the base and size of the memblock
 	 */
-	regs = of_get_property(np, "reg", NULL);
-	if (!regs)
+	prop = of_get_property(np, "reg", NULL);
+	if (!prop)
 		return ret;
 
-	base = be64_to_cpu(*(unsigned long *)regs);
-	lmb_size = be32_to_cpu(regs[3]);
+	addr_cells = of_n_addr_cells(np);
+	size_cells = of_n_size_cells(np);
+	/*
+	 * "reg" property represents (addr,size) tuple.
+	 */
+	base = of_read_number(prop, addr_cells);
+	prop += addr_cells;
+	lmb_size = of_read_number(prop, size_cells);
 
 	/*
 	 * Update memory region to represent the memory add


