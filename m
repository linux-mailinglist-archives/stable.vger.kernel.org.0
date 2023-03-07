Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8276AEA05
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCGRaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjCGR3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:29:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7B2A17E5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 110A0614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CE2C433EF;
        Tue,  7 Mar 2023 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209889;
        bh=4Zl7Vjb+b9Zc+NV8+EPuCobD8YlGBNB5G9VogX4vN8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILC8x4Kc6ZxVDqpVLY8hHSZaBQWAFvIKm0n6TrC0AFiMoiXhLBQ6pV8NxeTbCP7M5
         Cc/rNmUbY4hSWzzKAZ9jbc8wwl4Ej76bSq5UpXrK3kWzDMgP25+eLh488wFRYgo+Ls
         qpUxsogZ63ybAURBjQK5nFKa95i29P5HGIk30OhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0365/1001] drm/msm/dpu: Disallow unallocated resources to be returned
Date:   Tue,  7 Mar 2023 17:52:17 +0100
Message-Id: <20230307170037.224866791@linuxfoundation.org>
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
index 73b3442e74679..7ada957adbbb8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
@@ -660,6 +660,11 @@ int dpu_rm_get_assigned_resources(struct dpu_rm *rm,
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



