Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE4238A2D6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhETJqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233766AbhETJoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:44:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BBE9613D8;
        Thu, 20 May 2021 09:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503190;
        bh=/CncAhzPTjBPbmdbXKkNiHClkxizzGCCXUoVLQh2+CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UU3ouFPD6AVzI1KhExZU4srcTXxh/OUAAPcsMKLM3a+L5QL2mnhsVKBjyr0H21zx3
         LOj9FO5N+TqucSPm9ca1DAcg6QOnlzWSmLtzT98bChGvCNoFfX9wsnXFZ75S1sZeJ6
         LCZDR0F52c4nAsQe+r2rJV6UhkLgjnQ6IuRGG48w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 076/425] ALSA: sb: Fix two use after free in snd_sb_qsound_build
Date:   Thu, 20 May 2021 11:17:25 +0200
Message-Id: <20210520092133.944431198@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
 


