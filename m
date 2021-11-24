Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90A545B99B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbhKXMDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:03:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241888AbhKXMDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:03:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 342F5600EF;
        Wed, 24 Nov 2021 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755213;
        bh=xmzpDdi+dFBtEOdPA4IUgOZjjZmMIXcbMjn4sF9pUTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uO9m/jhHp7UI0QL6RpQfK6Sxlyr9+sdkVkZA9jBiOl8Eg5G6zphczNxY3/llnQ/rd
         5KFHhzAlHxYntjDdeQ+HLb1doFrAFGOqFvInmfku3Z/5/IVFiNECcd6SfccJ5fGdJn
         bkAB6XzgLuH+Ti5VC00ORMPXkyaiuJ2toNQM0ieU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 014/162] ALSA: synth: missing check for possible NULL after the call to kstrdup
Date:   Wed, 24 Nov 2021 12:55:17 +0100
Message-Id: <20211124115658.788216302@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
@@ -101,7 +101,7 @@ int snd_emux_register(struct snd_emux *e
 	emu->name = kstrdup(name, GFP_KERNEL);
 	emu->voices = kcalloc(emu->max_voices, sizeof(struct snd_emux_voice),
 			      GFP_KERNEL);
-	if (emu->voices == NULL)
+	if (emu->name == NULL || emu->voices == NULL)
 		return -ENOMEM;
 
 	/* create soundfont list */


