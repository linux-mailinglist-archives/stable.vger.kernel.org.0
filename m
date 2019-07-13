Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF51A67820
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 06:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfGMEMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 00:12:33 -0400
Received: from nibbler.cm4all.net ([82.165.145.151]:37146 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbfGMEMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Jul 2019 00:12:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id 109F1C018B
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 06:12:23 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at nibbler.cm4all.net
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id mIy06f_VywDU for <stable@vger.kernel.org>;
        Sat, 13 Jul 2019 06:12:22 +0200 (CEST)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id E6526C01C9
        for <stable@vger.kernel.org>; Sat, 13 Jul 2019 06:12:22 +0200 (CEST)
Received: (qmail 30916 invoked from network); 13 Jul 2019 06:44:00 +0200
Received: from unknown (HELO rabbit.intern.cm-ag) (172.30.3.1)
  by zero.intern.cm-ag with SMTP; 13 Jul 2019 06:44:00 +0200
Received: by rabbit.intern.cm-ag (Postfix, from userid 1023)
        id A2D3B460C4C; Sat, 13 Jul 2019 06:12:17 +0200 (CEST)
From:   Max Kellermann <mk@cm4all.com>
To:     linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com, bfields@redhat.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, hughd@google.com,
        anna.schumaker@netapp.com
Cc:     linux-kernel@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/4] fs/ext4/acl: apply umask if ACL support is disabled
Date:   Sat, 13 Jul 2019 06:11:58 +0200
Message-Id: <20190713041200.18566-2-mk@cm4all.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713041200.18566-1-mk@cm4all.com>
References: <20190713041200.18566-1-mk@cm4all.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function ext4_init_acl() calls posix_acl_create() which is
responsible for applying the umask.  But without
CONFIG_EXT4_FS_POSIX_ACL, ext4_init_acl() is an empty inline function,
and nobody applies the umask.

This fixes a bug which causes the umask to be ignored with O_TMPFILE
on ext4:

 https://github.com/MusicPlayerDaemon/MPD/issues/558
 https://bugs.gentoo.org/show_bug.cgi?id=686142#c3
 https://bugzilla.kernel.org/show_bug.cgi?id=203625

Signed-off-by: Max Kellermann <mk@cm4all.com>
Cc: stable@vger.kernel.org
---
 fs/ext4/acl.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 9b63f5416a2f..7f3b25b3fa6d 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -67,6 +67,11 @@ extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
 static inline int
 ext4_init_acl(handle_t *handle, struct inode *inode, struct inode *dir)
 {
+	/* usually, the umask is applied by posix_acl_create(), but if
+	   ext4 ACL support is disabled at compile time, we need to do
+	   it here, because posix_acl_create() will never be called */
+	inode->i_mode &= ~current_umask();
+
 	return 0;
 }
 #endif  /* CONFIG_EXT4_FS_POSIX_ACL */
-- 
2.20.1

