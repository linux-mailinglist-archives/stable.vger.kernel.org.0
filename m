Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEFF40E4E8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345167AbhIPRGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348558AbhIPRDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A73961246;
        Thu, 16 Sep 2021 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810044;
        bh=xE+/88MThaiYcrNdODqf4LqOpUydzK6zL+2gdM84GW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T02h9dY7f5HQLZdLeQQdSsa4CSUfBr9t0gsuKT4QSHdGc5ZdNxk/f8FC/p03i+pqR
         tyccFZqxy/RjAVQwsJdy3tqjnVI+tM+HEr1VwICAo82ia3P8FmQaskVOFEo0JdiO1n
         +Krlde8dEOWIQvUv2xIaFaYg7oVo7GiQPrrw7BK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalyan Thota <kalyan_t@codeaurora.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Subject: [PATCH 5.13 377/380] drm/msm/disp/dpu1: add safe lut config in dpu driver
Date:   Thu, 16 Sep 2021 18:02:14 +0200
Message-Id: <20210916155816.871353095@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalyan Thota <kalyan_t@codeaurora.org>

commit 5bccb945f38b2aff334619b23b50bb0a6a9995a5 upstream.

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
Link: https://lore.kernel.org/r/1628070028-2616-1-git-send-email-kalyan_t@codeaurora.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -902,6 +902,7 @@ static const struct dpu_perf_cfg sdm845_
 	.amortizable_threshold = 25,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xf000, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sdm845_qos_linear),
 		.entries = sdm845_qos_linear
@@ -929,6 +930,7 @@ static const struct dpu_perf_cfg sc7180_
 	.min_dram_ib = 1600000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xff, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_linear),
 		.entries = sc7180_qos_linear
@@ -956,6 +958,7 @@ static const struct dpu_perf_cfg sm8150_
 	.min_dram_ib = 800000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff8, 0xf000, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sm8150_qos_linear),
 		.entries = sm8150_qos_linear
@@ -984,6 +987,7 @@ static const struct dpu_perf_cfg sm8250_
 	.min_dram_ib = 800000,
 	.min_prefill_lines = 35,
 	.danger_lut_tbl = {0xf, 0xffff, 0x0},
+	.safe_lut_tbl = {0xfff0, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_linear),
 		.entries = sc7180_qos_linear
@@ -1012,6 +1016,7 @@ static const struct dpu_perf_cfg sc7280_
 	.min_dram_ib = 1600000,
 	.min_prefill_lines = 24,
 	.danger_lut_tbl = {0xffff, 0xffff, 0x0},
+	.safe_lut_tbl = {0xff00, 0xff00, 0xffff},
 	.qos_lut_tbl = {
 		{.nentry = ARRAY_SIZE(sc7180_qos_macrotile),
 		.entries = sc7180_qos_macrotile


