Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957E133B7D1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhCOOBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232588AbhCON7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB8EC64F1E;
        Mon, 15 Mar 2021 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816763;
        bh=pfIAXWKZmuag7c469syRF6DCSzceqdP9NHUCv7Jq1hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzAWz6pK4QBXnBQTAQ3H4W+CGCHdyQ6isr5vMPhKVGGrqjttsIovEUxk2ewg910kG
         QLZKeV22HoafjaGeWh4F5gwDGXHEwl7f0wKvDD1N6nbYZt4GNWLQOcJNrU0wjr/0Ql
         dMgDXJNIwETFPw8bwXg9oNYoqH35v6l+N0rvYrbU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.14 45/95] Revert 95ebabde382c ("capabilities: Dont allow writing ambiguous v3 file capabilities")
Date:   Mon, 15 Mar 2021 14:57:15 +0100
Message-Id: <20210315135741.754216761@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
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
@@ -507,8 +507,7 @@ int cap_convert_nscap(struct dentry *den
 	__u32 magic, nsmagic;
 	struct inode *inode = d_backing_inode(dentry);
 	struct user_namespace *task_ns = current_user_ns(),
-		*fs_ns = inode->i_sb->s_user_ns,
-		*ancestor;
+		*fs_ns = inode->i_sb->s_user_ns;
 	kuid_t rootid;
 	size_t newsize;
 
@@ -531,15 +530,6 @@ int cap_convert_nscap(struct dentry *den
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


