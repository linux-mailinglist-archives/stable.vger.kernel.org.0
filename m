Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D473173F0B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388764AbfGXTdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388751AbfGXTdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:33:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8551820659;
        Wed, 24 Jul 2019 19:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996781;
        bh=9ji9QypqW4jWQNsf1EAynUSKTtksVznp7CxGOF3dS28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bS8+c7SbbiqWhry2m1hNSOGmWKeAzULaxWXdvLaS7I/iTrPWaioeD1RRVgL9ANaMb
         jSsemFADNMQz3Snr2t4tVChuYfvYFhA6q+H3ws/VaMapPPKQYaR0/0ouLi22mqPzHL
         /fGppzKBagt5h/Mrk+qiV/WpAzJyEGLutSleYr+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 163/413] ALSA: hdac: Fix codec name after machine driver is unloaded and reloaded
Date:   Wed, 24 Jul 2019 21:17:34 +0200
Message-Id: <20190724191746.722753187@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8a5b0177a7f6099ff534a4d9ce72673af5c3cade ]

Currently on each driver reload internal counter is being increased. It
causes failure to enumerate driver devices, as they have hardcoded:
.codec_name = "ehdaudio0D2",
As there is currently no devices with multiple hda codecs and there is
currently no established way to reliably differentiate, between them,
always assign bus->idx = 0;

This fixes a problem when we unload and reload machine driver idx gets
incremented, so .codec_name would've needed to be set to "ehdaudio1D2"
after first reload and so on.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/ext/hdac_ext_bus.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/hda/ext/hdac_ext_bus.c b/sound/hda/ext/hdac_ext_bus.c
index a3a113ef5d56..4f9f1d2a2ec5 100644
--- a/sound/hda/ext/hdac_ext_bus.c
+++ b/sound/hda/ext/hdac_ext_bus.c
@@ -85,7 +85,6 @@ int snd_hdac_ext_bus_init(struct hdac_bus *bus, struct device *dev,
 			const struct hdac_ext_bus_ops *ext_ops)
 {
 	int ret;
-	static int idx;
 
 	/* check if io ops are provided, if not load the defaults */
 	if (io_ops == NULL)
@@ -96,7 +95,12 @@ int snd_hdac_ext_bus_init(struct hdac_bus *bus, struct device *dev,
 		return ret;
 
 	bus->ext_ops = ext_ops;
-	bus->idx = idx++;
+	/* FIXME:
+	 * Currently only one bus is supported, if there is device with more
+	 * buses, bus->idx should be greater than 0, but there needs to be a
+	 * reliable way to always assign same number.
+	 */
+	bus->idx = 0;
 	bus->cmd_dma_state = true;
 
 	return 0;
-- 
2.20.1



