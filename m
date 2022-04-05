Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BC44F2EA2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbiDEJDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbiDEIRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A21B0A57;
        Tue,  5 Apr 2022 01:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 452806167A;
        Tue,  5 Apr 2022 08:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4810AC385A1;
        Tue,  5 Apr 2022 08:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145905;
        bh=bpHXttM/e3cLQHkW0j8q0tlu0YafmBGpQxC5mr2uDeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVfQtl1VROnkz3WEW/lgQO2wNlzse7Ntvc0gJQDc/jD/MGrdXd6ICVjbZ25bKNjes
         0vvMt8vqAyVaC+jrSdHRHywM+BDk78HH+CU7XvFQJLK2ZQfO+FU9E7bcPNDFqFHREO
         sv6rOf2N3Rqq3xBg5ldmGe02kgkCLTt/ThyjqynI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0572/1126] drm/msm/dpu: add DSPP blocks teardown
Date:   Tue,  5 Apr 2022 09:21:59 +0200
Message-Id: <20220405070424.423744398@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d5c5e78f217172e87d8fb2c3418dd8b58b4adfcb ]

Add missing calls to dpu_hw_dspp_destroy() to free resources allocated
for DSPP hardware blocks.

Fixes: e47616df008b ("drm/msm/dpu: add support for color processing blocks in dpu driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20220121210618.3482550-3-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
index f9c83d6e427a..24fbaf562d41 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
@@ -35,6 +35,14 @@ int dpu_rm_destroy(struct dpu_rm *rm)
 {
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(rm->dspp_blks); i++) {
+		struct dpu_hw_dspp *hw;
+
+		if (rm->dspp_blks[i]) {
+			hw = to_dpu_hw_dspp(rm->dspp_blks[i]);
+			dpu_hw_dspp_destroy(hw);
+		}
+	}
 	for (i = 0; i < ARRAY_SIZE(rm->pingpong_blks); i++) {
 		struct dpu_hw_pingpong *hw;
 
-- 
2.34.1



