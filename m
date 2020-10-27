Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A2229B713
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732192AbgJ0P3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798209AbgJ0P0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F82B2064B;
        Tue, 27 Oct 2020 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812395;
        bh=regFFwn/ei+J2u38Oqddb/BPDaWtFhEmyJnAlkbv6os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsi6uYx9URBAuwq9kgwO9wJENFoNh1ri2C6WcKFD/ODirew6PZu1rtY7aHqQvBEFz
         fxclf1/+1lMREk+OE1fPuK5iFWdzuaIYePzmkTo2lccaBWqvHIUsgV/WZJGzSKPgXE
         tSDTHmb2pTP/iTlzhsyLo/KJAU4qKJsow2ZwNX7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit kumar <rohitkr@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 194/757] ASoC: qcom: lpass-platform: fix memory leak
Date:   Tue, 27 Oct 2020 14:47:24 +0100
Message-Id: <20201027135459.707158055@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohit kumar <rohitkr@codeaurora.org>

[ Upstream commit 5fd188215d4eb52703600d8986b22311099a5940 ]

lpass_pcm_data is never freed. Free it in close
ops to avoid memory leak.

Fixes: 022d00ee0b55 ("ASoC: lpass-platform: Fix broken pcm data usage")
Signed-off-by: Rohit kumar <rohitkr@codeaurora.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/1597402388-14112-5-git-send-email-rohitkr@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-platform.c b/sound/soc/qcom/lpass-platform.c
index 01179bc0e5e57..e62ac7e650785 100644
--- a/sound/soc/qcom/lpass-platform.c
+++ b/sound/soc/qcom/lpass-platform.c
@@ -61,7 +61,7 @@ static int lpass_platform_pcmops_open(struct snd_soc_component *component,
 	int ret, dma_ch, dir = substream->stream;
 	struct lpass_pcm_data *data;
 
-	data = devm_kzalloc(soc_runtime->dev, sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -118,6 +118,7 @@ static int lpass_platform_pcmops_close(struct snd_soc_component *component,
 	if (v->free_dma_channel)
 		v->free_dma_channel(drvdata, data->dma_ch);
 
+	kfree(data);
 	return 0;
 }
 
-- 
2.25.1



