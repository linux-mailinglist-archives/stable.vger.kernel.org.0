Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26BF37BCAE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhELMlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232963AbhELMlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 08:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD47F61376;
        Wed, 12 May 2021 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620823215;
        bh=CpW/ISQKVjLUhA4QdtgUZ80mbCJ+6Q9yuTwtySExcys=;
        h=From:To:Cc:Subject:Date:From;
        b=C2TIuqe99F2BxLaBpzPrqx7pMubtV4kDFbUSQ15RCY23/Hzje5u+OuJJRFhcmxk62
         Avjq/o5b+yBb407i9wJc7y2YJsmhxIcXvP4dDlHbvCRnxcxPRXKS9QGyuhH1OUnZq9
         0zK7rLUh102Dw7RTTclKA48MzSAmYmaJMLpg80amgaM1cp0OOTH5tH0o0TlNXuL5o1
         rTD0iJvUid4J6yFRYNV1IYSTQVqXynpuIalMwDcal8lV+FjsCBB7YiYmfG9i+bw0Hs
         xlSQTaLKGg8CxSJGzNvjK9JlfkoaSBq1EL6pNh2B6+jDGreR3uP89cA7ZPw0he4QlD
         KPRG/aDU2Ruuw==
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH] fs/mount_setattr: tighten permission checks
Date:   Wed, 12 May 2021 14:39:30 +0200
Message-Id: <20210512123928.1366671-1-brauner@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; i=FpJl0hDKjbwv8CMNxYye356AuKgDIwVPlTezaAmfJ4Q=; m=RwsTNVEYc+Cg/so2pwTtTJfIhIJDJCydpXn4gFLFT8c=; p=QEErO/LY644H55u8fkAjdhfPTIULvY8cwuCF6c1jVYY=; g=575b46a3ea261773d7b9746d1042d635a7b7941e
X-Patch-Sig: m=pgp; i=christian.brauner@ubuntu.com; s=0x0x91C61BC06578DCA2; b=iHUEABYKAB0WIQRAhzRXHqcMeLMyaSiRxhvAZXjcogUCYJvMVgAKCRCRxhvAZXjcog83AP99ZAL vj5RuoJECmNkIN5LexYRwk7ceTutbIDZQcWZo2QEAsPqqz3jjPNqeiwSUeGNUHzgdO5GAguDmQuxM Ewd6IwE=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

We currently don't have any filesystems that support idmapped mounts
which are mountable inside a user namespace. That was a deliberate
decision for now as a userns root can just mount the filesystem
themselves. So enforce this restriction explicitly until there's a real
use-case for this. This way we can notice it and will have a chance to
adapt and audit our translation helpers and fstests appropriately if we
need to support such filesystems.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Suggested-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namespace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f63337828e1c..c3f1a78ba369 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3855,8 +3855,12 @@ static int can_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 	if (!(m->mnt_sb->s_type->fs_flags & FS_ALLOW_IDMAP))
 		return -EINVAL;
 
+	/* Don't yet support filesystem mountable in user namespaces. */
+	if (m->mnt_sb->s_user_ns != &init_user_ns)
+		return -EINVAL;
+
 	/* We're not controlling the superblock. */
-	if (!ns_capable(m->mnt_sb->s_user_ns, CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* Mount has already been visible in the filesystem hierarchy. */

base-commit: 6efb943b8616ec53a5e444193dccf1af9ad627b5
-- 
2.27.0

