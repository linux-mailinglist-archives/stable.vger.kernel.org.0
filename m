Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4392733B870
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhCOODc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232836AbhCOOAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2E3164F26;
        Mon, 15 Mar 2021 13:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816783;
        bh=vLurVrrrwyChHe5fVfuDmI4OBPbtMESKyA6XtpQN/5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vKcW1fgpM6aLneQBcCN1/LTfLXIQHNmq3HGC0BwG3LeWURyjc7XN9tJzRqLJZHph4
         54LI+WNyV7lYDcKY1yCEhfZKFUwJuEk6IxLI9Z4j1FRAY3e7Et0sqLUnOFD6wf2aRi
         cQouM1vSz9qN+BUHgIWsAetGF4j9fDPTBLikU9/w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.19 065/120] Revert 95ebabde382c ("capabilities: Dont allow writing ambiguous v3 file capabilities")
Date:   Mon, 15 Mar 2021 14:56:56 +0100
Message-Id: <20210315135722.100875537@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Eric W. Biederman <ebiederm@xmission.com>

commit 3b0c2d3eaa83da259d7726192cf55a137769012f upstream.

It turns out that there are in fact userspace implementations that
care and this recent change caused a regression.

https://github.com/containers/buildah/issues/3071

As the motivation for the original change was future development,
and the impact is existing real world code just revert this change
and allow the ambiguity in v3 file caps.

Cc: stable@vger.kernel.org
Fixes: 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/commoncap.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -506,8 +506,7 @@ int cap_convert_nscap(struct dentry *den
 	__u32 magic, nsmagic;
 	struct inode *inode = d_backing_inode(dentry);
 	struct user_namespace *task_ns = current_user_ns(),
-		*fs_ns = inode->i_sb->s_user_ns,
-		*ancestor;
+		*fs_ns = inode->i_sb->s_user_ns;
 	kuid_t rootid;
 	size_t newsize;
 
@@ -530,15 +529,6 @@ int cap_convert_nscap(struct dentry *den
 	if (nsrootid == -1)
 		return -EINVAL;
 
-	/*
-	 * Do not allow allow adding a v3 filesystem capability xattr
-	 * if the rootid field is ambiguous.
-	 */
-	for (ancestor = task_ns->parent; ancestor; ancestor = ancestor->parent) {
-		if (from_kuid(ancestor, rootid) == 0)
-			return -EINVAL;
-	}
-
 	newsize = sizeof(struct vfs_ns_cap_data);
 	nscap = kmalloc(newsize, GFP_ATOMIC);
 	if (!nscap)


