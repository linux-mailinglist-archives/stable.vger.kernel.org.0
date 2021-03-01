Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C29329149
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243241AbhCAUXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243118AbhCAUQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:16:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1330365035;
        Mon,  1 Mar 2021 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621742;
        bh=f1NZd/zFw2FM4HiKvf18olnB0p0WoCr/qg0bQVOudEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vP22RDbUzd4pOwo3AOs5v16iElcbNazjN8bIeh7GdUqSGKoOClVhtDFfkxp6KqnbG
         WkTUh0I5ia3LC5Bg+QBTSMBfrg7v9a0DDctbSqd8jaELentiT8HmFI0VSqk1EuR4Kb
         8Y/nbwxL/Rx63rExwDHda0tkykwrokAixbdN1T3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Milner <kamilner@superlative.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 597/775] ALSA: usb-audio: Add implicit fb quirk for BOSS GP-10
Date:   Mon,  1 Mar 2021 17:12:45 +0100
Message-Id: <20210301161230.923300902@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 15447b64789d9ade71eb374d5ae1f37d0bbce0bd upstream.

BOSS GP-10 with 0582:0185 requires the similar quirk to make the
implicit feedback working like other BOSS devices.

Reported-by: Keith Milner <kamilner@superlative.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210214154251.10750-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/implicit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -73,6 +73,7 @@ static const struct snd_usb_implicit_fb_
 	/* No quirk for playback but with capture quirk (see below) */
 	IMPLICIT_FB_SKIP_DEV(0x0582, 0x0130),	/* BOSS BR-80 */
 	IMPLICIT_FB_SKIP_DEV(0x0582, 0x0171),   /* BOSS RC-505 */
+	IMPLICIT_FB_SKIP_DEV(0x0582, 0x0185),	/* BOSS GP-10 */
 	IMPLICIT_FB_SKIP_DEV(0x0582, 0x0189),	/* BOSS GT-100v2 */
 	IMPLICIT_FB_SKIP_DEV(0x0582, 0x01d6),	/* BOSS GT-1 */
 	IMPLICIT_FB_SKIP_DEV(0x0582, 0x01d8),	/* BOSS Katana */
@@ -86,6 +87,7 @@ static const struct snd_usb_implicit_fb_
 static const struct snd_usb_implicit_fb_match capture_implicit_fb_quirks[] = {
 	IMPLICIT_FB_FIXED_DEV(0x0582, 0x0130, 0x0d, 0x01), /* BOSS BR-80 */
 	IMPLICIT_FB_FIXED_DEV(0x0582, 0x0171, 0x0d, 0x01), /* BOSS RC-505 */
+	IMPLICIT_FB_FIXED_DEV(0x0582, 0x0185, 0x0d, 0x01), /* BOSS GP-10 */
 	IMPLICIT_FB_FIXED_DEV(0x0582, 0x0189, 0x0d, 0x01), /* BOSS GT-100v2 */
 	IMPLICIT_FB_FIXED_DEV(0x0582, 0x01d6, 0x0d, 0x01), /* BOSS GT-1 */
 	IMPLICIT_FB_FIXED_DEV(0x0582, 0x01d8, 0x0d, 0x01), /* BOSS Katana */


