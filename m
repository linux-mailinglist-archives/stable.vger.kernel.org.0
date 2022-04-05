Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90724F3776
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353006AbiDELNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349069AbiDEJtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10345A94F7;
        Tue,  5 Apr 2022 02:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A31615E5;
        Tue,  5 Apr 2022 09:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B852EC385A2;
        Tue,  5 Apr 2022 09:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151587;
        bh=D9X4N7CjniGGLjHiUlduDQRYx7n6Zjs8euUw2wDCyR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Rm32ttEIbYYPiaEsX4YQUeoW0a8uBb9Y8YqSScfYGOedQEWc9VrCoBag+JU6gGsj
         rKtIs03XexKrQ43z6eO2c58H+7YsEYJdsMzYDnHpk5EzjA6/DORu2xTbfBGKazj7Lz
         f7ZdFTtaDj4ome4CYeIDrovGr49sN1n4pyutkjHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/913] drm/msm/dp: stop link training after link training 2 failed
Date:   Tue,  5 Apr 2022 09:25:32 +0200
Message-Id: <20220405070353.943570972@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit 9051d629dbf7a998a40f7eac65a9512b01bc3bb8 ]

Each DP link training contains link training 1 followed by link
training 2.  There is maximum of 5 retries of DP link training
before declared link training failed. It is required to stop link
training at end of link training 2 if it is failed so that next
link training 1 can start freshly. This patch fixes link compliance
test  case 4.3.1.13 (Source Device Link Training EQ Fallback Test).

Changes in v10:
--  group into one series

Changes in v11:
-- drop drm/msm/dp: dp_link_parse_sink_count() return immediately if aux read

Fixes: 2e0adc765d88 ("drm/msm/dp: do not end dp link training until video is ready")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1642531648-8448-5-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 62e75dc8afc6..4af281d97493 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1744,6 +1744,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 				/* end with failure */
 				break; /* lane == 1 already */
 			}
+
+			/* stop link training before start re training  */
+			dp_ctrl_clear_training_pattern(ctrl);
 		}
 	}
 
-- 
2.34.1



