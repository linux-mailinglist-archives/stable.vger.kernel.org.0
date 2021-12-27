Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9A048007C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbhL0Pqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42102 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239651AbhL0PnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:43:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 088EF61115;
        Mon, 27 Dec 2021 15:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFEFC36AEA;
        Mon, 27 Dec 2021 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619779;
        bh=axrEps4g8Y4tssIwyYMncEr8Am++R8DDVDyREOlV8Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5gLLJjAnVJpnsEiYKGBpbjyDtRvSxm1j12+AZ1UjfHEV9QE2yiJ4X0qQvq8F2JeH
         jezFa7E6Ey9LtC2Yyjm2nwBeiHRHUiZeek2xHh3E+XvdsT4RdcnSB9uK16cxcqDr6V
         WqK3lQSKIm3bl55ZICbqRfUh7hEu85RCe4eMrFpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org, broonie@kernel.org,
        syzbot+88412ee8811832b00dbe@syzkaller.appspotmail.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 067/128] ALSA: rawmidi - fix the uninitalized user_pversion
Date:   Mon, 27 Dec 2021 16:30:42 +0100
Message-Id: <20211227151333.731950733@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 39a8fc4971a00d22536aeb7d446ee4a97810611b upstream.

The user_pversion was uninitialized for the user space file structure
in the open function, because the file private structure use
kmalloc for the allocation.

The kernel ALSA sequencer code clears the file structure, so no additional
fixes are required.

Cc: stable@kernel.org
Cc: broonie@kernel.org
BugLink: https://github.com/alsa-project/alsa-lib/issues/178
Fixes: 09d23174402d ("ALSA: rawmidi: introduce SNDRV_RAWMIDI_IOCTL_USER_PVERSION")
Reported-by: syzbot+88412ee8811832b00dbe@syzkaller.appspotmail.com
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20211218123925.2583847-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/rawmidi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -447,6 +447,7 @@ static int snd_rawmidi_open(struct inode
 		err = -ENOMEM;
 		goto __error;
 	}
+	rawmidi_file->user_pversion = 0;
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(&rmidi->open_wait, &wait);
 	while (1) {


