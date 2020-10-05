Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44E6283A7C
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgJEPeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728263AbgJEPeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A03620637;
        Mon,  5 Oct 2020 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912057;
        bh=VnHJlXDtB5Ll4IxeGyEK24Vc2mPCDLLSkEaY4eh9zBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvfx39FJxLfUngP6SnqELol2YSiIZ1TlFT+r7ykYFjPccrJnLD7Zc8IWhoB3BXaOh
         I8HJKLNtleNYYfDfXDCN00RJczfrahB6HO0/qvjolaW7LuuZ7zJ9NExxmKiojpTMCJ
         kfFZ3ACbpRlApPs1FOoN5xr89GhAuPffwzMUqzK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.8 85/85] ep_create_wakeup_source(): dentry name can change under you...
Date:   Mon,  5 Oct 2020 17:27:21 +0200
Message-Id: <20201005142118.822227725@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 3701cb59d892b88d569427586f01491552f377b1 upstream.

or get freed, for that matter, if it's a long (separately stored)
name.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1448,7 +1448,7 @@ static int reverse_path_check(void)
 
 static int ep_create_wakeup_source(struct epitem *epi)
 {
-	const char *name;
+	struct name_snapshot n;
 	struct wakeup_source *ws;
 
 	if (!epi->ep->ws) {
@@ -1457,8 +1457,9 @@ static int ep_create_wakeup_source(struc
 			return -ENOMEM;
 	}
 
-	name = epi->ffd.file->f_path.dentry->d_name.name;
-	ws = wakeup_source_register(NULL, name);
+	take_dentry_name_snapshot(&n, epi->ffd.file->f_path.dentry);
+	ws = wakeup_source_register(NULL, n.name.name);
+	release_dentry_name_snapshot(&n);
 
 	if (!ws)
 		return -ENOMEM;


