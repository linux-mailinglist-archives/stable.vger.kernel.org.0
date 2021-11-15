Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A036C4524DE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357411AbhKPBqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241379AbhKOSTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34728632AF;
        Mon, 15 Nov 2021 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998728;
        bh=3UtydLdEJfmraCHWQm0ERCQAxWACsBN7HaPESruk6fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3TAB3KnTRooUiPmFsio57TyHZYdIGxbe+j78KiIUnqXMQVztX9QwkX4qMkrPN2Zz
         z6ZD1Vq2JTcUT4ueVavofrXPByEb5MGolUvvpzY+zMbKSds8uL3bUPp8EFprVOkmZy
         uTGro4XiyCzuIu4Y/5m38Ewb23TjoHuBK1mjkMuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ace149a75a9a0a399ac7@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.14 040/849] ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume
Date:   Mon, 15 Nov 2021 17:52:03 +0100
Message-Id: <20211115165421.357772267@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
@@ -313,7 +313,7 @@ static int snd_mixer_oss_set_volume(stru
 	pslot->volume[1] = right;
 	result = (left & 0xff) | ((right & 0xff) << 8);
  unlock:
-	mutex_lock(&mixer->reg_mutex);
+	mutex_unlock(&mixer->reg_mutex);
 	return result;
 }
 


