Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C2166C4BC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjAPP55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjAPP5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5751CAE7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B781EB81052
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26137C433EF;
        Mon, 16 Jan 2023 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884649;
        bh=GQU4LNfI1hqYzrH5Ajp80x1VTaSFsryD7BYENTUXjr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a40RnUstu8dJXbkdnwilzoQfRqdhBwhAaPJJkNI6CD5pIvI4+a/q2kWxVV/SbdWW0
         /+IOrO0KZedxxsi3JeOMpIieHTdo+gKx9XWi+OdcmY0VomHjcBujisa3waTpw3jaTQ
         4eBPwdFU3BJetgd/LkErxshm3oPNQggCVq5it1bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 087/183] iommu/arm-smmu: Report IOMMU_CAP_CACHE_COHERENCY even betterer
Date:   Mon, 16 Jan 2023 16:50:10 +0100
Message-Id: <20230116154807.102072721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit ac9c5e92dd15b9927e7355ccf79df76a58b44344 upstream.

Although it's vanishingly unlikely that anyone would integrate an SMMU
within a coherent interconnect without also making the pagetable walk
interface coherent, the same effect happens if a coherent SMMU fails to
advertise CTTW correctly. This turns out to be the case on some popular
NXP SoCs, where VFIO started failing the IOMMU_CAP_CACHE_COHERENCY test,
even though IOMMU_CACHE *was* previously achieving the desired effect
anyway thanks to the underlying integration.

While those SoCs stand to gain some more general benefits from a
firmware update to override CTTW correctly in DT/ACPI, it's also easy
to work around this in Linux as well, to avoid imposing too much on
affected users - since the upstream client devices *are* correctly
marked as coherent, we can trivially infer their coherent paths through
the SMMU as well.

Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Fixes: df198b37e72c ("iommu/arm-smmu: Report IOMMU_CAP_CACHE_COHERENCY better")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/d6dc41952961e5c7b21acac08a8bf1eb0f69e124.1671123115.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1319,8 +1319,14 @@ static bool arm_smmu_capable(struct devi
 
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
-		/* Assume that a coherent TCU implies coherent TBUs */
-		return cfg->smmu->features & ARM_SMMU_FEAT_COHERENT_WALK;
+		/*
+		 * It's overwhelmingly the case in practice that when the pagetable
+		 * walk interface is connected to a coherent interconnect, all the
+		 * translation interfaces are too. Furthermore if the device is
+		 * natively coherent, then its translation interface must also be.
+		 */
+		return cfg->smmu->features & ARM_SMMU_FEAT_COHERENT_WALK ||
+			device_get_dma_attr(dev) == DEV_DMA_COHERENT;
 	case IOMMU_CAP_NOEXEC:
 		return true;
 	default:


