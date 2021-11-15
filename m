Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A311450CB6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbhKORmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:42:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237832AbhKORjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:39:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2C5B632E8;
        Mon, 15 Nov 2021 17:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997190;
        bh=5Czvmy/Z7GfcashVrKRSNfkfkMxcmrh7/KppuZzOj7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLar/pLPJsrs7OuAFTtaSd6a33QGPVNp06FzIt9RB4PyBSBDaUOeIRZl4k8o6MubP
         owaJyQnBAn7nDbfG8rKdilx3VXBdsnOGw09b2xXNFSBUP26mwSEY8mRc70K/krNUkw
         qBNB5H4rjzMiuzfZ+G3w5ZIBYqIAWzcCioKC7KlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 040/575] ALSA: synth: missing check for possible NULL after the call to kstrdup
Date:   Mon, 15 Nov 2021 17:56:05 +0100
Message-Id: <20211115165345.017421927@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austin.kim@lge.com>

commit d159037abbe3412285c271bdfb9cdf19e62678ff upstream.

If kcalloc() return NULL due to memory starvation, it is possible for
kstrdup() to return NULL in similar case. So add null check after the call
to kstrdup() is made.

[ minor coding-style fix by tiwai ]

Signed-off-by: Austin Kim <austin.kim@lge.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211109003742.GA5423@raspberrypi
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/synth/emux/emux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -88,7 +88,7 @@ int snd_emux_register(struct snd_emux *e
 	emu->name = kstrdup(name, GFP_KERNEL);
 	emu->voices = kcalloc(emu->max_voices, sizeof(struct snd_emux_voice),
 			      GFP_KERNEL);
-	if (emu->voices == NULL)
+	if (emu->name == NULL || emu->voices == NULL)
 		return -ENOMEM;
 
 	/* create soundfont list */


