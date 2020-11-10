Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC232ACC57
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732781AbgKJDyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732759AbgKJDyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2B38207BC;
        Tue, 10 Nov 2020 03:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980477;
        bh=X/AtrDzhqu2u5XpLJqCiXKOLPONAhkupltYsvuK8n2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pbx40JFWtDVn+VGxAo5WmUXZRIOqUGzzLXtd4fZwkQMVv/4pqz9LJStFqJfTctKWr
         +ItGnYdYrO0VdVgguyZWjjQ/hnlPqWw8e52TjnMhNxBhhJ9t2KSUnwfzWYFLVFYiqm
         fU7Tt307YFRnWPpdo/X/ZJpDoA3/umhLmEbtnkO0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Minh Yuan <yuanmingbuaa@gmail.com>, Greg KH <greg@kroah.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 54/55] vt: Disable KD_FONT_OP_COPY
Date:   Mon,  9 Nov 2020 22:53:17 -0500
Message-Id: <20201110035318.423757-54-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 3c4e0dff2095c579b142d5a0693257f1c58b4804 ]

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
References: https://lists.freedesktop.org/archives/systemd-devel/2016-June/036935.html
References: https://github.com/systemd/systemd/pull/3651
Cc: Greg KH <greg@kroah.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Link: https://lore.kernel.org/r/20201108153806.3140315-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 19cd4a4b19399..e7ef807bcaaaf 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4700,27 +4700,6 @@ static int con_font_default(struct vc_data *vc, struct console_font_op *op)
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
@@ -4731,7 +4710,8 @@ int con_font_op(struct vc_data *vc, struct console_font_op *op)
 	case KD_FONT_OP_SET_DEFAULT:
 		return con_font_default(vc, op);
 	case KD_FONT_OP_COPY:
-		return con_font_copy(vc, op);
+		/* was buggy and never really used */
+		return -EINVAL;
 	}
 	return -ENOSYS;
 }
-- 
2.27.0

