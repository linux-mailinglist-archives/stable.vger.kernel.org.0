Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4884114BB28
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgA1Onw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgA1OLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:11:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF51220678;
        Tue, 28 Jan 2020 14:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220664;
        bh=JCX2n3gscyc16de9sD7q/L6xPdnl4sxAI6Nb/SzPk7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhvz2mmCZWKI2sUgVao4PkDj3mL9TAFXdTUJGPHIukDKOI8OPFFNh7sW7l6BjpFWQ
         ek5/6Ze8a/zxFBIZH4DbhPqwn/Z+zM3bGS0aygSc1bbfqBMg8s89/IbnFHcZ8o8via
         6Mo7afdYcjWlv0DjGh0EoOh6Pue3dBtnbiJ6EOVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 097/183] iommu: Use right function to get group for device
Date:   Tue, 28 Jan 2020 15:05:16 +0100
Message-Id: <20200128135839.764329679@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 57274ea25736496ee019a5c40479855b21888839 ]

The iommu_group_get_for_dev() will allocate a group for a
device if it isn't in any group. This isn't the use case
in iommu_request_dm_for_dev(). Let's use iommu_group_get()
instead.

Fixes: d290f1e70d85a ("iommu: Introduce iommu_request_dm_for_dev()")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5d5066cf3bbd7..589207176ffa1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1594,9 +1594,9 @@ int iommu_request_dm_for_dev(struct device *dev)
 	int ret;
 
 	/* Device must already be in a group before calling this function */
-	group = iommu_group_get_for_dev(dev);
-	if (IS_ERR(group))
-		return PTR_ERR(group);
+	group = iommu_group_get(dev);
+	if (!group)
+		return -EINVAL;
 
 	mutex_lock(&group->mutex);
 
-- 
2.20.1



