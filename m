Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C9C259C2A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgIARLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:32848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgIAPQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:16:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74717206EB;
        Tue,  1 Sep 2020 15:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973376;
        bh=3CExIOXr3YwRtUueirUXSlXgJc1n8FAFOrJkVfadvsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gR8jop1UzFecf1zYQYpgqihg4DdMFXPvfWT5Z8Uz3fW0AwoP27Kp1XPaDooWFT/iA
         jb/mFH82k69gHj2daNKS6m8qtpFnsMUjuueKvmTf1YR31dPy24OBixCluX7cbscxrV
         9XUtUhyFbQk/91468rJ9HYWQCLMSoCuqByG4UPfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+9116ecc1978ca3a12f43@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4.9 53/78] vt: defer kfree() of vc_screenbuf in vc_do_resize()
Date:   Tue,  1 Sep 2020 17:10:29 +0200
Message-Id: <20200901150927.405612596@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit f8d1653daec02315e06d30246cff4af72e76e54e upstream.

syzbot is reporting UAF bug in set_origin() from vc_do_resize() [1], for
vc_do_resize() calls kfree(vc->vc_screenbuf) before calling set_origin().

Unfortunately, in set_origin(), vc->vc_sw->con_set_origin() might access
vc->vc_pos when scroll is involved in order to manipulate cursor, but
vc->vc_pos refers already released vc->vc_screenbuf until vc->vc_pos gets
updated based on the result of vc->vc_sw->con_set_origin().

Preserving old buffer and tolerating outdated vc members until set_origin()
completes would be easier than preventing vc->vc_sw->con_set_origin() from
accessing outdated vc members.

[1] https://syzkaller.appspot.com/bug?id=6649da2081e2ebdc65c0642c214b27fe91099db3

Reported-by: syzbot <syzbot+9116ecc1978ca3a12f43@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1596034621-4714-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -868,7 +868,7 @@ static int vc_do_resize(struct tty_struc
 	unsigned int old_rows, old_row_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
 	unsigned int user;
-	unsigned short *newscreen;
+	unsigned short *oldscreen, *newscreen;
 
 	WARN_CONSOLE_UNLOCKED();
 
@@ -950,10 +950,11 @@ static int vc_do_resize(struct tty_struc
 	if (new_scr_end > new_origin)
 		scr_memsetw((void *)new_origin, vc->vc_video_erase_char,
 			    new_scr_end - new_origin);
-	kfree(vc->vc_screenbuf);
+	oldscreen = vc->vc_screenbuf;
 	vc->vc_screenbuf = newscreen;
 	vc->vc_screenbuf_size = new_screen_size;
 	set_origin(vc);
+	kfree(oldscreen);
 
 	/* do part of a reset_terminal() */
 	vc->vc_top = 0;


