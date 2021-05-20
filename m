Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3B638A876
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbhETKvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237589AbhETKsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:48:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D9F661411;
        Thu, 20 May 2021 09:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504714;
        bh=AL7u/WMym1lYfDxy4MVtqLMV/bv2ffPUd+7yZssaMYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jQDLfDuhexHRxqDmBSI6oOZCwQi2od3HIo2ZA5gd9ykCVpJx+j9fxZYsEyVkIIC5
         xBtCgQ2iyF9/CNaXF3xMLw30BQUu8Vl/+dHywrlDRMb6i7ng+zGnhHxgKhZDaMUo/n
         mDq3UPN9fVCz327gQ25RjjlxXhhHMWfp3+mUaspI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 048/240] ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer
Date:   Thu, 20 May 2021 11:20:40 +0200
Message-Id: <20210520092110.282103267@linuxfoundation.org>
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

commit 1c98f574403dbcf2eb832d5535a10d967333ef2d upstream.

Our code analyzer reported a uaf.

In snd_emu8000_create_mixer, the callee snd_ctl_add(..,emu->controls[i])
calls snd_ctl_add_replace(.., kcontrol,..). Inside snd_ctl_add_replace(),
if error happens, kcontrol will be freed by snd_ctl_free_one(kcontrol).
Then emu->controls[i] points to a freed memory, and the execution comes
to __error branch of snd_emu8000_create_mixer. The freed emu->controls[i]
is used in snd_ctl_remove(card, emu->controls[i]).

My patch set emu->controls[i] to NULL if snd_ctl_add() failed to avoid
the uaf.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210426131129.4796-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/sb/emu8000.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/isa/sb/emu8000.c
+++ b/sound/isa/sb/emu8000.c
@@ -1042,8 +1042,10 @@ snd_emu8000_create_mixer(struct snd_card
 
 	memset(emu->controls, 0, sizeof(emu->controls));
 	for (i = 0; i < EMU8000_NUM_CONTROLS; i++) {
-		if ((err = snd_ctl_add(card, emu->controls[i] = snd_ctl_new1(mixer_defs[i], emu))) < 0)
+		if ((err = snd_ctl_add(card, emu->controls[i] = snd_ctl_new1(mixer_defs[i], emu))) < 0) {
+			emu->controls[i] = NULL;
 			goto __error;
+		}
 	}
 	return 0;
 


