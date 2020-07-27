Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D834022EFE6
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgG0OUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731489AbgG0OUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F2620775;
        Mon, 27 Jul 2020 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859607;
        bh=YZnLq741nuBq9qjJB7z7uTuxh27wOPHBavzsDj+frRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJY+g84KCZekxxQCWf2crSo0C2F3sXy3VKAFb9cqUV0+C5mqj2F0GDvnhGzAZ/JFb
         E97mZPUD98b58OBRolq7X3xMIDAxw/GG6V/W25u5QgvI3hQkEyxcc6qLym7HiDWe/z
         0rXQ0P8KaESXa5mkS//faEJHgbqVDmdl7dMyYuAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.7 036/179] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S 2 channel
Date:   Mon, 27 Jul 2020 16:03:31 +0200
Message-Id: <20200727134934.429451982@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 0ceb8a36d023d4bb4ffca3474a452fb1dfaa0ef2 upstream.

The default mode for SSP configuration is TDM 4 slot and so far we were
using this for the bus format on cht-bsw-rt56732 boards.

One board, the Lenovo Miix 2 10 uses not 1 but 2 codecs connected to SSP2.
The second piggy-backed, output-only codec is inside the keyboard-dock
(which has extra speakers). Unlike the main rt5672 codec, we cannot
configure this codec, it is hard coded to use 2 channel 24 bit I2S.

Using 4 channel TDM leads to the dock speakers codec (which listens in on
the data send from the SSP to the rt5672 codec) emiting horribly distorted
sound.

Since we only support 2 channels anyways, there is no need for TDM on any
cht-bsw-rt5672 designs. So we can simply use I2S 2ch everywhere.

This commit fixes the Lenovo Miix 2 10 dock speakers issue by changing
the bus format set in cht_codec_fixup() to I2S 2 channel.

This change has been tested on the following devices with a rt5672 codec:

Lenovo Miix 2 10
Lenovo Thinkpad 8
Lenovo Thinkpad 10 (gen 1)

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1786723
Link: https://lore.kernel.org/r/20200628155231.71089-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/boards/cht_bsw_rt5672.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/sound/soc/intel/boards/cht_bsw_rt5672.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5672.c
@@ -253,21 +253,20 @@ static int cht_codec_fixup(struct snd_so
 	params_set_format(params, SNDRV_PCM_FORMAT_S24_LE);
 
 	/*
-	 * Default mode for SSP configuration is TDM 4 slot
+	 * Default mode for SSP configuration is TDM 4 slot. One board/design,
+	 * the Lenovo Miix 2 10 uses not 1 but 2 codecs connected to SSP2. The
+	 * second piggy-backed, output-only codec is inside the keyboard-dock
+	 * (which has extra speakers). Unlike the main rt5672 codec, we cannot
+	 * configure this codec, it is hard coded to use 2 channel 24 bit I2S.
+	 * Since we only support 2 channels anyways, there is no need for TDM
+	 * on any cht-bsw-rt5672 designs. So we simply use I2S 2ch everywhere.
 	 */
-	ret = snd_soc_dai_set_fmt(asoc_rtd_to_codec(rtd, 0),
-				  SND_SOC_DAIFMT_DSP_B |
-				  SND_SOC_DAIFMT_IB_NF |
+	ret = snd_soc_dai_set_fmt(asoc_rtd_to_cpu(rtd, 0),
+				  SND_SOC_DAIFMT_I2S     |
+				  SND_SOC_DAIFMT_NB_NF   |
 				  SND_SOC_DAIFMT_CBS_CFS);
 	if (ret < 0) {
-		dev_err(rtd->dev, "can't set format to TDM %d\n", ret);
-		return ret;
-	}
-
-	/* TDM 4 slots 24 bit, set Rx & Tx bitmask to 4 active slots */
-	ret = snd_soc_dai_set_tdm_slot(asoc_rtd_to_codec(rtd, 0), 0xF, 0xF, 4, 24);
-	if (ret < 0) {
-		dev_err(rtd->dev, "can't set codec TDM slot %d\n", ret);
+		dev_err(rtd->dev, "can't set format to I2S, err %d\n", ret);
 		return ret;
 	}
 


