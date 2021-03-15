Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486A133B808
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhCOOBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232814AbhCON75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCE8064F18;
        Mon, 15 Mar 2021 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816767;
        bh=/Ddd2zPl42t0KPISs+Dxeg/qgBi4KA8gGxKbfY4SnUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7vyhzPXR1hXVWbOjatxr+DMmeLXQoxDH8GtB8xmIsVvdbxp7i0xhpesD0/SWc0tO
         CYd3Ut5fRIREZ/Mtx0on9OmieBEJf7D4rsfW9SsldTDlV0o+PWVIhqQC7H1vCkD7sM
         JTLTF+zng2i7DhnCQsUMFX3MKB23Nc7BiHNlA1UU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.4 096/168] Revert 95ebabde382c ("capabilities: Dont allow writing ambiguous v3 file capabilities")
Date:   Mon, 15 Mar 2021 14:55:28 +0100
Message-Id: <20210315135553.525307621@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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
@@ -500,8 +500,7 @@ int cap_convert_nscap(struct dentry *den
 	__u32 magic, nsmagic;
 	struct inode *inode = d_backing_inode(dentry);
 	struct user_namespace *task_ns = current_user_ns(),
-		*fs_ns = inode->i_sb->s_user_ns,
-		*ancestor;
+		*fs_ns = inode->i_sb->s_user_ns;
 	kuid_t rootid;
 	size_t newsize;
 
@@ -524,15 +523,6 @@ int cap_convert_nscap(struct dentry *den
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


