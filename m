Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08840505054
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbiDRMYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbiDRMV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:21:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E639B1D0F5;
        Mon, 18 Apr 2022 05:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 759F0B80EC4;
        Mon, 18 Apr 2022 12:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C08C385A7;
        Mon, 18 Apr 2022 12:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284256;
        bh=34W3T14ZyvuTjSBt3LK3XZum8D6tggDeBg81HxRc4to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07zr/yAdkwn+WBXChzHl6tO6NwHhS4o/XwNAImB8fr+gQmi3D5rMxdkSdK8yOSY74
         j/uVgjTb8XRAhdoxlIfBPw+DDMO1TTN0afGIqBtksFmiSBZjTlni9AMpsqEJqu3V33
         QcMJfTPei9yH7gtAJJmwhDDvtVLurXYnvQRBycNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.17 055/219] ALSA: usb-audio: Cap upper limits of buffer/period bytes for implicit fb
Date:   Mon, 18 Apr 2022 14:10:24 +0200
Message-Id: <20220418121206.770245526@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 98c27add5d96485db731a92dac31567b0486cae8 upstream.

In the implicit feedback mode, some parameters are tied between both
playback and capture streams.  One of the tied parameters is the
period size, and this can be a problem if the device has different
number of channels to both streams.  Assume that an application opens
a playback stream that has an implicit feedback from a capture stream,
and it allocates up to the max period and buffer size as much as
possible.  When the capture device supports only more channels than
the playback, the minimum period and buffer sizes become larger than
the sizes the playback stream took.  That is, the minimum size will be
over the max size the driver limits, and PCM core sees as if no
available configuration is found, returning -EINVAL mercilessly.

For avoiding this problem, we have to look through the counter part of
audioformat list for each sync ep, and checks the channels.  If more
channels are found there, we reduce the max period and buffer sizes
accordingly.

You may wonder that the patch adds only the evaluation of channels
between streams, and what about other parameters?  Both the format and
the rate are tied in the implicit fb mode, hence they are always
identical.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215792
Fixes: 5a6c3e11c9c9 ("ALSA: usb-audio: Add hw constraint for implicit fb sync")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220407211657.15087-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/pcm.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 2 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -659,6 +659,9 @@ static int snd_usb_pcm_prepare(struct sn
 #define hwc_debug(fmt, args...) do { } while(0)
 #endif
 
+#define MAX_BUFFER_BYTES	(1024 * 1024)
+#define MAX_PERIOD_BYTES	(512 * 1024)
+
 static const struct snd_pcm_hardware snd_usb_hardware =
 {
 	.info =			SNDRV_PCM_INFO_MMAP |
@@ -669,9 +672,9 @@ static const struct snd_pcm_hardware snd
 				SNDRV_PCM_INFO_PAUSE,
 	.channels_min =		1,
 	.channels_max =		256,
-	.buffer_bytes_max =	1024 * 1024,
+	.buffer_bytes_max =	MAX_BUFFER_BYTES,
 	.period_bytes_min =	64,
-	.period_bytes_max =	512 * 1024,
+	.period_bytes_max =	MAX_PERIOD_BYTES,
 	.periods_min =		2,
 	.periods_max =		1024,
 };
@@ -971,6 +974,78 @@ static int hw_rule_periods_implicit_fb(s
 				      ep->cur_buffer_periods);
 }
 
+/* get the adjusted max buffer (or period) bytes that can fit with the
+ * paired format for implicit fb
+ */
+static unsigned int
+get_adjusted_max_bytes(struct snd_usb_substream *subs,
+		       struct snd_usb_substream *pair,
+		       struct snd_pcm_hw_params *params,
+		       unsigned int max_bytes,
+		       bool reverse_map)
+{
+	const struct audioformat *fp, *pp;
+	unsigned int rmax = 0, r;
+
+	list_for_each_entry(fp, &subs->fmt_list, list) {
+		if (!fp->implicit_fb)
+			continue;
+		if (!reverse_map &&
+		    !hw_check_valid_format(subs, params, fp))
+			continue;
+		list_for_each_entry(pp, &pair->fmt_list, list) {
+			if (pp->iface != fp->sync_iface ||
+			    pp->altsetting != fp->sync_altsetting ||
+			    pp->ep_idx != fp->sync_ep_idx)
+				continue;
+			if (reverse_map &&
+			    !hw_check_valid_format(pair, params, pp))
+				break;
+			if (!reverse_map && pp->channels > fp->channels)
+				r = max_bytes * fp->channels / pp->channels;
+			else if (reverse_map && pp->channels < fp->channels)
+				r = max_bytes * pp->channels / fp->channels;
+			else
+				r = max_bytes;
+			rmax = max(rmax, r);
+			break;
+		}
+	}
+	return rmax;
+}
+
+/* Reduce the period or buffer bytes depending on the paired substream;
+ * when a paired configuration for implicit fb has a higher number of channels,
+ * we need to reduce the max size accordingly, otherwise it may become unusable
+ */
+static int hw_rule_bytes_implicit_fb(struct snd_pcm_hw_params *params,
+				     struct snd_pcm_hw_rule *rule)
+{
+	struct snd_usb_substream *subs = rule->private;
+	struct snd_usb_substream *pair;
+	struct snd_interval *it;
+	unsigned int max_bytes;
+	unsigned int rmax;
+
+	pair = &subs->stream->substream[!subs->direction];
+	if (!pair->ep_num)
+		return 0;
+
+	if (rule->var == SNDRV_PCM_HW_PARAM_PERIOD_BYTES)
+		max_bytes = MAX_PERIOD_BYTES;
+	else
+		max_bytes = MAX_BUFFER_BYTES;
+
+	rmax = get_adjusted_max_bytes(subs, pair, params, max_bytes, false);
+	if (!rmax)
+		rmax = get_adjusted_max_bytes(pair, subs, params, max_bytes, true);
+	if (!rmax)
+		return 0;
+
+	it = hw_param_interval(params, rule->var);
+	return apply_hw_params_minmax(it, 0, rmax);
+}
+
 /*
  * set up the runtime hardware information.
  */
@@ -1085,6 +1160,16 @@ static int setup_hw_info(struct snd_pcm_
 				  SNDRV_PCM_HW_PARAM_PERIODS, -1);
 	if (err < 0)
 		return err;
+	err = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
+				  hw_rule_bytes_implicit_fb, subs,
+				  SNDRV_PCM_HW_PARAM_BUFFER_BYTES, -1);
+	if (err < 0)
+		return err;
+	err = snd_pcm_hw_rule_add(runtime, 0, SNDRV_PCM_HW_PARAM_PERIOD_BYTES,
+				  hw_rule_bytes_implicit_fb, subs,
+				  SNDRV_PCM_HW_PARAM_PERIOD_BYTES, -1);
+	if (err < 0)
+		return err;
 
 	list_for_each_entry(fp, &subs->fmt_list, list) {
 		if (fp->implicit_fb) {


