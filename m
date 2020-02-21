Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6AA1673F6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgBUIRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387632AbgBUIRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:17:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30D124670;
        Fri, 21 Feb 2020 08:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273035;
        bh=FTOGElWgnVJw8gJktUCYPCksvhO+Fz5drW+cZvE/jw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbamVl0PR69AH7j273RKpn38Clcu2KXJDRw6T+/PwBuNKHg8KPPyUlBlptkhGP9ay
         qKrLhy5ZxW5Idx2XJieLm68gfsut+VZM0XHMxFmYiYqaXuXvoQ0B8mXvfRw0WjxLWa
         uDfuh5hsKKfr9oetNLXr0IwyUN8WBol7raZ0As0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/191] iommu/vt-d: Fix off-by-one in PASID allocation
Date:   Fri, 21 Feb 2020 08:39:57 +0100
Message-Id: <20200221072254.091418459@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
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
index fd8730b2cd46e..5944d3b4dca37 100644
--- a/drivers/iommu/intel-svm.c
+++ b/drivers/iommu/intel-svm.c
@@ -377,7 +377,7 @@ int intel_svm_bind_mm(struct device *dev, int *pasid, int flags, struct svm_dev_
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



