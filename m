Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A6F1FDB70
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgFRBLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbgFRBLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8CD52193E;
        Thu, 18 Jun 2020 01:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442696;
        bh=0eBh3Q0tasAH7NSrRJtTwSQ5nfxknCIIN9MpMfO0/s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ttkk8bVjQQqyiBSXCxF+CrK8y1zH86ml/MT0ib/nNIoC+fyvgvGLUbbX4F9BgkO0g
         5E/bDE+Vedv9rvbaP8nByj4pnZeHhS30JmeyGc+Cc3eZEQi2q2q9dxYDM18a1e9ndJ
         55rn9hv+dXImzqMKzZIC9D5170Gz4smveLzMzods=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 160/388] ASoC: SOF: Update correct LED status at the first time usage of update_mute_led()
Date:   Wed, 17 Jun 2020 21:04:17 -0400
Message-Id: <20200618010805.600873-160-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 49c22696348d6e7c8a2ecfd7e60fddfe188ded82 ]

At the first time update_mute_led() gets called, if channels are already
muted, the temp value equals to led_value as 0, skipping the following
LED setting.

So set led_value to -1 as an uninitialized state, to update the correct
LED status at first time usage.

Fixes: 5d43001ae436 ("ASoC: SOF: acpi led support for switch controls")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Acked-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200430091139.7003-1-kai.heng.feng@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/control.c   | 4 ++--
 sound/soc/sof/sof-audio.h | 2 +-
 sound/soc/sof/topology.c  | 2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/control.c b/sound/soc/sof/control.c
index dfc412e2d956..6d63768d42aa 100644
--- a/sound/soc/sof/control.c
+++ b/sound/soc/sof/control.c
@@ -19,8 +19,8 @@ static void update_mute_led(struct snd_sof_control *scontrol,
 			    struct snd_kcontrol *kcontrol,
 			    struct snd_ctl_elem_value *ucontrol)
 {
-	unsigned int temp = 0;
-	unsigned int mask;
+	int temp = 0;
+	int mask;
 	int i;
 
 	mask = 1U << snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
diff --git a/sound/soc/sof/sof-audio.h b/sound/soc/sof/sof-audio.h
index bf65f31af858..875a5fc13297 100644
--- a/sound/soc/sof/sof-audio.h
+++ b/sound/soc/sof/sof-audio.h
@@ -56,7 +56,7 @@ struct snd_sof_pcm {
 struct snd_sof_led_control {
 	unsigned int use_led;
 	unsigned int direction;
-	unsigned int led_value;
+	int led_value;
 };
 
 /* ALSA SOF Kcontrol device */
diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index fe8ba3e05e08..ab2b69de1d4d 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1203,6 +1203,8 @@ static int sof_control_load(struct snd_soc_component *scomp, int index,
 		return ret;
 	}
 
+	scontrol->led_ctl.led_value = -1;
+
 	dobj->private = scontrol;
 	list_add(&scontrol->list, &sdev->kcontrol_list);
 	return ret;
-- 
2.25.1

