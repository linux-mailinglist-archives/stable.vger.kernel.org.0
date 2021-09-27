Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F20419B5E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbhI0RRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236290AbhI0RPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:15:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E8E861209;
        Mon, 27 Sep 2021 17:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762674;
        bh=eFcVgMSeJq+tV7UF8lmj4ZHUvA2MiSPdv4p8BybcGdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5vE4bA65ceXIy70vRWp0QzNdR4W2YwCBtN876olERhE/++II0FGJ54FZwmJxzpAC
         5SUAPw5Smlwkly2pQzocIyIDtle0mP3h61EwbPARXzbXAin8GxGbwnYR63glKvqZps
         3v0zkOu+IKutieTiZmmayGut9v2LBth9m+P8nqZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohith Surabattula <rohiths@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.14 010/162] cifs: Not to defer close on file when lock is set
Date:   Mon, 27 Sep 2021 19:00:56 +0200
Message-Id: <20210927170233.803216583@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohith Surabattula <rohiths@microsoft.com>

commit 35866f3f779aef5e7ba84e4d1023fe2e2a0e219e upstream.

Close file immediately when lock is set.

Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Rohith Surabattula <rohiths@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/file.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1403,6 +1403,7 @@ struct cifsInodeInfo {
 #define CIFS_INO_INVALID_MAPPING	  (4) /* pagecache is invalid */
 #define CIFS_INO_LOCK			  (5) /* lock bit for synchronization */
 #define CIFS_INO_MODIFIED_ATTR            (6) /* Indicate change in mtime/ctime */
+#define CIFS_INO_CLOSE_ON_LOCK            (7) /* Not to defer the close when lock is set */
 	unsigned long flags;
 	spinlock_t writers_lock;
 	unsigned int writers;		/* Number of writers on this inode */
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -881,6 +881,7 @@ int cifs_close(struct inode *inode, stru
 		dclose = kmalloc(sizeof(struct cifs_deferred_close), GFP_KERNEL);
 		if ((cinode->oplock == CIFS_CACHE_RHW_FLG) &&
 		    cinode->lease_granted &&
+		    !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags) &&
 		    dclose) {
 			if (test_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags))
 				inode->i_ctime = inode->i_mtime = current_time(inode);
@@ -1861,6 +1862,7 @@ int cifs_lock(struct file *file, int cmd
 	cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag,
 			tcon->ses->server);
 	cifs_sb = CIFS_FILE_SB(file);
+	set_bit(CIFS_INO_CLOSE_ON_LOCK, &CIFS_I(d_inode(cfile->dentry))->flags);
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&


