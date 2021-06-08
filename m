Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5443A0231
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhFHTBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236650AbhFHS6n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:58:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A5261629;
        Tue,  8 Jun 2021 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177786;
        bh=AMWQ/w5E8AQa19L0RESJPij7OIgsmldXTH4+NicuEP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rfueq8KCRraPAjT7mgTwn6gLWHf1K9o/bKXDdA8LeLMuUCo5o4N1LaLGex3B+8Kx+
         r0Gcp5UaWPaHr9Xql14ShU7GWuf6yrKu1CL9Jlj3fIiDFRu5y2ju+WTBm4grkwwRzD
         8sZ+Nh2BiK0jPTiMBV88voJjUUMJIJ22U81moOtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 099/137] ALSA: hda: update the power_state during the direct-complete
Date:   Tue,  8 Jun 2021 20:27:19 +0200
Message-Id: <20210608175945.732154817@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit b8b90c17602689eeaa5b219d104bbc215d1225cc upstream.

The patch_realtek.c needs to check if the power_state.event equals
PM_EVENT_SUSPEND, after using the direct-complete, the suspend() and
resume() will be skipped if the codec is already rt_suspended, in this
case, the patch_realtek.c will always get PM_EVENT_ON even the system
is really resumed from S3.

We could set power_state to PMSG_SUSPEND in the prepare(), if other
PM functions are called before complete(), those functions will
override power_state; if no other PM functions are called before
complete(), we could know the suspend() and resume() are skipped since
only S3 pm functions could be skipped by direct-complete, in this case
set power_state to PMSG_RESUME in the complete(). This could guarantee
the first time of calling hda_codec_runtime_resume() after complete()
has the correct power_state.

Fixes: 215a22ed31a1 ("ALSA: hda: Refactor codec PM to use direct-complete optimization")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20210602145424.3132-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_codec.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2973,6 +2973,7 @@ static int hda_codec_runtime_resume(stru
 #ifdef CONFIG_PM_SLEEP
 static int hda_codec_pm_prepare(struct device *dev)
 {
+	dev->power.power_state = PMSG_SUSPEND;
 	return pm_runtime_suspended(dev);
 }
 
@@ -2980,6 +2981,10 @@ static void hda_codec_pm_complete(struct
 {
 	struct hda_codec *codec = dev_to_hda_codec(dev);
 
+	/* If no other pm-functions are called between prepare() and complete() */
+	if (dev->power.power_state.event == PM_EVENT_SUSPEND)
+		dev->power.power_state = PMSG_RESUME;
+
 	if (pm_runtime_suspended(dev) && (codec->jackpoll_interval ||
 	    hda_codec_need_resume(codec) || codec->forced_resume))
 		pm_request_resume(dev);


