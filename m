Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3F9450F7A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241977AbhKOSbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238217AbhKOS3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:29:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E60763441;
        Mon, 15 Nov 2021 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999088;
        bh=7GGlgZmfuERbfLOM+Y6DXWUQu5BjqhvQSDKzEvdZFe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joVKHbkAIF9FeFzo/+DYINvM/7PurHyNFHO/9W16t5yPyJLwy3aIkZjNjdW+TFoEc
         9D6Me5WxpzCVX3b3jlaZqqr9xAC7MlJ9qoMaweV/i1JrIuDU7tCdJLw7p8tSmc5hic
         7a2fynw+nNovVFGDTnF0xBzPdmBGAsDQFORuK+bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.14 170/849] cxl/pci: Fix NULL vs ERR_PTR confusion
Date:   Mon, 15 Nov 2021 17:54:13 +0100
Message-Id: <20211115165425.928360970@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit ca76a3a8052b71c0334d5c094859cfa340c290a8 upstream.

cxl_pci_map_regblock() may return an ERR_PTR(), but cxl_pci_setup_regs()
is only prepared for NULL as the error case. Pick the minimal fix for
-stable backport purposes and just have cxl_pci_map_regblock() return
NULL for errors.

Fixes: f8a7e8c29be8 ("cxl/pci: Reserve all device regions at once")
Cc: <stable@vger.kernel.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/163433325724.834522.17809774578178224149.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -970,7 +970,7 @@ static void __iomem *cxl_mem_map_regbloc
 	if (pci_resource_len(pdev, bar) < offset) {
 		dev_err(dev, "BAR%d: %pr: too small (offset: %#llx)\n", bar,
 			&pdev->resource[bar], (unsigned long long)offset);
-		return IOMEM_ERR_PTR(-ENXIO);
+		return NULL;
 	}
 
 	addr = pci_iomap(pdev, bar, 0);


