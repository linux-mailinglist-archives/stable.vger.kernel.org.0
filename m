Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1835C463728
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbhK3Ov4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbhK3OvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5A8C061748;
        Tue, 30 Nov 2021 06:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 209A0B819E7;
        Tue, 30 Nov 2021 14:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB38CC53FCF;
        Tue, 30 Nov 2021 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283678;
        bh=1pNQ+60EcBJZgMSHUy+cmbnowyPvPxR5LTtFNKojRWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USG8OCWZArILxPfYyNYpPFPIAV9f9JcHFmnxSeJhFn0CfANYvs1H3PLIIecaA/YCG
         rNwX3yeRPhp+m/uQr22roXjsyb8MAvqOeUmjGcBeTrIj4qjbpN99u4w087clmDPx5W
         +JjtjKkF4bL8Ac2+CKjLJ8yIJqhWoMLELv4rw6fTXWkDi4kvJiW/eWU8hZCfMFK3Xg
         /lFCDSVaqBGiXQBzmXsV1niacnkokB8IHX+EXZGqHOYp5gWQFuvYewv1COSXBWfgph
         HUhN9OYtNdW0SFhhWrOsrUmTn2xNz04IPN+LE8gzVX9CLEvh/Y36OAxyTb+B0JGVKA
         BHlrQkdXp5u4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bgoswami@codeaurora.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        stephan@gerhold.net, ultracoolguy@disroot.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 15/68] ASoC: qdsp6: q6routing: validate port id before setting up route
Date:   Tue, 30 Nov 2021 09:46:11 -0500
Message-Id: <20211130144707.944580-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 6712c2e18c06b0976559fd4bd47774b243038e9c ]

Validate port id before it starts sending commands to dsp this would
make error handling simpler.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20211116114721.12517-6-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6routing.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/qcom/qdsp6/q6routing.c b/sound/soc/qcom/qdsp6/q6routing.c
index 3390ebef9549d..ff81553b13362 100644
--- a/sound/soc/qcom/qdsp6/q6routing.c
+++ b/sound/soc/qcom/qdsp6/q6routing.c
@@ -372,6 +372,12 @@ int q6routing_stream_open(int fedai_id, int perf_mode,
 	}
 
 	session = &routing_data->sessions[stream_id - 1];
+	if (session->port_id < 0) {
+		dev_err(routing_data->dev, "Routing not setup for MultiMedia%d Session\n",
+			session->fedai_id);
+		return -EINVAL;
+	}
+
 	pdata = &routing_data->port_data[session->port_id];
 
 	mutex_lock(&routing_data->lock);
-- 
2.33.0

