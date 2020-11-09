Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2F32ABB8B
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731662AbgKINKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:10:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732190AbgKINKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:10:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60B1420663;
        Mon,  9 Nov 2020 13:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927453;
        bh=c4fqUKwJLWUdNQAK10C+8HsUOSTKIwNnNPCC/mNN9gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QE+8HWrjoq1i8DLwPDBWCRdN4/07A0lPIkB56+6i4q9iWbzXFBUsptz0hP24rlgPj
         WHCDimt10txj0NL6I0F25S8teWkPMm9qU4LpxA4qNujzPgffVf3hqi0zkZn6RtK0CN
         BksSa0uO02aehHZUWneUairCcHo0LDcEPYbY+D8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 34/71] ALSA: usb-audio: Add implicit feedback quirk for Qu-16
Date:   Mon,  9 Nov 2020 13:55:28 +0100
Message-Id: <20201109125021.506224588@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoffrey D. Bennett <g@b4.vu>

commit 0938ecae432e7ac8b01080c35dd81d50a1e43033 upstream.

This patch fixes audio distortion on playback for the Allen&Heath
Qu-16.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201104115717.GA19046@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -334,6 +334,7 @@ static int set_sync_ep_implicit_fb_quirk
 	switch (subs->stream->chip->usb_id) {
 	case USB_ID(0x0763, 0x2030): /* M-Audio Fast Track C400 */
 	case USB_ID(0x0763, 0x2031): /* M-Audio Fast Track C600 */
+	case USB_ID(0x22f0, 0x0006): /* Allen&Heath Qu-16 */
 		ep = 0x81;
 		ifnum = 3;
 		goto add_sync_ep_from_ifnum;


