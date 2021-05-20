Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2715C38A878
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbhETKvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237866AbhETKsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:48:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A40161415;
        Thu, 20 May 2021 09:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504716;
        bh=/CncAhzPTjBPbmdbXKkNiHClkxizzGCCXUoVLQh2+CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq6SQQ7H4Nvn6VUEP2tos0uJYm7TSiUlDoLs/6tQaD9z0ZEG2G8lZ+xitN3dk1fTt
         XwXE76nPLxEwFnV7I7/poN3nHszI9P4zmmAe4VHMB8Uq8MSfzfJ31wb0t6xmkY6tV7
         yCEOIZIjskW0VT0tTciNj/1cxEXhGRewiOZbvdww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 049/240] ALSA: sb: Fix two use after free in snd_sb_qsound_build
Date:   Thu, 20 May 2021 11:20:41 +0200
Message-Id: <20210520092110.317611779@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

commit 4fb44dd2c1dda18606348acdfdb97e8759dde9df upstream.

In snd_sb_qsound_build, snd_ctl_add(..,p->qsound_switch...) and
snd_ctl_add(..,p->qsound_space..) are called. But the second
arguments of snd_ctl_add() could be freed via snd_ctl_add_replace()
->snd_ctl_free_one(). After the error code is returned,
snd_sb_qsound_destroy(p) is called in __error branch.

But in snd_sb_qsound_destroy(), the freed p->qsound_switch and
p->qsound_space are still used by snd_ctl_remove().

My patch set p->qsound_switch and p->qsound_space to NULL if
snd_ctl_add() failed to avoid the uaf bugs. But these codes need
to further be improved with the code style.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210426145541.8070-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/sb/sb16_csp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -1059,10 +1059,14 @@ static int snd_sb_qsound_build(struct sn
 
 	spin_lock_init(&p->q_lock);
 
-	if ((err = snd_ctl_add(card, p->qsound_switch = snd_ctl_new1(&snd_sb_qsound_switch, p))) < 0)
+	if ((err = snd_ctl_add(card, p->qsound_switch = snd_ctl_new1(&snd_sb_qsound_switch, p))) < 0) {
+		p->qsound_switch = NULL;
 		goto __error;
-	if ((err = snd_ctl_add(card, p->qsound_space = snd_ctl_new1(&snd_sb_qsound_space, p))) < 0)
+	}
+	if ((err = snd_ctl_add(card, p->qsound_space = snd_ctl_new1(&snd_sb_qsound_space, p))) < 0) {
+		p->qsound_space = NULL;
 		goto __error;
+	}
 
 	return 0;
 


