Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0A3EF03A
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbfKDVum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387777AbfKDVul (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:50:41 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13FBC214D8;
        Mon,  4 Nov 2019 21:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904240;
        bh=LfTO+FHeZ6M9Pa2Fk/8x9G7IzL6obf8rE6hsYroN2dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1S8ccrM6yMfiJSJgfmFicxe/pjrmRYul82g+9J09etFHZFgnI90dZq8IQKV4AHZ+
         1WIUz5qHHTH/vX1jxOOrS3Ggjmn6kz57OVYQ4Bck172mQjAHlmVClzMHjk8bYUXmjW
         1LpUYtc4fY3incVuulzEN2AJ8C5jHET+N6vYIz4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.9 34/62] fuse: flush dirty data/metadata before non-truncate setattr
Date:   Mon,  4 Nov 2019 22:44:56 +0100
Message-Id: <20191104211937.303094666@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211901.387893698@linuxfoundation.org>
References: <20191104211901.387893698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit b24e7598db62386a95a3c8b9c75630c5d56fe077 upstream.

If writeback cache is enabled, then writes might get reordered with
chmod/chown/utimes.  The problem with this is that performing the write in
the fuse daemon might itself change some of these attributes.  In such case
the following sequence of operations will result in file ending up with the
wrong mode, for example:

  int fd = open ("suid", O_WRONLY|O_CREAT|O_EXCL);
  write (fd, "1", 1);
  fchown (fd, 0, 0);
  fchmod (fd, 04755);
  close (fd);

This patch fixes this by flushing pending writes before performing
chown/chmod/utimes.

Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Fixes: 4d99ff8f12eb ("fuse: Turn writeback cache on")
Cc: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dir.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1654,6 +1654,19 @@ int fuse_do_setattr(struct dentry *dentr
 	if (attr->ia_valid & ATTR_SIZE)
 		is_truncate = true;
 
+	/* Flush dirty data/metadata before non-truncate SETATTR */
+	if (is_wb && S_ISREG(inode->i_mode) &&
+	    attr->ia_valid &
+			(ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_MTIME_SET |
+			 ATTR_TIMES_SET)) {
+		err = write_inode_now(inode, true);
+		if (err)
+			return err;
+
+		fuse_set_nowrite(inode);
+		fuse_release_nowrite(inode);
+	}
+
 	if (is_truncate) {
 		fuse_set_nowrite(inode);
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);


