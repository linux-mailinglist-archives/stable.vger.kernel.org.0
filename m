Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3468C60424A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbiJSK5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiJSK4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:56:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5452B125020;
        Wed, 19 Oct 2022 03:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6AFBB82499;
        Wed, 19 Oct 2022 09:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C63C43470;
        Wed, 19 Oct 2022 09:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170488;
        bh=5Yd5FDDaRj03dfa4ccEHYsYfRgXcz6zUyLgXc1qtPKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXZzLOs1AarKEfiCVyE2FSuvtfXl4vpMnUpC6GC/gQXNWBQtIg4cda2lSYjX8k0aK
         y9XXR+1fiE3wm29Wtf9yFCWnMc6N7fnEQ24Av3TgLndYPsvYq/4jdd5qudAEEXBIyr
         Cv0ODjYaf6Arqr0p+9ckFRj5aVX4+/YdGnvqN0nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        John Garry <john.garry@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 642/862] iommu/iova: Fix module config properly
Date:   Wed, 19 Oct 2022 10:32:09 +0200
Message-Id: <20221019083318.289016215@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c6ba6d95d79c..83c00fac2acb 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -75,7 +75,7 @@ static inline unsigned long iova_pfn(struct iova_domain *iovad, dma_addr_t iova)
 	return iova >> iova_shift(iovad);
 }
 
-#if IS_ENABLED(CONFIG_IOMMU_IOVA)
+#if IS_REACHABLE(CONFIG_IOMMU_IOVA)
 int iova_cache_get(void);
 void iova_cache_put(void);
 
-- 
2.35.1



