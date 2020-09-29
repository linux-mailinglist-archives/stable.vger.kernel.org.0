Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDAE27CA43
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbgI2MRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbgI2Lgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93A1223E53;
        Tue, 29 Sep 2020 11:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379120;
        bh=WXxXPySre0YM/NS4OlELtHdlnYCawUYpcYb+CjbhLTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpjbhq9zokSkxLmkc0Xb1IRIFHHGsMGQ0zTWOpHZ1Jxro1GCAX1yHQZdR0JdXXye9
         A14M0wNgY9n8mysOFKE++u4GE6qPb60MjnUYTN3+iBxpkCtdpq/Y0Lz0jWULWKwbcQ
         RHOUd03mzTG6IlRtvBJgY88JbQfv9q6nsZyDXOm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Kamensky <kamensky@cisco.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/388] selinux: allow labeling before policy is loaded
Date:   Tue, 29 Sep 2020 12:55:35 +0200
Message-Id: <20200929110010.693878468@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 552e73d90fd25..212f48025db81 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3156,6 +3156,9 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 		return dentry_has_perm(current_cred(), dentry, FILE__SETATTR);
 	}
 
+	if (!selinux_state.initialized)
+		return (inode_owner_or_capable(inode) ? 0 : -EPERM);
+
 	sbsec = inode->i_sb->s_security;
 	if (!(sbsec->flags & SBLABEL_MNT))
 		return -EOPNOTSUPP;
@@ -3239,6 +3242,15 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
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



