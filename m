Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DCC272F3D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgIUQzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729335AbgIUQpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 078E7206B2;
        Mon, 21 Sep 2020 16:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706733;
        bh=YsJqGuQHBEUaF1qm14Gss1YdcyjLDX2tF6KDxKMGKjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKlDa5QM8DU7f2sm6jMrEXuqopt5WVjW2DsylR0RF+pDRlwv6KY07PkSJuF7fp6Ss
         642xrgDOBvFK1nXYyLpXkco8N2AyLyHI80acKF8jrND/LLoeBuXq5QenKVTLQzewud
         /+KvplWxd5zbf71na0hXeZbVW3XioT3LWjzPv2/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 073/118] iommu/amd: Fix potential @entry null deref
Date:   Mon, 21 Sep 2020 18:28:05 +0200
Message-Id: <20200921162039.724027857@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit 14c4acc5ed22c21f9821103be7c48efdf9763584 ]

After commit 26e495f34107 ("iommu/amd: Restore IRTE.RemapEn bit after
programming IRTE"), smatch warns:

	drivers/iommu/amd/iommu.c:3870 amd_iommu_deactivate_guest_mode()
        warn: variable dereferenced before check 'entry' (see line 3867)

Fix this by moving the @valid assignment to after @entry has been checked
for NULL.

Fixes: 26e495f34107 ("iommu/amd: Restore IRTE.RemapEn bit after programming IRTE")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20200910171621.12879-1-joao.m.martins@oracle.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 37c74c842f3a3..48fe272da6e9c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3855,12 +3855,14 @@ int amd_iommu_deactivate_guest_mode(void *data)
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 	struct irq_cfg *cfg = ir_data->cfg;
-	u64 valid = entry->lo.fields_remap.valid;
+	u64 valid;
 
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
 	    !entry || !entry->lo.fields_vapic.guest_mode)
 		return 0;
 
+	valid = entry->lo.fields_remap.valid;
+
 	entry->lo.val = 0;
 	entry->hi.val = 0;
 
-- 
2.25.1



