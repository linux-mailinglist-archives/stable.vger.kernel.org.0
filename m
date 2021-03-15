Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15D833B7AE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhCOOBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhCON7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0B5964F31;
        Mon, 15 Mar 2021 13:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816757;
        bh=ll99MXgdV4WftplZUy3c+s/6/3++75ApUZzSaIB72cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrAO4HXnX743Hr5I1c5uOvACDA1Aq3khZHe14imr8uTSwNR6Wq4Qz8fEf/MwdCnQf
         Qk8Dhh3kbzPcVC9wSuMx0+u5V+KEZ6WrEIj4U3q2Fo1Rt1p2T+wkOkf2DOJ9JPVlI7
         vUBZnqfx6yuwXXw8v8U5Q5B0DMjcmvmCUCi9/xjU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Kempe <kempe@lysator.liu.se>,
        John Ernberg <john.ernberg@actia.se>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 088/168] ALSA: usb: Add Plantronics C320-M USB ctrl msg delay quirk
Date:   Mon, 15 Mar 2021 14:55:20 +0100
Message-Id: <20210315135553.271012993@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: John Ernberg <john.ernberg@actia.se>

commit fc7c5c208eb7bc2df3a9f4234f14eca250001cb6 upstream.

The microphone in the Plantronics C320-M headset will randomly
fail to initialize properly, at least when using Microsoft Teams.
Introducing a 20ms delay on the control messages appears to
resolve the issue.

Link: https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/issues/1065
Tested-by: Andreas Kempe <kempe@lysator.liu.se>
Signed-off-by: John Ernberg <john.ernberg@actia.se>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210303181405.39835-1-john.ernberg@actia.se
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1604,6 +1604,14 @@ void snd_usb_ctl_msg_quirk(struct usb_de
 	    && (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		msleep(20);
 
+	/*
+	 * Plantronics C320-M needs a delay to avoid random
+	 * microhpone failures.
+	 */
+	if (chip->usb_id == USB_ID(0x047f, 0xc025)  &&
+	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
+		msleep(20);
+
 	/* Zoom R16/24, many Logitech(at least H650e/H570e/BCC950),
 	 * Jabra 550a, Kingston HyperX needs a tiny delay here,
 	 * otherwise requests like get/set frequency return


