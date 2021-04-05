Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0F3354022
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbhDEJQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240625AbhDEJPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A46A60FE4;
        Mon,  5 Apr 2021 09:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614143;
        bh=YjaNCdwBRVsObd96FbrMkd1ju3QxDkKzfnL3gAaDQ6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8JBv2bcoBvp/gtcX/X100NucQ+nTRsFkMjEz/wNESvG+umA/+TZ3l73+JAnYPXsj
         8SgWGFhgeBBtI5E5pqleoQbAL8EgIk4yAZPXdWVu7SV+LGokExcLNtInn2UNW+MiIR
         LIzjkwGoQVZBtndykaCn9nbqfK1HsaS+fHKoh8I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5.11 098/152] vfio/nvlink: Add missing SPAPR_TCE_IOMMU depends
Date:   Mon,  5 Apr 2021 10:54:07 +0200
Message-Id: <20210405085037.426135578@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

commit e0146a108ce4d2c22b9510fd12268e3ee72a0161 upstream.

Compiling the nvlink stuff relies on the SPAPR_TCE_IOMMU otherwise there
are compile errors:

 drivers/vfio/pci/vfio_pci_nvlink2.c:101:10: error: implicit declaration of function 'mm_iommu_put' [-Werror,-Wimplicit-function-declaration]
                            ret = mm_iommu_put(data->mm, data->mem);

As PPC only defines these functions when the config is set.

Previously this wasn't a problem by chance as SPAPR_TCE_IOMMU was the only
IOMMU that could have satisfied IOMMU_API on POWERNV.

Fixes: 179209fa1270 ("vfio: IOMMU_API should be selected")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Message-Id: <0-v1-83dba9768fc3+419-vfio_nvlink2_kconfig_jgg@nvidia.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -42,7 +42,7 @@ config VFIO_PCI_IGD
 
 config VFIO_PCI_NVLINK2
 	def_bool y
-	depends on VFIO_PCI && PPC_POWERNV
+	depends on VFIO_PCI && PPC_POWERNV && SPAPR_TCE_IOMMU
 	help
 	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
 


