Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAD849A330
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366167AbiAXXw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844736AbiAXXKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F14C09F83E;
        Mon, 24 Jan 2022 13:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96207B811FB;
        Mon, 24 Jan 2022 21:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5A4C340E4;
        Mon, 24 Jan 2022 21:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059094;
        bh=Wl7/FqyVESgtyk8MNTltFU21fmpFUMloKKngtNOgNRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZm/OClDDlGbuII0KT03mwHfmAUXFeytLEl3R59RXx+o1RX0qnLtd5Aszn/DQFPbx
         oupujNGN1DERcIaM6nRvczs2+ITprqBgoT9mUe7/YlfhtTf5QhgW/n8KFVHzXQ0j2z
         AwhaToa3EB9tRl2dKvuLza8qQLtEJXrvJEZ8sN5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-efi@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Pingfan Liu <kernelfans@gmail.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0502/1039] of: fdt: Aggregate the processing of "linux,usable-memory-range"
Date:   Mon, 24 Jan 2022 19:38:11 +0100
Message-Id: <20220124184142.136258100@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 8347b41748c3019157312fbe7f8a6792ae396eb7 ]

Currently, we parse the "linux,usable-memory-range" property in
early_init_dt_scan_chosen(), to obtain the specified memory range of the
crash kernel. We then reserve the required memory after
early_init_dt_scan_memory() has identified all available physical memory.
Because the two pieces of code are separated far, the readability and
maintainability are reduced. So bring them together.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
(change the prototype of early_init_dt_check_for_usable_mem_range(), in
order to use it outside)
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Tested-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: John Donnelly <john.p.donnelly@oracle.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
To: devicetree@vger.kernel.org
To: linux-efi@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index bdca35284cebd..5a238a933eb29 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -965,18 +965,22 @@ static void __init early_init_dt_check_for_elfcorehdr(unsigned long node)
 		 elfcorehdr_addr, elfcorehdr_size);
 }
 
-static phys_addr_t cap_mem_addr;
-static phys_addr_t cap_mem_size;
+static unsigned long chosen_node_offset = -FDT_ERR_NOTFOUND;
 
 /**
  * early_init_dt_check_for_usable_mem_range - Decode usable memory range
  * location from flat tree
- * @node: reference to node containing usable memory range location ('chosen')
  */
-static void __init early_init_dt_check_for_usable_mem_range(unsigned long node)
+static void __init early_init_dt_check_for_usable_mem_range(void)
 {
 	const __be32 *prop;
 	int len;
+	phys_addr_t cap_mem_addr;
+	phys_addr_t cap_mem_size;
+	unsigned long node = chosen_node_offset;
+
+	if ((long)node < 0)
+		return;
 
 	pr_debug("Looking for usable-memory-range property... ");
 
@@ -989,6 +993,8 @@ static void __init early_init_dt_check_for_usable_mem_range(unsigned long node)
 
 	pr_debug("cap_mem_start=%pa cap_mem_size=%pa\n", &cap_mem_addr,
 		 &cap_mem_size);
+
+	memblock_cap_memory_range(cap_mem_addr, cap_mem_size);
 }
 
 #ifdef CONFIG_SERIAL_EARLYCON
@@ -1137,9 +1143,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
 		return 0;
 
+	chosen_node_offset = node;
+
 	early_init_dt_check_for_initrd(node);
 	early_init_dt_check_for_elfcorehdr(node);
-	early_init_dt_check_for_usable_mem_range(node);
 
 	/* Retrieve command line */
 	p = of_get_flat_dt_prop(node, "bootargs", &l);
@@ -1275,7 +1282,7 @@ void __init early_init_dt_scan_nodes(void)
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
 	/* Handle linux,usable-memory-range property */
-	memblock_cap_memory_range(cap_mem_addr, cap_mem_size);
+	early_init_dt_check_for_usable_mem_range();
 }
 
 bool __init early_init_dt_scan(void *params)
-- 
2.34.1



