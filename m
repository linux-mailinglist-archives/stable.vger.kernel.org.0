Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6356D472D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbjDCORx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbjDCORu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:17:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A83F2C9E7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 09B49CE0932
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EDEC433EF;
        Mon,  3 Apr 2023 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531465;
        bh=qzK6HwpWb5JvAbeqAZKi2yaVAo38YXe80U1sExKg+Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJh8hv4G+v3UFOjLwnxvIkQS8suoMGNs2IS20N4g6ZwpVsvRB4tKOC4iN5PVwi9h+
         phB4M6K2Vj/7sEGPD7t0l2WGzzSnqFu6E2ZxmA84seGp4Rp+9239QGirtXlqRDWNad
         Qeev+vhH39fCe70Gdk2DrUrEbY7cspPvBndl++6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 74/84] ALSA: usb-audio: Fix regression on detection of Roland VS-100
Date:   Mon,  3 Apr 2023 16:09:15 +0200
Message-Id: <20230403140355.970635057@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit fa4e7a6fa12b1132340785e14bd439cbe95b7a5a upstream.

It's been reported that the recent kernel can't probe the PCM devices
on Roland VS-100 properly, and it turned out to be a regression by the
recent addition of the bit shift range check for the format bits.
In the old code, we just did bit-shift and it resulted in zero, which
is then corrected to the standard PCM format, while the new code
explicitly returns an error in such a case.

For addressing the regression, relax the check and fallback to the
standard PCM type (with the info output).

Fixes: 43d5ca88dfcd ("ALSA: usb-audio: Fix potential out-of-bounds shift")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217084
Link: https://lore.kernel.org/r/20230324075005.19403-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/format.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -53,8 +53,12 @@ static u64 parse_audio_format_i_type(str
 	case UAC_VERSION_1:
 	default: {
 		struct uac_format_type_i_discrete_descriptor *fmt = _fmt;
-		if (format >= 64)
-			return 0; /* invalid format */
+		if (format >= 64) {
+			usb_audio_info(chip,
+				       "%u:%d: invalid format type 0x%llx is detected, processed as PCM\n",
+				       fp->iface, fp->altsetting, format);
+			format = UAC_FORMAT_TYPE_I_PCM;
+		}
 		sample_width = fmt->bBitResolution;
 		sample_bytes = fmt->bSubframeSize;
 		format = 1ULL << format;


