Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51300F7B8A
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfKKShN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbfKKShI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A3C321925;
        Mon, 11 Nov 2019 18:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497427;
        bh=71lSMN3s+ULUntBXqkytyqM8Ok4PqSN8px6hPOw24DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM5fV89mreQq2xc9AU4Lz36DfNmJlv4JxfvOYkRKXQZRO/dYylR+svrDt2DTkUMNV
         E6odhEoY6sdSKjjyeVTa85mJ7pqW97fPXVtxlvjRmm+bmDGMCmPzlCH75e1YF4THbY
         DaLAI4MNInafVtxZ6qWR9/KbrFWhCI5XweiRsWfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 051/105] misc: pci_endpoint_test: Prevent some integer overflows
Date:   Mon, 11 Nov 2019 19:28:21 +0100
Message-Id: <20191111181442.731528689@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 378f79cab12b669928f3a4037f023837ead2ce0c upstream

"size + max" can have an arithmetic overflow when we're allocating:

	orig_src_addr = dma_alloc_coherent(dev, size + alignment, ...

I've added a few checks to prevent that.

Fixes: 13107c60681f ("misc: pci_endpoint_test: Add support to provide aligned buffer addresses")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -226,6 +226,9 @@ static bool pci_endpoint_test_copy(struc
 	u32 src_crc32;
 	u32 dst_crc32;
 
+	if (size > SIZE_MAX - alignment)
+		goto err;
+
 	orig_src_addr = dma_alloc_coherent(dev, size + alignment,
 					   &orig_src_phys_addr, GFP_KERNEL);
 	if (!orig_src_addr) {
@@ -311,6 +314,9 @@ static bool pci_endpoint_test_write(stru
 	size_t alignment = test->alignment;
 	u32 crc32;
 
+	if (size > SIZE_MAX - alignment)
+		goto err;
+
 	orig_addr = dma_alloc_coherent(dev, size + alignment, &orig_phys_addr,
 				       GFP_KERNEL);
 	if (!orig_addr) {
@@ -369,6 +375,9 @@ static bool pci_endpoint_test_read(struc
 	size_t alignment = test->alignment;
 	u32 crc32;
 
+	if (size > SIZE_MAX - alignment)
+		goto err;
+
 	orig_addr = dma_alloc_coherent(dev, size + alignment, &orig_phys_addr,
 				       GFP_KERNEL);
 	if (!orig_addr) {


