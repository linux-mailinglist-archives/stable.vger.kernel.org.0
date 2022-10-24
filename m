Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F0060BC78
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJXVsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiJXVrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:47:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90B0A571E;
        Mon, 24 Oct 2022 12:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0C77B815F6;
        Mon, 24 Oct 2022 12:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017FBC433D6;
        Mon, 24 Oct 2022 12:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613555;
        bh=fzcrBvCZW7mXwVLKymyezTswcQKSn+eSTCs7/2xGe8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCiOgUxqXTEekqdxYFZOsiTrzb1xBKNoDq49wmNC29OMg5GsiggFCcUJbV2Di5Afn
         QudTPrzVQQXAeWSfGWZabvWYqUPRgm16x7M23ls5GzNuL6dZJZVKFi7nUBbjB62+C9
         fYs15zvr4hGmi7IWq8pre7p4IQdlbw85YyxqlghU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        John Garry <john.garry@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/255] iommu/iova: Fix module config properly
Date:   Mon, 24 Oct 2022 13:31:31 +0200
Message-Id: <20221024113008.882222839@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index a0637abffee8..6c19b09e9663 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -132,7 +132,7 @@ static inline unsigned long iova_pfn(struct iova_domain *iovad, dma_addr_t iova)
 	return iova >> iova_shift(iovad);
 }
 
-#if IS_ENABLED(CONFIG_IOMMU_IOVA)
+#if IS_REACHABLE(CONFIG_IOMMU_IOVA)
 int iova_cache_get(void);
 void iova_cache_put(void);
 
-- 
2.35.1



