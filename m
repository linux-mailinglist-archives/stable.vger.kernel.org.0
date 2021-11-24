Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01BE45C65B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352032AbhKXOH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:07:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351520AbhKXOFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:05:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F184F63344;
        Wed, 24 Nov 2021 13:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759508;
        bh=J438vGk2Oc8vtmR/8okWRbE8zX/XKOKGgDt1byfqg58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLsJQxTknmDkPvbb1i6tWmt29+9VFwqpCPWDpE9aOc3eLRy3rXU0Ilzi8pFlVXLH1
         VPMq34oiu1GGlXlpxH4YhfGw5PSfX0XLf+ZtVwkFwpeFmUO1qWwMeZoe0tHx1gMGea
         7qfZaPFMmfzHlZYp3plWsHSZofXggPyihR1GKYDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Seth Forshee <seth.forshee@digitalocean.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.15 233/279] fs: handle circular mappings correctly
Date:   Wed, 24 Nov 2021 12:58:40 +0100
Message-Id: <20211124115726.793674406@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 968219708108440b23bc292e0486e3cc1d9a1bed upstream.

When calling setattr_prepare() to determine the validity of the attributes the
ia_{g,u}id fields contain the value that will be written to inode->i_{g,u}id.
When the {g,u}id attribute of the file isn't altered and the caller's fs{g,u}id
matches the current {g,u}id attribute the attribute change is allowed.

The value in ia_{g,u}id does already account for idmapped mounts and will have
taken the relevant idmapping into account. So in order to verify that the
{g,u}id attribute isn't changed we simple need to compare the ia_{g,u}id value
against the inode's i_{g,u}id value.

This only has any meaning for idmapped mounts as idmapping helpers are
idempotent without them. And for idmapped mounts this really only has a meaning
when circular idmappings are used, i.e. mappings where e.g. id 1000 is mapped
to id 1001 and id 1001 is mapped to id 1000. Such ciruclar mappings can e.g. be
useful when sharing the same home directory between multiple users at the same
time.

As an example consider a directory with two files: /source/file1 owned by
{g,u}id 1000 and /source/file2 owned by {g,u}id 1001. Assume we create an
idmapped mount at /target with an idmapping that maps files owned by {g,u}id
1000 to being owned by {g,u}id 1001 and files owned by {g,u}id 1001 to being
owned by {g,u}id 1000. In effect, the idmapped mount at /target switches the
ownership of /source/file1 and source/file2, i.e. /target/file1 will be owned
by {g,u}id 1001 and /target/file2 will be owned by {g,u}id 1000.

This means that a user with fs{g,u}id 1000 must be allowed to setattr
/target/file2 from {g,u}id 1000 to {g,u}id 1000. Similar, a user with fs{g,u}id
1001 must be allowed to setattr /target/file1 from {g,u}id 1001 to {g,u}id
1001. Conversely, a user with fs{g,u}id 1000 must fail to setattr /target/file1
from {g,u}id 1001 to {g,u}id 1000. And a user with fs{g,u}id 1001 must fail to
setattr /target/file2 from {g,u}id 1000 to {g,u}id 1000. Both cases must fail
with EPERM for non-capable callers.

Before this patch we could end up denying legitimate attribute changes and
allowing invalid attribute changes when circular mappings are used. To even get
into this situation the caller must've been privileged both to create that
mapping and to create that idmapped mount.

This hasn't been seen in the wild anywhere but came up when expanding the
testsuite during work on a series of hardening patches. All idmapped fstests
pass without any regressions and we add new tests to verify the behavior of
circular mappings.

Link: https://lore.kernel.org/r/20211109145713.1868404-1-brauner@kernel.org
Fixes: 2f221d6f7b88 ("attr: handle idmapped mounts")
Cc: Seth Forshee <seth.forshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Seth Forshee <sforshee@digitalocean.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -35,7 +35,7 @@ static bool chown_ok(struct user_namespa
 		     kuid_t uid)
 {
 	kuid_t kuid = i_uid_into_mnt(mnt_userns, inode);
-	if (uid_eq(current_fsuid(), kuid) && uid_eq(uid, kuid))
+	if (uid_eq(current_fsuid(), kuid) && uid_eq(uid, inode->i_uid))
 		return true;
 	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
 		return true;
@@ -62,7 +62,7 @@ static bool chgrp_ok(struct user_namespa
 {
 	kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
 	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode)) &&
-	    (in_group_p(gid) || gid_eq(gid, kgid)))
+	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
 		return true;
 	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
 		return true;


