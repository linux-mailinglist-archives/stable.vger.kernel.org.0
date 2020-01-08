Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD80134BD5
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgAHTrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:47:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43826 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730481AbgAHTqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:05 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006oo-VY; Wed, 08 Jan 2020 19:46:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-007doo-92; Wed, 08 Jan 2020 19:45:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Siddharth Chandrasekaran" <csiddharth@vmware.com>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        "Jann Horn" <jannh@google.com>
Date:   Wed, 08 Jan 2020 19:43:52 +0000
Message-ID: <lsq.1578512578.759211401@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 54/63] Make filldir[64]() verify the directory entry
 filename is valid
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8a23eb804ca4f2be909e372cf5a9e7b30ae476cd upstream.

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
Cc: Siddharth Chandrasekaran <csiddharth@vmware.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/readdir.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -51,6 +51,40 @@ out:
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
@@ -157,6 +191,9 @@ static int filldir(void * __buf, const c
 	int reclen = ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
 		sizeof(long));
 
+	buf->error = verify_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return buf->error;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
@@ -240,6 +277,9 @@ static int filldir64(void * __buf, const
 	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
 		sizeof(u64));
 
+	buf->error = verify_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return buf->error;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;

