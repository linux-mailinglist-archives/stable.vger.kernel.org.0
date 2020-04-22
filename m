Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191721B429C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgDVLCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgDVKAT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:00:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0A7F20774;
        Wed, 22 Apr 2020 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549619;
        bh=i3Rhkjl2pl8lrpd2bvu8KC/WZTiZaXHdz5AcnTEfjMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yeZFI1/BbdmEHkwUKSsUZ36N35yzF2lU/xKM9uRVLa46EPb5z1uOfAd+LcpO20+yS
         CvY6By2NaErzUolfPjSa+KnPG/UFIYPpmAbrKmapZnrY5Vnn/4i9CPWGj5Q+bXYGjM
         l4a3mE9ar9mWRDzlzhHbZEXliTY3SQK67wYD7jBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 037/100] ALSA: hda: Initialize power_state field properly
Date:   Wed, 22 Apr 2020 11:56:07 +0200
Message-Id: <20200422095029.213822414@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 183ab39eb0ea9879bb68422a83e65f750f3192f0 upstream.

The recent commit 98081ca62cba ("ALSA: hda - Record the current power
state before suspend/resume calls") made the HD-audio driver to store
the PM state in power_state field.  This forgot, however, the
initialization at power up.  Although the codec drivers usually don't
need to refer to this field in the normal operation, let's initialize
it properly for consistency.

Fixes: 98081ca62cba ("ALSA: hda - Record the current power state before suspend/resume calls")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -876,6 +876,7 @@ int snd_hda_codec_new(struct hda_bus *bu
 
 	/* power-up all before initialization */
 	hda_set_power_state(codec, AC_PWRST_D0);
+	codec->core.dev.power.power_state = PMSG_ON;
 
 	snd_hda_codec_proc_new(codec);
 


