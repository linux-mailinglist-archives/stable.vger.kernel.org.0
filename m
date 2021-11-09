Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5C244AFD4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 15:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhKIPAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 10:00:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230007AbhKIPAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 10:00:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B129B61051;
        Tue,  9 Nov 2021 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636469871;
        bh=15wgt7NzUxew6ROY5i2SeMYHMVK9xta2nRdGJISFzds=;
        h=From:To:Cc:Subject:Date:From;
        b=Q5XEvod7Yjesf/zce0S8YkCR+RnVWN9I6wlU/vX+PVtZeHRQVZXPsbtLTUSb6rkec
         HSEmP2GfKBUw1TKVe/Cl75b5HX7Cx7WnCK0mNjzcdhBUL9CCp9veuxUUDAtBOWbh3z
         uPCnBLo+FIDfJcyoz7a8xoxBlPkbGAHeuWpGhBVhOyDO3aMX7j7TkEvrHzI5OeT/Nc
         fNc3hdTJB8YMyIiDHZRncdSerYZghFCq/hkR3rmUuer/SC5xlShgW9qVp6bVdk4+r1
         niw3ME2y0b4yn7qO2JpYScdbVdtLbdjVegZfNVY9C/ZyRbbYwWSG+lExSiiGrB2crU
         RKz0qFHy5Pzbw==
From:   Christian Brauner <brauner@kernel.org>
To:     Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
Cc:     Seth Forshee <seth.forshee@digitalocean.com>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] fs: handle circular mappings correctly
Date:   Tue,  9 Nov 2021 15:57:12 +0100
Message-Id: <20211109145713.1868404-1-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3900; h=from:subject; bh=irbN+xRAs6TsbrbgOeyzP6xiRkJv+dBh9g1xw9O2BIw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR29binVTy7H3xjwZ/4+hSlOTzuDJttf566wX5/ss+R3XxT eOLmdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkRTojw+d0x16R3q7/K78e/bnzgW IYx+r/zq+fOe+dz7/EP0hq3xJGhk+reE2PLj0m9UTpwISppwL76hOOJaVrS92J6tTLc+tbzQEA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

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

Fixes: 2f221d6f7b88 ("attr: handle idmapped mounts")
Cc: Seth Forshee <seth.forshee@digitalocean.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 473d21b3a86d..66899b6e9bd8 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -35,7 +35,7 @@ static bool chown_ok(struct user_namespace *mnt_userns,
 		     kuid_t uid)
 {
 	kuid_t kuid = i_uid_into_mnt(mnt_userns, inode);
-	if (uid_eq(current_fsuid(), kuid) && uid_eq(uid, kuid))
+	if (uid_eq(current_fsuid(), kuid) && uid_eq(uid, inode->i_uid))
 		return true;
 	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
 		return true;
@@ -62,7 +62,7 @@ static bool chgrp_ok(struct user_namespace *mnt_userns,
 {
 	kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
 	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode)) &&
-	    (in_group_p(gid) || gid_eq(gid, kgid)))
+	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
 		return true;
 	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
 		return true;

base-commit: 8bb7eca972ad531c9b149c0a51ab43a417385813
-- 
2.30.2

