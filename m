Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC9914BA75
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgA1Oit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729903AbgA1OSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:18:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 960D021739;
        Tue, 28 Jan 2020 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221087;
        bh=PcEUpSz1l1Agv5M26s4TsmTinViyWnuAaUguPsE67hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdfxLvyo5ydQ1MqRABImDWxb/WVijjgwbJ8c6USlokFbO283lbCsPdus39K6hdbUp
         nx+xVxNXTZ7S7kv4r1LQfWZkNdkV/ZIXhVhsO9JZDyF2qQ3VMhuJtGHRj9XBIOhZt9
         8hdYyndMyTuREJzdfEJoAGoucE1Z+Wczf9NmQF7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Lai <plai@codeaurora.org>,
        Banajit Goswami <bgoswami@codeaurora.org>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 084/271] ASoC: qcom: Fix of-node refcount unbalance in apq8016_sbc_parse_of()
Date:   Tue, 28 Jan 2020 15:03:53 +0100
Message-Id: <20200128135858.823917481@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8d1667200850f8753c0265fa4bd25c9a6e5f94ce ]

The apq8016 driver leaves the of-node refcount at aborting from the
loop of for_each_child_of_node() in the error path.  Not only the
iterator node of for_each_child_of_node(), the children nodes referred
from it for codec and cpu have to be properly unreferenced.

Fixes: bdb052e81f62 ("ASoC: qcom: add apq8016 sound card support")
Cc: Patrick Lai <plai@codeaurora.org>
Cc: Banajit Goswami <bgoswami@codeaurora.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/apq8016_sbc.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/sound/soc/qcom/apq8016_sbc.c b/sound/soc/qcom/apq8016_sbc.c
index 07f91e918b234..754742018515a 100644
--- a/sound/soc/qcom/apq8016_sbc.c
+++ b/sound/soc/qcom/apq8016_sbc.c
@@ -114,13 +114,15 @@ static struct apq8016_sbc_data *apq8016_sbc_parse_of(struct snd_soc_card *card)
 
 		if (!cpu || !codec) {
 			dev_err(dev, "Can't find cpu/codec DT node\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto error;
 		}
 
 		link->cpu_of_node = of_parse_phandle(cpu, "sound-dai", 0);
 		if (!link->cpu_of_node) {
 			dev_err(card->dev, "error getting cpu phandle\n");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto error;
 		}
 
 		link->codec_of_node = of_parse_phandle(codec, "sound-dai", 0);
@@ -132,28 +134,37 @@ static struct apq8016_sbc_data *apq8016_sbc_parse_of(struct snd_soc_card *card)
 		ret = snd_soc_of_get_dai_name(cpu, &link->cpu_dai_name);
 		if (ret) {
 			dev_err(card->dev, "error getting cpu dai name\n");
-			return ERR_PTR(ret);
+			goto error;
 		}
 
 		ret = snd_soc_of_get_dai_name(codec, &link->codec_dai_name);
 		if (ret) {
 			dev_err(card->dev, "error getting codec dai name\n");
-			return ERR_PTR(ret);
+			goto error;
 		}
 
 		link->platform_of_node = link->cpu_of_node;
 		ret = of_property_read_string(np, "link-name", &link->name);
 		if (ret) {
 			dev_err(card->dev, "error getting codec dai_link name\n");
-			return ERR_PTR(ret);
+			goto error;
 		}
 
 		link->stream_name = link->name;
 		link->init = apq8016_sbc_dai_init;
 		link++;
+
+		of_node_put(cpu);
+		of_node_put(codec);
 	}
 
 	return data;
+
+ error:
+	of_node_put(np);
+	of_node_put(cpu);
+	of_node_put(codec);
+	return ERR_PTR(ret);
 }
 
 static const struct snd_soc_dapm_widget apq8016_sbc_dapm_widgets[] = {
-- 
2.20.1



