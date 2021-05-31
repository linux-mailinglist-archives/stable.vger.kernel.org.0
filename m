Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0707D39629B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhEaO6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234209AbhEaO4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C4F61CBF;
        Mon, 31 May 2021 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469610;
        bh=HwDx/tnX6hrkMgeAvjZu9FGgdS+sIWoW5N0fDqQF49A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1bRrC8fX65i/iwLUWfcHFNWPW5hlDXynHTHg/RdsMO0OdLOf7fTGDwch0UFPJ+PR
         NQYfyCDj3MYMuDOt0gwaEiA+Jd+GGuyrtu3SsztmHxWILWVSPeEXyKYNqig+tCzWIH
         4kN9H0u3xL2Do4aXXSIXd2bQxocHQebWk4R7VQLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 264/296] iommu/vt-d: Check for allocation failure in aux_detach_device()
Date:   Mon, 31 May 2021 15:15:19 +0200
Message-Id: <20210531130712.622927316@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1a590a1c8bf46bf80ea12b657ca44c345531ac80 ]

In current kernels small allocations never fail, but checking for
allocation failure is the correct thing to do.

Fixes: 18abda7a2d55 ("iommu/vt-d: Fix general protection fault in aux_detach_device()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/YJuobKuSn81dOPLd@mwanda
Link: https://lore.kernel.org/r/20210519015027.108468-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7e551da6c1fb..2569585ffcd4 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4626,6 +4626,8 @@ static int auxiliary_link_device(struct dmar_domain *domain,
 
 	if (!sinfo) {
 		sinfo = kzalloc(sizeof(*sinfo), GFP_ATOMIC);
+		if (!sinfo)
+			return -ENOMEM;
 		sinfo->domain = domain;
 		sinfo->pdev = dev;
 		list_add(&sinfo->link_phys, &info->subdevices);
-- 
2.30.2



