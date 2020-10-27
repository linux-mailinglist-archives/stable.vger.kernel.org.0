Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9A729B8BD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801799AbgJ0PoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800012AbgJ0Peh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FCDD22281;
        Tue, 27 Oct 2020 15:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812877;
        bh=yZKDANAqjHaUbsEO+pUzR+Nas7qVqF+qUaoZnfKj3zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4pgLn4Z+ZvNFp9aaxzjfRu6f+gSgapr3TamqO75Pl1ZNepqYj8K5oUxkZwWnuwuC
         6smk/Ky0G09lby6TERYlDuHPOFttDzCqto5sjty//lura/dWRrgwC3oejtl1RX2r4T
         y+ptHYn0EWz0SuD9461YIYsd2Q+Q9ZqKAT5WrtEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Brickman <Adam.Brickman@cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 361/757] ASoC: wm_adsp: Pass full name to snd_ctl_notify
Date:   Tue, 27 Oct 2020 14:50:11 +0100
Message-Id: <20201027135507.508030985@linuxfoundation.org>
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

From: Adam Brickman <Adam.Brickman@cirrus.com>

[ Upstream commit 20441614d89867142060d3bcd79cc111d8ba7a8e ]

A call to wm_adsp_write_ctl() could cause a kernel crash if it
does not retrieve a valid kcontrol from snd_soc_card_get_kcontrol().
This can happen due to a missing control name prefix. Then,
snd_ctl_notify() crashes when it tries to use the id field.

Modified wm_adsp_write_ctl() to incorporate the name_prefix (if applicable)
such that it is able to retrieve a valid id field from the kcontrol
once the platform has booted.

Fixes: eb65ccdb0836 ("ASoC: wm_adsp: Expose mixer control API")
Signed-off-by: Adam Brickman <Adam.Brickman@cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20201001152425.8590-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 410cca57da52d..344bd2c33bea1 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -2049,6 +2049,7 @@ int wm_adsp_write_ctl(struct wm_adsp *dsp, const char *name, int type,
 {
 	struct wm_coeff_ctl *ctl;
 	struct snd_kcontrol *kcontrol;
+	char ctl_name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
 	int ret;
 
 	ctl = wm_adsp_get_ctl(dsp, name, type, alg);
@@ -2059,8 +2060,25 @@ int wm_adsp_write_ctl(struct wm_adsp *dsp, const char *name, int type,
 		return -EINVAL;
 
 	ret = wm_coeff_write_ctrl(ctl, buf, len);
+	if (ret)
+		return ret;
+
+	if (ctl->flags & WMFW_CTL_FLAG_SYS)
+		return 0;
+
+	if (dsp->component->name_prefix)
+		snprintf(ctl_name, SNDRV_CTL_ELEM_ID_NAME_MAXLEN, "%s %s",
+			 dsp->component->name_prefix, ctl->name);
+	else
+		snprintf(ctl_name, SNDRV_CTL_ELEM_ID_NAME_MAXLEN, "%s",
+			 ctl->name);
+
+	kcontrol = snd_soc_card_get_kcontrol(dsp->component->card, ctl_name);
+	if (!kcontrol) {
+		adsp_err(dsp, "Can't find kcontrol %s\n", ctl_name);
+		return -EINVAL;
+	}
 
-	kcontrol = snd_soc_card_get_kcontrol(dsp->component->card, ctl->name);
 	snd_ctl_notify(dsp->component->card->snd_card,
 		       SNDRV_CTL_EVENT_MASK_VALUE, &kcontrol->id);
 
-- 
2.25.1



