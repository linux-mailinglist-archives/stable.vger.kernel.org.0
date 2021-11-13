Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415EC44F33D
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhKMNLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:11:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235805AbhKMNLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:11:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6E2360F45;
        Sat, 13 Nov 2021 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636808930;
        bh=z0TMVgQYHG8M96vjW9X97uP5J8/p1gENta/iEA3Wiqg=;
        h=Subject:To:Cc:From:Date:From;
        b=fkjDR6DAAJIoT4uE4Opn67n53a9lJ6KFqF0L1F57kwZVkXLDdU3kBVFfPnOWr2tuz
         p6tYHJDjzSfMHqS9dZvKsybtLvnVJSKyQpGYUR7j9pHy9HV5WKjvMQMaNMDzQRl7m0
         48cnEjS++b09nFjAajB1ewo4QoGe3KGHbkJf6Fjg=
Subject: FAILED: patch "[PATCH] ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume" failed to apply to 4.9-stable tree
To:     paskripkin@gmail.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:08:34 +0100
Message-ID: <1636808914229169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3ab7992018455ac63c33e9b3eaa7264e293e40f4 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Sun, 24 Oct 2021 17:03:15 +0300
Subject: [PATCH] ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume

In commit 411cef6adfb3 ("ALSA: mixer: oss: Fix racy access to slots")
added mutex protection in snd_mixer_oss_set_volume(). Second
mutex_lock() in same function looks like typo, fix it.

Reported-by: syzbot+ace149a75a9a0a399ac7@syzkaller.appspotmail.com
Fixes: 411cef6adfb3 ("ALSA: mixer: oss: Fix racy access to slots")
Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20211024140315.16704-1-paskripkin@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index d5ddc154a735..9620115cfdc0 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -313,7 +313,7 @@ static int snd_mixer_oss_set_volume(struct snd_mixer_oss_file *fmixer,
 	pslot->volume[1] = right;
 	result = (left & 0xff) | ((right & 0xff) << 8);
  unlock:
-	mutex_lock(&mixer->reg_mutex);
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 

