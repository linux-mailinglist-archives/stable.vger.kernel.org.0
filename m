Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB0A328D00
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240970AbhCATDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240709AbhCAS4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:56:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9122E64E5C;
        Mon,  1 Mar 2021 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620941;
        bh=PY4FrfNYCkygZ1XUL3Fsusw9rS43eIKOSl4R2qh9rIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnEaS8Yt7qenmyjaBGY/jFAhLwO3mo9AYj4Zv7XTQpTy2S2IecrbUB2EVtLIj3FkO
         3HyqMdKGnu149lWxJc6jPtwSfdNK6i/ObI2g1G2MZLFNPNQKmMVXAI3eT+e3h7TEA2
         uKASTfIe0ercMt3fWHuG9dDZRJLjG1tAA8ufFf4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Andrew G. Morgan" <morgan@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 305/775] capabilities: Dont allow writing ambiguous v3 file capabilities
Date:   Mon,  1 Mar 2021 17:07:53 +0100
Message-Id: <20210301161216.693254258@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 95ebabde382c371572297915b104e55403674e73 ]

The v3 file capabilities have a uid field that records the filesystem
uid of the root user of the user namespace the file capabilities are
valid in.

When someone is silly enough to have the same underlying uid as the
root uid of multiple nested containers a v3 filesystem capability can
be ambiguous.

In the spirit of don't do that then, forbid writing a v3 filesystem
capability if it is ambiguous.

Fixes: 8db6c34f1dbc ("Introduce v3 namespaced file capabilities")
Reviewed-by: Andrew G. Morgan <morgan@kernel.org>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/commoncap.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 26c1cb725dcbe..78598be45f101 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -500,7 +500,8 @@ int cap_convert_nscap(struct dentry *dentry, const void **ivalue, size_t size)
 	__u32 magic, nsmagic;
 	struct inode *inode = d_backing_inode(dentry);
 	struct user_namespace *task_ns = current_user_ns(),
-		*fs_ns = inode->i_sb->s_user_ns;
+		*fs_ns = inode->i_sb->s_user_ns,
+		*ancestor;
 	kuid_t rootid;
 	size_t newsize;
 
@@ -523,6 +524,15 @@ int cap_convert_nscap(struct dentry *dentry, const void **ivalue, size_t size)
 	if (nsrootid == -1)
 		return -EINVAL;
 
+	/*
+	 * Do not allow allow adding a v3 filesystem capability xattr
+	 * if the rootid field is ambiguous.
+	 */
+	for (ancestor = task_ns->parent; ancestor; ancestor = ancestor->parent) {
+		if (from_kuid(ancestor, rootid) == 0)
+			return -EINVAL;
+	}
+
 	newsize = sizeof(struct vfs_ns_cap_data);
 	nscap = kmalloc(newsize, GFP_ATOMIC);
 	if (!nscap)
-- 
2.27.0



