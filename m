Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEF24546F1
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 14:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhKQNMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 08:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhKQNMG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 08:12:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F11FC60E8E;
        Wed, 17 Nov 2021 13:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637154547;
        bh=eB8PPsgiPJ9/SaAajvJ35gAWOIDJ0PFRVbaq3N1meJA=;
        h=Subject:To:From:Date:From;
        b=0ma/FU2fGykdaL8vyk0QqznIM4mQVemBgrc3335AWN6l0HORw/hrmquEuZm43xsD3
         i3Nk9YwvjGzkaOH2TKl4J9sVR7YhJPrcyplAoOYceWl5Vn9tvK5L/5S11UjS25f12T
         KIMbRlBo83IF2whdoSujAqOqxJaAZHHO2InaEf5g=
Subject: patch "staging: greybus: Add missing rwsem around snd_ctl_remove() calls" added to staging-linus
To:     tiwai@suse.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 14:09:04 +0100
Message-ID: <16371545445113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: greybus: Add missing rwsem around snd_ctl_remove() calls

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ffcf7ae90f4489047d7b076539ba207024dea5f6 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Tue, 16 Nov 2021 08:20:27 +0100
Subject: staging: greybus: Add missing rwsem around snd_ctl_remove() calls

snd_ctl_remove() has to be called with card->controls_rwsem held (when
called after the card instantiation).  This patch adds the missing
rwsem calls around it.

Fixes: 510e340efe0c ("staging: greybus: audio: Add helper APIs for dynamic audio modules")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20211116072027.18466-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/audio_helper.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/greybus/audio_helper.c b/drivers/staging/greybus/audio_helper.c
index 1ed4772d2771..843760675876 100644
--- a/drivers/staging/greybus/audio_helper.c
+++ b/drivers/staging/greybus/audio_helper.c
@@ -192,7 +192,11 @@ int gbaudio_remove_component_controls(struct snd_soc_component *component,
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
-- 
2.34.0


