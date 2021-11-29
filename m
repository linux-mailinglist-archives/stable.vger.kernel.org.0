Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1074A46266D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhK2WwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbhK2Wui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:50:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2D7C127B4B;
        Mon, 29 Nov 2021 10:28:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03612B815A9;
        Mon, 29 Nov 2021 18:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AD9C53FD4;
        Mon, 29 Nov 2021 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210517;
        bh=2rgywBWwJa8OMFQQTRJMyDz0W0AP1M1uAc1YPxNUVtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPZIMwsIuDATqwoE1U+SYTBzgTcE6zmopxjiI7+V/GP0/TfPzNct2A1NCSJDRKm9h
         mw6n2q61ouzlTuxKi/OSHFSqI0B9kqKTrhAY8kwcoXsMl56alYm+5EDfG/nRP+lghr
         xe88ho3BEC9HpR/2v8Z7Egu3qMtOKGOa+3jfe3Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 023/121] staging: greybus: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 29 Nov 2021 19:17:34 +0100
Message-Id: <20211129181712.434336036@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit ffcf7ae90f4489047d7b076539ba207024dea5f6 upstream.

snd_ctl_remove() has to be called with card->controls_rwsem held (when
called after the card instantiation).  This patch adds the missing
rwsem calls around it.

Fixes: 510e340efe0c ("staging: greybus: audio: Add helper APIs for dynamic audio modules")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20211116072027.18466-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/audio_helper.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/staging/greybus/audio_helper.c
+++ b/drivers/staging/greybus/audio_helper.c
@@ -192,7 +192,11 @@ int gbaudio_remove_component_controls(st
 				      unsigned int num_controls)
 {
 	struct snd_card *card = component->card->snd_card;
+	int err;
 
-	return gbaudio_remove_controls(card, component->dev, controls,
-				       num_controls, component->name_prefix);
+	down_write(&card->controls_rwsem);
+	err = gbaudio_remove_controls(card, component->dev, controls,
+				      num_controls, component->name_prefix);
+	up_write(&card->controls_rwsem);
+	return err;
 }


