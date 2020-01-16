Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF3513FEFC
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgAPXjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:32874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391079AbgAPX2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:28:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E5E520684;
        Thu, 16 Jan 2020 23:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217298;
        bh=zYyQCYQDckUrS/kpMNPDCdFrFdG67epaAPuttfXLJ8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVYn9eh/mZiBb23EWX9JsJPrwIkRcbmVAndLnNEqxNqVj6mIRqsjApDk+OJcl/o6A
         BK4M0LNC+C1ylEsFbEMKFhGdR4ccGnHB5Z8912+8BvAHqXigSbP+wEdMy0LyrbuRCx
         dfXsHysC+c5AkqvoFeW5HBL5UTnQ9EwJW7vtv+QM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 25/84] iommu: Remove device link to group on failure
Date:   Fri, 17 Jan 2020 00:17:59 +0100
Message-Id: <20200116231716.623652200@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit 7d4e6ccd1fb09dbfbc49746ca82bd5c25ad4bfe4 upstream.

This adds the missing teardown step that removes the device link from
the group when the device addition fails.

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Fixes: 797a8b4d768c5 ("iommu: Handle default domain attach failure")
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/iommu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -650,6 +650,7 @@ err_put_group:
 	mutex_unlock(&group->mutex);
 	dev->iommu_group = NULL;
 	kobject_put(group->devices_kobj);
+	sysfs_remove_link(group->devices_kobj, device->name);
 err_free_name:
 	kfree(device->name);
 err_remove_link:


