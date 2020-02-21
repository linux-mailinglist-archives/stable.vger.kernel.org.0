Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56017167077
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBUHpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:45:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbgBUHpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:45:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45CDD24672;
        Fri, 21 Feb 2020 07:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271121;
        bh=h5EqkVv0DO84hWwSL2dDOcUgBtNX3MwH2uaDNvbe5qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvHLSN4sNJYIgu4fxGJzy6t1b6Mbiuwf4XlwIRr16huX0SVtgiwx99fv96tpAZpnN
         SUIeAabIK8+6vuuF+En/iIdqAvm+mRutLEs0cSy0yzf4+suMBiZFjg3qf6GBhYz1aG
         VjG9PivT6Be1si2Kj/W35qD9/7zykNwRMA1O1nho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 048/399] iommu/vt-d: Fix off-by-one in PASID allocation
Date:   Fri, 21 Feb 2020 08:36:13 +0100
Message-Id: <20200221072407.029447182@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit 39d630e332144028f56abba83d94291978e72df1 ]

PASID allocator uses IDR which is exclusive for the end of the
allocation range. There is no need to decrement pasid_max.

Fixes: af39507305fb ("iommu/vt-d: Apply global PASID in SVA")
Reported-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
index dca88f9fdf29a..ff7a3f9add325 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -317,7 +317,7 @@ int intel_svm_bind_mm(struct device *dev, int *pasid, int flags, struct svm_dev_
 		/* Do not use PASID 0 in caching mode (virtualised IOMMU) */
 		ret = intel_pasid_alloc_id(svm,
 					   !!cap_caching_mode(iommu->cap),
-					   pasid_max - 1, GFP_KERNEL);
+					   pasid_max, GFP_KERNEL);
 		if (ret < 0) {
 			kfree(svm);
 			kfree(sdev);
-- 
2.20.1



