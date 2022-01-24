Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC63499BBC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356074AbiAXVyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458145AbiAXVmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458E7C07A954;
        Mon, 24 Jan 2022 12:30:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01A85B8122A;
        Mon, 24 Jan 2022 20:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399A8C340E5;
        Mon, 24 Jan 2022 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056247;
        bh=lk34w8WMdUL6l4PL5XdnwhuS4losa8tnQTL3Rj/ZblM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfx2Wup2blfcMAFl5LZcVIRSCNWBB/yVGcpZiob3MdpLsFeqjnXs76MDhmXuVrrCg
         LQJMqZL8CCtO8YQdpHKmPAuYfXMtgyephYfawLXlkfLQtN33F2RKYeRUGBGCK68ZDB
         zwH1Z2rftyeZrCeOYhRwivruYWeakT8IYKLDvrcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 420/846] iommu/amd: X2apic mode: re-enable after resume
Date:   Mon, 24 Jan 2022 19:38:57 +0100
Message-Id: <20220124184115.468706093@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 01b297a48a26bcb96769505ac948db4603b72bd1 ]

Otherwise it is guaranteed to not work after the resume...

Fixes: 66929812955bb ("iommu/amd: Add support for X2APIC IOMMU interrupts")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20211123161038.48009-3-mlevitsk@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 9b12a2f7548ac..c1d4e66d2747b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2169,7 +2169,6 @@ static int iommu_setup_intcapxt(struct amd_iommu *iommu)
 		return ret;
 	}
 
-	iommu_feature_enable(iommu, CONTROL_INTCAPXT_EN);
 	return 0;
 }
 
@@ -2192,6 +2191,10 @@ static int iommu_init_irq(struct amd_iommu *iommu)
 
 	iommu->int_enabled = true;
 enable_faults:
+
+	if (amd_iommu_xt_mode == IRQ_REMAP_X2APIC_MODE)
+		iommu_feature_enable(iommu, CONTROL_INTCAPXT_EN);
+
 	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
 
 	if (iommu->ppr_log != NULL)
-- 
2.34.1



