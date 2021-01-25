Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DFB304A89
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbhAZFFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbhAYSyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2CAF206B2;
        Mon, 25 Jan 2021 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600874;
        bh=A8SHOgM8OLigOYwv2oXxJ5wKlk5EQp96H2iFHeqHHOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQThi/okSKelbxSyiEypjTrLR+lSEX1WBJpgnQxIAhO/bWYwnglo1jHaQXTlMMqTG
         LKW9P1gcnbhOTj1MF92ZRCWGwOyVdz3u6Zu3PZI+xfWrO+BQrs/a9Gd7mYgvII0Ian
         WROdRYEhZaHur3jMPSVj01ZncWPTZu33N9RCkC7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 157/199] ASoC: SOF: Intel: fix page fault at probe if i915 init fails
Date:   Mon, 25 Jan 2021 19:39:39 +0100
Message-Id: <20210125183222.828090676@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit 9c25af250214e45f6d1c21ff6239a1ffeeedf20e upstream.

The earlier commit to fix runtime PM in case i915 init fails,
introduces a possibility to hit a page fault.

snd_hdac_ext_bus_device_exit() is designed to be called from
dev.release(). Calling it outside device reference counting, is
not safe and may lead to calling the device_exit() function
twice. Additionally, as part of ext_bus_device_init(), the device
is also registered with snd_hdac_device_register(). Thus before
calling device_exit(), the device must be removed from device
hierarchy first.

Fix the issue by rolling back init actions by calling
hdac_device_unregister() and then releasing device with put_device().
This matches with existing code in hdac-ext module.

To complete the fix, add handling for the case where
hda_codec_load_module() returns -ENODEV, and clean up the hdac_ext
resources also in this case.

In future work, hdac-ext interface should be extended to allow clients
more flexibility to handle the life-cycle of individual devices, beyond
just the current snd_hdac_ext_bus_device_remove(), which removes all
devices.

BugLink: https://github.com/thesofproject/linux/issues/2646
Reported-by: Jaroslav Kysela <perex@perex.cz>
Fixes: 6c63c954e1c5 ("ASoC: SOF: fix a runtime pm issue in SOF when HDMI codec doesn't work")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Libin Yang <libin.yang@intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Link: https://lore.kernel.org/r/20210113150715.3992635-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sof/intel/hda-codec.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -156,7 +156,8 @@ static int hda_codec_probe(struct snd_so
 		if (!hdev->bus->audio_component) {
 			dev_dbg(sdev->dev,
 				"iDisp hw present but no driver\n");
-			goto error;
+			ret = -ENOENT;
+			goto out;
 		}
 		hda_priv->need_display_power = true;
 	}
@@ -173,24 +174,23 @@ static int hda_codec_probe(struct snd_so
 		 * other return codes without modification
 		 */
 		if (ret == 0)
-			goto error;
+			ret = -ENOENT;
 	}
 
-	return ret;
-
-error:
-	snd_hdac_ext_bus_device_exit(hdev);
-	return -ENOENT;
-
+out:
+	if (ret < 0) {
+		snd_hdac_device_unregister(hdev);
+		put_device(&hdev->dev);
+	}
 #else
 	hdev = devm_kzalloc(sdev->dev, sizeof(*hdev), GFP_KERNEL);
 	if (!hdev)
 		return -ENOMEM;
 
 	ret = snd_hdac_ext_bus_device_init(&hbus->core, address, hdev, HDA_DEV_ASOC);
+#endif
 
 	return ret;
-#endif
 }
 
 /* Codec initialization */


