Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8717E140022
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390497AbgAPXT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390504AbgAPXTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A72724656;
        Thu, 16 Jan 2020 23:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216792;
        bh=FWgsFAk0FgHnFZbSwAzTfvJQPRQfRfPVfVPTBfidlZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHyd6fy8jnt8LWFfAr9R19+UfoMZx8COoGCV50QkCq7pgTjFFCZ69vSShaROJUpUI
         HbltHbAXRkJehpGwpJIUt0swD5GRbEwy+Nr8buAkHrHcY5scGGJu3JtQlXpABNBf0j
         hX+hSXz73qX5Un25gVxBnqpNCuVGYXmTdCidf+wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 021/203] iommu/vt-d: Unlink device if failed to add to group
Date:   Fri, 17 Jan 2020 00:15:38 +0100
Message-Id: <20200116231746.439579095@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit f78947c409204138a4bc0609f98e07ef9d01ac0a upstream.

If the device fails to be added to the group, make sure to unlink the
reference before returning.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Fixes: 39ab9555c2411 ("iommu: Add sysfs bindings for struct iommu_device")
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5593,8 +5593,10 @@ static int intel_iommu_add_device(struct
 
 	group = iommu_group_get_for_dev(dev);
 
-	if (IS_ERR(group))
-		return PTR_ERR(group);
+	if (IS_ERR(group)) {
+		ret = PTR_ERR(group);
+		goto unlink;
+	}
 
 	iommu_group_put(group);
 
@@ -5620,7 +5622,8 @@ static int intel_iommu_add_device(struct
 				if (!get_private_domain_for_dev(dev)) {
 					dev_warn(dev,
 						 "Failed to get a private domain.\n");
-					return -ENOMEM;
+					ret = -ENOMEM;
+					goto unlink;
 				}
 
 				dev_info(dev,
@@ -5635,6 +5638,10 @@ static int intel_iommu_add_device(struct
 	}
 
 	return 0;
+
+unlink:
+	iommu_device_unlink(&iommu->iommu, dev);
+	return ret;
 }
 
 static void intel_iommu_remove_device(struct device *dev)


