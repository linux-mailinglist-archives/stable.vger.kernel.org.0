Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A8F129A87
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 20:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfLWTnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 14:43:35 -0500
Received: from [66.170.99.2] ([66.170.99.2]:9007 "EHLO
        sid-build-box.eng.vmware.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726829AbfLWTm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 14:42:56 -0500
Received: by sid-build-box.eng.vmware.com (Postfix, from userid 1000)
        id 07175BA17B9; Tue, 24 Dec 2019 01:07:15 +0530 (IST)
From:   Siddharth Chandrasekaran <csiddharth@vmware.com>
To:     torvalds@linux-foundation.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org, jannh@google.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        siddharth@embedjournal.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Siddharth Chandrasekaran <csiddharth@vmware.com>
Subject: [PATCH 4.19 1/2] Make filldir[64]() verify the directory entry filename is valid
Date:   Tue, 24 Dec 2019 01:06:29 +0530
Message-Id: <164cda4d7a07cac74a298e575278b000a1389285.1577128883.git.csiddharth@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1577128778.git.csiddharth@vmware.com>
References: <cover.1577128778.git.csiddharth@vmware.com>
In-Reply-To: <cover.1577128883.git.csiddharth@vmware.com>
References: <cover.1577128883.git.csiddharth@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 8a23eb804ca4f2be909e372cf5a9e7b30ae476cd ]

This has been discussed several times, and now filesystem people are
talking about doing it individually at the filesystem layer, so head
that off at the pass and just do it in getdents{64}().

This is partially based on a patch by Jann Horn, but checks for NUL
bytes as well, and somewhat simplified.

There's also commentary about how it might be better if invalid names
due to filesystem corruption don't cause an immediate failure, but only
an error at the end of the readdir(), so that people can still see the
filenames that are ok.

There's also been discussion about just how much POSIX strictly speaking
requires this since it's about filesystem corruption.  It's really more
"protect user space from bad behavior" as pointed out by Jann.  But
since Eric Biederman looked up the POSIX wording, here it is for context:

 "From readdir:

   The readdir() function shall return a pointer to a structure
   representing the directory entry at the current position in the
   directory stream specified by the argument dirp, and position the
   directory stream at the next entry. It shall return a null pointer
   upon reaching the end of the directory stream. The structure dirent
   defined in the <dirent.h> header describes a directory entry.

  From definitions:

   3.129 Directory Entry (or Link)

   An object that associates a filename with a file. Several directory
   entries can associate names with the same file.

  ...

   3.169 Filename

   A name consisting of 1 to {NAME_MAX} bytes used to name a file. The
   characters composing the name may be selected from the set of all
   character values excluding the slash character and the null byte. The
   filenames dot and dot-dot have special meaning. A filename is
   sometimes referred to as a 'pathname component'."

Note that I didn't bother adding the checks to any legacy interfaces
that nobody uses.

Also note that if this ends up being noticeable as a performance
regression, we can fix that to do a much more optimized model that
checks for both NUL and '/' at the same time one word at a time.

We haven't really tended to optimize 'memchr()', and it only checks for
one pattern at a time anyway, and we really _should_ check for NUL too
(but see the comment about "soft errors" in the code about why it
currently only checks for '/')

See the CONFIG_DCACHE_WORD_ACCESS case of hash_name() for how the name
lookup code looks for pathname terminating characters in parallel.

Link: https://lore.kernel.org/lkml/20190118161440.220134-2-jannh@google.com/
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Siddharth Chandrasekaran <csiddharth@vmware.com>
---
 fs/readdir.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/readdir.c b/fs/readdir.c
index 9d0212c..ace19d9 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -64,6 +64,40 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 EXPORT_SYMBOL(iterate_dir);
 
 /*
+ * POSIX says that a dirent name cannot contain NULL or a '/'.
+ *
+ * It's not 100% clear what we should really do in this case.
+ * The filesystem is clearly corrupted, but returning a hard
+ * error means that you now don't see any of the other names
+ * either, so that isn't a perfect alternative.
+ *
+ * And if you return an error, what error do you use? Several
+ * filesystems seem to have decided on EUCLEAN being the error
+ * code for EFSCORRUPTED, and that may be the error to use. Or
+ * just EIO, which is perhaps more obvious to users.
+ *
+ * In order to see the other file names in the directory, the
+ * caller might want to make this a "soft" error: skip the
+ * entry, and return the error at the end instead.
+ *
+ * Note that this should likely do a "memchr(name, 0, len)"
+ * check too, since that would be filesystem corruption as
+ * well. However, that case can't actually confuse user space,
+ * which has to do a strlen() on the name anyway to find the
+ * filename length, and the above "soft error" worry means
+ * that it's probably better left alone until we have that
+ * issue clarified.
+ */
+static int verify_dirent_name(const char *name, int len)
+{
+	if (WARN_ON_ONCE(!len))
+		return -EIO;
+	if (WARN_ON_ONCE(memchr(name, '/', len)))
+		return -EIO;
+	return 0;
+}
+
+/*
  * Traditional linux readdir() handling..
  *
  * "count=1" is a special case, meaning that the buffer is one
@@ -172,6 +206,9 @@ static int filldir(struct dir_context *ctx, const char *name, int namlen,
 	int reclen = ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
 		sizeof(long));
 
+	buf->error = verify_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return buf->error;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
@@ -258,6 +295,9 @@ static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
 		sizeof(u64));
 
+	buf->error = verify_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return buf->error;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
-- 
2.7.4

