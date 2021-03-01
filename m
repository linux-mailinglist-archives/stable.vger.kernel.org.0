Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BD3328CBF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240806AbhCAS6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:58:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240536AbhCASwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:52:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C8A265110;
        Mon,  1 Mar 2021 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618899;
        bh=9CT/6GWs+LIlVXSEBxLxIkDqwBig9kw5n/SIXROj9jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBcLeOyIdIWU9qHKnusWf3bTw5mxoPu3y6bPlnRoOusGLKLIyZ/Bw4ZeB+dDi7UQq
         DDtPYqqWh3aVGcJC2vzP6AyABpXjYFzRPGpyEnqoK652EBvCEpRB/60njfjNENL7ef
         5XveEtNhCELrj3m/Ms9lsbehZ3ZZrFSROGFT77jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Andrew G. Morgan" <morgan@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/663] capabilities: Dont allow writing ambiguous v3 file capabilities
Date:   Mon,  1 Mar 2021 17:08:25 +0100
Message-Id: <20210301161154.541381356@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index a6c9bb4441d54..b2a656947504d 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -500,7 +500,8 @@ int cap_convert_nscap(struct dentry *dentry, void **ivalue, size_t size)
 	__u32 magic, nsmagic;
 	struct inode *inode = d_backing_inode(dentry);
 	struct user_namespace *task_ns = current_user_ns(),
-		*fs_ns = inode->i_sb->s_user_ns;
+		*fs_ns = inode->i_sb->s_user_ns,
+		*ancestor;
 	kuid_t rootid;
 	size_t newsize;
 
@@ -523,6 +524,15 @@ int cap_convert_nscap(struct dentry *dentry, void **ivalue, size_t size)
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



