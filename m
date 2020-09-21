Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE70C272F2C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgIUQpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729515AbgIUQph (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687B323788;
        Mon, 21 Sep 2020 16:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706735;
        bh=9zGEvBYjjk3/TckniU3gjntHp7zocFs48AHjGEiHBsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mY7rvqqgPyGm6StdN/UD9R1IHq9InA9rhHA+sMqbHE5ZAqQCyuLzULcexYyOEmeUD
         y5Sz8GtOePzTwFvaGUFug3Xk0NaqtliFtqvviVJePKjCfECaZceYQGH5U5ATCHHq5x
         ZAtPQ8tYjyUw7LHd9FOwmzYhwjGQE9LbH4u6+mNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 074/118] iommu/amd: Restore IRTE.RemapEn bit for amd_iommu_activate_guest_mode
Date:   Mon, 21 Sep 2020 18:28:06 +0200
Message-Id: <20200921162039.772722555@linuxfoundation.org>
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

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit e97685abd5d711c885053d4949178f7ab9acbaef ]

Commit e52d58d54a32 ("iommu/amd: Use cmpxchg_double() when updating
128-bit IRTE") removed an assumption that modify_irte_ga always set
the valid bit, which requires the callers to set the appropriate value
for the struct irte_ga.valid bit before calling the function.

Similar to the commit 26e495f34107 ("iommu/amd: Restore IRTE.RemapEn
bit after programming IRTE"), which is for the function
amd_iommu_deactivate_guest_mode().

The same change is also needed for the amd_iommu_activate_guest_mode().
Otherwise, this could trigger IO_PAGE_FAULT for the VFIO based VMs with
AVIC enabled.

Fixes: e52d58d54a321 ("iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE")
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20200916111720.43913-1-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 48fe272da6e9c..a51dcf26b09f2 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3831,14 +3831,18 @@ int amd_iommu_activate_guest_mode(void *data)
 {
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
+	u64 valid;
 
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
 	    !entry || entry->lo.fields_vapic.guest_mode)
 		return 0;
 
+	valid = entry->lo.fields_vapic.valid;
+
 	entry->lo.val = 0;
 	entry->hi.val = 0;
 
+	entry->lo.fields_vapic.valid       = valid;
 	entry->lo.fields_vapic.guest_mode  = 1;
 	entry->lo.fields_vapic.ga_log_intr = 1;
 	entry->hi.fields.ga_root_ptr       = ir_data->ga_root_ptr;
-- 
2.25.1



