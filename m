Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B41F34411E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhCVMbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230319AbhCVMa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6624F619A7;
        Mon, 22 Mar 2021 12:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416228;
        bh=2lJqdAqkhYSkRcnoGC1kDEyj1kX+sKzO6aTqhUaHIEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/OuXhlZvgDPMTv+ws057haDNF2282p6bfAXOZd4eJvFm8Vg5h6kmiDQCmx3ncteH
         Ho1dynaVEEOZvLqxY01Es3yC1cG1flSEnZFWBnKuCxVluC+sfcmbxj11p1wjCamChj
         DkDWDviTRA6jeh735NlN+5O61X2slo6ApXbVXzCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.11 027/120] iommu/amd: Keep track of amd_iommu_irq_remap state
Date:   Mon, 22 Mar 2021 13:26:50 +0100
Message-Id: <20210322121930.564195579@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

commit 4b8ef157ca832f812b3302b1800548bd92c207de upstream.

The amd_iommu_irq_remap variable is set to true in amd_iommu_prepare().
But if initialization fails it is not set to false. Fix that and
correctly keep track of whether irq remapping is enabled or not.

Fixes: b34f10c2dc59 ("iommu/amd: Stop irq_remapping_select() matching when remapping is disabled")
Cc: stable@vger.kernel.org # v5.11
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20210317091037.31374-4-joro@8bytes.org
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3000,8 +3000,11 @@ int __init amd_iommu_prepare(void)
 	amd_iommu_irq_remap = true;
 
 	ret = iommu_go_to_state(IOMMU_ACPI_FINISHED);
-	if (ret)
+	if (ret) {
+		amd_iommu_irq_remap = false;
 		return ret;
+	}
+
 	return amd_iommu_irq_remap ? 0 : -ENODEV;
 }
 


