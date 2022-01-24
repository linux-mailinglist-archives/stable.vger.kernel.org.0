Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF87049943E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388856AbiAXUkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387016AbiAXUgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2227C061793;
        Mon, 24 Jan 2022 11:49:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FB57B81229;
        Mon, 24 Jan 2022 19:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE97C340E7;
        Mon, 24 Jan 2022 19:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053766;
        bh=55bT+W5IzbYWV6wdiB5BwYZCsiDz0MdjVCXygfKPdB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n659OKQRGgFzuMsMAJ39JA6HNKSR3qWvoYrZxPTyUWyUtxNy13J5xZAy1p5/u0VxU
         +2cm6akxyzqSrKb4mNlItlhF/eJNj2D6LQ+yJrQFCkBWJZ/EL7KNNGABxePpEtEX4M
         YXo4nYX8jwdfkafKQiMYFiImVml+K9Rz089TecXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/563] drm/msm/dpu: fix safe status debugfs file
Date:   Mon, 24 Jan 2022 19:38:54 +0100
Message-Id: <20220124184030.256612367@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index b4a2e8eb35dd2..08e082d0443af 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -71,8 +71,8 @@ static int _dpu_danger_signal_status(struct seq_file *s,
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



