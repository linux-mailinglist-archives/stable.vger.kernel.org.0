Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FEA408FCF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbhIMNqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243756AbhIMNoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3BE7610CE;
        Mon, 13 Sep 2021 13:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539884;
        bh=TgCLmv4iU0PqBKcaK82CjsboDReFW42E1rXJzrpRNE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lagLPWmaa+44zf7xO1VnKzH7Z+sY+ZsfQ1r/MsDHZZEnNJy+4xEMjoFYC5UCo6JcH
         o/hdJ535STPRv3H7qEdTkP4bepBG3yWFJUoxCR3xs41HqsHDCrutojj0YBrLl8yh3H
         Clgg/kj4liiRQyUmCx/FnRZloWD0XtJwKxKFCjBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/236] ASoC: wcd9335: Fix a memory leak in the error handling path of the probe function
Date:   Mon, 13 Sep 2021 15:15:03 +0200
Message-Id: <20210913131107.119091402@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit fc6fc81caa63900cef9ebb8b2e365c3ed5a9effb ]

If 'wcd9335_setup_irqs()' fails, me must release the memory allocated in
'wcd_clsh_ctrl_alloc()', as already done in the remove function.

Add an error handling path and the missing 'wcd_clsh_ctrl_free()' call.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-Id: <6dc12372f09fabb70bf05941dbe6a1382dc93e43.1629091028.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 0b7aae5cc783..7f758728f403 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -4844,6 +4844,7 @@ static void wcd9335_codec_init(struct snd_soc_component *component)
 static int wcd9335_codec_probe(struct snd_soc_component *component)
 {
 	struct wcd9335_codec *wcd = dev_get_drvdata(component->dev);
+	int ret;
 	int i;
 
 	snd_soc_component_init_regmap(component, wcd->regmap);
@@ -4861,7 +4862,15 @@ static int wcd9335_codec_probe(struct snd_soc_component *component)
 	for (i = 0; i < NUM_CODEC_DAIS; i++)
 		INIT_LIST_HEAD(&wcd->dai[i].slim_ch_list);
 
-	return wcd9335_setup_irqs(wcd);
+	ret = wcd9335_setup_irqs(wcd);
+	if (ret)
+		goto free_clsh_ctrl;
+
+	return 0;
+
+free_clsh_ctrl:
+	wcd_clsh_ctrl_free(wcd->clsh_ctrl);
+	return ret;
 }
 
 static void wcd9335_codec_remove(struct snd_soc_component *comp)
-- 
2.30.2



