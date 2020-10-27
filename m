Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB5129BF84
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815483AbgJ0RCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793714AbgJ0PH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:07:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EEB92072E;
        Tue, 27 Oct 2020 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811278;
        bh=580iR/LT0UQ8d0Sl0XgJEyh4AV79dWMBlN48KRQ84PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erQLdUfuUJKuXiYmWDl6sEPtbRPIIOcGPGducDAfKZrio9BMwfsUutRrhZUmcM7bu
         GpW8+rcjEtGFDYcXhPBDxemI9mFIlXuTdPpc/IzKRrOTfy0SEM9YwgnXD4lutfWPHK
         7ul/ygOXgb2B61Wrkp7PKZwfWRNafA5q/KJt9qOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 436/633] vfio: add a singleton check for vfio_group_pin_pages
Date:   Tue, 27 Oct 2020 14:52:59 +0100
Message-Id: <20201027135543.174799020@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

[ Upstream commit 7ef32e52368f62a4e041a4f0abefb4fb64e7fd4a ]

Page pinning is used both to translate and pin device mappings for DMA
purpose, as well as to indicate to the IOMMU backend to limit the dirty
page scope to those pages that have been pinned, in the case of an IOMMU
backed device.
To support this, the vfio_pin_pages() interface limits itself to only
singleton groups such that the IOMMU backend can consider dirty page
scope only at the group level.  Implement the same requirement for the
vfio_group_pin_pages() interface.

Fixes: 95fc87b44104 ("vfio: Selective dirty page tracking if IOMMU backed device pins pages")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 580099afeaffa..2a70e25cfe954 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2050,6 +2050,9 @@ int vfio_group_pin_pages(struct vfio_group *group,
 	if (!group || !user_iova_pfn || !phys_pfn || !npage)
 		return -EINVAL;
 
+	if (group->dev_counter > 1)
+		return -EINVAL;
+
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-- 
2.25.1



