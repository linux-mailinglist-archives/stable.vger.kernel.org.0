Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B822113FCEC
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390111AbgAPXT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389574AbgAPXTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F88B2072B;
        Thu, 16 Jan 2020 23:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216795;
        bh=LMrkLo67UGhsSpzLx9bu9L4AyetnlhZPDlYJWnq0GM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkBwcGYkJtCRHdkCDfDzxcm7PVDlM8bJLUAA/IfsrlReYI8S8RiQfFjztUYi5WPsH
         oFhalF2t4TCO1wQAJctNk6T+YV6a/EKyzl2VGRUWSnxUcxbbsTu5vcD+KkK7fM0xce
         DtTbA2iAKKuPUx0RX9fXpfp9m0dYWuGfJspz3E2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 022/203] iommu: Remove device link to group on failure
Date:   Fri, 17 Jan 2020 00:15:39 +0100
Message-Id: <20200116231746.498220120@linuxfoundation.org>
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
@@ -751,6 +751,7 @@ err_put_group:
 	mutex_unlock(&group->mutex);
 	dev->iommu_group = NULL;
 	kobject_put(group->devices_kobj);
+	sysfs_remove_link(group->devices_kobj, device->name);
 err_free_name:
 	kfree(device->name);
 err_remove_link:


