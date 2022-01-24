Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA2E499792
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448771AbiAXVNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59520 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446237AbiAXVHn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF593B810BD;
        Mon, 24 Jan 2022 21:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C51C36AF6;
        Mon, 24 Jan 2022 21:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058460;
        bh=W2fz6Dp5kFEdezSW4eSWeBiIQQYuoPrdjPWyRGEBVoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h25Yy9axh02KWLN9IVDnOLAt1UKJtW8GSUu9VFJBVfPgfbXrFh+bdIPSzD/DIbuFK
         XZVt2Sock1wEzIZdk0lpauuqELMe1GrlsoaBMNmAtavnsuUICOaBk/O9mzvETN6EJO
         XvavEWDuE+3CEbraHm/8AlpduX3I3Oo27J5P884s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0295/1039] drm/msm/dpu: fix safe status debugfs file
Date:   Mon, 24 Jan 2022 19:34:44 +0100
Message-Id: <20220124184135.206087473@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f31b0e24d31e18b4503eeaf0032baeacc0beaff6 ]

Make safe_status debugfs fs file actually return safe status rather than
danger status data.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20211201222633.2476780-3-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index a15b264282809..d25d18a0084d9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -73,8 +73,8 @@ static int _dpu_danger_signal_status(struct seq_file *s,
 					&status);
 	} else {
 		seq_puts(s, "\nSafe signal status:\n");
-		if (kms->hw_mdp->ops.get_danger_status)
-			kms->hw_mdp->ops.get_danger_status(kms->hw_mdp,
+		if (kms->hw_mdp->ops.get_safe_status)
+			kms->hw_mdp->ops.get_safe_status(kms->hw_mdp,
 					&status);
 	}
 	pm_runtime_put_sync(&kms->pdev->dev);
-- 
2.34.1



