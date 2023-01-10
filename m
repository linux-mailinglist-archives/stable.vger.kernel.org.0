Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56926664B34
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbjAJSjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbjAJSim (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:38:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AEA87936
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:34:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAB31B81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A4EC433EF;
        Tue, 10 Jan 2023 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375646;
        bh=Zyl2rqZ9aVRKH/ufjPfl6VtqefpJF8ju/IjUKUlOIxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfQuzKTf5alA+bHuZDzxjtnezFmff+nQq1dXliMZ8sNTh7mdiTP72edIFVTTcj8K5
         Ybo/eKqwFleOQj94/DhlMu8aOr2u4PaW4e+tRnva8qUDRI5/SHgd8nZ4vA5Pf2RExf
         kaNCTDUaSv0Jq+H/D6wl/7CD1V3D1RZzseuxqnhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/290] drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()
Date:   Tue, 10 Jan 2023 19:05:48 +0100
Message-Id: <20230110180040.832065305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 3792fc508c095abd84b10ceae12bd773e61fdc36 ]

Call intel_vgpu_unpin_mm() on this error path.

Fixes: 418741480809 ("drm/i915/gvt: Adding ppgtt to GVT GEM context after shadow pdps settled.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/Y3OQ5tgZIVxyQ/WV@kili
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 1bb1be5c48c8..0291d42cfba8 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -694,6 +694,7 @@ intel_vgpu_shadow_mm_pin(struct intel_vgpu_workload *workload)
 
 	if (workload->shadow_mm->type != INTEL_GVT_MM_PPGTT ||
 	    !workload->shadow_mm->ppgtt_mm.shadowed) {
+		intel_vgpu_unpin_mm(workload->shadow_mm);
 		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
 		return -EINVAL;
 	}
-- 
2.35.1



