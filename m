Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4F45BB11
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243317AbhKXMQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243608AbhKXMOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAD4F61163;
        Wed, 24 Nov 2021 12:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755770;
        bh=ORdil0lSCH5niHK5ARiMh6xV9T34JDvnkZDM1a6Q37c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALuPxt7QB5q7AkI/U1zrwf00Gc/06dcCSlavgehq+klYlOJYUNWIxXdFtxwz+hBcJ
         o16lQUFvXtBx4cl5P87bsPi3ZXr9jvpfjCAGBU8ZZ4s+OOmgyH1BE7QtwGtNRRRLsC
         SMykEGRIdm/MzZJsthoo8ko4/ugowPTKdADDbIiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ace149a75a9a0a399ac7@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 049/207] ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume
Date:   Wed, 24 Nov 2021 12:55:20 +0100
Message-Id: <20211124115705.519483184@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 3ab7992018455ac63c33e9b3eaa7264e293e40f4 upstream.

In commit 411cef6adfb3 ("ALSA: mixer: oss: Fix racy access to slots")
added mutex protection in snd_mixer_oss_set_volume(). Second
mutex_lock() in same function looks like typo, fix it.

Reported-by: syzbot+ace149a75a9a0a399ac7@syzkaller.appspotmail.com
Fixes: 411cef6adfb3 ("ALSA: mixer: oss: Fix racy access to slots")
Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20211024140315.16704-1-paskripkin@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/oss/mixer_oss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -328,7 +328,7 @@ static int snd_mixer_oss_set_volume(stru
 	pslot->volume[1] = right;
 	result = (left & 0xff) | ((right & 0xff) << 8);
  unlock:
-	mutex_lock(&mixer->reg_mutex);
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 


