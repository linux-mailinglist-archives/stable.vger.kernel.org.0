Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488506583DB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbiL1Qwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235203AbiL1Qwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF681DDC9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:46:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44431B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953A9C433D2;
        Wed, 28 Dec 2022 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246015;
        bh=hbVt091vWRGVnI7WXqqR6j61ab9tdP0C8v5IAWhC4Mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0c4KxRdh/PYJ/jw+cMuHlCbNp50xDA3/WBV+0hb+w3P3ex0CAHuPxtA6Y8K+KUMCo
         1qvUnCOvBY9LCyd8LnTkg5acX2XSLFbQDeuqZBKBvfQdp/cY8w2sMazPrsSnaLvhIH
         yGFPoKHZMSDnAg2BV52Pyn8kptn9B6V9D99JrHW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0998/1073] ALSA: hda: add snd_hdac_stop_streams() helper
Date:   Wed, 28 Dec 2022 15:43:06 +0100
Message-Id: <20221228144355.240325825@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 24ad3835a6db4f8857975effa6bf47730371a5ff ]

Minor code reuse, no functionality change.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20220919121041.43463-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 171107237246 ("ASoC: Intel: Skylake: Fix driver hang during shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h        |  1 +
 sound/hda/hdac_stream.c        | 17 ++++++++++++++---
 sound/pci/hda/hda_controller.c |  4 +---
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index 797bf67a164d..ceaa7b7cfdc3 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -562,6 +562,7 @@ int snd_hdac_stream_set_params(struct hdac_stream *azx_dev,
 void snd_hdac_stream_start(struct hdac_stream *azx_dev, bool fresh_start);
 void snd_hdac_stream_clear(struct hdac_stream *azx_dev);
 void snd_hdac_stream_stop(struct hdac_stream *azx_dev);
+void snd_hdac_stop_streams(struct hdac_bus *bus);
 void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus);
 void snd_hdac_stream_reset(struct hdac_stream *azx_dev);
 void snd_hdac_stream_sync_trigger(struct hdac_stream *azx_dev, bool set,
diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
index f3582012d22f..eea22cf72aef 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -142,17 +142,28 @@ void snd_hdac_stream_stop(struct hdac_stream *azx_dev)
 }
 EXPORT_SYMBOL_GPL(snd_hdac_stream_stop);
 
+/**
+ * snd_hdac_stop_streams - stop all streams
+ * @bus: HD-audio core bus
+ */
+void snd_hdac_stop_streams(struct hdac_bus *bus)
+{
+	struct hdac_stream *stream;
+
+	list_for_each_entry(stream, &bus->stream_list, list)
+		snd_hdac_stream_stop(stream);
+}
+EXPORT_SYMBOL_GPL(snd_hdac_stop_streams);
+
 /**
  * snd_hdac_stop_streams_and_chip - stop all streams and chip if running
  * @bus: HD-audio core bus
  */
 void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus)
 {
-	struct hdac_stream *stream;
 
 	if (bus->chip_init) {
-		list_for_each_entry(stream, &bus->stream_list, list)
-			snd_hdac_stream_stop(stream);
+		snd_hdac_stop_streams(bus);
 		snd_hdac_bus_stop_chip(bus);
 	}
 }
diff --git a/sound/pci/hda/hda_controller.c b/sound/pci/hda/hda_controller.c
index 75dcb14ff20a..0ff286b7b66b 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -1033,10 +1033,8 @@ EXPORT_SYMBOL_GPL(azx_init_chip);
 void azx_stop_all_streams(struct azx *chip)
 {
 	struct hdac_bus *bus = azx_bus(chip);
-	struct hdac_stream *s;
 
-	list_for_each_entry(s, &bus->stream_list, list)
-		snd_hdac_stream_stop(s);
+	snd_hdac_stop_streams(bus);
 }
 EXPORT_SYMBOL_GPL(azx_stop_all_streams);
 
-- 
2.35.1



