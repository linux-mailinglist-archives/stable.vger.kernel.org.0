Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749F34BE1E3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349131AbiBUJ21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:28:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349121AbiBUJ1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B5F12A87;
        Mon, 21 Feb 2022 01:12:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBBF0CE0E79;
        Mon, 21 Feb 2022 09:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE53BC340E9;
        Mon, 21 Feb 2022 09:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434735;
        bh=CuhhGfIoAjBxYF3sdqIAIwU0hvEMEeFHrD/RaIYIkJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbPj/umcYvUAAsTvdYSIQejVg5NAy+KXJD52KteZWriFphi8rJ7goU9Sm58epg0fp
         Zuh5suTc+R6XpiT/+B76QkT7yHrLk/LoTT/liF3RIC9ZX8YiL3r5Gu4S02XJI9Diwu
         0R9tAtV30b410SdgT19S6kurz5Vc0CDC3jyJAlLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matteo Martelli <matteomartelli3@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 111/196] ALSA: usb-audio: revert to IMPLICIT_FB_FIXED_DEV for M-Audio FastTrack Ultra
Date:   Mon, 21 Feb 2022 09:49:03 +0100
Message-Id: <20220221084934.653453496@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Matteo Martelli <matteomartelli3@gmail.com>

commit 19d20c7a29bf2e46ff1ab8e8c4fcd2da8a4f38e2 upstream.

Commit 83b7dcbc51c930fc2079ab6c6fc9d719768321f1 introduced a generic
implicit feedback parser, which fails to execute for M-Audio FastTrack
Ultra sound cards. The issue is with the ENDPOINT_SYNCTYPE check in
add_generic_implicit_fb() where the SYNCTYPE is ADAPTIVE instead of ASYNC.
The reason is that the sync type of the FastTrack output endpoints are
set to adaptive in the quirks table since commit
65f04443c96dbda11b8fff21d6390e082846aa3c.

Fixes: 83b7dcbc51c9 ("ALSA: usb-audio: Add generic implicit fb parsing")
Signed-off-by: Matteo Martelli <matteomartelli3@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220211224913.20683-2-matteomartelli3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/implicit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -47,13 +47,13 @@ struct snd_usb_implicit_fb_match {
 static const struct snd_usb_implicit_fb_match playback_implicit_fb_quirks[] = {
 	/* Generic matching */
 	IMPLICIT_FB_GENERIC_DEV(0x0499, 0x1509), /* Steinberg UR22 */
-	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2080), /* M-Audio FastTrack Ultra */
-	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2081), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2030), /* M-Audio Fast Track C400 */
 	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2031), /* M-Audio Fast Track C600 */
 
 	/* Fixed EP */
 	/* FIXME: check the availability of generic matching */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2080, 0x81, 2), /* M-Audio FastTrack Ultra */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2081, 0x81, 2), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_FIXED_DEV(0x2466, 0x8010, 0x81, 2), /* Fractal Audio Axe-Fx III */
 	IMPLICIT_FB_FIXED_DEV(0x31e9, 0x0001, 0x81, 2), /* Solid State Logic SSL2 */
 	IMPLICIT_FB_FIXED_DEV(0x31e9, 0x0002, 0x81, 2), /* Solid State Logic SSL2+ */


