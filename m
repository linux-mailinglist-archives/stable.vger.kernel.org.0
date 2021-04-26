Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2598036AE11
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhDZHlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233482AbhDZHjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DBE2613B3;
        Mon, 26 Apr 2021 07:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422662;
        bh=VGIKi137E+ddYJLUTS0lnAKLre8DBq1QVLFL+p5vb4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMeJXGzNT7mKwYfXKXjC2eK/Q5PIThzClvxFLL4WskUeur3enUo4wyS3p2lRHR6zO
         9Ly8jFFGDjnYLmlxiIDluyznjnluMG0K91qodrxtL9BRgxr06XKDaOVV5citoT9ClA
         XUbue1xKYAEdsvyA0TvZ4jQluTCfJv5waR/PqMPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/57] ia64: fix discontig.c section mismatches
Date:   Mon, 26 Apr 2021 09:29:52 +0200
Message-Id: <20210426072822.448636776@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e2af9da4f867a1a54f1252bf3abc1a5c63951778 ]

Fix IA64 discontig.c Section mismatch warnings.

When CONFIG_SPARSEMEM=y and CONFIG_MEMORY_HOTPLUG=y, the functions
computer_pernodesize() and scatter_node_data() should not be marked as
__meminit because they are needed after init, on any memory hotplug
event.  Also, early_nr_cpus_node() is called by compute_pernodesize(),
so early_nr_cpus_node() cannot be __meminit either.

  WARNING: modpost: vmlinux.o(.text.unlikely+0x1612): Section mismatch in reference from the function arch_alloc_nodedata() to the function .meminit.text:compute_pernodesize()
  The function arch_alloc_nodedata() references the function __meminit compute_pernodesize().
  This is often because arch_alloc_nodedata lacks a __meminit annotation or the annotation of compute_pernodesize is wrong.

  WARNING: modpost: vmlinux.o(.text.unlikely+0x1692): Section mismatch in reference from the function arch_refresh_nodedata() to the function .meminit.text:scatter_node_data()
  The function arch_refresh_nodedata() references the function __meminit scatter_node_data().
  This is often because arch_refresh_nodedata lacks a __meminit annotation or the annotation of scatter_node_data is wrong.

  WARNING: modpost: vmlinux.o(.text.unlikely+0x1502): Section mismatch in reference from the function compute_pernodesize() to the function .meminit.text:early_nr_cpus_node()
  The function compute_pernodesize() references the function __meminit early_nr_cpus_node().
  This is often because compute_pernodesize lacks a __meminit annotation or the annotation of early_nr_cpus_node is wrong.

Link: https://lkml.kernel.org/r/20210411001201.3069-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/mm/discontig.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index 1928d5719e41..db3104c9fac5 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -96,7 +96,7 @@ static int __init build_node_maps(unsigned long start, unsigned long len,
  * acpi_boot_init() (which builds the node_to_cpu_mask array) hasn't been
  * called yet.  Note that node 0 will also count all non-existent cpus.
  */
-static int __meminit early_nr_cpus_node(int node)
+static int early_nr_cpus_node(int node)
 {
 	int cpu, n = 0;
 
@@ -111,7 +111,7 @@ static int __meminit early_nr_cpus_node(int node)
  * compute_pernodesize - compute size of pernode data
  * @node: the node id.
  */
-static unsigned long __meminit compute_pernodesize(int node)
+static unsigned long compute_pernodesize(int node)
 {
 	unsigned long pernodesize = 0, cpus;
 
@@ -371,7 +371,7 @@ static void __init reserve_pernode_space(void)
 	}
 }
 
-static void __meminit scatter_node_data(void)
+static void scatter_node_data(void)
 {
 	pg_data_t **dst;
 	int node;
-- 
2.30.2



