Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6580D1880EE
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgCQLN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727690AbgCQLNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:13:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 058F920663;
        Tue, 17 Mar 2020 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443634;
        bh=L7Bcr2/fKqTd6Gwmz3z81lshdLylMuMc0dbeObONMME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXBtZYbIsgHCGcuDIrDmhi0stdhj22AR7T73DaBnKYPKM7tH2fxpnAAJfXko+wxle
         p8/WxeZn66efj2tRoo2G5KSb20qHUNsc6pEe92HFTNj7QlkXuMddNVQ+Srjm4XBBz3
         6gJ3Cy02JKWPIe8BoGKB8LUrl8bPAi1lREJJETD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.5 149/151] iommu/amd: Fix IOMMU AVIC not properly update the is_run bit in IRTE
Date:   Tue, 17 Mar 2020 11:55:59 +0100
Message-Id: <20200317103337.322601542@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit 730ad0ede130015a773229573559e97ba0943065 upstream.

Commit b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC
(de-)activation code") accidentally left out the ir_data pointer when
calling modity_irte_ga(), which causes the function amd_iommu_update_ga()
to return prematurely due to struct amd_ir_data.ref is NULL and
the "is_run" bit of IRTE does not get updated properly.

This results in bad I/O performance since IOMMU AVIC always generate GA Log
entry and notify IOMMU driver and KVM when it receives interrupt from the
PCI pass-through device instead of directly inject interrupt to the vCPU.

Fixes by passing ir_data when calling modify_irte_ga() as done previously.

Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3836,7 +3836,7 @@ int amd_iommu_activate_guest_mode(void *
 	entry->lo.fields_vapic.ga_tag      = ir_data->ga_tag;
 
 	return modify_irte_ga(ir_data->irq_2_irte.devid,
-			      ir_data->irq_2_irte.index, entry, NULL);
+			      ir_data->irq_2_irte.index, entry, ir_data);
 }
 EXPORT_SYMBOL(amd_iommu_activate_guest_mode);
 
@@ -3862,7 +3862,7 @@ int amd_iommu_deactivate_guest_mode(void
 				APICID_TO_IRTE_DEST_HI(cfg->dest_apicid);
 
 	return modify_irte_ga(ir_data->irq_2_irte.devid,
-			      ir_data->irq_2_irte.index, entry, NULL);
+			      ir_data->irq_2_irte.index, entry, ir_data);
 }
 EXPORT_SYMBOL(amd_iommu_deactivate_guest_mode);
 


