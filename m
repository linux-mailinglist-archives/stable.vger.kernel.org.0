Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D903D2A58
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhGVQK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233718AbhGVQIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF3861DBF;
        Thu, 22 Jul 2021 16:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972511;
        bh=KPqakCbcJwhk6as2lVGh0h6Q2wj60Fv2N+mbmPGEDpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptalImpcYr+rTSeldsq3t1/pV6ZLyRfIsK4GmgHbYftNzVrySIfXQmpeIDBxv6ohr
         tONz1aI/h+T3ZcOVjMAmo3dVFzPUw6vtaLWH/4AP+XOmIQ3vibPuCOLbvNjUNBtlmh
         b2KBjO52Bqkb8lsMixPiRo67XLZRUPFW2sHmk0Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Pouzenc <bugreports@pouzenc.fr>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.13 139/156] vboxsf: Add support for the atomic_open directory-inode op
Date:   Thu, 22 Jul 2021 18:31:54 +0200
Message-Id: <20210722155632.846854683@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 52dfd86aa568e433b24357bb5fc725560f1e22d8 upstream.

Opening a new file is done in 2 steps on regular filesystems:

1. Call the create inode-op on the parent-dir to create an inode
to hold the meta-data related to the file.
2. Call the open file-op to get a handle for the file.

vboxsf however does not really use disk-backed inodes because it
is based on passing through file-related system-calls through to
the hypervisor. So both steps translate to an open(2) call being
passed through to the hypervisor. With the handle returned by
the first call immediately being closed again.

Making 2 open calls for a single open(..., O_CREATE, ...) calls
has 2 problems:

a) It is not really efficient.
b) It actually breaks some apps.

An example of b) is doing a git clone inside a vboxsf mount.
When git clone tries to create a tempfile to store the pak
files which is downloading the following happens:

1. vboxsf_dir_mkfile() gets called with a mode of 0444 and succeeds.
2. vboxsf_file_open() gets called with file->f_flags containing
O_RDWR. When the host is a Linux machine this fails because doing
a open(..., O_RDWR) on a file which exists and has mode 0444 results
in an -EPERM error.

Other network-filesystems and fuse avoid the problem of needing to
pass 2 open() calls to the other side by using the atomic_open
directory-inode op.

This commit fixes git clone not working inside a vboxsf mount,
by adding support for the atomic_open directory-inode op.
As an added bonus this should also make opening new files faster.

The atomic_open implementation is modelled after the atomic_open
implementations from the 9p and fuse code.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Reported-by: Ludovic Pouzenc <bugreports@pouzenc.fr>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/vboxsf/dir.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -308,6 +308,53 @@ static int vboxsf_dir_mkdir(struct user_
 	return vboxsf_dir_create(parent, dentry, mode, true, true, NULL);
 }
 
+static int vboxsf_dir_atomic_open(struct inode *parent, struct dentry *dentry,
+				  struct file *file, unsigned int flags, umode_t mode)
+{
+	struct vboxsf_sbi *sbi = VBOXSF_SBI(parent->i_sb);
+	struct vboxsf_handle *sf_handle;
+	struct dentry *res = NULL;
+	u64 handle;
+	int err;
+
+	if (d_in_lookup(dentry)) {
+		res = vboxsf_dir_lookup(parent, dentry, 0);
+		if (IS_ERR(res))
+			return PTR_ERR(res);
+
+		if (res)
+			dentry = res;
+	}
+
+	/* Only creates */
+	if (!(flags & O_CREAT) || d_really_is_positive(dentry))
+		return finish_no_open(file, res);
+
+	err = vboxsf_dir_create(parent, dentry, mode, false, flags & O_EXCL, &handle);
+	if (err)
+		goto out;
+
+	sf_handle = vboxsf_create_sf_handle(d_inode(dentry), handle, SHFL_CF_ACCESS_READWRITE);
+	if (IS_ERR(sf_handle)) {
+		vboxsf_close(sbi->root, handle);
+		err = PTR_ERR(sf_handle);
+		goto out;
+	}
+
+	err = finish_open(file, dentry, generic_file_open);
+	if (err) {
+		/* This also closes the handle passed to vboxsf_create_sf_handle() */
+		vboxsf_release_sf_handle(d_inode(dentry), sf_handle);
+		goto out;
+	}
+
+	file->private_data = sf_handle;
+	file->f_mode |= FMODE_CREATED;
+out:
+	dput(res);
+	return err;
+}
+
 static int vboxsf_dir_unlink(struct inode *parent, struct dentry *dentry)
 {
 	struct vboxsf_sbi *sbi = VBOXSF_SBI(parent->i_sb);
@@ -428,6 +475,7 @@ const struct inode_operations vboxsf_dir
 	.lookup  = vboxsf_dir_lookup,
 	.create  = vboxsf_dir_mkfile,
 	.mkdir   = vboxsf_dir_mkdir,
+	.atomic_open = vboxsf_dir_atomic_open,
 	.rmdir   = vboxsf_dir_unlink,
 	.unlink  = vboxsf_dir_unlink,
 	.rename  = vboxsf_dir_rename,


