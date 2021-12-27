Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5337E480013
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbhL0Pm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbhL0PlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F4DC06173E;
        Mon, 27 Dec 2021 07:39:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBACE610A6;
        Mon, 27 Dec 2021 15:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55EBC36AEA;
        Mon, 27 Dec 2021 15:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619597;
        bh=T+CuL0RIRZVbTifmv/VRAKufeWDUHR5KY3Hn/9usjOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5trgej7qgDS4+BTAXZAm5arMf0eM911dt4gU1M746g+mneMO0lVDTYK9hJcrnRIS
         kdeHfCRj/uUw2g88L8gHDBkwQtD4KnWIQvtMJaUSvLGC/6XaCd8xaDVthkHlgMjJGu
         M/nQCwKdaYQe2u1Ktuqi7rIdujEBtxA/We+jK+/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bradley Scott <bscott@teksavvy.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 37/76] ALSA: hda/realtek: Add new alc285-hp-amp-init model
Date:   Mon, 27 Dec 2021 16:30:52 +0100
Message-Id: <20211227151325.992741963@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bradley Scott <bscott@teksavvy.com>

commit aa72394667e5cea3547e4c41ddff7ca8c632d764 upstream.

Adds a new "alc285-hp-amp-init" model that can be used to apply the ALC285
HP speaker amplifier initialization fixup to devices that are not already
known by passing "hda_model=alc285-hp-amp-init" to the
snd-sof-intel-hda-common module or "model=alc285-hp-amp-init" to the
snd-hda-intel module, depending on which is being used.

Signed-off-by: Bradley Scott <bscott@teksavvy.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211213162246.506838-1-bscott@teksavvy.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sound/hd-audio/models.rst |    2 ++
 sound/pci/hda/patch_realtek.c           |    1 +
 2 files changed, 3 insertions(+)

--- a/Documentation/sound/hd-audio/models.rst
+++ b/Documentation/sound/hd-audio/models.rst
@@ -326,6 +326,8 @@ usi-headset
     Headset support on USI machines
 dual-codecs
     Lenovo laptops with dual codecs
+alc285-hp-amp-init
+    HP laptops which require speaker amplifier initialization (ALC285)
 
 ALC680
 ======
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9061,6 +9061,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP, .name = "alc287-ideapad-bass-spk-amp"},
 	{.id = ALC623_FIXUP_LENOVO_THINKSTATION_P340, .name = "alc623-lenovo-thinkstation-p340"},
 	{.id = ALC255_FIXUP_ACER_HEADPHONE_AND_MIC, .name = "alc255-acer-headphone-and-mic"},
+	{.id = ALC285_FIXUP_HP_GPIO_AMP_INIT, .name = "alc285-hp-amp-init"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


