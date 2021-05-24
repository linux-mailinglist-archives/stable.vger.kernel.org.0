Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AB338EFA9
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbhEXP6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233923AbhEXP5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4229613C8;
        Mon, 24 May 2021 15:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871031;
        bh=KN9/wTIwtYFC3VY1RYKg//I4UbsHp7lVb6coPb4Sxuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnHuDhA0TVn+5/TKZOpeT/XN4i4ldR+mDsUUXZ1gALUvaWcAp52JbYKMWBUpVd4K+
         S13ATLUQx0ZdCgeN4suH2mQpq8zXWslJ6pRrLIB5TRKEjXlNo/EtkV8G2i6uwYkrpN
         +qK/N8TMqxzjhEWf7n4Od7hG8DwCau21Y3m2DcyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.12 040/127] fs/mount_setattr: tighten permission checks
Date:   Mon, 24 May 2021 17:25:57 +0200
Message-Id: <20210524152336.206780930@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 2ca4dcc4909d787ee153272f7efc2bff3b498720 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3853,8 +3853,12 @@ static int can_idmap_mount(const struct
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


