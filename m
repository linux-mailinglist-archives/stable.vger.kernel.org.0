Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503D26AF3ED
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbjCGTLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbjCGTKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:10:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E98C9E32F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:55:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EACC61531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4858AC433EF;
        Tue,  7 Mar 2023 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215322;
        bh=AGW/09WFM/k8GGWG5/uVGrdm+v3aJ6d6UTf+CmUepmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ix48IOGvu+S8yiXrKT0ZQMXgpaCoFnrtsz5YIreZCvUueGwzlIShpE0bfR8QyGZup
         9/JT/P4OIpmtDCXsCds9RA6ok/Cfozhm3LTkD3cb+VwBB9OFqu5ZxXcd6t8Rtsxacg
         RRCFlmfzjqd1TqsDxq4vk+g/Gj2jfeVYK4tlF8qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/567] drm/msm/dpu: Disallow unallocated resources to be returned
Date:   Tue,  7 Mar 2023 17:58:48 +0100
Message-Id: <20230307165914.263425068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit abc40122d9a69f56c04efb5a7485795f5ac799d1 ]

In the event that the topology requests resources that have not been
created by the system (because they are typically not represented in
dpu_mdss_cfg ^1), the resource(s) in global_state (in this case DSC
blocks, until their allocation/assignment is being sanity-checked in
"drm/msm/dpu: Reject topologies for which no DSC blocks are available")
remain NULL but will still be returned out of
dpu_rm_get_assigned_resources, where the caller expects to get an array
containing num_blks valid pointers (but instead gets these NULLs).

To prevent this from happening, where null-pointer dereferences
typically result in a hard-to-debug platform lockup, num_blks shouldn't
increase past NULL blocks and will print an error and break instead.
After all, max_blks represents the static size of the maximum number of
blocks whereas the actual amount varies per platform.

^1: which can happen after a git rebase ended up moving additions to
_dpu_cfg to a different struct which has the same patch context.

Fixes: bb00a452d6f7 ("drm/msm/dpu: Refactor resource manager")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/517636/
Link: https://lore.kernel.org/r/20230109231556.344977-1-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
index 24fbaf562d418..932275b2dfe74 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
@@ -663,6 +663,11 @@ int dpu_rm_get_assigned_resources(struct dpu_rm *rm,
 				  blks_size, enc_id);
 			break;
 		}
+		if (!hw_blks[i]) {
+			DPU_ERROR("Allocated resource %d unavailable to assign to enc %d\n",
+				  type, enc_id);
+			break;
+		}
 		blks[num_blks++] = hw_blks[i];
 	}
 
-- 
2.39.2



