Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D844239613D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhEaOhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhEaOfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3352F6162C;
        Mon, 31 May 2021 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469070;
        bh=qKGOX0Ss4HKPu86al1XwM/prUFx9xEBhjkjHeSxaE4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zF9S1F0VU53pk58oO53igPdNQE8p04GEE2K4roMGM8SyXD4QGgKKebJifeLrfdWCP
         72KKpEW3srOstIBpiZeBH/t8npKyMWxY4aFrYwmG/eZZbdOfy2nz6eQPmMmgyOw0Z/
         +W49sWZ8Yhmkbc1LDbE+z/MpPVMmHtG55qOiJhLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.12 023/296] iommu/vt-d: Fix sysfs leak in alloc_iommu()
Date:   Mon, 31 May 2021 15:11:18 +0200
Message-Id: <20210531130704.546190537@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rolf Eike Beer <eb@emlix.com>

commit 0ee74d5a48635c848c20f152d0d488bf84641304 upstream.

iommu_device_sysfs_add() is called before, so is has to be cleaned on subsequent
errors.

Fixes: 39ab9555c2411 ("iommu: Add sysfs bindings for struct iommu_device")
Cc: stable@vger.kernel.org # 4.11.x
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/17411490.HIIP88n32C@mobilepool36.emlix.com
Link: https://lore.kernel.org/r/20210525070802.361755-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/dmar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1144,7 +1144,7 @@ static int alloc_iommu(struct dmar_drhd_
 
 		err = iommu_device_register(&iommu->iommu);
 		if (err)
-			goto err_unmap;
+			goto err_sysfs;
 	}
 
 	drhd->iommu = iommu;
@@ -1152,6 +1152,8 @@ static int alloc_iommu(struct dmar_drhd_
 
 	return 0;
 
+err_sysfs:
+	iommu_device_sysfs_remove(&iommu->iommu);
 err_unmap:
 	unmap_iommu(iommu);
 error_free_seq_id:


