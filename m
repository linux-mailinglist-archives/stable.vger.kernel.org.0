Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4BA6BB320
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbjCOMlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbjCOMlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:41:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37F137B77
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BEF961D51
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA86BC433D2;
        Wed, 15 Mar 2023 12:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884021;
        bh=nqhR3mpv+AU20TvA87+nnSSgc1mh4H+MzIHnAgVfiAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0iLBboNoMXWxZIuJrVlRmmVpbNT6ztTzSuLE6g3ChT4R91Fsf5OYkIOgrke8UVl8
         ZdE1bZVWegd/sIxkRwQwdWv9lY+494MkxfwFtzbE/xQMkuaA+ixVTQwYs83ya11nxe
         9xZvqhIjRDsA672YHFVOPW+Qf8c8cgmgyyuTE0yU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 077/141] drm/msm/disp/dpu: fix sc7280_pp base offset
Date:   Wed, 15 Mar 2023 13:13:00 +0100
Message-Id: <20230315115742.312168682@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit ce68153edb5b36ddf87a19ed5a85131498690bbf ]

At sc7280, pingpong block is used to management the dither effects
to reduce distortion at panel. Currently pingpong-0 base offset is
wrongly set at 0x59000. This mistake will not cause system to crash.
However it will make dither not work. This patch correct sc7280 ping
pong-0 block base offset.

Changes in v2:
-- add more details info n regrading of pingpong block at commit text

Fixes: 591e34a091d1 ("drm/msm/disp/dpu1: add support for display for SC7280 target")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/524332/
Link: https://lore.kernel.org/r/1677533800-3125-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index a5268207ab1fe..e8a217d242ca7 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -1216,7 +1216,7 @@ static const struct dpu_pingpong_cfg sm8150_pp[] = {
 };
 
 static const struct dpu_pingpong_cfg sc7280_pp[] = {
-	PP_BLK("pingpong_0", PINGPONG_0, 0x59000, 0, sc7280_pp_sblk, -1, -1),
+	PP_BLK("pingpong_0", PINGPONG_0, 0x69000, 0, sc7280_pp_sblk, -1, -1),
 	PP_BLK("pingpong_1", PINGPONG_1, 0x6a000, 0, sc7280_pp_sblk, -1, -1),
 	PP_BLK("pingpong_2", PINGPONG_2, 0x6b000, 0, sc7280_pp_sblk, -1, -1),
 	PP_BLK("pingpong_3", PINGPONG_3, 0x6c000, 0, sc7280_pp_sblk, -1, -1),
-- 
2.39.2



