Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B4A664895
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbjAJSMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238869AbjAJSL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:11:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76755E5E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:10:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12D2961866
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6E3C433D2;
        Tue, 10 Jan 2023 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374235;
        bh=1kWbMsaTYrYA+ClJ3yAOD06gUm4odCYDxQnfopTjvdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ioutHlxPH1jEpcaAPL8ZElLHKjX9aFukEYwXAL0O50L5VB2L64OaM8sB37Ebwd8DA
         xLPC3a+R5FBHNb9hFI2EOJr6ss7kxprCqOy04CH2DieQd0pfBm++oZvEqRcHgIvsf5
         kqfm4AsdXWecs6rGsOrGl7Nd8WE38LCJhyrZT4K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 096/148] drm/i915/gvt: fix double free bug in split_2MB_gtt_entry
Date:   Tue, 10 Jan 2023 19:03:20 +0100
Message-Id: <20230110180020.238132316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 4a61648af68f5ba4884f0e3b494ee1cabc4b6620 ]

If intel_gvt_dma_map_guest_page failed, it will call
ppgtt_invalidate_spt, which will finally free the spt.
But the caller function ppgtt_populate_spt_by_guest_entry
does not notice that, it will free spt again in its error
path.

Fix this by canceling the mapping of DMA address and freeing sub_spt.
Besides, leave the handle of spt destroy to caller function instead
of callee function when error occurs.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20221229165641.1192455-1-zyytlz.wz@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/gtt.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index ce0eb03709c3..80c60754a5c1 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1214,10 +1214,8 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	for_each_shadow_entry(sub_spt, &sub_se, sub_index) {
 		ret = intel_gvt_dma_map_guest_page(vgpu, start_gfn + sub_index,
 						   PAGE_SIZE, &dma_addr);
-		if (ret) {
-			ppgtt_invalidate_spt(spt);
-			return ret;
-		}
+		if (ret)
+			goto err;
 		sub_se.val64 = se->val64;
 
 		/* Copy the PAT field from PDE. */
@@ -1236,6 +1234,17 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	ops->set_pfn(se, sub_spt->shadow_page.mfn);
 	ppgtt_set_shadow_entry(spt, se, index);
 	return 0;
+err:
+	/* Cancel the existing addess mappings of DMA addr. */
+	for_each_present_shadow_entry(sub_spt, &sub_se, sub_index) {
+		gvt_vdbg_mm("invalidate 4K entry\n");
+		ppgtt_invalidate_pte(sub_spt, &sub_se);
+	}
+	/* Release the new allocated spt. */
+	trace_spt_change(sub_spt->vgpu->id, "release", sub_spt,
+		sub_spt->guest_page.gfn, sub_spt->shadow_page.type);
+	ppgtt_free_spt(sub_spt);
+	return ret;
 }
 
 static int split_64KB_gtt_entry(struct intel_vgpu *vgpu,
-- 
2.35.1



