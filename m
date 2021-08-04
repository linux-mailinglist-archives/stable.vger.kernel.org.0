Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82643DFE32
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 11:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhHDJlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 05:41:23 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:10843 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbhHDJlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 05:41:22 -0400
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 04 Aug 2021 02:41:10 -0700
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 04 Aug 2021 02:41:08 -0700
X-QCInternal: smtphost
Received: from kalyant-linux.qualcomm.com ([10.204.66.210])
  by ironmsg02-blr.qualcomm.com with ESMTP; 04 Aug 2021 15:10:31 +0530
Received: by kalyant-linux.qualcomm.com (Postfix, from userid 94428)
        id 244B54C65; Wed,  4 Aug 2021 02:40:30 -0700 (PDT)
From:   Kalyan Thota <kalyan_t@codeaurora.org>
To:     dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, devicetree@vger.kernel.org
Cc:     Kalyan Thota <kalyan_t@codeaurora.org>,
        linux-kernel@vger.kernel.org, robdclark@gmail.com,
        dianders@chromium.org, mkrishn@codeaurora.org,
        saiprakash.ranjan@codeaurora.org, rnayak@codeaurora.org,
        stable@vger.kernel.org
Subject: [Resend v3] drm/msm/disp/dpu1: add safe lut config in dpu driver
Date:   Wed,  4 Aug 2021 02:40:28 -0700
Message-Id: <1628070028-2616-1-git-send-email-kalyan_t@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add safe lut configuration for all the targets in dpu
driver as per QOS recommendation.

Issue reported on SC7280:

With wait-for-safe feature in smmu enabled, RT client
buffer levels are checked to be safe before smmu invalidation.
Since display was always set to unsafe it was delaying the
invalidaiton process thus impacting the performance on NRT clients
such as eMMC and NVMe.

Validated this change on SC7280, With this change eMMC performance
has improved significantly.

Changes in v2:
- Add fixes tag (Sai)
- CC stable kernel (Dimtry)

Changes in v3:
- Correct fixes tag with appropriate hash (stephen)
- Resend patch adding reviewed by tag
- Resend patch adding correct format for pushing into stable tree (Greg)

Fixes: 591e34a091d1 ("drm/msm/disp/dpu1: add support for display for SC7280 target")
Cc: stable@vger.kernel.org
Signed-off-by: Kalyan Thota <kalyan_t@codeaurora.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org> (sc7280, sc7180)
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index d01c4c9..2e482cd 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -974,6 +974,7 @@ static const struct dpu_perf_cfg sdm845_perf_data = {
 	.amortizable_threshold = 25,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sdm845_qos_linear),
 		.entries = sdm845_qos_linear
@@ -1001,6 +1002,7 @@ static const struct dpu_perf_cfg sc7180_perf_data = {
 	.min_dram_ib = 1600000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xff, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_linear),
 		.entries = sc7180_qos_linear
@@ -1028,6 +1030,7 @@ static const struct dpu_perf_cfg sm8150_perf_data = {
 	.min_dram_ib = 800000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff8, 0xf000, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sm8150_qos_linear),
 		.entries = sm8150_qos_linear
@@ -1056,6 +1059,7 @@ static const struct dpu_perf_cfg sm8250_perf_data = {
 	.min_dram_ib = 800000,
 	.min_prefill_lines = 35,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_linear),
 		.entries = sc7180_qos_linear
@@ -1084,6 +1088,7 @@ static const struct dpu_perf_cfg sc7280_perf_data = {
 	.min_dram_ib = 1600000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xffff, 0xffff, 0x0},
+	.safe_lut_tbl = {0xff00, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_macrotile),
 		.entries = sc7180_qos_macrotile
-- 
2.7.4

