Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F8660FDE3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbiJ0RAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbiJ0RAF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AFA4D254
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B976EB82713
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB00C433C1;
        Thu, 27 Oct 2022 17:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890001;
        bh=oGTDRtZZMSifU1s1dxq9ft33ixIbJMA66HrYwxCuAzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ig/zu8OM2PUWzzYTCXkFgPcsJCJwxKU4ITC7/d7UNAJ6JT3a2fIbFrxFFMfVkZabQ
         3GP39U7pDXM/dqN55yw+eOAC2uYh9pr5iZyTR6UazDHb6Mrw1+EOl4IVoaEMv033xo
         x93Y1Vs3EuM6qQQr/fklahSFZUIYi/CBWaqF4l9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Edward Cree <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 79/94] sfc: include vport_id in filter spec hash and equal()
Date:   Thu, 27 Oct 2022 18:55:21 +0200
Message-Id: <20221027165100.379984147@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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
 drivers/net/ethernet/sfc/filter.h    |  4 ++--
 drivers/net/ethernet/sfc/rx_common.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/filter.h b/drivers/net/ethernet/sfc/filter.h
index 4d928839d292..f569d07ef267 100644
--- a/drivers/net/ethernet/sfc/filter.h
+++ b/drivers/net/ethernet/sfc/filter.h
@@ -161,9 +161,9 @@ struct efx_filter_spec {
 	u32	priority:2;
 	u32	flags:6;
 	u32	dmaq_id:12;
-	u32	vport_id;
 	u32	rss_context;
-	__be16	outer_vid __aligned(4); /* allow jhash2() of match values */
+	u32	vport_id;
+	__be16	outer_vid;
 	__be16	inner_vid;
 	u8	loc_mac[ETH_ALEN];
 	u8	rem_mac[ETH_ALEN];
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 4826e6a7e4ce..9220afeddee8 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -660,17 +660,17 @@ bool efx_filter_spec_equal(const struct efx_filter_spec *left,
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



