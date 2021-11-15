Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0376450ABE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhKOROW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231517AbhKORMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:12:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16A3561BF8;
        Mon, 15 Nov 2021 17:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996183;
        bh=5Czvmy/Z7GfcashVrKRSNfkfkMxcmrh7/KppuZzOj7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixfSW9pmc0gAhbSbEXYuFJTSTpwrs0wVHXlbLZRqnOBUNpKW7SJ8rvovFYecw1TbU
         HZ0aDgpW21FfM8MngyrYbFPefPPpl3jI69ix+JtK6kpHYBDTKQDW660FaYuEE0utgo
         RDQuAgRFnW3H30onw8Esx3S11a7iqRVT9nPvrGOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 029/355] ALSA: synth: missing check for possible NULL after the call to kstrdup
Date:   Mon, 15 Nov 2021 17:59:13 +0100
Message-Id: <20211115165314.490190483@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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


