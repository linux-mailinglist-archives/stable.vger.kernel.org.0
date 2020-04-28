Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476A41BC8E5
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgD1Sgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbgD1Sgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:36:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF8032085B;
        Tue, 28 Apr 2020 18:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099003;
        bh=V/z9nYtkNN3czXQhqwf7MYTQj/NZF5QlMLIlsp40KV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMqxtI7q6laBNLkdNCjv9uDfBT/hb6lEfXdTGrpwOTCSZGBluNe7OvEI6dhuJNZky
         P8/tNw9J8fE6LlHWThxemnKRv+9PSLBcQpv3cxuc5BwSvT126hlGcUBFb89VHssSBy
         dgobOFHUB25gzIjqoUIzO9y9UnDjLVY1GXBxxdM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Krysiuk <piotras@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 084/131] fs/namespace.c: fix mountpoint reference counter race
Date:   Tue, 28 Apr 2020 20:24:56 +0200
Message-Id: <20200428182235.475417804@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Piotr Krysiuk <piotras@gmail.com>

A race condition between threads updating mountpoint reference counter
affects longterm releases 4.4.220, 4.9.220, 4.14.177 and 4.19.118.

The mountpoint reference counter corruption may occur when:
* one thread increments m_count member of struct mountpoint
  [under namespace_sem, but not holding mount_lock]
    pivot_root()
* another thread simultaneously decrements the same m_count
  [under mount_lock, but not holding namespace_sem]
    put_mountpoint()
      unhash_mnt()
        umount_mnt()
          mntput_no_expire()

To fix this race condition, grab mount_lock before updating m_count in
pivot_root().

Reference: CVE-2020-12114
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3142,8 +3142,8 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* make certain new is below the root */
 	if (!is_path_reachable(new_mnt, new.dentry, &root))
 		goto out4;
-	root_mp->m_count++; /* pin it so it won't go away */
 	lock_mount_hash();
+	root_mp->m_count++; /* pin it so it won't go away */
 	detach_mnt(new_mnt, &parent_path);
 	detach_mnt(root_mnt, &root_parent);
 	if (root_mnt->mnt.mnt_flags & MNT_LOCKED) {


