Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6DC48CDF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 20:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfFQSrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 14:47:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39385 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbfFQSrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 14:47:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so468303wma.4
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 11:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jyz6fqs53F/qDL0teIid/cZMh/h4MCVWeZnSY+AMCoY=;
        b=dpkZ/BaXFS1LG6+8QDEVPNUs8VTnwlkwRqxE2SkOPncRaIFYbT5UtO0rCbAE8wklPK
         A+pM4bjs042iCCS63cjDb5nKJp6db4RHvVWRUuKWSDEOVVnTbO7OWr8WYlCextQ0QimK
         hw4LLF1wNpVkzFD6V+ONmIlTnrY1+8k6e4TaZdpVoNDlKqkUuSqFVfBEQ+OJG1LDWSgP
         m75VIMcL0EguIzRlli+ULY88ePkc83ABPa3Xgx6PJVjcudVyRfDrhq7dPFSQXwt/+NkE
         589m46d9c9z40EJjutdnQmqYLs/FwabIdq2M/LnYeF6nxtc/3UfhKEjb+iwOPAalvC/K
         5BLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jyz6fqs53F/qDL0teIid/cZMh/h4MCVWeZnSY+AMCoY=;
        b=tPPlYnjHR27WGChtWkALwjwdslgVmIYjFrQZvLi5flyJcIK4XmJpBlqPpTHbfoZ/pK
         Dm/3OU5qEvgU047T8KB1dshA8skfgHAjCvc+xrjZr01yN+teov7MmlibO3wlervWfneN
         p31Rm83EP1OmJzHK4DyW2Vu4S/rhJ+Pmq+p3HtEUpKuU4v0XwaXpNvfxQaUMYDkrcWWe
         bfR7qp7hVsDZ2nXEV6BlC3umtyXpA5GwOwErsVxpfO92/Mify60k1eRZLC0AI/3n7OH1
         Z5qakcDn4GayEa4gQ1wgzDq11cnQuSk1MsWVnGTU4aLdp0wYTaZqlTwMrbKYzNxkTbgR
         s7sw==
X-Gm-Message-State: APjAAAVSZALj0FP0loEEFVlNold9NTb9jkt5FEzGbKdDmL25ZOZvq+0I
        DYRpc8kSKVjs/ym98DirzAyGQzRUyBwIrg==
X-Google-Smtp-Source: APXvYqwCog0WuntJNECNO7CxMrilOnBpLe8UZEZ8fB1Xecu0XDTNFGjWT/QTVqbrRp87QTWwXnKxrA==
X-Received: by 2002:a1c:9a05:: with SMTP id c5mr63708wme.36.1560797243509;
        Mon, 17 Jun 2019 11:47:23 -0700 (PDT)
Received: from localhost.localdomain ([212.91.227.56])
        by smtp.gmail.com with ESMTPSA id w23sm70389wmi.45.2019.06.17.11.47.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 11:47:22 -0700 (PDT)
From:   Christian Brauner <christian@brauner.io>
To:     viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        ebiederm@xmission.com
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org
Subject: [PATCH] fs/namespace: fix unprivileged mount propagation
Date:   Mon, 17 Jun 2019 20:47:11 +0200
Message-Id: <20190617184711.21364-1-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/namespace.c | 1 +
 fs/pnode.c     | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index b26778bdc236..44b540e6feb9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2105,6 +2105,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		/* Notice when we are propagating across user namespaces */
 		if (child->mnt_parent->mnt_ns->user_ns != user_ns)
 			lock_mnt_tree(child);
+		child->mnt.mnt_flags &= ~MNT_LOCKED;
 		commit_tree(child);
 	}
 	put_mountpoint(smp);
diff --git a/fs/pnode.c b/fs/pnode.c
index 595857a1883e..d118106fa631 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -257,11 +257,10 @@ static int propagate_one(struct mount *m)
 		if (IS_MNT_SHARED(m))
 			type |= CL_MAKE_SHARED;
 	}
-		
+
 	child = copy_tree(last_source, last_source->mnt.mnt_root, type);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
-	child->mnt.mnt_flags &= ~MNT_LOCKED;
 	mnt_set_mountpoint(m, mp, child);
 	last_dest = m;
 	last_source = child;
-- 
2.21.0

