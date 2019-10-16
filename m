Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF776D9F43
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394908AbfJPVxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437608AbfJPVxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:52 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17DCA218DE;
        Wed, 16 Oct 2019 21:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262831;
        bh=yMdd9+3dIqRrqhK2Xmm3GHRba8cax9jHAW2YNqLK5pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2tTHYHs2jgbPZNJt26YpwpoWZOR2xniIyOqrEnvurTcq/BLmaznJ1Yyxc0bI9DSO
         wVgaqiHGCzZkG87iqxU3virUl3h1mQNWw9cQPrzmlTjBI858vf1RQOsPWTHZWuU5Tc
         5EPQmnNJ7jZknh4tnHiloO20d3YCjp6ya1MutJZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>,
        Steve French <smfrench@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 74/79] cifs: Check uniqueid for SMB2+ and return -ESTALE if necessary
Date:   Wed, 16 Oct 2019 14:50:49 -0700
Message-Id: <20191016214832.919397500@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit a108471b5730b52017e73b58c9f486319d2ac308 ]

Commit 7196ac113a4f ("Fix to check Unique id and FileType when client
refer file directly.") checks whether the uniqueid of an inode has
changed when getting the inode info, but only when using the UNIX
extensions. Add a similar check for SMB2+, since this can be done
without an extra network roundtrip.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0f210cb5038a4..3d3c66fcb5ee6 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -829,8 +829,21 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
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
@@ -871,6 +884,13 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
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
-- 
2.20.1



