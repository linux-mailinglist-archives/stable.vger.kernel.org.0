Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB086AEA7E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjCGRe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjCGReM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0318D9B9A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB7D0B819A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F96C433EF;
        Tue,  7 Mar 2023 17:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210186;
        bh=8nnujh0FK/mnQfDxio1/4msAJ3ck5PCxt+jkwOZH3ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T89vSZfgDShfpb6UGcs2ehhkmy0jtoOKZDfN78t0P8LefXVfPZDuFmC8fkEvmHLra
         QD/s9UQvT+us069JHr6PDWSuys9HfFL8iAPBKa4nwLjTXg9f32he7+HjvHiXBK9wmL
         Df8+pSG+e7H92CQyTZExV/xEBLYNaecVp3UGk7cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harry Wentland <harry.wentland@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0430/1001] drm/amd/display: dont call dc_interrupt_set() for disabled crtcs
Date:   Tue,  7 Mar 2023 17:53:22 +0100
Message-Id: <20230307170040.017337570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamza Mahfooz <hamza.mahfooz@amd.com>

[ Upstream commit 4936458bf989d168f5a89015dd81067c4c2bdc64 ]

As made mention of in commit 4ea7fc09539b ("drm/amd/display: Do not
program interrupt status on disabled crtc"), we shouldn't program
disabled crtcs. So, filter out disabled crtcs in dm_set_vupdate_irq()
and dm_set_vblank().

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 589d2739332d ("drm/amd/display: Use crtc enable/disable_vblank hooks")
Fixes: d2574c33bb71 ("drm/amd/display: In VRR mode, do DRM core vblank handling at end of vblank. (v2)")
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 22125daf9dcfe..78c2ed59e87d2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -77,6 +77,9 @@ int dm_set_vupdate_irq(struct drm_crtc *crtc, bool enable)
 	struct amdgpu_device *adev = drm_to_adev(crtc->dev);
 	int rc;
 
+	if (acrtc->otg_inst == -1)
+		return 0;
+
 	irq_source = IRQ_TYPE_VUPDATE + acrtc->otg_inst;
 
 	rc = dc_interrupt_set(adev->dm.dc, irq_source, enable) ? 0 : -EBUSY;
@@ -152,6 +155,9 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
 	struct vblank_control_work *work;
 	int rc = 0;
 
+	if (acrtc->otg_inst == -1)
+		goto skip;
+
 	if (enable) {
 		/* vblank irq on -> Only need vupdate irq in vrr mode */
 		if (amdgpu_dm_vrr_active(acrtc_state))
@@ -169,6 +175,7 @@ static inline int dm_set_vblank(struct drm_crtc *crtc, bool enable)
 	if (!dc_interrupt_set(adev->dm.dc, irq_source, enable))
 		return -EBUSY;
 
+skip:
 	if (amdgpu_in_reset(adev))
 		return 0;
 
-- 
2.39.2



