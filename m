Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3413395C51
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhEaNbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232437AbhEaN3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE7D61418;
        Mon, 31 May 2021 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467350;
        bh=qyAv7zT9mxZEqmsAwmGr+tMC2ngeuTBaZEVrO08jyBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMtym/Dvm+d7i6lt2HCRwgAcmcPpq24SouRuurSEmPHvbdEkrYlcCZv7rF993e65j
         jyrKuCDRb+gFA3IoPf1rPh7UKX23Q3qrMJs8SmgyuqV5f6CoA3FlHrUgdew9yNu8Yk
         c0JOSHHpn8BbxnJI6DgqHRKYQZ/0CejWP3vt+aJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rolf Eike Beer <eb@emlix.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 006/116] iommu/vt-d: Fix sysfs leak in alloc_iommu()
Date:   Mon, 31 May 2021 15:13:02 +0200
Message-Id: <20210531130640.360198515@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
 drivers/iommu/dmar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1119,7 +1119,7 @@ static int alloc_iommu(struct dmar_drhd_
 
 		err = iommu_device_register(&iommu->iommu);
 		if (err)
-			goto err_unmap;
+			goto err_sysfs;
 	}
 
 	drhd->iommu = iommu;
@@ -1127,6 +1127,8 @@ static int alloc_iommu(struct dmar_drhd_
 
 	return 0;
 
+err_sysfs:
+	iommu_device_sysfs_remove(&iommu->iommu);
 err_unmap:
 	unmap_iommu(iommu);
 error_free_seq_id:


