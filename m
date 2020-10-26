Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D2729869F
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 06:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769900AbgJZFyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 01:54:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:51292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1769866AbgJZFyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 01:54:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 47A4CADA2;
        Mon, 26 Oct 2020 05:54:20 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org,
        Fabian Vogt <fvogt@suse.com>
Subject: [PATCH] vt_ioctl: fix GIO_UNIMAP regression
Date:   Mon, 26 Oct 2020 06:54:19 +0100
Message-Id: <20201026055419.30518-1-jslaby@suse.cz>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 5ba127878722, we shuffled with the check of 'perm'. But my
brain somehow inverted the condition in 'do_unimap_ioctl' (I thought
it is ||, not &&), so GIO_UNIMAP stopped working completely.

Move the 'perm' checks back to do_unimap_ioctl and do them right again.
In fact, this reverts this part of code to the pre-5ba127878722 state.
Except 'perm' is now a bool.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Fixes: 5ba127878722 ("vt_ioctl: move perm checks level up")
Cc: stable@vger.kernel.org
Reported-by:  Fabian Vogt <fvogt@suse.com>
---
 drivers/tty/vt/vt_ioctl.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 0a33b8ababe3..2321775ef098 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -549,7 +549,7 @@ static int vt_io_fontreset(struct console_font_op *op)
 }
 
 static inline int do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud,
-		struct vc_data *vc)
+		bool perm, struct vc_data *vc)
 {
 	struct unimapdesc tmp;
 
@@ -557,9 +557,11 @@ static inline int do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud,
 		return -EFAULT;
 	switch (cmd) {
 	case PIO_UNIMAP:
+		if (!perm)
+			return -EPERM;
 		return con_set_unimap(vc, tmp.entry_ct, tmp.entries);
 	case GIO_UNIMAP:
-		if (fg_console != vc->vc_num)
+		if (!perm && fg_console != vc->vc_num)
 			return -EPERM;
 		return con_get_unimap(vc, tmp.entry_ct, &(user_ud->entry_ct),
 				tmp.entries);
@@ -639,10 +641,7 @@ static int vt_io_ioctl(struct vc_data *vc, unsigned int cmd, void __user *up,
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
-		if (!perm)
-			return -EPERM;
-
-		return do_unimap_ioctl(cmd, up, vc);
+		return do_unimap_ioctl(cmd, up, perm, vc);
 
 	default:
 		return -ENOIOCTLCMD;
-- 
2.29.1

