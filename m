Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9AD5EA5C7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbiIZMRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239402AbiIZMRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:17:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2068769D;
        Mon, 26 Sep 2022 04:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8FA8CE10E9;
        Mon, 26 Sep 2022 10:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A25C433C1;
        Mon, 26 Sep 2022 10:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188952;
        bh=JMWFfDdxGeDhF2nbUZDhH8kf6fSAkLFjq6b7QHEYMAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfoIVF0+dOjOK/gx+Hos/2Y9IheMnF7TVK60nGhgpLqUVib0dJsMd3VCwXudlLibY
         x7VAoYUgqjOX5q1p6GFJbYRmWVbBFfMCistuhtovZJ9fA7x6mwjLm4t0JsUX2lNBBj
         lncXpwxsVJPO2WZTgAnN8GGiqD52ziTjM5Dl227o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.19 025/207] Revert "ALSA: usb-audio: Split endpoint setups for hw_params and prepare"
Date:   Mon, 26 Sep 2022 12:10:14 +0200
Message-Id: <20220926100807.598605894@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 79764ec772bc1346441ae1c4b1f3bd1991d634e8 upstream.

This reverts commit ff878b408a03bef5d610b7e2302702e16a53636e.

Unfortunately the recent fix seems bringing another regressions with
PulseAudio / pipewire, at least for Steinberg and MOTU devices.

As a temporary solution, do a straight revert.  The issue for Android
will be revisited again later by another different fix (if any).

Fixes: ff878b408a03 ("ALSA: usb-audio: Split endpoint setups for hw_params and prepare")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216500
Link: https://lore.kernel.org/r/20220920113929.25162-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |   23 ++++++++++++++---------
 sound/usb/endpoint.h |    6 ++----
 sound/usb/pcm.c      |   14 ++++----------
 3 files changed, 20 insertions(+), 23 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -758,8 +758,7 @@ bool snd_usb_endpoint_compatible(struct
  * The endpoint needs to be closed via snd_usb_endpoint_close() later.
  *
  * Note that this function doesn't configure the endpoint.  The substream
- * needs to set it up later via snd_usb_endpoint_set_params() and
- * snd_usb_endpoint_prepare().
+ * needs to set it up later via snd_usb_endpoint_configure().
  */
 struct snd_usb_endpoint *
 snd_usb_endpoint_open(struct snd_usb_audio *chip,
@@ -1293,13 +1292,12 @@ out_of_memory:
 /*
  * snd_usb_endpoint_set_params: configure an snd_usb_endpoint
  *
- * It's called either from hw_params callback.
  * Determine the number of URBs to be used on this endpoint.
  * An endpoint must be configured before it can be started.
  * An endpoint that is already running can not be reconfigured.
  */
-int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
-				struct snd_usb_endpoint *ep)
+static int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
+				       struct snd_usb_endpoint *ep)
 {
 	const struct audioformat *fmt = ep->cur_audiofmt;
 	int err;
@@ -1382,18 +1380,18 @@ static int init_sample_rate(struct snd_u
 }
 
 /*
- * snd_usb_endpoint_prepare: Prepare the endpoint
+ * snd_usb_endpoint_configure: Configure the endpoint
  *
  * This function sets up the EP to be fully usable state.
- * It's called either from prepare callback.
+ * It's called either from hw_params or prepare callback.
  * The function checks need_setup flag, and performs nothing unless needed,
  * so it's safe to call this multiple times.
  *
  * This returns zero if unchanged, 1 if the configuration has changed,
  * or a negative error code.
  */
-int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
-			     struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
+			       struct snd_usb_endpoint *ep)
 {
 	bool iface_first;
 	int err = 0;
@@ -1414,6 +1412,9 @@ int snd_usb_endpoint_prepare(struct snd_
 			if (err < 0)
 				goto unlock;
 		}
+		err = snd_usb_endpoint_set_params(chip, ep);
+		if (err < 0)
+			goto unlock;
 		goto done;
 	}
 
@@ -1441,6 +1442,10 @@ int snd_usb_endpoint_prepare(struct snd_
 	if (err < 0)
 		goto unlock;
 
+	err = snd_usb_endpoint_set_params(chip, ep);
+	if (err < 0)
+		goto unlock;
+
 	err = snd_usb_select_mode_quirk(chip, ep->cur_audiofmt);
 	if (err < 0)
 		goto unlock;
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -17,10 +17,8 @@ snd_usb_endpoint_open(struct snd_usb_aud
 		      bool is_sync_ep);
 void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 			    struct snd_usb_endpoint *ep);
-int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
-				struct snd_usb_endpoint *ep);
-int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
-			     struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
+			       struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_get_clock_rate(struct snd_usb_audio *chip, int clock);
 
 bool snd_usb_endpoint_compatible(struct snd_usb_audio *chip,
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -443,17 +443,17 @@ static int configure_endpoints(struct sn
 		if (stop_endpoints(subs, false))
 			sync_pending_stops(subs);
 		if (subs->sync_endpoint) {
-			err = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
+			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
 			if (err < 0)
 				return err;
 		}
-		err = snd_usb_endpoint_prepare(chip, subs->data_endpoint);
+		err = snd_usb_endpoint_configure(chip, subs->data_endpoint);
 		if (err < 0)
 			return err;
 		snd_usb_set_format_quirk(subs, subs->cur_audiofmt);
 	} else {
 		if (subs->sync_endpoint) {
-			err = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
+			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
 			if (err < 0)
 				return err;
 		}
@@ -551,13 +551,7 @@ static int snd_usb_hw_params(struct snd_
 	subs->cur_audiofmt = fmt;
 	mutex_unlock(&chip->mutex);
 
-	if (subs->sync_endpoint) {
-		ret = snd_usb_endpoint_set_params(chip, subs->sync_endpoint);
-		if (ret < 0)
-			goto unlock;
-	}
-
-	ret = snd_usb_endpoint_set_params(chip, subs->data_endpoint);
+	ret = configure_endpoints(chip, subs);
 
  unlock:
 	if (ret < 0)


