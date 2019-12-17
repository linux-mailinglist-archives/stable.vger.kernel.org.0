Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85219122064
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfLQAyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35294 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727046AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003Ms-PJ; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005Zr-Pl; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Giuseppe Scrivano" <gscrivan@redhat.com>,
        "Miklos Szeredi" <mszeredi@redhat.com>
Date:   Tue, 17 Dec 2019 00:46:59 +0000
Message-ID: <lsq.1576543535.205728246@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 085/136] fuse: flush dirty data/metadata before
 non-truncate setattr
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/dir.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1751,6 +1751,19 @@ int fuse_do_setattr(struct dentry *dentr
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
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

