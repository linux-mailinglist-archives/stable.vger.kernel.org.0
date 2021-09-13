Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E544091D9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244900AbhIMOFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:05:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343863AbhIMODr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5E5161165;
        Mon, 13 Sep 2021 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540332;
        bh=H8RVo4VgN59Q67WAfBwme9TNl4me1vWHNdTWUoXZu4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yegKOLMHg5cterVO4OC/FV0iwtYrXOG8Jxh6PkC0wnf8+ogRHgKF5nwv3VgsoAriM
         8wJikXD4z/OAHQgewVMNQVQ9m0MFBEallPTkLcJ3zssOuxIhs8hQCHs/6qyefKBPu4
         FuTf1VN+1m2U6KqQGY4dMFUVFJrFknoFO9SB0WNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 149/300] media: venus: helper: do not set constrained parameters for UBWC
Date:   Mon, 13 Sep 2021 15:13:30 +0200
Message-Id: <20210913131114.428575313@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit 1ac61faf6ebbce59fccbb53d7faf25576e9897ab ]

Plane constraints firmware interface is to override the default
alignment for a given color format. By default venus hardware has
alignments as 128x32, but NV12 was defined differently to meet
various usecases. Compressed NV12 has always been aligned as 128x32,
hence not needed to override the default alignment.

Fixes: bc28936bbba9 ("media: venus: helpers, hfi, vdec: Set actual plane constraints to FW")
Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index b813d6dba481..3a0871f0bea6 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -1138,6 +1138,9 @@ int venus_helper_set_format_constraints(struct venus_inst *inst)
 	if (!IS_V6(inst->core))
 		return 0;
 
+	if (inst->opb_fmt == HFI_COLOR_FORMAT_NV12_UBWC)
+		return 0;
+
 	pconstraint.buffer_type = HFI_BUFFER_OUTPUT2;
 	pconstraint.num_planes = 2;
 	pconstraint.plane_format[0].stride_multiples = 128;
-- 
2.30.2



