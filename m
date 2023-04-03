Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021396D47C5
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjDCOXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjDCOXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BA92D7D8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00AFE61D5F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14430C4339B;
        Mon,  3 Apr 2023 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531774;
        bh=LGxED/n1YkWwhiEoXO7dPNsBXTGMmhf3fHFvcpDd4ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJWDo7eNvthpBtIC46jIN78JShXOe2M3B/wQfvGh16PYd9Uxp+iQoWsQ8Ay8eN9OW
         efR3Q80LxeE9wMEn27tfqqNylr6hXytPT9n8f6hiG3L2yXTTBMCD4bdT2IXMLQMpfe
         GkdFkVDkoXzZqCVFu2HdJ7gUdRwzUojuWQeN3cHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 096/104] ALSA: usb-audio: Fix regression on detection of Roland VS-100
Date:   Mon,  3 Apr 2023 16:09:28 +0200
Message-Id: <20230403140407.925942878@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
@@ -40,8 +40,12 @@ static u64 parse_audio_format_i_type(str
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


