Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4EA1A5D11
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 08:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgDLGpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Apr 2020 02:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgDLGpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Apr 2020 02:45:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99AED20739;
        Sun, 12 Apr 2020 06:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586673940;
        bh=wxdnWnmngyh+662kpHNf8IpzeFfOf456PUSarvKpF+w=;
        h=Date:From:To:Subject:From;
        b=E0LiMgkAVXWnKanIo6wm0ffWeUNIwLL6oiGnu86HMQLqvoFiIgRwrB/75zyye+CuH
         rNbDMVz2fVtCNF8laCmFu0BAHSQhqIDkmj9J1B1Kbq4uFHIZYRuGsLH3Wh6HdV0vuk
         AAA2byGY8QdQtKYtikhTAWiks5BPyBsajkAbYU+I=
Date:   Sat, 11 Apr 2020 23:45:40 -0700
From:   akpm@linux-foundation.org
To:     ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org,
        jeffv@google.com, jeyu@kernel.org, keescook@chromium.org,
        mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com,
        stable@vger.kernel.org
Subject:  [merged]
 fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
 removed from -mm tree
Message-ID: <20200412064540.u8Tsg_LiU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()
has been removed from the -mm tree.  Its filename was
     fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()

After request_module(), nothing is stopping the module from being unloaded
until someone takes a reference to it via try_get_module().

The WARN_ONCE() in get_fs_type() is thus user-reachable, via userspace
running 'rmmod' concurrently.

Since WARN_ONCE() is for kernel bugs only, not for user-reachable
situations, downgrade this warning to pr_warn_once().

Keep it printed once only, since the intent of this warning is to detect a
bug in modprobe at boot time.  Printing the warning more than once
wouldn't really provide any useful extra information.

Link: http://lkml.kernel.org/r/20200312202552.241885-3-ebiggers@kernel.org
Fixes: 41124db869b7 ("fs: warn in case userspace lied about modprobe return")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jessica Yu <jeyu@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: NeilBrown <neilb@suse.com>
Cc: <stable@vger.kernel.org>		[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/filesystems.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/filesystems.c~fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once
+++ a/fs/filesystems.c
@@ -272,7 +272,9 @@ struct file_system_type *get_fs_type(con
 	fs = __get_fs_type(name, len);
 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
 		fs = __get_fs_type(name, len);
-		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
+		if (!fs)
+			pr_warn_once("request_module fs-%.*s succeeded, but still no fs?\n",
+				     len, name);
 	}
 
 	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
_

Patches currently in -mm which might be from ebiggers@google.com are


