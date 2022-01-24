Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C61A49A317
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366126AbiAXXwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844632AbiAXXJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:09:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B93AC09F82C;
        Mon, 24 Jan 2022 13:18:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8E6BB80FA3;
        Mon, 24 Jan 2022 21:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0324BC340E4;
        Mon, 24 Jan 2022 21:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059078;
        bh=AARvIspTDx5oeredf44NzHo/9Hvy6QhxhRkqFfkxd5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGLMS6sUos6rSe6gIrLFHKKdaHSiqKWQlQMxiINi/9jKxE7MWEpGoPn4Xr2AcLtHM
         dTBogFw/HatnzsDjee6hqt5cn+DWRLWBPGvz0k2P/fpLAkEUNDwTwcWwzjqR8zjaja
         MOj8IC1gQLwQHU4UZAJQLgE96IyKI7IPEwi/f3jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0497/1039] iommu/amd: Remove useless irq affinity notifier
Date:   Mon, 24 Jan 2022 19:38:06 +0100
Message-Id: <20220124184141.953120806@linuxfoundation.org>
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

[ Upstream commit 575f5cfb13c84f324f9898383fa4a5694e53c9ef ]

iommu->intcapxt_notify field is no longer used
after a switch to a separate domain was done

Fixes: d1adcfbb520c ("iommu/amd: Fix IOMMU interrupt generation in X2APIC mode")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20211123161038.48009-6-mlevitsk@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 867535eb0ce97..ffc89c4fb1205 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -645,8 +645,6 @@ struct amd_iommu {
 	/* DebugFS Info */
 	struct dentry *debugfs;
 #endif
-	/* IRQ notifier for IntCapXT interrupt */
-	struct irq_affinity_notify intcapxt_notify;
 };
 
 static inline struct amd_iommu *dev_to_amd_iommu(struct device *dev)
-- 
2.34.1



