Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13974657EE6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbiL1P7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiL1P7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:59:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6D8183AB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B202CE1369
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C21C433EF;
        Wed, 28 Dec 2022 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243135;
        bh=c9zh7T+S24+eNrta3F0Vql0/ZsdX3kGpM0UtwQVuO74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4wFUZF16Y431f26l1wRp8xaYDubUDViR6PcFNAoLwdC/G5fLx1dBi317/zWd7H+l
         i9t16rl4d0Oh7RN7qdn1D2hFe6pKsEcMADiI8c+JBHR60ZBGfrjo75NswazN8j2uDz
         9AKC8nLjafyaXQA5sD2G2FdQHfwcrYjDlPC2/WaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 687/731] ALSA: hda: add snd_hdac_stop_streams() helper
Date:   Wed, 28 Dec 2022 15:43:14 +0100
Message-Id: <20221228144316.380931879@linuxfoundation.org>
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
index 6a90ce405e60..658fccdc8660 100644
--- a/include/sound/hdaudio.h
+++ b/include/sound/hdaudio.h
@@ -558,6 +558,7 @@ int snd_hdac_stream_set_params(struct hdac_stream *azx_dev,
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



