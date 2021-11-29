Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1841C462680
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbhK2WxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbhK2Wvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:51:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB43C1A0D08;
        Mon, 29 Nov 2021 10:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0782FB815EB;
        Mon, 29 Nov 2021 18:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3742BC53FAD;
        Mon, 29 Nov 2021 18:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210979;
        bh=2rgywBWwJa8OMFQQTRJMyDz0W0AP1M1uAc1YPxNUVtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RW12lKCFpd8zWGAbo5tzwVF81YwPnOxgN/OSxo/2VGkAqQhO0zo2OIhNt9EEKpd9t
         RZbmm7AwczRq3JJ3zJGCHjrgcy8GdXvBKN28EdNeKDvw/Tu/aI8cDewO6vbBdgLlqU
         qKIgbCyJzjlFd0RhfkOcI97ZDWkor8Rwj+hQykxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 029/179] staging: greybus: Add missing rwsem around snd_ctl_remove() calls
Date:   Mon, 29 Nov 2021 19:17:03 +0100
Message-Id: <20211129181719.913507542@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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


