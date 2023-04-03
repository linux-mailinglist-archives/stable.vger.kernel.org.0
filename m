Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C946D4AC8
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbjDCOuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbjDCOuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06D34483
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71926B81D74
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6B4C433D2;
        Mon,  3 Apr 2023 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533360;
        bh=+O+uY0hjyAYiHCAtpIIykAZv7rdIf+jyb0X2fk79fsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkr41tJnTz2b/nRnkCafyKm74e7WmCMtuiZKh6N/vW8bngXyVxR7U9wOosxXQUo/n
         zxYEVi1lK9xKbbz8oSUFn984+nzbGUXxTlknsVbSnbgexSmtMqNJAm8xyFfRD45BrA
         hOJALIVEwpFQUeS3rgjn6BuUW48yO9kILeG1vFEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Simon Horman <simon.horman@corigine.com>,
        Felix Fietkau <nbd@nbd.name>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 123/187] net: ethernet: mtk_eth_soc: add missing ppe cache flush when deleting a flow
Date:   Mon,  3 Apr 2023 16:09:28 +0200
Message-Id: <20230403140420.017812200@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 924531326e2dd4ceabe7240f2b55a88e7d894ec2 ]

The cache needs to be flushed to ensure that the hardware stops offloading
the flow immediately.

Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230330120840.52079-3-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 52db211d9596a..2ea539ccc0802 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -459,6 +459,7 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 		hwe->ib1 &= ~MTK_FOE_IB1_STATE;
 		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
 		dma_wmb();
+		mtk_ppe_cache_clear(ppe);
 	}
 	entry->hash = 0xffff;
 
-- 
2.39.2



