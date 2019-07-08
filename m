Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF34622DA
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbfGHP3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389500AbfGHP3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A96821537;
        Mon,  8 Jul 2019 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599776;
        bh=fEV56gnYpPkogzIow6iloZq2JvmolkSAjPoJ9ZYsC2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYGY+mhPmi37zMqSfg7AegEVulzSXUFIH6fongyl8CkNdLq1ZLY6WbifKfE8PwzMv
         mipCRyvkhJiHfa39tEFSHhJRz9OlIrbMUCk434nCaob4jm364fdSXjyKLeBRy87icn
         4KX1Y/KfZXh4UgGfudawW3hUvWPmT97d5VU+tGHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 74/90] ALSA: hda: Initialize power_state field properly
Date:   Mon,  8 Jul 2019 17:13:41 +0200
Message-Id: <20190708150526.070864123@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 183ab39eb0ea9879bb68422a83e65f750f3192f0 ]

The recent commit 98081ca62cba ("ALSA: hda - Record the current power
state before suspend/resume calls") made the HD-audio driver to store
the PM state in power_state field.  This forgot, however, the
initialization at power up.  Although the codec drivers usually don't
need to refer to this field in the normal operation, let's initialize
it properly for consistency.

Fixes: 98081ca62cba ("ALSA: hda - Record the current power state before suspend/resume calls")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 21de8145f1a6..a6233775e779 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -971,6 +971,7 @@ int snd_hda_codec_device_new(struct hda_bus *bus, struct snd_card *card,
 
 	/* power-up all before initialization */
 	hda_set_power_state(codec, AC_PWRST_D0);
+	codec->core.dev.power.power_state = PMSG_ON;
 
 	snd_hda_codec_proc_new(codec);
 
-- 
2.20.1



