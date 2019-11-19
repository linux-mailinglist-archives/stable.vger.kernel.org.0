Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE445101404
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfKSF31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbfKSF31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:29:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B1621823;
        Tue, 19 Nov 2019 05:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141365;
        bh=MoWnjBMIgcXTr4l6Fg4FmwAOxh2SjxrlgINqMqRU38o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRGbKPleeb8gM9xdPjx74SJcGq/4lleg5KlyQnIYnkIFTC+B2Mmr7ncgrmnli2IN8
         /XM21MeEZGzFWS9NOK7NMzDud5yPuxravz3L+lxCNgEuUZwisK0t9zAUq9tmIDgxig
         mGC3plFVwL6XxV61CJaz1S8xlCvRmsxrLf4vwqjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/422] ASoC: dapm: Avoid uninitialised variable warning
Date:   Tue, 19 Nov 2019 06:15:31 +0100
Message-Id: <20191119051407.536743205@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit fc269c0396448cabe1afd648c0b335669aa347b7 ]

Commit 4a75aae17b2a ("ASoC: dapm: Add support for multi-CODEC
CODEC to CODEC links") adds loops that iterate over multiple
CODECs in snd_soc_dai_link_event. This also introduced a compiler
warning for a potentially uninitialised variable in the case
no CODECs are present. This should never be the case as the
DAI link must by definition contain at least 1 CODEC however
probably best to avoid the compiler warning by initialising ret
to zero.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index ff31d9f9ecd64..7f0b48b363809 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3684,7 +3684,7 @@ static int snd_soc_dai_link_event(struct snd_soc_dapm_widget *w,
 	struct snd_pcm_hw_params *params = NULL;
 	struct snd_pcm_runtime *runtime = NULL;
 	unsigned int fmt;
-	int ret;
+	int ret = 0;
 
 	if (WARN_ON(!config) ||
 	    WARN_ON(list_empty(&w->edges[SND_SOC_DAPM_DIR_OUT]) ||
-- 
2.20.1



