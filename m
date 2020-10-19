Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D139292C3C
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgJSRDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:03:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32860 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730909AbgJSRCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:46 -0400
Date:   Mon, 19 Oct 2020 17:02:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126963;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tTlY+cBtYyvcd7ndef/FoMfCcKAf9Yycpj9RKczYcHY=;
        b=UA5F/RDIsB0UQOcabcAbNbkZng6f4FvvZvbM489MUcrJXVWOsr2058jvATH0wssXvs8MSN
        USSs9Ac8Aa7lacBJBVakyNWrQtfNdqGBIpGWeY6IvSYzA7JcbWcFQD4tD2Bx9kwceCQsfq
        cKhYpbg/2/xrtWeCxXZ1qCNX4DoNk049WxPXTl5KUZhGg/0BxmMMj3hkahGmMfObtyQNqg
        9MeHcStOGrgko7cEbF7BmuwlrqyLwlkHQ+2ix33VTs3Z0bXO+LnV6eXS7NApacIf0T4bwD
        CO47RkJQNfjLX8TKlrvqyM21RfuBjUXV+PZrWSoPV8MuyKHaoA6Mn4pAynidlw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126963;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tTlY+cBtYyvcd7ndef/FoMfCcKAf9Yycpj9RKczYcHY=;
        b=E7QHD1CG/97arEU4Ek7pcXTkNqLbif4u15QD+HB3icL7trRn3ZcCtT1/dbG15jle95t/SP
        nSSqf6x61zddtqDw==
From:   "tip-bot2 for Tetsuo Handa" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] vt_ioctl: make VT_RESIZEX behave like VT_RESIZE
Cc:     syzbot <syzbot+b308f5fd049fbbc6e74f@syzkaller.appspotmail.com>,
        syzbot <syzbot+16469b5e8e5a72e9131e@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        stable <stable@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4933b81b-9b1a-355b-df0e-9b31e8280ab9@i-love.sakura.ne.jp>
References: <4933b81b-9b1a-355b-df0e-9b31e8280ab9@i-love.sakura.ne.jp>
MIME-Version: 1.0
Message-ID: <160312696280.7002.6866734236123032181.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     6d389a66ccfc743699aa0274801654b6c7f9753b
Gitweb:        https://git.kernel.org/tip/6d389a66ccfc743699aa0274801654b6c7f9753b
Author:        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
AuthorDate:    Sun, 27 Sep 2020 20:46:30 +09:00
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:22 +02:00

vt_ioctl: make VT_RESIZEX behave like VT_RESIZE

commit 988d0763361bb65690d60e2bc53a6b72777040c3 upstream.

syzbot is reporting UAF/OOB read at bit_putcs()/soft_cursor() [1][2], for
vt_resizex() from ioctl(VT_RESIZEX) allows setting font height larger than
actual font height calculated by con_font_set() from ioctl(PIO_FONT).
Since fbcon_set_font() from con_font_set() allocates minimal amount of
memory based on actual font height calculated by con_font_set(),
use of vt_resizex() can cause UAF/OOB read for font data.

VT_RESIZEX was introduced in Linux 1.3.3, but it is unclear that what
comes to the "+ more" part, and I couldn't find a user of VT_RESIZEX.

  #define VT_RESIZE   0x5609 /* set kernel's idea of screensize */
  #define VT_RESIZEX  0x560A /* set kernel's idea of screensize + more */

So far we are not aware of syzbot reports caused by setting non-zero value
to v_vlin parameter. But given that it is possible that nobody is using
VT_RESIZEX, we can try removing support for v_clin and v_vlin parameters.

Therefore, this patch effectively makes VT_RESIZEX behave like VT_RESIZE,
with emitting a message if somebody is still using v_clin and/or v_vlin
parameters.

[1] https://syzkaller.appspot.com/bug?id=32577e96d88447ded2d3b76d71254fb855245837
[2] https://syzkaller.appspot.com/bug?id=6b8355d27b2b94fb5cedf4655e3a59162d9e48e3

Reported-by: syzbot <syzbot+b308f5fd049fbbc6e74f@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+16469b5e8e5a72e9131e@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4933b81b-9b1a-355b-df0e-9b31e8280ab9@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c | 57 ++++++--------------------------------
 1 file changed, 10 insertions(+), 47 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index a4e520b..bc33938 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -773,58 +773,21 @@ static int vt_resizex(struct vc_data *vc, struct vt_consize __user *cs)
 	if (copy_from_user(&v, cs, sizeof(struct vt_consize)))
 		return -EFAULT;
 
-	/* FIXME: Should check the copies properly */
-	if (!v.v_vlin)
-		v.v_vlin = vc->vc_scan_lines;
-
-	if (v.v_clin) {
-		int rows = v.v_vlin / v.v_clin;
-		if (v.v_rows != rows) {
-			if (v.v_rows) /* Parameters don't add up */
-				return -EINVAL;
-			v.v_rows = rows;
-		}
-	}
-
-	if (v.v_vcol && v.v_ccol) {
-		int cols = v.v_vcol / v.v_ccol;
-		if (v.v_cols != cols) {
-			if (v.v_cols)
-				return -EINVAL;
-			v.v_cols = cols;
-		}
-	}
-
-	if (v.v_clin > 32)
-		return -EINVAL;
+	if (v.v_vlin)
+		pr_info_once("\"struct vt_consize\"->v_vlin is ignored. Please report if you need this.\n");
+	if (v.v_clin)
+		pr_info_once("\"struct vt_consize\"->v_clin is ignored. Please report if you need this.\n");
 
+	console_lock();
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
-		struct vc_data *vcp;
+		vc = vc_cons[i].d;
 
-		if (!vc_cons[i].d)
-			continue;
-		console_lock();
-		vcp = vc_cons[i].d;
-		if (vcp) {
-			int ret;
-			int save_scan_lines = vcp->vc_scan_lines;
-			int save_font_height = vcp->vc_font.height;
-
-			if (v.v_vlin)
-				vcp->vc_scan_lines = v.v_vlin;
-			if (v.v_clin)
-				vcp->vc_font.height = v.v_clin;
-			vcp->vc_resize_user = 1;
-			ret = vc_resize(vcp, v.v_cols, v.v_rows);
-			if (ret) {
-				vcp->vc_scan_lines = save_scan_lines;
-				vcp->vc_font.height = save_font_height;
-				console_unlock();
-				return ret;
-			}
+		if (vc) {
+			vc->vc_resize_user = 1;
+			vc_resize(vc, v.v_cols, v.v_rows);
 		}
-		console_unlock();
 	}
+	console_unlock();
 
 	return 0;
 }
