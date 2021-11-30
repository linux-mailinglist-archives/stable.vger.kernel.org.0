Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0644637BF
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242821AbhK3Ozp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:55:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48072 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243124AbhK3OyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FC1FB81A58;
        Tue, 30 Nov 2021 14:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3866C53FCD;
        Tue, 30 Nov 2021 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283854;
        bh=askHQZC0W79e5jCS/bMEBre5DvmcTh/+I9+Rqtlm5cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4n+KqVTN0RiWzi/xpNyg1adME/Y2nMfTV9UNwfH+XtI2pkYzf3TXXlwB33vxxWZB
         zRosqzRX116Ea7GLMIZwlxxYgSW2DAWwebs1Cin+Txt6bD46LGKpxIUo9NQaX8zaPK
         xm76QFEjv94NKacoxnPigaziI6GY0zVEbZYd+EqBQXOm8iLXWb0Btjz8FxJwwZoQVz
         +HrFFUBFu0UmqzbgT0q5SBK8SD860k20JNCbyEZzG5YFvy4VQ577+PfWr4z1JMblTj
         2uiKvFs5z9Wo6bIFGDpXXak0dKAquYn759/r9vIKnAXZbsw9fqtk8T3Mo96q6edZBu
         JsiTNpiLQsrxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bgoswami@codeaurora.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        stephan@gerhold.net, ultracoolguy@disroot.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 10/43] ASoC: qdsp6: q6routing: validate port id before setting up route
Date:   Tue, 30 Nov 2021 09:49:47 -0500
Message-Id: <20211130145022.945517-10-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
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
index 0a6b9433f6acf..81fd2c7bdd1b1 100644
--- a/sound/soc/qcom/qdsp6/q6routing.c
+++ b/sound/soc/qcom/qdsp6/q6routing.c
@@ -368,6 +368,12 @@ int q6routing_stream_open(int fedai_id, int perf_mode,
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

