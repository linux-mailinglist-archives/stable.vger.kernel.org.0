Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBD244F33B
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhKMNLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:11:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231555AbhKMNLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E39B60724;
        Sat, 13 Nov 2021 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636808923;
        bh=oyhYLpNf6n0cjwMsa4VWazYe3iUMU32npLgvGXvaWFQ=;
        h=Subject:To:Cc:From:Date:From;
        b=G31rWYvKZM5+JrmhhHWxcYKtb4L7dhvNw//n7acIQKZ6A8LaaDkdBCdBoitzfrE97
         8iBLvfK4MtLiWtC2h7qbbBxwwa4mNEormSNuazzG6PqaemQqywxr/9Lbihb2bYFQIF
         qEjTi7EzIbtS6dR2i0kHAjSHM+wcVOIrnhuaKNI8=
Subject: FAILED: patch "[PATCH] ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume" failed to apply to 5.10-stable tree
To:     paskripkin@gmail.com, stable@vger.kernel.org, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:08:33 +0100
Message-ID: <163680891316625@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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
 

