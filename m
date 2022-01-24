Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578394998B6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352686AbiAXV3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:29:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37420 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446189AbiAXVRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:17:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7BCCB812A4;
        Mon, 24 Jan 2022 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED44AC340E4;
        Mon, 24 Jan 2022 21:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059069;
        bh=nGSKyNwHqxYnvZTzIEn47sHUm0MNCLWPaVZ1C6/ULmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPN70eBBQAoIg1orgSrU44tYdApWzduoPNyBVRhUowUTagEaw/nYlQKuTed+Ftg0Q
         SLE3ZuScGAc/txBMBWo5KKDJGZu6nErdQ3pCS/0joFqZGG0i8C2WsEqE4cd0wu1bfM
         eGCgMltzUEOc5DDsckiOo7ds9YiUYQO7LCkLr+/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0494/1039] iommu/amd: X2apic mode: re-enable after resume
Date:   Mon, 24 Jan 2022 19:38:03 +0100
Message-Id: <20220124184141.859316718@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 8dae85fcfc2eb..b905604f434e1 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2172,7 +2172,6 @@ static int iommu_setup_intcapxt(struct amd_iommu *iommu)
 		return ret;
 	}
 
-	iommu_feature_enable(iommu, CONTROL_INTCAPXT_EN);
 	return 0;
 }
 
@@ -2195,6 +2194,10 @@ static int iommu_init_irq(struct amd_iommu *iommu)
 
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



