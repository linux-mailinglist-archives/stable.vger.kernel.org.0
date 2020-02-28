Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86FDF173B12
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 16:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgB1PLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 10:11:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgB1PLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 10:11:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1A242469F;
        Fri, 28 Feb 2020 15:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582902691;
        bh=KHBxUcIKHdZAzwuW+oua5QZJHqnEHkaeRTD2yd/WMz8=;
        h=Subject:To:From:Date:From;
        b=0jLTbc6Ps1cXDvipPpBhhw4iS+kOwZoOA0UR19o5Rgm8ifJ333adshCRh38ZT5AEs
         Oj3p3uMjgMoOh5unHXHP9BVh2A3AYCOCalUG3zDtywALgkR0WaqMl1nFkDi5zh3vBQ
         7xkD5l2mK5FosmTW47hz2C92b5ExWfuxnIZURSwU=
Subject: patch "vt: selection, push console lock down" added to tty-linus
To:     jslaby@suse.cz, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 28 Feb 2020 16:11:28 +0100
Message-ID: <1582902688169113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt: selection, push console lock down

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4b70dd57a15d2f4685ac6e38056bad93e81e982f Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 28 Feb 2020 12:54:05 +0100
Subject: vt: selection, push console lock down

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
 drivers/staging/speakup/selection.c |  2 --
 drivers/tty/vt/selection.c          | 13 ++++++++++++-
 drivers/tty/vt/vt.c                 |  2 --
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/speakup/selection.c b/drivers/staging/speakup/selection.c
index a8b4d0c5ab7e..032f3264fba1 100644
--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -51,9 +51,7 @@ static void __speakup_set_selection(struct work_struct *work)
 		goto unref;
 	}
 
-	console_lock();
 	set_selection_kernel(&sel, tty);
-	console_unlock();
 
 unref:
 	tty_kref_put(tty);
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 0c50d7410b31..9126a01290ea 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -181,7 +181,7 @@ int set_selection_user(const struct tiocl_selection __user *sel,
 	return set_selection_kernel(&v, tty);
 }
 
-int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
+static int __set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
 	int new_sel_start, new_sel_end, spc;
@@ -343,6 +343,17 @@ int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 	mutex_unlock(&sel_lock);
 	return ret;
 }
+
+int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
+{
+	int ret;
+
+	console_lock();
+	ret = __set_selection_kernel(v, tty);
+	console_unlock();
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(set_selection_kernel);
 
 /* Insert the contents of the selection buffer into the
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 0cfbb7182b5a..15d27698054a 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3046,10 +3046,8 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 	switch (type)
 	{
 		case TIOCL_SETSEL:
-			console_lock();
 			ret = set_selection_user((struct tiocl_selection
 						 __user *)(p+1), tty);
-			console_unlock();
 			break;
 		case TIOCL_PASTESEL:
 			ret = paste_selection(tty);
-- 
2.25.1


