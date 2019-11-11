Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1829DF7E79
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfKKSn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:43:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbfKKSnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:43:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30F52173B;
        Mon, 11 Nov 2019 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497804;
        bh=/nHuH0hvuAw08PPOh/q8OkvYcVbuFDtssqgRIWUq81s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfSmzu8mI1480WJ5AF6p5r2isr15DdjSk0AE4W9KBfh3snnP/myshjHAyg21lpC+H
         r/R/SvWY/uyy1qFbkA7/PvlYiwWEqylih4tLHQ0u5Y7JJzLQELZzHnNTuiy72zgjn8
         hX1DUheqf/JAooOSSfxEhcXddvSdNjMc3BmYRREA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 062/125] ALSA: usb-audio: Fix possible NULL dereference at create_yamaha_midi_quirk()
Date:   Mon, 11 Nov 2019 19:28:21 +0100
Message-Id: <20191111181448.565879068@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 60849562a5db4a1eee2160167e4dce4590d3eafe upstream.

The previous addition of descriptor validation may lead to a NULL
dereference at create_yamaha_midi_quirk() when either injd or outjd is
NULL.  Add proper non-NULL checks.

Fixes: 57f8770620e9 ("ALSA: usb-audio: More validations of descriptor units")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -259,8 +259,8 @@ static int create_yamaha_midi_quirk(stru
 					NULL, USB_MS_MIDI_OUT_JACK);
 	if (!injd && !outjd)
 		return -ENODEV;
-	if (!snd_usb_validate_midi_desc(injd) ||
-	    !snd_usb_validate_midi_desc(outjd))
+	if (!(injd && snd_usb_validate_midi_desc(injd)) ||
+	    !(outjd && snd_usb_validate_midi_desc(outjd)))
 		return -ENODEV;
 	if (injd && (injd->bLength < 5 ||
 		     (injd->bJackType != USB_MS_EMBEDDED &&


