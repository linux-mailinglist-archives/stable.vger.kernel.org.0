Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B806BB2AE
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbjCOMiD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjCOMhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:37:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DBEA0B02
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8576E61D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C57DC433D2;
        Wed, 15 Mar 2023 12:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883740;
        bh=zOkZ0Qt3ypqKG3Ynxn0s+Eno8eY4IY2xUM6CsyMOplk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4VX1zxAyL6MEdkgwArKWb8MkonBo09s8HDGXqLawkp+LqP+fGtV9QPf5dzUUftcu
         INHpSkzxNxx1oAanRAs30HOug3gKrozS0U8NBuuQ4JGLATUXumJFENQF1wwV2OvQ8n
         4JLpqyrQzi2SJqNBdcIe7n2wMlfgknRi2ktYOdPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kalyan Thota <quic_kalyant@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/143] drm/msm/dpu: clear DSPP reservations in rm release
Date:   Wed, 15 Mar 2023 13:12:50 +0100
Message-Id: <20230315115743.088302327@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalyan Thota <quic_kalyant@quicinc.com>

[ Upstream commit 5ec498ba86550909f2611b07087d57a71a78c336 ]

Clear DSPP reservations from the global state during
rm release

Fixes: e47616df008b ("drm/msm/dpu: add support for color processing blocks in dpu driver")
Signed-off-by: Kalyan Thota <quic_kalyant@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/522443/
Link: https://lore.kernel.org/r/1676286704-818-2-git-send-email-quic_kalyant@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
index 7ada957adbbb8..58abf5fe97e20 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
@@ -572,6 +572,8 @@ void dpu_rm_release(struct dpu_global_state *global_state,
 		ARRAY_SIZE(global_state->ctl_to_enc_id), enc->base.id);
 	_dpu_rm_clear_mapping(global_state->dsc_to_enc_id,
 		ARRAY_SIZE(global_state->dsc_to_enc_id), enc->base.id);
+	_dpu_rm_clear_mapping(global_state->dspp_to_enc_id,
+		ARRAY_SIZE(global_state->dspp_to_enc_id), enc->base.id);
 }
 
 int dpu_rm_reserve(
-- 
2.39.2



