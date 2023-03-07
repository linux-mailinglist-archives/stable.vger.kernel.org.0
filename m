Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFC06AEAE5
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjCGRi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjCGRiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F959474B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:33:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B8A2B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F36C433D2;
        Tue,  7 Mar 2023 17:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210433;
        bh=pgWK7iDobdFd0IOjlILgXLxRznXKjkiZPmIYrwy8efU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ItIrOas/aKqxk84LkAtwFkSuPthtJTRrT5D8gO8J1dMC8k1pCqof7JDJTUt6r08C6
         dT06a0CMva2GIEp/s7LxK/KXaSSkY20Of08itAJFY1pQe9pCscLxVmfEhqEXreTwl0
         kxmwMJMt4VR7lJlcPALsjjwFEmRKBMz9D53v+isk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0540/1001] phy: mediatek: remove temporary variable @mask_
Date:   Tue,  7 Mar 2023 17:55:12 +0100
Message-Id: <20230307170044.890913179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 49094d928618309877c50e589f23e639a3b0c453 ]

Remove the temporary @mask_, this may cause build warning when use clang
compiler for powerpc, but can't reproduce it when compile for arm64.
the build warning is caused by:

"warning: result of comparison of constant 18446744073709551615 with
expression of type (aka 'unsigned long') is always false
[-Wtautological-constant-out-of-range-compare]"

More information provided in below lore link.

After removing @mask_, there is a "CHECK:MACRO_ARG_REUSE" when run
checkpatch.pl, but due to @mask is constant, no reuse problem will happen.

Link: https://lore.kernel.org/lkml/202212160357.jJuesD8n-lkp@intel.com/t/
Fixes: 84513eccd678 ("phy: mediatek: fix build warning of FIELD_PREP()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230118084343.26913-1-chunfeng.yun@mediatek.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-io.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/mediatek/phy-mtk-io.h b/drivers/phy/mediatek/phy-mtk-io.h
index d20ad5e5be814..58f06db822cb0 100644
--- a/drivers/phy/mediatek/phy-mtk-io.h
+++ b/drivers/phy/mediatek/phy-mtk-io.h
@@ -39,8 +39,8 @@ static inline void mtk_phy_update_bits(void __iomem *reg, u32 mask, u32 val)
 /* field @mask shall be constant and continuous */
 #define mtk_phy_update_field(reg, mask, val) \
 ({ \
-	typeof(mask) mask_ = (mask);	\
-	mtk_phy_update_bits(reg, mask_, FIELD_PREP(mask_, val)); \
+	BUILD_BUG_ON_MSG(!__builtin_constant_p(mask), "mask is not constant"); \
+	mtk_phy_update_bits(reg, mask, FIELD_PREP(mask, val)); \
 })
 
 #endif
-- 
2.39.2



