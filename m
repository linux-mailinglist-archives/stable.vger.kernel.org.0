Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851B660A5D1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiJXMag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbiJXM22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:28:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56F986FA4;
        Mon, 24 Oct 2022 05:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC22E612F0;
        Mon, 24 Oct 2022 12:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB629C433D6;
        Mon, 24 Oct 2022 12:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612912;
        bh=54tY2h5Qry2GXNveBLK3B1tcepdEC6wKQ9dOikm8r2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlRPA41i86zuCJ9VOKFWhHgb6ZlY5HeHpv40qtbnCgdMMaUnZ2gFQcm23CzYU3kzC
         6NEhkZRX52fIqrgbi3blYES5+Ysw0m917aG7RdnOytMt/5FESiV+FeEwp/IP2AzI4B
         9ByiQxQU8DXtGkR4zVVeXsTfUHb6HYF8yMTLv0iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        John Garry <john.garry@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/229] iommu/iova: Fix module config properly
Date:   Mon, 24 Oct 2022 13:31:26 +0200
Message-Id: <20221024113004.479893418@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 4f58330fcc8482aa90674e1f40f601e82f18ed4a ]

IOMMU_IOVA is intended to be an optional library for users to select as
and when they desire. Since it can be a module now, this means that
built-in code which has chosen not to select it should not fail to link
if it happens to have selected as a module by someone else. Replace
IS_ENABLED() with IS_REACHABLE() to do the right thing.

CC: Thierry Reding <thierry.reding@gmail.com>
Reported-by: John Garry <john.garry@huawei.com>
Fixes: 15bbdec3931e ("iommu: Make the iova library a module")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/548c2f683ca379aface59639a8f0cccc3a1ac050.1663069227.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iova.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iova.h b/include/linux/iova.h
index 84fbe73d2ec0..8d4616c532da 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -133,7 +133,7 @@ static inline unsigned long iova_pfn(struct iova_domain *iovad, dma_addr_t iova)
 	return iova >> iova_shift(iovad);
 }
 
-#if IS_ENABLED(CONFIG_IOMMU_IOVA)
+#if IS_REACHABLE(CONFIG_IOMMU_IOVA)
 int iova_cache_get(void);
 void iova_cache_put(void);
 
-- 
2.35.1



