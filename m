Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341FB20C8D0
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 17:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgF1Pwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 11:52:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726002AbgF1Pwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 11:52:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593359559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tup3JNhnMrSyWfFhwMz3iwoU167e7gBF13OGzA9K/z8=;
        b=QDplHabpasZw3CQh1mGa2ehv4egkarWEn/iTdQwYk0vM5zmKtotq/IOpDTGBnFPSdip7jV
        kDmk6YoJsOycguYwaP9V1Wnsx2RsNNDC9VZmL6K9v+7Q3kSimhE0c9sQeHBPb3lm8nfyk2
        0GIAofrJ6+G/iboIcviF8E0vdfTA7to=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-wmrIUZHTO2G7hDKsI0Aipg-1; Sun, 28 Jun 2020 11:52:38 -0400
X-MC-Unique: wmrIUZHTO2G7hDKsI0Aipg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6921D107ACCD;
        Sun, 28 Jun 2020 15:52:36 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-41.ams2.redhat.com [10.36.112.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8CAD1944D;
        Sun, 28 Jun 2020 15:52:34 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 1/6] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S 2 channel
Date:   Sun, 28 Jun 2020 17:52:26 +0200
Message-Id: <20200628155231.71089-2-hdegoede@redhat.com>
In-Reply-To: <20200628155231.71089-1-hdegoede@redhat.com>
References: <20200628155231.71089-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1786723
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 sound/soc/intel/boards/cht_bsw_rt5672.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/sound/soc/intel/boards/cht_bsw_rt5672.c b/sound/soc/intel/boards/cht_bsw_rt5672.c
index 7a43c70a1378..22e432768edb 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5672.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5672.c
@@ -253,21 +253,20 @@ static int cht_codec_fixup(struct snd_soc_pcm_runtime *rtd,
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
 
-- 
2.26.2

