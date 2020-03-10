Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D71817FB00
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbgCJNJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730880AbgCJNJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:09:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2120D24691;
        Tue, 10 Mar 2020 13:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845796;
        bh=Vy+3LT7hQ+tD5XD0SBvg6Iv/W9zvuc2D7lWwe/bUvq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oojGqsYLU5RHFEWc6CRetQb9yEPKK7okCGHIa492U9FUev8dtOdOhR1p1qfybhtco
         vyI1jKnWpBBOWjsekUZE35vrDhZ01NIUh8k7QyCiEPRTp28HgDYjcbwFpiNG/O7Vrm
         aZQTKeKR8teHttqJ3k6buOkwNjbMU9bgMjx5YpRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.14 104/126] vt: selection, push console lock down
Date:   Tue, 10 Mar 2020 13:42:05 +0100
Message-Id: <20200310124210.283001157@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 4b70dd57a15d2f4685ac6e38056bad93e81e982f upstream.

We need to nest the console lock in sel_lock, so we have to push it down
a bit. Fortunately, the callers of set_selection_* just lock the console
lock around the function call. So moving it down is easy.

In the next patch, we switch the order.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Fixes: 07e6124a1a46 ("vt: selection, close sel_buffer race")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200228115406.5735-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/selection.c |   13 ++++++++++++-
 drivers/tty/vt/vt.c        |    2 --
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -157,7 +157,7 @@ static int store_utf8(u16 c, char *p)
  *	The entire selection process is managed under the console_lock. It's
  *	 a lot under the lock but its hardly a performance path
  */
-int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *tty)
+static int __set_selection(const struct tiocl_selection __user *sel, struct tty_struct *tty)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
 	int sel_mode, new_sel_start, new_sel_end, spc;
@@ -333,6 +333,17 @@ unlock:
 	return ret;
 }
 
+int set_selection(const struct tiocl_selection __user *v, struct tty_struct *tty)
+{
+	int ret;
+
+	console_lock();
+	ret = __set_selection(v, tty);
+	console_unlock();
+
+	return ret;
+}
+
 /* Insert the contents of the selection buffer into the
  * queue of the tty associated with the current console.
  * Invoked by ioctl().
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2688,9 +2688,7 @@ int tioclinux(struct tty_struct *tty, un
 	switch (type)
 	{
 		case TIOCL_SETSEL:
-			console_lock();
 			ret = set_selection((struct tiocl_selection __user *)(p+1), tty);
-			console_unlock();
 			break;
 		case TIOCL_PASTESEL:
 			ret = paste_selection(tty);


