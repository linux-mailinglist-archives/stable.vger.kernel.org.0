Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E42A1213B2
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfLPSED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729599AbfLPSD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:03:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 324CD20700;
        Mon, 16 Dec 2019 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519438;
        bh=FkDwqSX2U3Zi6u1zSLl0ekZoB6wGScHpf/uAMixefME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ly8nJfBubQhbrPehHejxOIlJa44TIdI8hVN/bqs2/hyFfgunnzWGtCgJC2EZT4T42
         WZ5/B/0FG4qS7XkAwgd8DMz1EaqR+KoQILRcYW75YVIfSGYF3sISednO4zsvLj+sjS
         LEcJ/WCv/RiUHO/lDew/jQ0wxM0gx3nYgiJyrEQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bb1836a212e69f8e201a@syzkaller.appspotmail.com,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 049/140] ovl: relax WARN_ON() on rename to self
Date:   Mon, 16 Dec 2019 18:48:37 +0100
Message-Id: <20191216174802.043464455@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 6889ee5a53b8d969aa542047f5ac8acdc0e79a91 upstream.

In ovl_rename(), if new upper is hardlinked to old upper underneath
overlayfs before upper dirs are locked, user will get an ESTALE error
and a WARN_ON will be printed.

Changes to underlying layers while overlayfs is mounted may result in
unexpected behavior, but it shouldn't crash the kernel and it shouldn't
trigger WARN_ON() either, so relax this WARN_ON().

Reported-by: syzbot+bb1836a212e69f8e201a@syzkaller.appspotmail.com
Fixes: 804032fabb3b ("ovl: don't check rename to self")
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1174,7 +1174,7 @@ static int ovl_rename(struct inode *oldd
 	if (newdentry == trap)
 		goto out_dput;
 
-	if (WARN_ON(olddentry->d_inode == newdentry->d_inode))
+	if (olddentry->d_inode == newdentry->d_inode)
 		goto out_dput;
 
 	err = 0;


