Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9238212200A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfLQAvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34996 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726869AbfLQAvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003LF-7F; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005Ut-07; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nakajima Akira" <nakajima.akira@nttcom.co.jp>,
        "Steve French" <smfrench@gmail.com>,
        "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
Date:   Tue, 17 Dec 2019 00:46:19 +0000
Message-ID: <lsq.1576543535.172974899@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 045/136] Fix to check Unique id and FileType when
 client refer file directly.
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

From: Nakajima Akira <nakajima.akira@nttcom.co.jp>

commit 7196ac113a4f38b7ca1a3282fd9edf328bd22287 upstream.

When you refer file directly on cifs client,
 (e.g. ls -li <filename>, cd <dir>, stat <filename>)
 the function return old inode number and filetype from old inode cache,
 though server has different inode number or filetype.

When server is Windows, cifs client has same problem.
When Server is Windows
, This patch fixes bug in different filetype,
  but does not fix bug in different inode number.
Because QUERY_PATH_INFO response by Windows does not include inode number(Index Number) .

BUG INFO
https://bugzilla.kernel.org/show_bug.cgi?id=90021
https://bugzilla.kernel.org/show_bug.cgi?id=90031

Reported-by: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Signed-off-by: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Reviewed-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/inode.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -401,9 +401,25 @@ int cifs_get_inode_info_unix(struct inod
 			rc = -ENOMEM;
 	} else {
 		/* we already have inode, update it */
+
+		/* if uniqueid is different, return error */
+		if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
+		    CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
+			rc = -ESTALE;
+			goto cgiiu_exit;
+		}
+
+		/* if filetype is different, return error */
+		if (unlikely(((*pinode)->i_mode & S_IFMT) !=
+		    (fattr.cf_mode & S_IFMT))) {
+			rc = -ESTALE;
+			goto cgiiu_exit;
+		}
+
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
+cgiiu_exit:
 	return rc;
 }
 
@@ -839,6 +855,15 @@ cifs_get_inode_info(struct inode **inode
 		if (!*inode)
 			rc = -ENOMEM;
 	} else {
+		/* we already have inode, update it */
+
+		/* if filetype is different, return error */
+		if (unlikely(((*inode)->i_mode & S_IFMT) !=
+		    (fattr.cf_mode & S_IFMT))) {
+			rc = -ESTALE;
+			goto cgii_exit;
+		}
+
 		cifs_fattr_to_inode(*inode, &fattr);
 	}
 

