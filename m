Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDCC33B9A8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhCOOG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232529AbhCOOBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F25BE64DAD;
        Mon, 15 Mar 2021 14:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816903;
        bh=9wyKlr/EQljsHgyaIzwI0soeNwiz4UREscQBXHwO4z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXX/KYAt262IhdyXhgeazOk71vYSsXNzz3aCfnYl+dl9JgHAqUO8QBj8aiqnRIwX+
         0F/867HZX0udNxavwrDMcntzoI9vlp6JitLG+im934KTvqcULfOeUn80Gj4foGFcaL
         X1rIuZNYoEW567WDsLu1aU0HbmGfdOJBM58Hxtaw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 179/290] ALSA: usb-audio: Apply the control quirk to Plantronics headsets
Date:   Mon, 15 Mar 2021 14:54:32 +0100
Message-Id: <20210315135547.958798922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Takashi Iwai <tiwai@suse.de>

commit 06abcb18b3a021ba1a3f2020cbefb3ed04e59e72 upstream.

Other Plantronics headset models seem requiring the same workaround as
C320-M to add the 20ms delay for the control messages, too.  Apply the
workaround generically for devices with the vendor ID 0x047f.

Note that the problem didn't surface before 5.11 just with luck.
Since 5.11 got a big code rewrite about the stream handling, the
parameter setup procedure has changed, and this seemed triggering the
problem more often.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1182552
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210304085009.4770-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1674,10 +1674,10 @@ void snd_usb_ctl_msg_quirk(struct usb_de
 		msleep(20);
 
 	/*
-	 * Plantronics C320-M needs a delay to avoid random
-	 * microhpone failures.
+	 * Plantronics headsets (C320, C320-M, etc) need a delay to avoid
+	 * random microhpone failures.
 	 */
-	if (chip->usb_id == USB_ID(0x047f, 0xc025)  &&
+	if (USB_ID_VENDOR(chip->usb_id) == 0x047f &&
 	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
 		msleep(20);
 


