Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A9A29BE62
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812883AbgJ0Qqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801558AbgJ0Pmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0D3C20719;
        Tue, 27 Oct 2020 15:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813366;
        bh=od7TbWHrlVXOm+3teQdzVsxHZH0KhcmHRpvCcKrJwms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrEAeQFxUcZY2zE0vBM3AnH+BsUOlW3w68gmj9I5ZPoNciDga5fVQ23unsbG7hWlw
         NSWMHsnPz9dn1Y/7B5TzbWYJdgkgEx5ZLVzKUBccEeHGNPNeKDbkGXWun77SGsQlH2
         qADODeelmQb5LP36AjlPjIAhyghh0zzfcTsLxCCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 527/757] vfio: add a singleton check for vfio_group_pin_pages
Date:   Tue, 27 Oct 2020 14:52:57 +0100
Message-Id: <20201027135515.204133332@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 262ab0efd06c6..532bcaf28c11d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2051,6 +2051,9 @@ int vfio_group_pin_pages(struct vfio_group *group,
 	if (!group || !user_iova_pfn || !phys_pfn || !npage)
 		return -EINVAL;
 
+	if (group->dev_counter > 1)
+		return -EINVAL;
+
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-- 
2.25.1



