Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D2F6D4A9A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjDCOsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjDCOs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:48:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66D71766B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:47:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E0F661F50
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D0EC4339B;
        Mon,  3 Apr 2023 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533234;
        bh=CMj4c/ZIUVRCCzFUFSz9++mPH9R/HYaVVlufubWf4wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qV3l7/5c5j1rcFdL8IY3QtOPqkmwlxpJyZZlw82WVyKZYea5MAoKpb70XWXzLueH1
         Rn1CAOo/GvfWCfmihFiYF+QtTixGMJ5WG/oBBSHPaS6cy0zaDaOx5NEYi6nwKel67P
         gwPMWammosW4z0pMahO8aP7Iso1ajxGDNZtRsukg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Malz <robertx.malz@intel.com>,
        Brett Creeley <brett.creeley@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Jakub Andrysiak <jakub.andrysiak@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 105/187] ice: Fix ice_cfg_rdma_fltr() to only update relevant fields
Date:   Mon,  3 Apr 2023 16:09:10 +0200
Message-Id: <20230403140419.429179529@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit d94dbdc4e0209b5e7d736ab696f8d635b034e3ee ]

The current implementation causes ice_vsi_update() to update all VSI
fields based on the cached VSI context. This also assumes that the
ICE_AQ_VSI_PROP_Q_OPT_VALID bit is set. This can cause problems if the
VSI context is not correctly synced by the driver. Fix this by only
updating the fields that correspond to ICE_AQ_VSI_PROP_Q_OPT_VALID.
Also, make sure to save the updated result in the cached VSI context
on success.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Co-developed-by: Robert Malz <robertx.malz@intel.com>
Signed-off-by: Robert Malz <robertx.malz@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Tested-by: Jakub Andrysiak <jakub.andrysiak@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 26 +++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 61f844d225123..46b36851af460 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1780,18 +1780,36 @@ ice_update_vsi(struct ice_hw *hw, u16 vsi_handle, struct ice_vsi_ctx *vsi_ctx,
 int
 ice_cfg_rdma_fltr(struct ice_hw *hw, u16 vsi_handle, bool enable)
 {
-	struct ice_vsi_ctx *ctx;
+	struct ice_vsi_ctx *ctx, *cached_ctx;
+	int status;
+
+	cached_ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	if (!cached_ctx)
+		return -ENOENT;
 
-	ctx = ice_get_vsi_ctx(hw, vsi_handle);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
-		return -EIO;
+		return -ENOMEM;
+
+	ctx->info.q_opt_rss = cached_ctx->info.q_opt_rss;
+	ctx->info.q_opt_tc = cached_ctx->info.q_opt_tc;
+	ctx->info.q_opt_flags = cached_ctx->info.q_opt_flags;
+
+	ctx->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_Q_OPT_VALID);
 
 	if (enable)
 		ctx->info.q_opt_flags |= ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
 	else
 		ctx->info.q_opt_flags &= ~ICE_AQ_VSI_Q_OPT_PE_FLTR_EN;
 
-	return ice_update_vsi(hw, vsi_handle, ctx, NULL);
+	status = ice_update_vsi(hw, vsi_handle, ctx, NULL);
+	if (!status) {
+		cached_ctx->info.q_opt_flags = ctx->info.q_opt_flags;
+		cached_ctx->info.valid_sections |= ctx->info.valid_sections;
+	}
+
+	kfree(ctx);
+	return status;
 }
 
 /**
-- 
2.39.2



