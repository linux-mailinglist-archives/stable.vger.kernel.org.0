Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C365077FF
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356610AbiDSSSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356638AbiDSSRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB093ED38;
        Tue, 19 Apr 2022 11:13:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68AF760A75;
        Tue, 19 Apr 2022 18:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B6AC385A5;
        Tue, 19 Apr 2022 18:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391980;
        bh=T1EzDUfwjggOELHvvCTAYsHts3WIZamAMmLGdfdkNLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgC8pQu+sgDNaqY9Xc7f2jPJ5FJSiIoHj7Zrk2gu0hBJad8GgUSDM4l2YKuOfpYnx
         LV26XzkaZkaHJFI4B8YIoUkcSr2f3Trmt2ZM/drI8PzHmItpanUc7aUvpLAeqDH5ST
         pC6rTvhbMkfIV89ozhgUNLR9hwk1d8+vGRfdP0nfQlJpXIsNWp1ddr1imeTjqF7O7l
         m1hZRA7tbmtXXCFUJuo68QbDAA/YIfralG2joDoLT4LWf9G0/pUzj4zLzrKYXQAT07
         kFhAGad9UA3iQda/Jtt42USEcNC4o75kz6z/4MobNxjAtxxpNISAmgb8aJVS71HXG4
         8fZsZI91YZwFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoke Wang <xkernel.wang@foxmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        dmitry.baryshkov@linaro.org, greenfoo@u92.eu,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 06/27] drm/msm/disp: check the return value of kzalloc()
Date:   Tue, 19 Apr 2022 14:12:21 -0400
Message-Id: <20220419181242.485308-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit f75e582b0c3ee8f0bddc2248cc8b9175f29c5937 ]

kzalloc() is a memory allocation function which can return NULL when
some internal memory errors happen. So it is better to check it to
prevent potential wrong memory access.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/tencent_B3E19486FF39415098B572B7397C2936C309@qq.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
index cabe15190ec1..369e57f73a47 100644
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
@@ -169,6 +169,8 @@ void msm_disp_snapshot_add_block(struct msm_disp_state *disp_state, u32 len,
 	va_list va;
 
 	new_blk = kzalloc(sizeof(struct msm_disp_state_block), GFP_KERNEL);
+	if (!new_blk)
+		return;
 
 	va_start(va, fmt);
 
-- 
2.35.1

