Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DA343A021
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhJYT1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235226AbhJYTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23F0A60F70;
        Mon, 25 Oct 2021 19:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189747;
        bh=5eom8NlZLabZLJh/uza/J8ZttkYQ4oSOl0sUK6XhPQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzqVF8Xv117uu54ZFXUAYy5OaRiHsPfng4lYScEFmqnJKikTmMu2C+d+VbUZQoonE
         c6IjNY3QfbjW5qt5g8aLvRc/CYmDm5Piaj1EXI2+dFkIWjVTv/0o3p7aO4WwMxdhFW
         WTpjC0ipOFP3Q5HdonaY4ro6NlOyMkGDC7dle1qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4.14 16/30] ASoC: DAPM: Fix missing kctl change notifications
Date:   Mon, 25 Oct 2021 21:14:36 +0200
Message-Id: <20211025190926.890741543@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5af82c81b2c49cfb1cad84d9eb6eab0e3d1c4842 upstream.

The put callback of a kcontrol is supposed to return 1 when the value
is changed, and this will be notified to user-space.  However, some
DAPM kcontrols always return 0 (except for errors), hence the
user-space misses the update of a control value.

This patch corrects the behavior by properly returning 1 when the
value gets updated.

Reported-and-tested-by: Hans de Goede <hdegoede@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20211006141712.2439-1-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-dapm.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2495,6 +2495,7 @@ static int snd_soc_dapm_set_pin(struct s
 				const char *pin, int status)
 {
 	struct snd_soc_dapm_widget *w = dapm_find_widget(dapm, pin, true);
+	int ret = 0;
 
 	dapm_assert_locked(dapm);
 
@@ -2507,13 +2508,14 @@ static int snd_soc_dapm_set_pin(struct s
 		dapm_mark_dirty(w, "pin configuration");
 		dapm_widget_invalidate_input_paths(w);
 		dapm_widget_invalidate_output_paths(w);
+		ret = 1;
 	}
 
 	w->connected = status;
 	if (status == 0)
 		w->force = 0;
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -3441,14 +3443,15 @@ int snd_soc_dapm_put_pin_switch(struct s
 {
 	struct snd_soc_card *card = snd_kcontrol_chip(kcontrol);
 	const char *pin = (const char *)kcontrol->private_value;
+	int ret;
 
 	if (ucontrol->value.integer.value[0])
-		snd_soc_dapm_enable_pin(&card->dapm, pin);
+		ret = snd_soc_dapm_enable_pin(&card->dapm, pin);
 	else
-		snd_soc_dapm_disable_pin(&card->dapm, pin);
+		ret = snd_soc_dapm_disable_pin(&card->dapm, pin);
 
 	snd_soc_dapm_sync(&card->dapm);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_put_pin_switch);
 
@@ -3824,7 +3827,7 @@ static int snd_soc_dapm_dai_link_put(str
 
 	w->params_select = ucontrol->value.enumerated.item[0];
 
-	return 0;
+	return 1;
 }
 
 int snd_soc_dapm_new_pcm(struct snd_soc_card *card,


