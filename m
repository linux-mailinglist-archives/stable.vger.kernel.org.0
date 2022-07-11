Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B0656FC35
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiGKJkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbiGKJkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DBB8C760;
        Mon, 11 Jul 2022 02:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82436612A3;
        Mon, 11 Jul 2022 09:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9546EC34115;
        Mon, 11 Jul 2022 09:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531233;
        bh=gn6z5xNUSkjtagaL4BSFt6iLReVorGh4Ro3OTLFfa/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yz40VyOH3AceSZsG6Zne3a21efxkwhnuIBai4TM7KqtK8lrMM3m0sdk2NfBblZU2K
         7HXSdadfu9T6jv6ImpJtBRbYWWYvq9MN8umhTbHk10t2na9c4DQmS/Vy/rSBzZ32Hb
         80bZKl1/MlzsFYO+Cf8nPzzYv4Gijq3tmVOCkgZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 004/230] ALSA: usb-audio: Workarounds for Behringer UMC 204/404 HD
Date:   Mon, 11 Jul 2022 11:04:20 +0200
Message-Id: <20220711090604.193001581@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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


