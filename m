Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104505B70CB
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiIMO3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbiIMO2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C875E0E6;
        Tue, 13 Sep 2022 07:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C807614DA;
        Tue, 13 Sep 2022 14:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B44BC433C1;
        Tue, 13 Sep 2022 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078652;
        bh=0vizO5AQNzEfIp7DJay4COUo+rIKGkR9slyZwrv/jLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5vk4JamrXO/Nc8gO2J3Nmvx69CwwtUKLcJVMt2TRgCi1WDB6UKBb0kVzcJI6JgBR
         dYjYU8GCJZuEJY4g1t6Ii/hlH7dxkQ4PQbIrrjpSHxO4f3hYA1BHHJNOGeVpEKTn7v
         LAL23xY9q6a+9bUSdqFpkoF5cyIEOfh/xud6GSvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chihhao chen <chihhao.chen@mediatek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 030/121] ALSA: usb-audio: Split endpoint setups for hw_params and prepare
Date:   Tue, 13 Sep 2022 16:03:41 +0200
Message-Id: <20220913140358.645262860@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ff878b408a03bef5d610b7e2302702e16a53636e upstream.

One of the former changes for the endpoint management was the more
consistent setup of endpoints at hw_params.
snd_usb_endpoint_configure() is a single function that does the full
setup, and it's called from both PCM hw_params and prepare callbacks.
Although the EP setup at the prepare phase is usually skipped (by
checking need_setup flag), it may be still effective in some cases
like suspend/resume that requires the interface setup again.

As it's a full and single setup, the invocation of
snd_usb_endpoint_configure() includes not only the USB interface setup
but also the buffer release and allocation.  OTOH, doing the buffer
release and re-allocation at PCM prepare phase is rather superfluous,
and better to be done only in the hw_params phase.

For those optimizations, this patch splits the endpoint setup to two
phases: snd_usb_endpoint_set_params() and snd_usb_endpoint_prepare(),
to be called from hw_params and from prepare, respectively.

Note that this patch changes the driver operation slightly,
effectively moving the USB interface setup again to PCM prepare stage
instead of hw_params stage, while the buffer allocation and such
initializations are still done at hw_params stage.

And, the change of the USB interface setup timing (moving to prepare)
gave an interesting "fix", too: it was reported that the recent
kernels caused silent output at the beginning on playbacks on some
devices on Android, and this change casually fixed the regression.
It seems that those devices are picky about the sample rate change (or
the interface change?), and don't follow the too immediate rate
changes.

Meanwhile, Android operates the PCM in the following order:
- open, then hw_params with the possibly highest sample rate
- close without prepare
- re-open, hw_params with the normal sample rate
- prepare, and start streaming
This procedure ended up the hw_params twice with different rates, and
because the recent kernel did set up the sample rate twice one and
after, it screwed up the device.  OTOH, the earlier kernels didn't set
up the USB interface at hw_params, hence this problem didn't appear.

Now, with this patch, the USB interface setup is again back to the
prepare phase, and it works around the problem automagically.
Although we should address the sample rate problem in a more solid
way in future, let's keep things working as before for now.

Fixes: bf6313a0ff76 ("ALSA: usb-audio: Refactor endpoint management")
Cc: <stable@vger.kernel.org>
Reported-by: chihhao chen <chihhao.chen@mediatek.com>
Link: https://lore.kernel.org/r/87e6d6ae69d68dc588ac9acc8c0f24d6188375c3.camel@mediatek.com
Link: https://lore.kernel.org/r/20220901124136.4984-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |   23 +++++++++--------------
 sound/usb/endpoint.h |    6 ++++--
 sound/usb/pcm.c      |   14 ++++++++++----
 3 files changed, 23 insertions(+), 20 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -731,7 +731,8 @@ bool snd_usb_endpoint_compatible(struct
  * The endpoint needs to be closed via snd_usb_endpoint_close() later.
  *
  * Note that this function doesn't configure the endpoint.  The substream
- * needs to set it up later via snd_usb_endpoint_configure().
+ * needs to set it up later via snd_usb_endpoint_set_params() and
+ * snd_usb_endpoint_prepare().
  */
 struct snd_usb_endpoint *
 snd_usb_endpoint_open(struct snd_usb_audio *chip,
@@ -1254,12 +1255,13 @@ out_of_memory:
 /*
  * snd_usb_endpoint_set_params: configure an snd_usb_endpoint
  *
+ * It's called either from hw_params callback.
  * Determine the number of URBs to be used on this endpoint.
  * An endpoint must be configured before it can be started.
  * An endpoint that is already running can not be reconfigured.
  */
-static int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
-				       struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
+				struct snd_usb_endpoint *ep)
 {
 	const struct audioformat *fmt = ep->cur_audiofmt;
 	int err;
@@ -1315,18 +1317,18 @@ static int snd_usb_endpoint_set_params(s
 }
 
 /*
- * snd_usb_endpoint_configure: Configure the endpoint
+ * snd_usb_endpoint_prepare: Prepare the endpoint
  *
  * This function sets up the EP to be fully usable state.
- * It's called either from hw_params or prepare callback.
+ * It's called either from prepare callback.
  * The function checks need_setup flag, and performs nothing unless needed,
  * so it's safe to call this multiple times.
  *
  * This returns zero if unchanged, 1 if the configuration has changed,
  * or a negative error code.
  */
-int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
-			       struct snd_usb_endpoint *ep)
+int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
+			     struct snd_usb_endpoint *ep)
 {
 	bool iface_first;
 	int err = 0;
@@ -1348,9 +1350,6 @@ int snd_usb_endpoint_configure(struct sn
 			if (err < 0)
 				goto unlock;
 		}
-		err = snd_usb_endpoint_set_params(chip, ep);
-		if (err < 0)
-			goto unlock;
 		goto done;
 	}
 
@@ -1378,10 +1377,6 @@ int snd_usb_endpoint_configure(struct sn
 	if (err < 0)
 		goto unlock;
 
-	err = snd_usb_endpoint_set_params(chip, ep);
-	if (err < 0)
-		goto unlock;
-
 	err = snd_usb_select_mode_quirk(chip, ep->cur_audiofmt);
 	if (err < 0)
 		goto unlock;
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -17,8 +17,10 @@ snd_usb_endpoint_open(struct snd_usb_aud
 		      bool is_sync_ep);
 void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 			    struct snd_usb_endpoint *ep);
-int snd_usb_endpoint_configure(struct snd_usb_audio *chip,
-			       struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
+				struct snd_usb_endpoint *ep);
+int snd_usb_endpoint_prepare(struct snd_usb_audio *chip,
+			     struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_get_clock_rate(struct snd_usb_audio *chip, int clock);
 
 bool snd_usb_endpoint_compatible(struct snd_usb_audio *chip,
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -443,17 +443,17 @@ static int configure_endpoints(struct sn
 		if (stop_endpoints(subs, false))
 			sync_pending_stops(subs);
 		if (subs->sync_endpoint) {
-			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
+			err = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
 			if (err < 0)
 				return err;
 		}
-		err = snd_usb_endpoint_configure(chip, subs->data_endpoint);
+		err = snd_usb_endpoint_prepare(chip, subs->data_endpoint);
 		if (err < 0)
 			return err;
 		snd_usb_set_format_quirk(subs, subs->cur_audiofmt);
 	} else {
 		if (subs->sync_endpoint) {
-			err = snd_usb_endpoint_configure(chip, subs->sync_endpoint);
+			err = snd_usb_endpoint_prepare(chip, subs->sync_endpoint);
 			if (err < 0)
 				return err;
 		}
@@ -551,7 +551,13 @@ static int snd_usb_hw_params(struct snd_
 	subs->cur_audiofmt = fmt;
 	mutex_unlock(&chip->mutex);
 
-	ret = configure_endpoints(chip, subs);
+	if (subs->sync_endpoint) {
+		ret = snd_usb_endpoint_set_params(chip, subs->sync_endpoint);
+		if (ret < 0)
+			goto unlock;
+	}
+
+	ret = snd_usb_endpoint_set_params(chip, subs->data_endpoint);
 
  unlock:
 	if (ret < 0)


