Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F171220AF
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLQA5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:57:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34980 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726863AbfLQAvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003LI-HJ; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005Ux-21; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Steve French" <smfrench@gmail.com>,
        "Ross Lagerwall" <ross.lagerwall@citrix.com>
Date:   Tue, 17 Dec 2019 00:46:20 +0000
Message-ID: <lsq.1576543535.883584702@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 046/136] cifs: Check uniqueid for SMB2+ and return
 -ESTALE if necessary
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

From: Ross Lagerwall <ross.lagerwall@citrix.com>

commit a108471b5730b52017e73b58c9f486319d2ac308 upstream.

Commit 7196ac113a4f ("Fix to check Unique id and FileType when client
refer file directly.") checks whether the uniqueid of an inode has
changed when getting the inode info, but only when using the UNIX
extensions. Add a similar check for SMB2+, since this can be done
without an extra network roundtrip.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/inode.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -815,8 +815,21 @@ cifs_get_inode_info(struct inode **inode
 			}
 		} else
 			fattr.cf_uniqueid = iunique(sb, ROOT_I);
-	} else
-		fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
+	} else {
+		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+		    validinum == false && server->ops->get_srv_inum) {
+			/*
+			 * Pass a NULL tcon to ensure we don't make a round
+			 * trip to the server. This only works for SMB2+.
+			 */
+			tmprc = server->ops->get_srv_inum(xid,
+				NULL, cifs_sb, full_path,
+				&fattr.cf_uniqueid, data);
+			if (tmprc)
+				fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
+		} else
+			fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
+	}
 
 	/* query for SFU type info if supported and needed */
 	if (fattr.cf_cifsattrs & ATTR_SYSTEM &&
@@ -857,6 +870,13 @@ cifs_get_inode_info(struct inode **inode
 	} else {
 		/* we already have inode, update it */
 
+		/* if uniqueid is different, return error */
+		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		    CIFS_I(*inode)->uniqueid != fattr.cf_uniqueid)) {
+			rc = -ESTALE;
+			goto cgii_exit;
+		}
+
 		/* if filetype is different, return error */
 		if (unlikely(((*inode)->i_mode & S_IFMT) !=
 		    (fattr.cf_mode & S_IFMT))) {

