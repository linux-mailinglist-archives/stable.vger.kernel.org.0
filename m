Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB92A5851
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgKCUrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731352AbgKCUrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE19A20719;
        Tue,  3 Nov 2020 20:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436454;
        bh=5fK79m+5E9BogoI86LILJfXfRx4KDEPqdPAPrzc+1qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWUyQOyMp1kf5qUt9xScbpX1O3avo6TaWSzb95r9xxRxhDm70ApzLRjGbAoH5MoxB
         RmYDM53BlLb9lHAkw1p80+Gg46Z6ve86/q4dDvaygMl987wATQ7m7KOEKDuX0VBveZ
         kZCU+M1qW15JRTNCF3gsm0mILA3/jTZMF796SzcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabian Vogt <fvogt@suse.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.9 256/391] vt_ioctl: fix GIO_UNIMAP regression
Date:   Tue,  3 Nov 2020 21:35:07 +0100
Message-Id: <20201103203404.296513919@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit d54654790302ccaa72589380dce060d376ef8716 upstream.

In commit 5ba127878722, we shuffled with the check of 'perm'. But my
brain somehow inverted the condition in 'do_unimap_ioctl' (I thought
it is ||, not &&), so GIO_UNIMAP stopped working completely.

Move the 'perm' checks back to do_unimap_ioctl and do them right again.
In fact, this reverts this part of code to the pre-5ba127878722 state.
Except 'perm' is now a bool.

Fixes: 5ba127878722 ("vt_ioctl: move perm checks level up")
Cc: stable@vger.kernel.org
Reported-by: Fabian Vogt <fvogt@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20201026055419.30518-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt_ioctl.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -550,7 +550,7 @@ static int vt_io_fontreset(struct consol
 }
 
 static inline int do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud,
-		struct vc_data *vc)
+		bool perm, struct vc_data *vc)
 {
 	struct unimapdesc tmp;
 
@@ -558,9 +558,11 @@ static inline int do_unimap_ioctl(int cm
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
@@ -640,10 +642,7 @@ static int vt_io_ioctl(struct vc_data *v
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
-		if (!perm)
-			return -EPERM;
-
-		return do_unimap_ioctl(cmd, up, vc);
+		return do_unimap_ioctl(cmd, up, perm, vc);
 
 	default:
 		return -ENOIOCTLCMD;


