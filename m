Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5B46381B
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243686AbhK3O6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:58:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50034 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243050AbhK3O4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:56:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97BE7B81A3D;
        Tue, 30 Nov 2021 14:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF31C53FC7;
        Tue, 30 Nov 2021 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283971;
        bh=eHm3/0AdxWr5tIKBQI2fRkronTffXkuGvZxWgCOEYl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jV55h4hbTlFCzPHcgVgkAM35yyI3qukNkl2LqRIn0/JWJ2fjqPSrIw2tnVepOt/jt
         vXcFobEk5aHDpitVxR9iHpS9Er2DiWp1bSPFrE2JUa6UITk5ujjKviGMcyhCjtIiTj
         XCUv6W/AzdIp/6TOqraS+v+tbTskzzLdwPk0iLkt82hPrPk8VymIOYKV7wajWEEgzv
         OhxNVbmJGTThi9ivbpbLKzE2eqpvhivz+aVvj/KIyD7nlqNXP247myQUVBTwR5TuH2
         UaWpe7kvzQWCn7e7RjQNd413mKPDNBFLP8aMKUK0PrfMrPI83nlFgU6bLE3m2j6Uop
         0O6nKvhVj/mPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bgoswami@codeaurora.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        stephan@gerhold.net, ultracoolguy@disroot.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 03/17] ASoC: qdsp6: q6routing: validate port id before setting up route
Date:   Tue, 30 Nov 2021 09:52:27 -0500
Message-Id: <20211130145243.946407-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145243.946407-1-sashal@kernel.org>
References: <20211130145243.946407-1-sashal@kernel.org>
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
index 44eee18c658ae..a5bc7a60d119e 100644
--- a/sound/soc/qcom/qdsp6/q6routing.c
+++ b/sound/soc/qcom/qdsp6/q6routing.c
@@ -320,6 +320,12 @@ int q6routing_stream_open(int fedai_id, int perf_mode,
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

