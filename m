Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93ADE5AEC44
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbiIFOAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240860AbiIFN6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:58:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A648305A;
        Tue,  6 Sep 2022 06:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C83AB818B9;
        Tue,  6 Sep 2022 13:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5622C433C1;
        Tue,  6 Sep 2022 13:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471765;
        bh=3rQIWftn9/ylHrSmPoJcjnNSWsdJZsDmcOjAsuZnSWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFQg9LnYsFXRBJs8PI4ekGi1qlBwKjz8YXLBwMEEnxvlRhToUBcDPXb+lkx/xbOy0
         bfp0GxGcjfQLWjEtjSI/BDCQH0TKxIRY39VJCKM6zpSwCTszxlb4+ArIHLG2fIj8YP
         DsuwTYMTu1TkHKHVHywwK8BRXg/F+kLB7Q6HXDHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Jessica Zhang <quic_jesszhan@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 003/155] drm/msm/dpu: populate wb or intf before reset_intf_cfg
Date:   Tue,  6 Sep 2022 15:29:11 +0200
Message-Id: <20220906132829.567715851@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit ef3ac3ae147c6ab370875727791e9b3eaf176cea ]

dpu_encoder_helper_phys_cleanup() was not populating neither
wb or intf to the intf_cfg before calling the reset_intf_cfg().

This causes the reset of the active bits of wb/intf to be
skipped which is incorrect.

Fix this by populating the relevant wb or intf indices correctly.

Fixes: ae4d721ce100 ("drm/msm/dpu: add an API to reset the encoder related hw blocks")
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Tested-by: Jessica Zhang <quic_jesszhan@quicinc.com> # Trogdor (SC8170)
Patchwork: https://patchwork.freedesktop.org/patch/494298/
Link: https://lore.kernel.org/r/1657912468-17254-1-git-send-email-quic_abhinavk@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 9b4df3084366b..d98c7f7da7c08 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1998,6 +1998,12 @@ void dpu_encoder_helper_phys_cleanup(struct dpu_encoder_phys *phys_enc)
 
 	intf_cfg.stream_sel = 0; /* Don't care value for video mode */
 	intf_cfg.mode_3d = dpu_encoder_helper_get_3d_blend_mode(phys_enc);
+
+	if (phys_enc->hw_intf)
+		intf_cfg.intf = phys_enc->hw_intf->idx;
+	if (phys_enc->hw_wb)
+		intf_cfg.wb = phys_enc->hw_wb->idx;
+
 	if (phys_enc->hw_pp->merge_3d)
 		intf_cfg.merge_3d = phys_enc->hw_pp->merge_3d->idx;
 
-- 
2.35.1



