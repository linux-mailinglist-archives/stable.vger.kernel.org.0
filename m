Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D092C17FDB3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgCJMvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgCJMvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C07A2468E;
        Tue, 10 Mar 2020 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844698;
        bh=MXln7nZqWGaCBLy6dtD8fUgYZiJwCNGm/S6MIDZKz0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fM88ivZUj/MhIFccJHMfnbLYytbAx3rpTblE15sqVeKXuNHwnubHQzRVBCG9ytvly
         +TFz7aPnzEZGcRU/J4a9qbdX0bKlDM7T/nBbihgAbD9efpGpFo2LX/gjKVR3oVSqEq
         PK313TeFybBy/DsadozdMktCUtgEjJiNosb5XFcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.4 086/168] vt: selection, push console lock down
Date:   Tue, 10 Mar 2020 13:38:52 +0100
Message-Id: <20200310123643.985077008@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
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
 drivers/staging/speakup/selection.c |    2 --
 drivers/tty/vt/selection.c          |   13 ++++++++++++-
 drivers/tty/vt/vt.c                 |    2 --
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/staging/speakup/selection.c
+++ b/drivers/staging/speakup/selection.c
@@ -51,9 +51,7 @@ static void __speakup_set_selection(stru
 		goto unref;
 	}
 
-	console_lock();
 	set_selection_kernel(&sel, tty);
-	console_unlock();
 
 unref:
 	tty_kref_put(tty);
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -181,7 +181,7 @@ int set_selection_user(const struct tioc
 	return set_selection_kernel(&v, tty);
 }
 
-int set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
+static int __set_selection_kernel(struct tiocl_selection *v, struct tty_struct *tty)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
 	int new_sel_start, new_sel_end, spc;
@@ -343,6 +343,17 @@ unlock:
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
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3046,10 +3046,8 @@ int tioclinux(struct tty_struct *tty, un
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


