Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9F320659F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388596AbgFWUH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387620AbgFWUHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AAEB2064B;
        Tue, 23 Jun 2020 20:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942844;
        bh=kieshNiK2KrhBVzWgfcFix7J1eLM6mLChxPGjbdxttE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXIoZTqVJP7O+MSYJ+I1T8nPjRV8lpJl/lLQoJYdIf9FWY5BNLM19Tr36iqKrDIRG
         58z3mQlbkt3hj3hxRmepfZPh8sFZMvWJQGRMOUC0bJuwt3+MZEDjhGuoo5Xw5cPjuD
         V2VWPHh/Lmrk/dXHLAnG9Ow9iBjszjAlXSTy2Ee8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 157/477] ASoC: SOF: Update correct LED status at the first time usage of update_mute_led()
Date:   Tue, 23 Jun 2020 21:52:34 +0200
Message-Id: <20200623195415.020307515@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index dfc412e2d9565..6d63768d42aa1 100644
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
index bf65f31af8582..875a5fc132970 100644
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
index fe8ba3e05e08b..ab2b69de1d4d7 100644
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



