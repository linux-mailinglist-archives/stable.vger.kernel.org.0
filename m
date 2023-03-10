Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862736B4198
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjCJNyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjCJNyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:54:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD18A10FB9C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:54:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D6BAB822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC116C433EF;
        Fri, 10 Mar 2023 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456476;
        bh=++Tar65/IL/mM1cxN7n/aRBBTvtuMvpPnoG6fWLHT/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+sKHKxTndhmv83V+WQr01oDHzfQL/rSSrIfn8y1DxdaXbUBb2hUcM7tT1xaLiRJ+
         FojYmpF0YQoOzSuJ9RMiKktKjFkbFacaX4qov37Mxi2oOKspSc4HLxdCt7YZN4msEI
         v63AsIPs8ytJK0qKRBM27tFTKRwUc0gDfp5aOjs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tinghan Shen <tinghan.shen@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 008/211] soc: mediatek: mtk-pm-domains: Allow mt8186 ADSP default power on
Date:   Fri, 10 Mar 2023 14:36:28 +0100
Message-Id: <20230310133718.982096506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Tinghan Shen <tinghan.shen@mediatek.com>

[ Upstream commit 0d08c56d97a614f56d74f490d693faf8038db125 ]

In the use case of configuring the access permissions of the ADSP core,
the mt8186 SoC ADSP power will be switched on in the bootloader because
the permission control registers are located in the ADSP subsys.

Signed-off-by: Tinghan Shen <tinghan.shen@mediatek.com>
Fixes: 88590cbc1703 ("soc: mediatek: pm-domains: Add support for mt8186")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221012075434.30009-1-tinghan.shen@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mt8186-pm-domains.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/soc/mediatek/mt8186-pm-domains.h b/drivers/soc/mediatek/mt8186-pm-domains.h
index 108af61854a38..fce86f79c5055 100644
--- a/drivers/soc/mediatek/mt8186-pm-domains.h
+++ b/drivers/soc/mediatek/mt8186-pm-domains.h
@@ -304,7 +304,6 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 		.ctl_offs = 0x9FC,
 		.pwr_sta_offs = 0x16C,
 		.pwr_sta2nd_offs = 0x170,
-		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8186_POWER_DOMAIN_ADSP_INFRA] = {
 		.name = "adsp_infra",
@@ -312,7 +311,6 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 		.ctl_offs = 0x9F8,
 		.pwr_sta_offs = 0x16C,
 		.pwr_sta2nd_offs = 0x170,
-		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8186_POWER_DOMAIN_ADSP_TOP] = {
 		.name = "adsp_top",
@@ -332,7 +330,7 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 				MT8186_TOP_AXI_PROT_EN_3_CLR,
 				MT8186_TOP_AXI_PROT_EN_3_STA),
 		},
-		.caps = MTK_SCPD_SRAM_ISO | MTK_SCPD_KEEP_DEFAULT_OFF | MTK_SCPD_ACTIVE_WAKEUP,
+		.caps = MTK_SCPD_SRAM_ISO | MTK_SCPD_ACTIVE_WAKEUP,
 	},
 };
 
-- 
2.39.2



