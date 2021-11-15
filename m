Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21D84521A4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245469AbhKPBFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245461AbhKOTUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 496D96354A;
        Mon, 15 Nov 2021 18:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001309;
        bh=hYQE+7hJEdA+L5jYAWSJucXNU7vGHmO4eYdauqdSTVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcuTHqoKg+ne8tCvbhcV0EczYsAp2iepm8NhQRbsQlhLwM8l9Gi908QLIy6chOxBE
         NbfBWbHGvYkmCGNNvoYrM/RkL/a25JWdGbrIo74jrMKqEnsprT8AroHhs0fq+GoB29
         a3gAwIS0PCLEF40HLBBAR2L7ccjgPSbXPYyGg54A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.15 142/917] cxl/pci: Fix NULL vs ERR_PTR confusion
Date:   Mon, 15 Nov 2021 17:53:57 +0100
Message-Id: <20211115165433.576582526@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
@@ -972,7 +972,7 @@ static void __iomem *cxl_mem_map_regbloc
 	if (pci_resource_len(pdev, bar) < offset) {
 		dev_err(dev, "BAR%d: %pr: too small (offset: %#llx)\n", bar,
 			&pdev->resource[bar], (unsigned long long)offset);
-		return IOMEM_ERR_PTR(-ENXIO);
+		return NULL;
 	}
 
 	addr = pci_iomap(pdev, bar, 0);


