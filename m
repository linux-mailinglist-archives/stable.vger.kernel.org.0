Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F46E27CC30
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbgI2MeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729623AbgI2LW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:22:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8283123A75;
        Tue, 29 Sep 2020 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378424;
        bh=Ck6fc4SttpI6j9QYpn6//UUfsHchD6fGEC7acmbMEqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GvF/QdwxhClWOHonn6PsOIby/7efV2c0hZWpwXSH7Fpb5zYFKSGUhxuncIwxRx6Dr
         OWwSeEwEZa+X1PpBt/no1E3hZRsBKVpjp83LtYoKB/IQ8EhsVXuIN5Qq979YYs+KPo
         KgYG3SUg9Wsn1xBAa8bY/Asw/qhJtCbMbhV/uNDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Kamensky <kamensky@cisco.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/245] selinux: allow labeling before policy is loaded
Date:   Tue, 29 Sep 2020 12:57:32 +0200
Message-Id: <20200929105947.056525770@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lebon <jlebon@redhat.com>

[ Upstream commit 3e3e24b42043eceb97ed834102c2d094dfd7aaa6 ]

Currently, the SELinux LSM prevents one from setting the
`security.selinux` xattr on an inode without a policy first being
loaded. However, this restriction is problematic: it makes it impossible
to have newly created files with the correct label before actually
loading the policy.

This is relevant in distributions like Fedora, where the policy is
loaded by systemd shortly after pivoting out of the initrd. In such
instances, all files created prior to pivoting will be unlabeled. One
then has to relabel them after pivoting, an operation which inherently
races with other processes trying to access those same files.

Going further, there are use cases for creating the entire root
filesystem on first boot from the initrd (e.g. Container Linux supports
this today[1], and we'd like to support it in Fedora CoreOS as well[2]).
One can imagine doing this in two ways: at the block device level (e.g.
laying down a disk image), or at the filesystem level. In the former,
labeling can simply be part of the image. But even in the latter
scenario, one still really wants to be able to set the right labels when
populating the new filesystem.

This patch enables this by changing behaviour in the following two ways:
1. allow `setxattr` if we're not initialized
2. don't try to set the in-core inode SID if we're not initialized;
   instead leave it as `LABEL_INVALID` so that revalidation may be
   attempted at a later time

Note the first hunk of this patch is mostly the same as a previously
discussed one[3], though it was part of a larger series which wasn't
accepted.

[1] https://coreos.com/os/docs/latest/root-filesystem-placement.html
[2] https://github.com/coreos/fedora-coreos-tracker/issues/94
[3] https://www.spinics.net/lists/linux-initramfs/msg04593.html

Co-developed-by: Victor Kamensky <kamensky@cisco.com>
Signed-off-by: Victor Kamensky <kamensky@cisco.com>
Signed-off-by: Jonathan Lebon <jlebon@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 452254fd89f87..250b725f5754c 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3304,6 +3304,9 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 		return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
 	}
 
+	if (!selinux_state.initialized)
+		return (inode_owner_or_capable(inode) ? 0 : -EPERM);
+
 	sbsec = inode->i_sb->s_security;
 	if (!(sbsec->flags & SBLABEL_MNT))
 		return -EOPNOTSUPP;
@@ -3387,6 +3390,15 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 		return;
 	}
 
+	if (!selinux_state.initialized) {
+		/* If we haven't even been initialized, then we can't validate
+		 * against a policy, so leave the label as invalid. It may
+		 * resolve to a valid label on the next revalidation try if
+		 * we've since initialized.
+		 */
+		return;
+	}
+
 	rc = security_context_to_sid_force(&selinux_state, value, size,
 					   &newsid);
 	if (rc) {
-- 
2.25.1



