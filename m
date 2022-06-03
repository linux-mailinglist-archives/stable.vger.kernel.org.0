Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64D453CFE2
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbiFCR5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345777AbiFCR4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:56:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8427456F97;
        Fri,  3 Jun 2022 10:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4209DB82430;
        Fri,  3 Jun 2022 17:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C942C341C0;
        Fri,  3 Jun 2022 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278841;
        bh=u3IpJg7f52QEmZoiTs+geEPRmnLMhe+3HVFYgwUxjcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfplIdH5VWQBNcX7nAjS2H99ntgDNP6ofPHzSkCTJpJqpXugim9Elr15L1haOCzv+
         2PHc32p9XFXsPy8buVugH552s69xDnDZQ4frZBUncc793UcjLpEtKN41j2ADeg5/6M
         ND7OoYns9TBHE+TA1eZo+302S+SSVgn2EoKyh+KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Maris Abele <maris7abele@gmail.com>
Subject: [PATCH 5.17 44/75] ALSA: usb-audio: Workaround for clock setup on TEAC devices
Date:   Fri,  3 Jun 2022 19:43:28 +0200
Message-Id: <20220603173822.998263429@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

commit 5ce0b06ae5e69e23142e73c5c3c0260e9f2ccb4b upstream.

Maris reported that TEAC UD-501 (0644:8043) doesn't work with the
typical "clock source 41 is not valid, cannot use" errors on the
recent kernels.  The currently known workaround so far is to restore
(partially) what we've done unconditionally at the clock setup;
namely, re-setup the USB interface immediately after the clock is
changed.  This patch re-introduces the behavior conditionally for TEAC
devices.

Further notes:
- The USB interface shall be set later in
  snd_usb_endpoint_configure(), but this seems to be too late.
- Even calling  usb_set_interface() right after
  sne_usb_init_sample_rate() doesn't help; so this must be related
  with the clock validation, too.
- The device may still spew the "clock source 41 is not valid" error
  at the first clock setup.  This seems happening at the very first
  try of clock setup, but it disappears at later attempts.
  The error is likely harmless because the driver retries the clock
  setup (such an error is more or less expected on some devices).

Fixes: bf6313a0ff76 ("ALSA: usb-audio: Refactor endpoint management")
Reported-and-tested-by: Maris Abele <maris7abele@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220521064627.29292-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/clock.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -572,6 +572,13 @@ static int set_sample_rate_v2v3(struct s
 		/* continue processing */
 	}
 
+	/* FIXME - TEAC devices require the immediate interface setup */
+	if (rate != prev_rate && USB_ID_VENDOR(chip->usb_id) == 0x0644) {
+		usb_set_interface(chip->dev, fmt->iface, fmt->altsetting);
+		if (chip->quirk_flags & QUIRK_FLAG_IFACE_DELAY)
+			msleep(50);
+	}
+
 validation:
 	/* validate clock after rate change */
 	if (!uac_clock_source_is_valid(chip, fmt, clock))


