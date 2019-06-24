Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC46508D4
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfFXKWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730777AbfFXKWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:22:14 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4ACB2133F;
        Mon, 24 Jun 2019 10:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371734;
        bh=WfFaIxEMITIz5eai5eS+2Gi1SVJf03WbAAv9BsFwjHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vH9Y0MdaWl1IedjW/+0HnDBQdh3qfc5/evuaBgPRfu5lPyph7jkDaLHL28Z4mi/Ku
         AlhVfmulkfgDKewsnLKEeW7RKwdW81Dvw2Tzul+gKzCy5rpz9yqcOj4EG1AkVngmgZ
         I7NHL7fJ76GCyYIW4F5BSSyZTsnC+jbJ7vzis2Xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian@brauner.io>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.1 114/121] fs/namespace: fix unprivileged mount propagation
Date:   Mon, 24 Jun 2019 17:57:26 +0800
Message-Id: <20190624092326.475497997@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian@brauner.io>

commit d728cf79164bb38e9628d15276e636539f857ef1 upstream.

When propagating mounts across mount namespaces owned by different user
namespaces it is not possible anymore to move or umount the mount in the
less privileged mount namespace.

Here is a reproducer:

  sudo mount -t tmpfs tmpfs /mnt
  sudo --make-rshared /mnt

  # create unprivileged user + mount namespace and preserve propagation
  unshare -U -m --map-root --propagation=unchanged

  # now change back to the original mount namespace in another terminal:
  sudo mkdir /mnt/aaa
  sudo mount -t tmpfs tmpfs /mnt/aaa

  # now in the unprivileged user + mount namespace
  mount --move /mnt/aaa /opt

Unfortunately, this is a pretty big deal for userspace since this is
e.g. used to inject mounts into running unprivileged containers.
So this regression really needs to go away rather quickly.

The problem is that a recent change falsely locked the root of the newly
added mounts by setting MNT_LOCKED. Fix this by only locking the mounts
on copy_mnt_ns() and not when adding a new mount.

Fixes: 3bd045cc9c4b ("separate copying and locking mount tree on cross-userns copies")
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Tested-by: Christian Brauner <christian@brauner.io>
Acked-by: Christian Brauner <christian@brauner.io>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    1 +
 fs/pnode.c     |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2079,6 +2079,7 @@ static int attach_recursive_mnt(struct m
 		/* Notice when we are propagating across user namespaces */
 		if (child->mnt_parent->mnt_ns->user_ns != user_ns)
 			lock_mnt_tree(child);
+		child->mnt.mnt_flags &= ~MNT_LOCKED;
 		commit_tree(child);
 	}
 	put_mountpoint(smp);
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -262,7 +262,6 @@ static int propagate_one(struct mount *m
 	child = copy_tree(last_source, last_source->mnt.mnt_root, type);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
-	child->mnt.mnt_flags &= ~MNT_LOCKED;
 	mnt_set_mountpoint(m, mp, child);
 	last_dest = m;
 	last_source = child;


