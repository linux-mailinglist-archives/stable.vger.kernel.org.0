Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6354469E16
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346679AbhLFPgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44126 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387359AbhLFPbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:31:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 103406132B;
        Mon,  6 Dec 2021 15:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38D0C34901;
        Mon,  6 Dec 2021 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804456;
        bh=mCDQ59W/C1EcTM1MvDCBsEqiPTR7igOsBHdYXHpn4Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRrha+doR2JTD1HAjYw8kdxg8hkwXflaykWtgWb1MkTLaOGFn0D/Vp/+sO/0twBui
         JNJOTXeCFoI+pKkdb55cl96wQB7R/dLdLk/J6i7tXg5oVPpnPaMOxHH2i25SA7s6U9
         ERRJfdPBb5qrIiablNdL34xuhCF6ImZKKAwefm/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Steev Klimaszewski <steev@kali.org>,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/207] drm/msm/devfreq: Fix OPP refcnt leak
Date:   Mon,  6 Dec 2021 15:56:48 +0100
Message-Id: <20211206145615.588611539@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 59ba1b2b4825342676300f66d785764be3fcb093 ]

Reported-by: Douglas Anderson <dianders@chromium.org>
Fixes: 9bc95570175a ("drm/msm: Devfreq tuning")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-By: Steev Klimaszewski <steev@kali.org>
Reviewed-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20211105202021.181092-1-robdclark@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu_devfreq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gpu_devfreq.c b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
index 20006d060b5b5..4ac2a4eb984d8 100644
--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
+++ b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -20,6 +20,10 @@ static int msm_devfreq_target(struct device *dev, unsigned long *freq,
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 	struct dev_pm_opp *opp;
 
+	/*
+	 * Note that devfreq_recommended_opp() can modify the freq
+	 * to something that actually is in the opp table:
+	 */
 	opp = devfreq_recommended_opp(dev, freq, flags);
 
 	/*
@@ -28,6 +32,7 @@ static int msm_devfreq_target(struct device *dev, unsigned long *freq,
 	 */
 	if (gpu->devfreq.idle_freq) {
 		gpu->devfreq.idle_freq = *freq;
+		dev_pm_opp_put(opp);
 		return 0;
 	}
 
-- 
2.33.0



