Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB522E3CB6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437702AbgL1OF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437696AbgL1OFy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFBB422C9C;
        Mon, 28 Dec 2020 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164313;
        bh=IWbrbmoSWSZ0KfQhmos6beNGwnM6tyUVVHNpCdFWtHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mAU7n97XXXt5OcC8C0qHCZq+OL1eH7WbM8Qd6rQPSoAdn0xNdjxTo4EC8mqyp+1LQ
         Aj6Uo82tSUwZaAQLd2OEQIs7jN3QsRR0591q8REjlmtXr4Hm2tD9PCh/BGcouGBB3M
         SrOxGZYyC2pP73VQovBlaJRku8kTt5But11Q61Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/717] media: venus: put dummy vote on video-mem path after last session release
Date:   Mon, 28 Dec 2020 13:42:14 +0100
Message-Id: <20201228125027.468375360@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

[ Upstream commit eff5ce02e170125936c43ca96c7dc701a86681ed ]

As per current implementation, video driver is unvoting "videom-mem" path
for last video session during vdec_session_release().
While video playback when we try to suspend device, we see video clock
warnings since votes are already removed during vdec_session_release().

corrected this by putting dummy vote on "video-mem" after last video
session release and unvoting it during suspend.

suspend")

Fixes: 07f8f22a33a9e ("media: venus: core: remove CNOC voting while device
Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index a9538c2cc3c9d..2946547a0df4a 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -212,6 +212,16 @@ static int load_scale_bw(struct venus_core *core)
 	}
 	mutex_unlock(&core->lock);
 
+	/*
+	 * keep minimum bandwidth vote for "video-mem" path,
+	 * so that clks can be disabled during vdec_session_release().
+	 * Actual bandwidth drop will be done during device supend
+	 * so that device can power down without any warnings.
+	 */
+
+	if (!total_avg && !total_peak)
+		total_avg = kbps_to_icc(1000);
+
 	dev_dbg(core->dev, VDBGL "total: avg_bw: %u, peak_bw: %u\n",
 		total_avg, total_peak);
 
-- 
2.27.0



