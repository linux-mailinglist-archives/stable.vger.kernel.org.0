Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FBD60FE93
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiJ0RGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbiJ0RG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:06:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA7319ABDB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:06:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CFFDCE278E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84470C433D7;
        Thu, 27 Oct 2022 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890382;
        bh=Snh8j5IU+8UhM/dgANFRWnNLebCE4YziLjrJHaPR3zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txpUxPZWlbeu4f+MVW+QtqMBW0Ae9GVwCxmfBJSlg/FxR/ADBjHA/ZSI/84zRzbLp
         Kw7Rp5CpbHRGCKy733vqkFGScPQtntTIcKfPHiXaafuerVymM6MTKKm13HyA4F4Sp/
         SzmQEYPG3vFEmhruImHWjIivMPpggIvg//SuQHQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Edward Cree <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/79] sfc: include vport_id in filter spec hash and equal()
Date:   Thu, 27 Oct 2022 18:55:59 +0200
Message-Id: <20221027165056.006365638@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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

From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

[ Upstream commit c2bf23e4a5af37a4d77901d9ff14c50a269f143d ]

Filters on different vports are qualified by different implicit MACs and/or
VLANs, so shouldn't be considered equal even if their other match fields
are identical.

Fixes: 7c460d9be610 ("sfc: Extend and abstract efx_filter_spec to cover Huntington/EF10")
Co-developed-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20221018092841.32206-1-pieter.jansen-van-vuuren@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/filter.h    |  3 ++-
 drivers/net/ethernet/sfc/rx_common.c | 10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/filter.h b/drivers/net/ethernet/sfc/filter.h
index 40b2af8bfb81..2ac3c8f1b04b 100644
--- a/drivers/net/ethernet/sfc/filter.h
+++ b/drivers/net/ethernet/sfc/filter.h
@@ -157,7 +157,8 @@ struct efx_filter_spec {
 	u32	flags:6;
 	u32	dmaq_id:12;
 	u32	rss_context;
-	__be16	outer_vid __aligned(4); /* allow jhash2() of match values */
+	u32	vport_id;
+	__be16	outer_vid;
 	__be16	inner_vid;
 	u8	loc_mac[ETH_ALEN];
 	u8	rem_mac[ETH_ALEN];
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 2c09afac5beb..36b46ddb6710 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -676,17 +676,17 @@ bool efx_filter_spec_equal(const struct efx_filter_spec *left,
 	     (EFX_FILTER_FLAG_RX | EFX_FILTER_FLAG_TX)))
 		return false;
 
-	return memcmp(&left->outer_vid, &right->outer_vid,
+	return memcmp(&left->vport_id, &right->vport_id,
 		      sizeof(struct efx_filter_spec) -
-		      offsetof(struct efx_filter_spec, outer_vid)) == 0;
+		      offsetof(struct efx_filter_spec, vport_id)) == 0;
 }
 
 u32 efx_filter_spec_hash(const struct efx_filter_spec *spec)
 {
-	BUILD_BUG_ON(offsetof(struct efx_filter_spec, outer_vid) & 3);
-	return jhash2((const u32 *)&spec->outer_vid,
+	BUILD_BUG_ON(offsetof(struct efx_filter_spec, vport_id) & 3);
+	return jhash2((const u32 *)&spec->vport_id,
 		      (sizeof(struct efx_filter_spec) -
-		       offsetof(struct efx_filter_spec, outer_vid)) / 4,
+		       offsetof(struct efx_filter_spec, vport_id)) / 4,
 		      0);
 }
 
-- 
2.35.1



