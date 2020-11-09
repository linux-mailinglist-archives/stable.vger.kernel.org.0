Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF222ABAE4
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbgKINUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730884AbgKINUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E35B020663;
        Mon,  9 Nov 2020 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928033;
        bh=MBVVUTVc6OR3Hd5UP/dEY9MxaVYoDNioxeoYYdqFpGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQvtCOe+u21lnJ2qmbq2RDEoQHQ/L1qulKYr81ioEkzRT9yjss1XdyGNr0AAqGqyD
         swQNok84dRVmxWbKukva7QuO3YtZhwcrsqssHHLGif7fZsmhKBnstl5HKEQWvqn87h
         +kKkGX00CoMCMWlPeTLzrgQndqhJgkRz+Uf4i5w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>,
        Minh Yuan <yuanmingbuaa@gmail.com>, Greg KH <greg@kroah.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5.9 105/133] vt: Disable KD_FONT_OP_COPY
Date:   Mon,  9 Nov 2020 13:56:07 +0100
Message-Id: <20201109125035.741312801@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 3c4e0dff2095c579b142d5a0693257f1c58b4804 upstream.

It's buggy:

On Fri, Nov 06, 2020 at 10:30:08PM +0800, Minh Yuan wrote:
> We recently discovered a slab-out-of-bounds read in fbcon in the latest
> kernel ( v5.10-rc2 for now ).  The root cause of this vulnerability is that
> "fbcon_do_set_font" did not handle "vc->vc_font.data" and
> "vc->vc_font.height" correctly, and the patch
> <https://lkml.org/lkml/2020/9/27/223> for VT_RESIZEX can't handle this
> issue.
>
> Specifically, we use KD_FONT_OP_SET to set a small font.data for tty6, and
> use  KD_FONT_OP_SET again to set a large font.height for tty1. After that,
> we use KD_FONT_OP_COPY to assign tty6's vc_font.data to tty1's vc_font.data
> in "fbcon_do_set_font", while tty1 retains the original larger
> height. Obviously, this will cause an out-of-bounds read, because we can
> access a smaller vc_font.data with a larger vc_font.height.

Further there was only one user ever.
- Android's loadfont, busybox and console-tools only ever use OP_GET
  and OP_SET
- fbset documentation only mentions the kernel cmdline font: option,
  not anything else.
- systemd used OP_COPY before release 232 published in Nov 2016

Now unfortunately the crucial report seems to have gone down with
gmane, and the commit message doesn't say much. But the pull request
hints at OP_COPY being broken

https://github.com/systemd/systemd/pull/3651

So in other words, this never worked, and the only project which
foolishly every tried to use it, realized that rather quickly too.

Instead of trying to fix security issues here on dead code by adding
missing checks, fix the entire thing by removing the functionality.

Note that systemd code using the OP_COPY function ignored the return
value, so it doesn't matter what we're doing here really - just in
case a lone server somewhere happens to be extremely unlucky and
running an affected old version of systemd. The relevant code from
font_copy_to_all_vcs() in systemd was:

	/* copy font from active VT, where the font was uploaded to */
	cfo.op = KD_FONT_OP_COPY;
	cfo.height = vcs.v_active-1; /* tty1 == index 0 */
	(void) ioctl(vcfd, KDFONTOP, &cfo);

Note this just disables the ioctl, garbage collecting the now unused
callbacks is left for -next.

v2: Tetsuo found the old mail, which allowed me to find it on another
archive. Add the link too.

Acked-by: Peilin Ye <yepeilin.cs@gmail.com>
Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://lore.kernel.org/r/20201108153806.3140315-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4700,27 +4700,6 @@ static int con_font_default(struct vc_da
 	return rc;
 }
 
-static int con_font_copy(struct vc_data *vc, struct console_font_op *op)
-{
-	int con = op->height;
-	int rc;
-
-
-	console_lock();
-	if (vc->vc_mode != KD_TEXT)
-		rc = -EINVAL;
-	else if (!vc->vc_sw->con_font_copy)
-		rc = -ENOSYS;
-	else if (con < 0 || !vc_cons_allocated(con))
-		rc = -ENOTTY;
-	else if (con == vc->vc_num)	/* nothing to do */
-		rc = 0;
-	else
-		rc = vc->vc_sw->con_font_copy(vc, con);
-	console_unlock();
-	return rc;
-}
-
 int con_font_op(struct vc_data *vc, struct console_font_op *op)
 {
 	switch (op->op) {
@@ -4731,7 +4710,8 @@ int con_font_op(struct vc_data *vc, stru
 	case KD_FONT_OP_SET_DEFAULT:
 		return con_font_default(vc, op);
 	case KD_FONT_OP_COPY:
-		return con_font_copy(vc, op);
+		/* was buggy and never really used */
+		return -EINVAL;
 	}
 	return -ENOSYS;
 }


