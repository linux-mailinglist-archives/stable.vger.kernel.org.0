Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C68420B83
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhJDM5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233565AbhJDM5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD15F6139F;
        Mon,  4 Oct 2021 12:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352125;
        bh=2qpAD+L5/T28ZNjqb6iHZdmxrgabzWb4CH1om1FuagI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6oWsrtN38GF7AVA/OBKdZddtjwcPANYeBLVrX+3g/brgK5mmn1V6fXSa/Uv58Ms7
         /NxTjlAPxWrbkB8OuRSGniCCLnJbFYVlQRQUvDTbyyYNwZg5FDZdU7vUE5iw4sy9P4
         eSWD+hJyG+4NM+dr/yIP8qZ9RY0q1wQhRucMmBkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Igor Matheus Andrade Torrente <igormtorrente@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+858dc7a2f7ef07c2c219@syzkaller.appspotmail.com
Subject: [PATCH 4.4 25/41] tty: Fix out-of-bound vmalloc access in imageblit
Date:   Mon,  4 Oct 2021 14:52:16 +0200
Message-Id: <20211004125027.378244619@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125026.597501645@linuxfoundation.org>
References: <20211004125026.597501645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>

[ Upstream commit 3b0c406124719b625b1aba431659f5cdc24a982c ]

This issue happens when a userspace program does an ioctl
FBIOPUT_VSCREENINFO passing the fb_var_screeninfo struct
containing only the fields xres, yres, and bits_per_pixel
with values.

If this struct is the same as the previous ioctl, the
vc_resize() detects it and doesn't call the resize_screen(),
leaving the fb_var_screeninfo incomplete. And this leads to
the updatescrollmode() calculates a wrong value to
fbcon_display->vrows, which makes the real_y() return a
wrong value of y, and that value, eventually, causes
the imageblit to access an out-of-bound address value.

To solve this issue I made the resize_screen() be called
even if the screen does not need any resizing, so it will
"fix and fill" the fb_var_screeninfo independently.

Cc: stable <stable@vger.kernel.org> # after 5.15-rc2 is out, give it time to bake
Reported-and-tested-by: syzbot+858dc7a2f7ef07c2c219@syzkaller.appspotmail.com
Signed-off-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Link: https://lore.kernel.org/r/20210628134509.15895-1-igormtorrente@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 9f479b4c6491..0fab196a1d90 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -882,8 +882,25 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	new_row_size = new_cols << 1;
 	new_screen_size = new_row_size * new_rows;
 
-	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
-		return 0;
+	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows) {
+		/*
+		 * This function is being called here to cover the case
+		 * where the userspace calls the FBIOPUT_VSCREENINFO twice,
+		 * passing the same fb_var_screeninfo containing the fields
+		 * yres/xres equal to a number non-multiple of vc_font.height
+		 * and yres_virtual/xres_virtual equal to number lesser than the
+		 * vc_font.height and yres/xres.
+		 * In the second call, the struct fb_var_screeninfo isn't
+		 * being modified by the underlying driver because of the
+		 * if above, and this causes the fbcon_display->vrows to become
+		 * negative and it eventually leads to out-of-bound
+		 * access by the imageblit function.
+		 * To give the correct values to the struct and to not have
+		 * to deal with possible errors from the code below, we call
+		 * the resize_screen here as well.
+		 */
+		return resize_screen(vc, new_cols, new_rows, user);
+	}
 
 	if (new_screen_size > (4 << 20))
 		return -EINVAL;
-- 
2.33.0



