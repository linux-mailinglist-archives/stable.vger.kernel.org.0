Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A69427AB4
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 15:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhJIN5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 09:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233146AbhJIN53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 09:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A07D660F70;
        Sat,  9 Oct 2021 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633787732;
        bh=KwiH/6gASzJmjKYBK2t2iqIl/+38wsCzCVBLWXtI1Sc=;
        h=Subject:To:Cc:From:Date:From;
        b=PD/mAbhTfcqS7cGFbqPShIWEb8f/R2m71d1bhX/j6RGMuvwKF7Wu8oippDWKeMOE2
         1n06TFbdVLyXdXkJ9A1+LDQl7QgJME6SOZYQs5nymrhB9UjCftRssSd9+4HAf3glkw
         IXJ495ayQwPFW4cA6NfZ/w1g3EvKjpZs1bQH4VMk=
Subject: FAILED: patch "[PATCH] ovl: fix missing negative dentry check in ovl_rename()" failed to apply to 4.4-stable tree
To:     zhengliang6@huawei.com, mszeredi@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 09 Oct 2021 15:55:29 +0200
Message-ID: <163378772914820@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a295aef603e109a47af355477326bd41151765b6 Mon Sep 17 00:00:00 2001
From: Zheng Liang <zhengliang6@huawei.com>
Date: Fri, 24 Sep 2021 09:16:27 +0800
Subject: [PATCH] ovl: fix missing negative dentry check in ovl_rename()

The following reproducer

  mkdir lower upper work merge
  touch lower/old
  touch lower/new
  mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merge
  rm merge/new
  mv merge/old merge/new & unlink upper/new

may result in this race:

PROCESS A:
  rename("merge/old", "merge/new");
  overwrite=true,ovl_lower_positive(old)=true,
  ovl_dentry_is_whiteout(new)=true -> flags |= RENAME_EXCHANGE

PROCESS B:
  unlink("upper/new");

PROCESS A:
  lookup newdentry in new_upperdir
  call vfs_rename() with negative newdentry and RENAME_EXCHANGE

Fix by adding the missing check for negative newdentry.

Signed-off-by: Zheng Liang <zhengliang6@huawei.com>
Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: <stable@vger.kernel.org> # v3.18
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1fefb2b8960e..93c7c267de93 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1219,9 +1219,13 @@ static int ovl_rename(struct user_namespace *mnt_userns, struct inode *olddir,
 				goto out_dput;
 		}
 	} else {
-		if (!d_is_negative(newdentry) &&
-		    (!new_opaque || !ovl_is_whiteout(newdentry)))
-			goto out_dput;
+		if (!d_is_negative(newdentry)) {
+			if (!new_opaque || !ovl_is_whiteout(newdentry))
+				goto out_dput;
+		} else {
+			if (flags & RENAME_EXCHANGE)
+				goto out_dput;
+		}
 	}
 
 	if (olddentry == trap)

