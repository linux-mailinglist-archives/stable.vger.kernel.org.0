Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9F25969A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgIAQEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728401AbgIAPmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:42:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1622206EB;
        Tue,  1 Sep 2020 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974922;
        bh=1N7E8jTdaJiP5AS0s7ssZc9dpyomkdQrUUBLpq3o5w0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dddhBOJdNon7j4CmRT++IbuCxjHU/oYeLes6htWOEDqKHAoudKwElTK49Ck/CUMU+
         q6Bl6My5fXGhWPi+JAqB46B5Jr3a0mpInl5aWG61nxwRMssge3g2gFXz+Zy95Zy3lL
         BweIIs8WaLvbe+O2Fm+PKtOImufFs5jt3x7wp4w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 141/255] ALSA: usb-audio: ignore broken processing/extension unit
Date:   Tue,  1 Sep 2020 17:09:57 +0200
Message-Id: <20200901151007.459879002@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

[ Upstream commit d8d0db7bb358ef65d60726a61bfcd08eccff0bc0 ]

Some devices have broken extension unit where getting current value
doesn't work. Attempt that once when creating mixer control for it. If
it fails, just ignore it, so that it won't cripple the device entirely
(and/or make the error floods).

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
Link: https://lore.kernel.org/r/5f3abc52.1c69fb81.9cf2.fe91@mx.google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index eab0fd4fd7c33..e0b7174c10430 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2367,7 +2367,7 @@ static int build_audio_procunit(struct mixer_build *state, int unitid,
 	int num_ins;
 	struct usb_mixer_elem_info *cval;
 	struct snd_kcontrol *kctl;
-	int i, err, nameid, type, len;
+	int i, err, nameid, type, len, val;
 	const struct procunit_info *info;
 	const struct procunit_value_info *valinfo;
 	const struct usbmix_name_map *map;
@@ -2470,6 +2470,12 @@ static int build_audio_procunit(struct mixer_build *state, int unitid,
 			break;
 		}
 
+		err = get_cur_ctl_value(cval, cval->control << 8, &val);
+		if (err < 0) {
+			usb_mixer_elem_info_free(cval);
+			return -EINVAL;
+		}
+
 		kctl = snd_ctl_new1(&mixer_procunit_ctl, cval);
 		if (!kctl) {
 			usb_mixer_elem_info_free(cval);
-- 
2.25.1



