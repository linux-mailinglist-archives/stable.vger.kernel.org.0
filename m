Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449EB499B9E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575202AbiAXVvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458150AbiAXVmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4C7C07A959;
        Mon, 24 Jan 2022 12:31:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCBE761536;
        Mon, 24 Jan 2022 20:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8A5C340E5;
        Mon, 24 Jan 2022 20:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056271;
        bh=31xC9mtUNmT5ViszQgZGChLa+pmB3GlMeXbvgzxJHR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZEC+ROZ5fwELLGQggQwH3O7XtHiu4BKen5E3aew2BR2HA4n/Dw6lLtTpiUEXwCWcW
         Gjaja2Yx3flS2bBHQFjpUDI6gdvp27rEwJs2W0O7GTkYiwqvZjxEdRY06UgUjavtwv
         YBbIyX0hmx7rBuv3Z30GBhW2zVkZ4aV8t3YxElwY=
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
Subject: [PATCH 5.15 427/846] of: fdt: Aggregate the processing of "linux,usable-memory-range"
Date:   Mon, 24 Jan 2022 19:39:04 +0100
Message-Id: <20220124184115.705813438@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 4546572af24bb..105b1a47905ab 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -969,18 +969,22 @@ static void __init early_init_dt_check_for_elfcorehdr(unsigned long node)
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
 
@@ -993,6 +997,8 @@ static void __init early_init_dt_check_for_usable_mem_range(unsigned long node)
 
 	pr_debug("cap_mem_start=%pa cap_mem_size=%pa\n", &cap_mem_addr,
 		 &cap_mem_size);
+
+	memblock_cap_memory_range(cap_mem_addr, cap_mem_size);
 }
 
 #ifdef CONFIG_SERIAL_EARLYCON
@@ -1141,9 +1147,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
 		return 0;
 
+	chosen_node_offset = node;
+
 	early_init_dt_check_for_initrd(node);
 	early_init_dt_check_for_elfcorehdr(node);
-	early_init_dt_check_for_usable_mem_range(node);
 
 	/* Retrieve command line */
 	p = of_get_flat_dt_prop(node, "bootargs", &l);
@@ -1279,7 +1286,7 @@ void __init early_init_dt_scan_nodes(void)
 	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 
 	/* Handle linux,usable-memory-range property */
-	memblock_cap_memory_range(cap_mem_addr, cap_mem_size);
+	early_init_dt_check_for_usable_mem_range();
 }
 
 bool __init early_init_dt_scan(void *params)
-- 
2.34.1



