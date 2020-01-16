Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6130213FE7C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391540AbgAPXfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:35:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404184AbgAPXcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EEEA2087E;
        Thu, 16 Jan 2020 23:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217521;
        bh=W54AnkGIJIgsZh2Pxr/0CVORRm1R1GgPocZUQvvRSVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFKM1+w08w0aUVFgwjJq1bhdfaL6MhgFfsiVUarEri72yUyKepZir31So/pnuwvLX
         4Dx/K1xpzfVnfp898eRHzKn5Pt8uOy3SLL8UiHqz2rOGdAKimKGcTNo8WeukBR4a9c
         C3sQJb6mOnkZ/1doscynHOKXVCcZ3ZMHkTrC63AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.14 25/71] iommu: Remove device link to group on failure
Date:   Fri, 17 Jan 2020 00:18:23 +0100
Message-Id: <20200116231713.077962349@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
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
@@ -613,6 +613,7 @@ err_put_group:
 	mutex_unlock(&group->mutex);
 	dev->iommu_group = NULL;
 	kobject_put(group->devices_kobj);
+	sysfs_remove_link(group->devices_kobj, device->name);
 err_free_name:
 	kfree(device->name);
 err_remove_link:


