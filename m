Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124A4272ECC
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgIUQwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729031AbgIUQtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:49:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 203A920874;
        Mon, 21 Sep 2020 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706974;
        bh=fI2aKDivCX+waYHUpVfEfNfFRJSy3ULPsS5Vk61gPrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvgsazQZNeG20VsKCUvjKk1sSOeDQsbVn17rpPtcZeVNXgJ26BOa/qhEmdx5pzefS
         35i/3CGFpEAbMcVw2H3DgBw3ish/+DjEjjfHLCXEOhYUR3Qpx+6Mw93Z4EajDt6Mbh
         FoV9TbGfa/wdMDAuc1GfKJPM1WgCwmF29TIQ1kvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/72] iommu/amd: Fix potential @entry null deref
Date:   Mon, 21 Sep 2020 18:31:27 +0200
Message-Id: <20200921163124.164393341@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
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
 drivers/iommu/amd_iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index cdafc652d9d1a..fa91d856a43ee 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4431,12 +4431,14 @@ int amd_iommu_deactivate_guest_mode(void *data)
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



