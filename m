Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7C756FB05
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiGKJZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiGKJYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BFD24955;
        Mon, 11 Jul 2022 02:14:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19868B80CEF;
        Mon, 11 Jul 2022 09:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65760C341C0;
        Mon, 11 Jul 2022 09:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530886;
        bh=gn6z5xNUSkjtagaL4BSFt6iLReVorGh4Ro3OTLFfa/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I54qc7h19xyYQLj6t9sV0J94Jr4Ypq+te4QZt0dmI0gUPYCxG2Qj9O1KJ/eCMM/bb
         o8g1thZIPLNEOnJVB5B8Ltzsy46U/OySSuW/zxJGxu96VpmYirPDbbOVD5EdaE66P6
         W3vXzmAqLEn2MLZPNeiFCePqBjIMbelNRkKw+VyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 002/112] ALSA: usb-audio: Workarounds for Behringer UMC 204/404 HD
Date:   Mon, 11 Jul 2022 11:06:02 +0200
Message-Id: <20220711090549.617382071@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

commit ae8b1631561a3634cc09d0c62bbdd938eade05ec upstream.

Both Behringer UMC 202 HD and 404 HD need explicit quirks to enable
the implicit feedback mode and start the playback stream primarily.
The former seems fixing the stuttering and the latter is required for
a playback-only case.

Note that the "clock source 41 is not valid" error message still
appears even after this fix, but it should be only once at probe.
The reason of the error is still unknown, but this seems to be mostly
harmless as it's a one-off error and the driver retires the clock
setup and it succeeds afterwards.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215934
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220624101132.14528-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1842,6 +1842,10 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x1397, 0x0508, /* Behringer UMC204HD */
+		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x1397, 0x0509, /* Behringer UMC404HD */
+		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x13e5, 0x0001, /* Serato Phono */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x154e, 0x1002, /* Denon DCD-1500RE */


