Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173AA330DEE
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhCHMeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:34:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhCHMeG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7631B651DC;
        Mon,  8 Mar 2021 12:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206846;
        bh=8/sAaKwax+Ge2FF1sEl2qj5pzin6DpC3zaVom/++uhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hks8KXwzBiytI2jQLi6h6ciSkAQDqS4zsTrQ1CTjqNWxR/I8N78FRfrCrPtWKk0Ly
         FIOJ7yNZTUdaLNX9nL9CziptKbPuBmWxkp0E4r4vZBZG936oLiHR3iUQBalUvMuXcv
         MoeZEWJpRZ61/pcPO5qYKN0+QBM6Zit2IxlpsK4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Rob Herring <robh@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Subject: [PATCH 5.10 26/42] of/address: Introduce of_dma_get_max_cpu_address()
Date:   Mon,  8 Mar 2021 13:30:52 +0100
Message-Id: <20210308122719.416632219@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 964db79d6c186cc2ecc6ae46f98eed7e0ea8cf71 upstream

Introduce of_dma_get_max_cpu_address(), which provides the highest CPU
physical address addressable by all DMA masters in the system. It's
specially useful for setting memory zones sizes at early boot time.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20201119175400.9995-4-nsaenzjulienne@suse.de
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h   |    7 +++++++
 2 files changed, 49 insertions(+)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -1025,6 +1025,48 @@ out:
 #endif /* CONFIG_HAS_DMA */
 
 /**
+ * of_dma_get_max_cpu_address - Gets highest CPU address suitable for DMA
+ * @np: The node to start searching from or NULL to start from the root
+ *
+ * Gets the highest CPU physical address that is addressable by all DMA masters
+ * in the sub-tree pointed by np, or the whole tree if NULL is passed. If no
+ * DMA constrained device is found, it returns PHYS_ADDR_MAX.
+ */
+phys_addr_t __init of_dma_get_max_cpu_address(struct device_node *np)
+{
+	phys_addr_t max_cpu_addr = PHYS_ADDR_MAX;
+	struct of_range_parser parser;
+	phys_addr_t subtree_max_addr;
+	struct device_node *child;
+	struct of_range range;
+	const __be32 *ranges;
+	u64 cpu_end = 0;
+	int len;
+
+	if (!np)
+		np = of_root;
+
+	ranges = of_get_property(np, "dma-ranges", &len);
+	if (ranges && len) {
+		of_dma_range_parser_init(&parser, np);
+		for_each_of_range(&parser, &range)
+			if (range.cpu_addr + range.size > cpu_end)
+				cpu_end = range.cpu_addr + range.size - 1;
+
+		if (max_cpu_addr > cpu_end)
+			max_cpu_addr = cpu_end;
+	}
+
+	for_each_available_child_of_node(np, child) {
+		subtree_max_addr = of_dma_get_max_cpu_address(child);
+		if (max_cpu_addr > subtree_max_addr)
+			max_cpu_addr = subtree_max_addr;
+	}
+
+	return max_cpu_addr;
+}
+
+/**
  * of_dma_is_coherent - Check if device is coherent
  * @np:	device node
  *
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -558,6 +558,8 @@ int of_map_id(struct device_node *np, u3
 	       const char *map_name, const char *map_mask_name,
 	       struct device_node **target, u32 *id_out);
 
+phys_addr_t of_dma_get_max_cpu_address(struct device_node *np);
+
 #else /* CONFIG_OF */
 
 static inline void of_core_init(void)
@@ -995,6 +997,11 @@ static inline int of_map_id(struct devic
 	return -EINVAL;
 }
 
+static inline phys_addr_t of_dma_get_max_cpu_address(struct device_node *np)
+{
+	return PHYS_ADDR_MAX;
+}
+
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */


