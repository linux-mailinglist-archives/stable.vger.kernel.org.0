Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B323744F400
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 16:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbhKMPlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 10:41:45 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:42606 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbhKMPlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 10:41:44 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 679E81FD46;
        Sat, 13 Nov 2021 15:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636817931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hoATkK7u+RxUSPw17dCKHEbWDyklAvh908gw8Y3BLVQ=;
        b=Fves5ZzXxPwVr/AyYj7hkjER9ty7LqUHr+tKQtSx91rnSOiZPIoXwpH743TnuMYXPRPEbl
        2ocz7HKLnT1HbQ4kvgv+ESLKt4g83hC8rOrwqTNlORN1QI7LlYgGvJL9fubR6G5u/gE8Rj
        6z0oxRT2Nxs+IGY6Rp/BShsaClSCLzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636817931;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hoATkK7u+RxUSPw17dCKHEbWDyklAvh908gw8Y3BLVQ=;
        b=9+6uFsTaqz2nLf+m0lMvnyECv2gShh8UmD3UKshsQauShyqXbXxyNv5GHumbaj7zHOxxbU
        BINaHDf4guxrRcDA==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 55BC8A3B83;
        Sat, 13 Nov 2021 15:38:51 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH stable-5.4.y 2/2] ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume
Date:   Sat, 13 Nov 2021 16:38:46 +0100
Message-Id: <20211113153846.10996-2-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211113153846.10996-1-tiwai@suse.de>
References: <20211113153846.10996-1-tiwai@suse.de>
MIME-Version: 1.0
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
---

Please apply to older stable kernels, too.

 sound/core/oss/mixer_oss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index fd567611f67e..50ec8b8ff68c 100644
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
 
-- 
2.26.2

