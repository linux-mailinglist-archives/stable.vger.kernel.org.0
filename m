Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C144A450B0A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbhKORRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236978AbhKORPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:15:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 371586322D;
        Mon, 15 Nov 2021 17:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996322;
        bh=3UtydLdEJfmraCHWQm0ERCQAxWACsBN7HaPESruk6fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXhiOLodEX28LsSfLSXhX2zYc8st4N8VT/0ybH2tlpULTkqZTL8hEjpk+mwrgCZZ1
         2UDCeiLsq84M9QfaBRH9OlRNqDCh0MtwiVomc0sl1W/KxEK1w4ctoKO+nRiv/1cTbH
         cYVdX+njxEAImyuqzaUKl2GidiQMYIxrLDStPgBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ace149a75a9a0a399ac7@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 096/355] ALSA: mixer: fix deadlock in snd_mixer_oss_set_volume
Date:   Mon, 15 Nov 2021 18:00:20 +0100
Message-Id: <20211115165316.903581870@linuxfoundation.org>
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
 


