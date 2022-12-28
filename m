Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF3E657EE3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiL1P6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiL1P6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:58:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6301F18B31
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06B8BB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E32AC433D2;
        Wed, 28 Dec 2022 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243126;
        bh=hq9L3NzxtTTQJ/HnUO/qDnvIV6iil0fRyMkvtAxV0jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvCZfbDMhNRQHnwl0tzzvIvqZVZPI7tp8G0mURHHg1wIg7nC+0Mzum9N6wnzo9shA
         TDCMDh/8nD99Hb2UdfYXPLvM0M3/unU+Ohhc50yN3HngvNyX5puwRgpyV7XSbWO4HL
         aXjhTSBHmQoqqlNBGVd99br+g+/Ypst22XWjkozE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 686/731] ALSA/ASoC: hda: move/rename snd_hdac_ext_stop_streams to hdac_stream.c
Date:   Wed, 28 Dec 2022 15:43:13 +0100
Message-Id: <20221228144316.352988821@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 12054f0ce8be7d2003ec068ab27c9eb608397b98 ]

snd_hdac_ext_stop_streams() has really nothing to do with the
extension, it just loops over the bus streams.

Move it to the hdac_stream layer and rename to remove the 'ext'
prefix and add the precision that the chip will also be stopped.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20211216231128.344321-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 171107237246 ("ASoC: Intel: Skylake: Fix driver hang during shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hdaudio.h         |  1 +
 include/sound/hdaudio_ext.h     |  1 -
 sound/hda/ext/hdac_ext_stream.c | 17 -----------------
 sound/hda/hdac_stream.c         | 16 ++++++++++++++++
 sound/soc/intel/skylake/skl.c   |  4 ++--
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/include/sound/hdaudio.h b/include/sound/hdaudio.h
index 22af68b01426..6a90ce405e60 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -558,6 +558,7 @@ int snd_hdac_stream_set_params(struct hdac_stream *azx_dev,
 void snd_hdac_stream_start(struct hdac_stream *azx_dev, bool fresh_start);
 void snd_hdac_stream_clear(struct hdac_stream *azx_dev);
 void snd_hdac_stream_stop(struct hdac_stream *azx_dev);
+void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus);
 void snd_hdac_stream_reset(struct hdac_stream *azx_dev);
 void snd_hdac_stream_sync_trigger(struct hdac_stream *azx_dev, bool set,
 				  unsigned int streams, unsigned int reg);
diff --git a/include/sound/hdaudio_ext.h b/include/sound/hdaudio_ext.h
index d4e31ea16aba..56ea5cde5e63 100644
--- a/include/sound/hdaudio_ext.h
+++ b/include/sound/hdaudio_ext.h
@@ -92,7 +92,6 @@ void snd_hdac_ext_stream_decouple_locked(struct hdac_bus *bus,
 				  struct hdac_ext_stream *azx_dev, bool decouple);
 void snd_hdac_ext_stream_decouple(struct hdac_bus *bus,
 				struct hdac_ext_stream *azx_dev, bool decouple);
-void snd_hdac_ext_stop_streams(struct hdac_bus *bus);
 
 int snd_hdac_ext_stream_set_spib(struct hdac_bus *bus,
 				 struct hdac_ext_stream *stream, u32 value);
diff --git a/sound/hda/ext/hdac_ext_stream.c b/sound/hda/ext/hdac_ext_stream.c
index 37154ed43bd5..c09652da43ff 100644
--- a/sound/hda/ext/hdac_ext_stream.c
+++ b/sound/hda/ext/hdac_ext_stream.c
@@ -475,23 +475,6 @@ int snd_hdac_ext_stream_get_spbmaxfifo(struct hdac_bus *bus,
 }
 EXPORT_SYMBOL_GPL(snd_hdac_ext_stream_get_spbmaxfifo);
 
-
-/**
- * snd_hdac_ext_stop_streams - stop all stream if running
- * @bus: HD-audio core bus
- */
-void snd_hdac_ext_stop_streams(struct hdac_bus *bus)
-{
-	struct hdac_stream *stream;
-
-	if (bus->chip_init) {
-		list_for_each_entry(stream, &bus->stream_list, list)
-			snd_hdac_stream_stop(stream);
-		snd_hdac_bus_stop_chip(bus);
-	}
-}
-EXPORT_SYMBOL_GPL(snd_hdac_ext_stop_streams);
-
 /**
  * snd_hdac_ext_stream_drsm_enable - enable DMA resume for a stream
  * @bus: HD-audio core bus
diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
index aa7955fdf68a..f3582012d22f 100644
--- a/sound/hda/hdac_stream.c
+++ b/sound/hda/hdac_stream.c
@@ -142,6 +142,22 @@ void snd_hdac_stream_stop(struct hdac_stream *azx_dev)
 }
 EXPORT_SYMBOL_GPL(snd_hdac_stream_stop);
 
+/**
+ * snd_hdac_stop_streams_and_chip - stop all streams and chip if running
+ * @bus: HD-audio core bus
+ */
+void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus)
+{
+	struct hdac_stream *stream;
+
+	if (bus->chip_init) {
+		list_for_each_entry(stream, &bus->stream_list, list)
+			snd_hdac_stream_stop(stream);
+		snd_hdac_bus_stop_chip(bus);
+	}
+}
+EXPORT_SYMBOL_GPL(snd_hdac_stop_streams_and_chip);
+
 /**
  * snd_hdac_stream_reset - reset a stream
  * @azx_dev: HD-audio core stream to reset
diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index 5b1a15e39912..148ddf4cace0 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -439,7 +439,7 @@ static int skl_free(struct hdac_bus *bus)
 
 	skl->init_done = 0; /* to be sure */
 
-	snd_hdac_ext_stop_streams(bus);
+	snd_hdac_stop_streams_and_chip(bus);
 
 	if (bus->irq >= 0)
 		free_irq(bus->irq, (void *)bus);
@@ -1096,7 +1096,7 @@ static void skl_shutdown(struct pci_dev *pci)
 	if (!skl->init_done)
 		return;
 
-	snd_hdac_ext_stop_streams(bus);
+	snd_hdac_stop_streams_and_chip(bus);
 	list_for_each_entry(s, &bus->stream_list, list) {
 		stream = stream_to_hdac_ext_stream(s);
 		snd_hdac_ext_stream_decouple(bus, stream, false);
-- 
2.35.1



