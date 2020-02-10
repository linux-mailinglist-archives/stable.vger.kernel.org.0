Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89A20157554
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgBJMkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgBJMkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:16 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A67E620733;
        Mon, 10 Feb 2020 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338415;
        bh=rSh3R8xY6L76Nno7pwqyOzKKxTJ7fEguyZYa2B7n3O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2phL52Sk50eGdJRTgyvMKKlKN0D/5Klx26eWT5nklNBGfm06ZHdI0/qTJ3KdA/Zo
         cXHuJ2To88NNahIaB6zHUKkWHf0Zqt3wC+tUnDBRwYpXM5UaCLbglo4tMR1yv0O+OS
         pqglgnTWBHhOPAwXLyDKuurpqzzIl+ZvPC5ykDrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.5 130/367] ovl: fix wrong WARN_ON() in ovl_cache_update_ino()
Date:   Mon, 10 Feb 2020 04:30:43 -0800
Message-Id: <20200210122436.874786793@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 4c37e71b713ecffe81f8e6273c6835e54306d412 upstream.

The WARN_ON() that child entry is always on overlay st_dev became wrong
when we allowed this function to update d_ino in non-samefs setup with xino
enabled.

It is not true in case of xino bits overflow on a non-dir inode.  Leave the
WARN_ON() only for directories, where assertion is still true.

Fixes: adbf4f7ea834 ("ovl: consistent d_ino for non-samefs with xino")
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/readdir.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -504,7 +504,13 @@ get:
 		if (err)
 			goto fail;
 
-		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
+		/*
+		 * Directory inode is always on overlay st_dev.
+		 * Non-dir with ovl_same_dev() could be on pseudo st_dev in case
+		 * of xino bits overflow.
+		 */
+		WARN_ON_ONCE(S_ISDIR(stat.mode) &&
+			     dir->d_sb->s_dev != stat.dev);
 		ino = stat.ino;
 	} else if (xinobits && !OVL_TYPE_UPPER(type)) {
 		ino = ovl_remap_lower_ino(ino, xinobits,


