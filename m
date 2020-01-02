Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0DE12F04D
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgABWWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgABWWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:22:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C2562253D;
        Thu,  2 Jan 2020 22:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003769;
        bh=1BVvi37lXMsIZ8ASqwOJJQCpfuPGpO64HBQr7CaM3MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atpULbxOrYY+pZR0DMRNpncUdOI7GE//lUOs8tmIQ0bU/Vt3I1OEFKQ/S5vScNE17
         HfDD29zUkTKLHPxVGBu7Y3aYbwb7eFFtRsmWvbHF97XyO1UDLwIld7vdzyoM+EeTW2
         9zUHyiW4bxwTaW8kV06eT57Nm1CcqgRf0lXTE2uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Siddharth Chandrasekaran <csiddharth@vmware.com>
Subject: [PATCH 4.19 080/114] Make filldir[64]() verify the directory entry filename is valid
Date:   Thu,  2 Jan 2020 23:07:32 +0100
Message-Id: <20200102220037.169044480@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Siddharth Chandrasekaran <csiddharth@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/readdir.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -65,6 +65,40 @@ out:
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
@@ -173,6 +207,9 @@ static int filldir(struct dir_context *c
 	int reclen = ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
 		sizeof(long));
 
+	buf->error = verify_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return buf->error;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
@@ -259,6 +296,9 @@ static int filldir64(struct dir_context
 	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
 		sizeof(u64));
 
+	buf->error = verify_dirent_name(name, namlen);
+	if (unlikely(buf->error))
+		return buf->error;
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;


