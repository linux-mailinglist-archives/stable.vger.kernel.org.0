Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C3D6676DC
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbjALOhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbjALOgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:36:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3606D12AAC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:27:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EAE362026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8247DC43392;
        Thu, 12 Jan 2023 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533633;
        bh=FyhFkSiUSNEJSsZFjDnAancaOoQjZwxTcFMthr3HZJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kh02LV+BejnKwCRiRu2DE6h4M67sdSu/iE/rYWdwq6bhtQyu1nVqU11U+JTlKXS0Q
         QrtfktdkujXHjoByjSo/njWMLcnMp6hebCH2gMOr7dbsosKGz82i7WBNmB7umczfEi
         +NObBQD07G+siBH3iy0/Pebq+6hKGMb9lYC0ZJ8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 542/783] ALSA: hda: add snd_hdac_stop_streams() helper
Date:   Thu, 12 Jan 2023 14:54:18 +0100
Message-Id: <20230112135549.331619669@linuxfoundation.org>
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
index 63edae565573..496decb63f80 100644
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
index f9f0ed3042a2..1e0f61affd97 100644
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
index 3de7dc34def2..ea76395d71d3 100644
--- a/sound/pci/hda/hda_controller.c
+++ b/sound/pci/hda/hda_controller.c
@@ -1045,10 +1045,8 @@ EXPORT_SYMBOL_GPL(azx_init_chip);
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



