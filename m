Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56666770E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbjALOje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239764AbjALOit (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:38:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D1B5831B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:28:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C2EA62026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E1FC433EF;
        Thu, 12 Jan 2023 14:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533722;
        bh=pyvI5CHV0SI2Qj7a+jqf0GwBAtS3SGPSRCHnXyD/Tjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RB1tjl8/9v0bM5+kCAwapTuW5fFMrK7l2qdN9MMZdVUwqSWp9DcuIQrP5Qa7mw6SQ
         YWWVrFWVNKb3gzyIK6ryvjOXVpQ4Fhi4xiVTTx+xNK50BRiy+EhRaqQ5NtwNsi3Vb1
         mcHtAfPJ9U1khpj3SNXVGVmwwcZo14AAhHIrOlWE=
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
Subject: [PATCH 5.10 541/783] ALSA/ASoC: hda: move/rename snd_hdac_ext_stop_streams to hdac_stream.c
Date:   Thu, 12 Jan 2023 14:54:17 +0100
Message-Id: <20230112135549.283182914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 6eed61e6cf8a..63edae565573 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -562,6 +562,7 @@ int snd_hdac_stream_set_params(struct hdac_stream *azx_dev,
 void snd_hdac_stream_start(struct hdac_stream *azx_dev, bool fresh_start);
 void snd_hdac_stream_clear(struct hdac_stream *azx_dev);
 void snd_hdac_stream_stop(struct hdac_stream *azx_dev);
+void snd_hdac_stop_streams_and_chip(struct hdac_bus *bus);
 void snd_hdac_stream_reset(struct hdac_stream *azx_dev);
 void snd_hdac_stream_sync_trigger(struct hdac_stream *azx_dev, bool set,
 				  unsigned int streams, unsigned int reg);
diff --git a/include/sound/hdaudio_ext.h b/include/sound/hdaudio_ext.h
index 75048ea178f6..ddcb5b2f0a8e 100644
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
index 1e6e4cf428cd..4276dae2e00a 100644
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
index ce77a5320163..f9f0ed3042a2 100644
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
index 8b993722f74e..83b1eb70b40a 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -439,7 +439,7 @@ static int skl_free(struct hdac_bus *bus)
 
 	skl->init_done = 0; /* to be sure */
 
-	snd_hdac_ext_stop_streams(bus);
+	snd_hdac_stop_streams_and_chip(bus);
 
 	if (bus->irq >= 0)
 		free_irq(bus->irq, (void *)bus);
@@ -1100,7 +1100,7 @@ static void skl_shutdown(struct pci_dev *pci)
 	if (!skl->init_done)
 		return;
 
-	snd_hdac_ext_stop_streams(bus);
+	snd_hdac_stop_streams_and_chip(bus);
 	list_for_each_entry(s, &bus->stream_list, list) {
 		stream = stream_to_hdac_ext_stream(s);
 		snd_hdac_ext_stream_decouple(bus, stream, false);
-- 
2.35.1



