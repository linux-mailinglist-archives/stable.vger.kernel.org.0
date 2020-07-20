Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48043226814
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388618AbgGTQQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbgGTQQ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:16:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF6920656;
        Mon, 20 Jul 2020 16:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261816;
        bh=7YEzp2TLeeENKUeWqMUIHBobc/q7bF3zjTbqOeIN1Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3YfcyQdGj2Axff+yZM2Z7Tl1D8mD6NWy9s1et73O5KrrN6r9H1fw3QblIlVAIDcW
         CpKVLswScTa31Znerh+zBqkd4gO27KA4Qz4EBYNJn0q+EePaJGq4lqiFP3/MQBG1XA
         9eY3c1ppTNlvd+j9OzcOIYIyBAKoD8FczN7kdEsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 5.7 238/244] iommu/vt-d: Make Intel SVM code 64-bit only
Date:   Mon, 20 Jul 2020 17:38:29 +0200
Message-Id: <20200720152837.158735106@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 9486727f5981a5ec5c0b699fb1777451bd6786e4 upstream.

Current Intel SVM is designed by setting the pgd_t of the processor page
table to FLPTR field of the PASID entry. The first level translation only
supports 4 and 5 level paging structures, hence it's infeasible for the
IOMMU to share a processor's page table when it's running in 32-bit mode.
Let's disable 32bit support for now and claim support only when all the
missing pieces are ready in the future.

Fixes: 1c4f88b7f1f92 ("iommu/vt-d: Shared virtual address in scalable mode")
Suggested-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200622231345.29722-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -211,7 +211,7 @@ config INTEL_IOMMU_DEBUGFS
 
 config INTEL_IOMMU_SVM
 	bool "Support for Shared Virtual Memory with Intel IOMMU"
-	depends on INTEL_IOMMU && X86
+	depends on INTEL_IOMMU && X86_64
 	select PCI_PASID
 	select PCI_PRI
 	select MMU_NOTIFIER


