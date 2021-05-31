Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63460396188
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhEaOlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234198AbhEaOji (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 083FA613DD;
        Mon, 31 May 2021 13:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469182;
        bh=xRkXyXRD4VsuCj4tAgHWY+MiLuM+0pgSLT5KovffrFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZf4ngxKjyn5J3h0N4yprdK+PIEp0HqlhZc8OKLoJd9QNDdGon3JwRiUXTDtG3zj/
         HLIqKHVL5cA0huLtLIeOS7AKgafeOjtqKHrIbXP0CHiJsL4GRMNZyli+Fvb9+0dFQN
         rbgL8/RDIyPI0CLOshCk+HixfgM55M2Er2HN4dA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 5.12 065/296] debugfs: fix security_locked_down() call for SELinux
Date:   Mon, 31 May 2021 15:12:00 +0200
Message-Id: <20210531130706.022562078@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 5881fa8dc2de9697a89451f6518e8b3a796c09c6 upstream.

When (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) is zero, then
the SELinux implementation of the locked_down hook might report a denial
even though the operation would actually be allowed.

To fix this, make sure that security_locked_down() is called only when
the return value will be taken into account (i.e. when changing one of
the problematic attributes).

Note: this was introduced by commit 5496197f9b08 ("debugfs: Restrict
debugfs when the kernel is locked down"), but it didn't matter at that
time, as the SELinux support came in later.

Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Link: https://lore.kernel.org/r/20210507125304.144394-1-omosnace@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -45,10 +45,13 @@ static unsigned int debugfs_allow __ro_a
 static int debugfs_setattr(struct user_namespace *mnt_userns,
 			   struct dentry *dentry, struct iattr *ia)
 {
-	int ret = security_locked_down(LOCKDOWN_DEBUGFS);
+	int ret;
 
-	if (ret && (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)))
-		return ret;
+	if (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) {
+		ret = security_locked_down(LOCKDOWN_DEBUGFS);
+		if (ret)
+			return ret;
+	}
 	return simple_setattr(&init_user_ns, dentry, ia);
 }
 


