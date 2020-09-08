Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C326168F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731498AbgIHROG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731757AbgIHQTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E00962483A;
        Tue,  8 Sep 2020 15:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579880;
        bh=dkd1VTGWkDPbUY99d0zFvWomNILn15OcG/cU8vcH9A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+b8QiT4cv+om4Fs3DmwwluvaigrnhZA0ta5mMwvROFzk2YcHhGm7jh1+4x5ojp2K
         WT+LxSqDBCtXiYHcgfA7fRWd4yEk0XFo5hV+R1OVkbR08mrql3ttD8qwYlhl2O+OMI
         lICHeB14Ek3AUhPIJNj+M/9M+x4mGHTu6DF2RMaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/129] iommu/amd: Restore IRTE.RemapEn bit after programming IRTE
Date:   Tue,  8 Sep 2020 17:25:11 +0200
Message-Id: <20200908152233.197523349@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 26e495f341075c09023ba16dee9a7f37a021e745 ]

Currently, the RemapEn (valid) bit is accidentally cleared when
programming IRTE w/ guestMode=0. It should be restored to
the prior state.

Fixes: b9fc6b56f478 ("iommu/amd: Implements irq_set_vcpu_affinity() hook to setup vapic mode for pass-through devices")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20200903093822.52012-2-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 3a7094f4813f2..cdafc652d9d1a 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4431,6 +4431,7 @@ int amd_iommu_deactivate_guest_mode(void *data)
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 	struct irq_cfg *cfg = ir_data->cfg;
+	u64 valid = entry->lo.fields_remap.valid;
 
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
 	    !entry || !entry->lo.fields_vapic.guest_mode)
@@ -4439,6 +4440,7 @@ int amd_iommu_deactivate_guest_mode(void *data)
 	entry->lo.val = 0;
 	entry->hi.val = 0;
 
+	entry->lo.fields_remap.valid       = valid;
 	entry->lo.fields_remap.dm          = apic->irq_dest_mode;
 	entry->lo.fields_remap.int_type    = apic->irq_delivery_mode;
 	entry->hi.fields.vector            = cfg->vector;
-- 
2.25.1



