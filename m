Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C49E1013A2
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfKSF0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbfKSF0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C625E21823;
        Tue, 19 Nov 2019 05:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141160;
        bh=xcYe53B6Y5/aBuFSE0AZhBG0EhSJ7aq0oFLt5lotR4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDwrlHoY+tdqeAOcwQwCNOGPBZrUG1xLAPJ9pWuQUvMihbyasaL/3xEl+cmOw+/Us
         y21YjQfXdwKAlqRmiqcnlhajOea5r8deUog6+5IdHHsRkkVRVuTibACW7pp8gpIXdg
         GLnvKo2dx/W/3ENo3k2zvl3v6Xp80g8JPsjpcRFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/422] ASoC: dapm: Dont fail creating new DAPM control on NULL pinctrl
Date:   Tue, 19 Nov 2019 06:14:23 +0100
Message-Id: <20191119051403.957403191@linuxfoundation.org>
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

[ Upstream commit a5cd7e9cf587f51a84b86c828b4e1c7b392f448e ]

devm_pinctrl_get will only return NULL in the case that pinctrl
is not built into the kernel and all the pinctrl functions used
by the DAPM core are appropriately stubbed for that case. There
is no need to error out of snd_soc_dapm_new_control_unlocked
if pinctrl isn't built into the kernel, so change the
IS_ERR_OR_NULL to just an IS_ERR.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 4ce57510b6236..ff31d9f9ecd64 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3514,7 +3514,7 @@ snd_soc_dapm_new_control_unlocked(struct snd_soc_dapm_context *dapm,
 		break;
 	case snd_soc_dapm_pinctrl:
 		w->pinctrl = devm_pinctrl_get(dapm->dev);
-		if (IS_ERR_OR_NULL(w->pinctrl)) {
+		if (IS_ERR(w->pinctrl)) {
 			ret = PTR_ERR(w->pinctrl);
 			if (ret == -EPROBE_DEFER)
 				return ERR_PTR(ret);
-- 
2.20.1



