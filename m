Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AE823529
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390729AbfETMd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390722AbfETMd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:33:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 395A320815;
        Mon, 20 May 2019 12:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355607;
        bh=wI8M121d5OZgG4ozQagejJWER3HiOPI7D/6+JpXvypQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+0DRgBj+JzlYKjJETJBj7N1bMfyIDsdgCOptA9hHeP/ad5Zj63AWuS9am1670uCh
         EN4+RAEWE+qgEEOlzdsiac1zflcbq+HOUbGwp82OiawcNx/f7c+8+FLyDXVrmhEV+G
         WRSy3ucNNZaI7WCB2v1HZhmRI80jThtj+vv7rluU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libin Yang <libin.yang@intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.1 057/128] ASoC: codec: hdac_hdmi add device_link to card device
Date:   Mon, 20 May 2019 14:14:04 +0200
Message-Id: <20190520115253.638695239@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Libin Yang <libin.yang@intel.com>

commit 01c8327667c249818d3712c3e25c7ad2aca7f389 upstream.

In resume from S3, HDAC HDMI codec driver dapm event callback may be
operated before HDMI codec driver turns on the display audio power
domain because of the contest between display driver and hdmi codec driver.

This patch adds the device_link between soc card device (consumer) and
hdmi codec device (supplier) to make sure the sequence is always correct.

Signed-off-by: Libin Yang <libin.yang@intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/hdac_hdmi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -1855,6 +1855,17 @@ static int hdmi_codec_probe(struct snd_s
 	hdmi->card = dapm->card->snd_card;
 
 	/*
+	 * Setup a device_link between card device and HDMI codec device.
+	 * The card device is the consumer and the HDMI codec device is
+	 * the supplier. With this setting, we can make sure that the audio
+	 * domain in display power will be always turned on before operating
+	 * on the HDMI audio codec registers.
+	 * Let's use the flag DL_FLAG_AUTOREMOVE_CONSUMER. This can make
+	 * sure the device link is freed when the machine driver is removed.
+	 */
+	device_link_add(component->card->dev, &hdev->dev, DL_FLAG_RPM_ACTIVE |
+			DL_FLAG_AUTOREMOVE_CONSUMER);
+	/*
 	 * hdac_device core already sets the state to active and calls
 	 * get_noresume. So enable runtime and set the device to suspend.
 	 */


