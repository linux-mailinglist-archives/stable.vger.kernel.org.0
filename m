Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF7514809B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387983AbgAXLMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387873AbgAXLMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:12:41 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B267720708;
        Fri, 24 Jan 2020 11:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864360;
        bh=1107wFI5AHf/usbvPCIjUBbMTwp3G6mZlbYIHoG3RpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVCF99YxjGAOEuvRn5Epp7iiAH01acZSykQ7IPmeyQURDSjJbvz4WQ90T/locQkNo
         g1sSmiSzP95PkIGKbe/1emSKoDplPoni3VtugcLJFK5aGPDr6JlNJWIJoNU3uW0Mkw
         8uyZheIYsv4gvCAHNRE3jc2OXRnIOdLaOW7V58nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 245/639] iommu/vt-d: Fix NULL pointer reference in intel_svm_bind_mm()
Date:   Fri, 24 Jan 2020 10:26:55 +0100
Message-Id: <20200124093117.470691497@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c56cba5daf45d2d091ef1cfe2f1d6a930446687b ]

Intel IOMMU could be turned off with intel_iommu=off. If Intel
IOMMU is off,  the intel_iommu struct will not be initialized.
When device drivers call intel_svm_bind_mm(), the NULL pointer
reference will happen there.

Add dmar_disabled check to avoid NULL pointer reference.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Fixes: 2f26e0a9c9860 ("iommu/vt-d: Add basic SVM PASID support")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
index 188f4eaed6e59..fd8730b2cd46e 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -293,7 +293,7 @@ int intel_svm_bind_mm(struct device *dev, int *pasid, int flags, struct svm_dev_
 	int pasid_max;
 	int ret;
 
-	if (!iommu)
+	if (!iommu || dmar_disabled)
 		return -EINVAL;
 
 	if (dev_is_pci(dev)) {
-- 
2.20.1



