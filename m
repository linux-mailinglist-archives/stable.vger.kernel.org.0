Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D60017FCF4
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbgCJM6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729749AbgCJM6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:58:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E826A20674;
        Tue, 10 Mar 2020 12:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845120;
        bh=/Dk3kV8MbWq34lpEEYXLiuCUQ5tJX38f3kASz0JHOl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzlyvgMRLpLz4Q80NsNJW0OIAvOadj20mr8QPneubfZlfVN8RjbOg3Jl7VgrEp5BU
         QmW/BQo5JJvMa4r+jVmbuCyPX1zy0VPDIKT1RYs4IJylYUsemggCloWXsVXItaqEs+
         Xu7V1JkCBQ1GCaek321BNbhywbe/bH8b9v65qj68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH 5.5 068/189] cifs: fix rename() by ensuring source handle opened with DELETE bit
Date:   Tue, 10 Mar 2020 13:38:25 +0100
Message-Id: <20200310123646.486581344@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

commit 86f740f2aed5ea7fe1aa86dc2df0fb4ab0f71088 upstream.

To rename a file in SMB2 we open it with the DELETE access and do a
special SetInfo on it. If the handle is missing the DELETE bit the
server will fail the SetInfo with STATUS_ACCESS_DENIED.

We currently try to reuse any existing opened handle we have with
cifs_get_writable_path(). That function looks for handles with WRITE
access but doesn't check for DELETE, making rename() fail if it finds
a handle to reuse. Simple reproducer below.

To select handles with the DELETE bit, this patch adds a flag argument
to cifs_get_writable_path() and find_writable_file() and the existing
'bool fsuid_only' argument is converted to a flag.

The cifsFileInfo struct only stores the UNIX open mode but not the
original SMB access flags. Since the DELETE bit is not mapped in that
mode, this patch stores the access mask in cifs_fid on file open,
which is accessible from cifsFileInfo.

Simple reproducer:

	#include <stdio.h>
	#include <stdlib.h>
	#include <sys/types.h>
	#include <sys/stat.h>
	#include <fcntl.h>
	#include <unistd.h>
	#define E(s) perror(s), exit(1)

	int main(int argc, char *argv[])
	{
		int fd, ret;
		if (argc != 3) {
			fprintf(stderr, "Usage: %s A B\n"
			"create&open A in write mode, "
			"rename A to B, close A\n", argv[0]);
			return 0;
		}

		fd = openat(AT_FDCWD, argv[1], O_WRONLY|O_CREAT|O_SYNC, 0666);
		if (fd == -1) E("openat()");

		ret = rename(argv[1], argv[2]);
		if (ret) E("rename()");

		ret = close(fd);
		if (ret) E("close()");

		return ret;
	}

$ gcc -o bugrename bugrename.c
$ ./bugrename /mnt/a /mnt/b
rename(): Permission denied

Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsglob.h  |    7 +++++++
 fs/cifs/cifsproto.h |    5 +++--
 fs/cifs/cifssmb.c   |    3 ++-
 fs/cifs/file.c      |   19 ++++++++++++-------
 fs/cifs/inode.c     |    6 +++---
 fs/cifs/smb1ops.c   |    2 +-
 fs/cifs/smb2inode.c |    4 ++--
 fs/cifs/smb2ops.c   |    3 ++-
 fs/cifs/smb2pdu.c   |    1 +
 9 files changed, 33 insertions(+), 17 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1277,6 +1277,7 @@ struct cifs_fid {
 	__u64 volatile_fid;	/* volatile file id for smb2 */
 	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for smb2 */
 	__u8 create_guid[16];
+	__u32 access;
 	struct cifs_pending_open *pending_open;
 	unsigned int epoch;
 #ifdef CONFIG_CIFS_DEBUG2
@@ -1737,6 +1738,12 @@ static inline bool is_retryable_error(in
 	return false;
 }
 
+
+/* cifs_get_writable_file() flags */
+#define FIND_WR_ANY         0
+#define FIND_WR_FSUID_ONLY  1
+#define FIND_WR_WITH_DELETE 2
+
 #define   MID_FREE 0
 #define   MID_REQUEST_ALLOCATED 1
 #define   MID_REQUEST_SUBMITTED 2
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -134,11 +134,12 @@ extern bool backup_cred(struct cifs_sb_i
 extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
 extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 			    unsigned int bytes_written);
-extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
+extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, int);
 extern int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
-				  bool fsuid_only,
+				  int flags,
 				  struct cifsFileInfo **ret_file);
 extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
+				  int flags,
 				  struct cifsFileInfo **ret_file);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1492,6 +1492,7 @@ openRetry:
 	*oplock = rsp->OplockLevel;
 	/* cifs fid stays in le */
 	oparms->fid->netfid = rsp->Fid;
+	oparms->fid->access = desired_access;
 
 	/* Let caller know file was created so we can set the mode. */
 	/* Do we care about the CreateAction in any other cases? */
@@ -2115,7 +2116,7 @@ cifs_writev_requeue(struct cifs_writedat
 		wdata2->tailsz = tailsz;
 		wdata2->bytes = cur_len;
 
-		rc = cifs_get_writable_file(CIFS_I(inode), false,
+		rc = cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY,
 					    &wdata2->cfile);
 		if (!wdata2->cfile) {
 			cifs_dbg(VFS, "No writable handle to retry writepages rc=%d\n",
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1964,7 +1964,7 @@ struct cifsFileInfo *find_readable_file(
 
 /* Return -EBADF if no handle is found and general rc otherwise */
 int
-cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only,
+cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 		       struct cifsFileInfo **ret_file)
 {
 	struct cifsFileInfo *open_file, *inv_file = NULL;
@@ -1972,7 +1972,8 @@ cifs_get_writable_file(struct cifsInodeI
 	bool any_available = false;
 	int rc = -EBADF;
 	unsigned int refind = 0;
-
+	bool fsuid_only = flags & FIND_WR_FSUID_ONLY;
+	bool with_delete = flags & FIND_WR_WITH_DELETE;
 	*ret_file = NULL;
 
 	/*
@@ -2004,6 +2005,8 @@ refind_writable:
 			continue;
 		if (fsuid_only && !uid_eq(open_file->uid, current_fsuid()))
 			continue;
+		if (with_delete && !(open_file->fid.access & DELETE))
+			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
@@ -2051,12 +2054,12 @@ refind_writable:
 }
 
 struct cifsFileInfo *
-find_writable_file(struct cifsInodeInfo *cifs_inode, bool fsuid_only)
+find_writable_file(struct cifsInodeInfo *cifs_inode, int flags)
 {
 	struct cifsFileInfo *cfile;
 	int rc;
 
-	rc = cifs_get_writable_file(cifs_inode, fsuid_only, &cfile);
+	rc = cifs_get_writable_file(cifs_inode, flags, &cfile);
 	if (rc)
 		cifs_dbg(FYI, "couldn't find writable handle rc=%d", rc);
 
@@ -2065,6 +2068,7 @@ find_writable_file(struct cifsInodeInfo
 
 int
 cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
+		       int flags,
 		       struct cifsFileInfo **ret_file)
 {
 	struct list_head *tmp;
@@ -2091,7 +2095,7 @@ cifs_get_writable_path(struct cifs_tcon
 		kfree(full_path);
 		cinode = CIFS_I(d_inode(cfile->dentry));
 		spin_unlock(&tcon->open_file_lock);
-		return cifs_get_writable_file(cinode, 0, ret_file);
+		return cifs_get_writable_file(cinode, flags, ret_file);
 	}
 
 	spin_unlock(&tcon->open_file_lock);
@@ -2168,7 +2172,8 @@ static int cifs_partialpagewrite(struct
 	if (mapping->host->i_size - offset < (loff_t)to)
 		to = (unsigned)(mapping->host->i_size - offset);
 
-	rc = cifs_get_writable_file(CIFS_I(mapping->host), false, &open_file);
+	rc = cifs_get_writable_file(CIFS_I(mapping->host), FIND_WR_ANY,
+				    &open_file);
 	if (!rc) {
 		bytes_written = cifs_write(open_file, open_file->pid,
 					   write_data, to - from, &offset);
@@ -2361,7 +2366,7 @@ retry:
 		if (cfile)
 			cifsFileInfo_put(cfile);
 
-		rc = cifs_get_writable_file(CIFS_I(inode), false, &cfile);
+		rc = cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile);
 
 		/* in case of an error store it to return later */
 		if (rc)
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2283,7 +2283,7 @@ cifs_set_file_size(struct inode *inode,
 	 * writebehind data than the SMB timeout for the SetPathInfo
 	 * request would allow
 	 */
-	open_file = find_writable_file(cifsInode, true);
+	open_file = find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
 	if (open_file) {
 		tcon = tlink_tcon(open_file->tlink);
 		server = tcon->ses->server;
@@ -2433,7 +2433,7 @@ cifs_setattr_unix(struct dentry *direntr
 		args->ctime = NO_CHANGE_64;
 
 	args->device = 0;
-	open_file = find_writable_file(cifsInode, true);
+	open_file = find_writable_file(cifsInode, FIND_WR_FSUID_ONLY);
 	if (open_file) {
 		u16 nfid = open_file->fid.netfid;
 		u32 npid = open_file->pid;
@@ -2536,7 +2536,7 @@ cifs_setattr_nounix(struct dentry *diren
 	rc = 0;
 
 	if (attrs->ia_valid & ATTR_MTIME) {
-		rc = cifs_get_writable_file(cifsInode, false, &wfile);
+		rc = cifs_get_writable_file(cifsInode, FIND_WR_ANY, &wfile);
 		if (!rc) {
 			tcon = tlink_tcon(wfile->tlink);
 			rc = tcon->ses->server->ops->flush(xid, tcon, &wfile->fid);
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -765,7 +765,7 @@ smb_set_file_info(struct inode *inode, c
 	struct cifs_tcon *tcon;
 
 	/* if the file is already open for write, just use that fileid */
-	open_file = find_writable_file(cinode, true);
+	open_file = find_writable_file(cinode, FIND_WR_FSUID_ONLY);
 	if (open_file) {
 		fid.netfid = open_file->fid.netfid;
 		netpid = open_file->pid;
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -526,7 +526,7 @@ smb2_mkdir_setinfo(struct inode *inode,
 	cifs_i = CIFS_I(inode);
 	dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
 	data.Attributes = cpu_to_le32(dosattrs);
-	cifs_get_writable_path(tcon, name, &cfile);
+	cifs_get_writable_path(tcon, name, FIND_WR_ANY, &cfile);
 	tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
 				 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
 				 CREATE_NOT_FILE, ACL_NO_MODE,
@@ -582,7 +582,7 @@ smb2_rename_path(const unsigned int xid,
 {
 	struct cifsFileInfo *cfile;
 
-	cifs_get_writable_path(tcon, from_name, &cfile);
+	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
 
 	return smb2_set_path_attr(xid, tcon, from_name, to_name,
 				  cifs_sb, DELETE, SMB2_OP_RENAME, cfile);
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1366,6 +1366,7 @@ smb2_set_fid(struct cifsFileInfo *cfile,
 
 	cfile->fid.persistent_fid = fid->persistent_fid;
 	cfile->fid.volatile_fid = fid->volatile_fid;
+	cfile->fid.access = fid->access;
 #ifdef CONFIG_CIFS_DEBUG2
 	cfile->fid.mid = fid->mid;
 #endif /* CIFS_DEBUG2 */
@@ -3225,7 +3226,7 @@ static loff_t smb3_llseek(struct file *f
 	 * some servers (Windows2016) will not reflect recent writes in
 	 * QUERY_ALLOCATED_RANGES until SMB2_flush is called.
 	 */
-	wrcfile = find_writable_file(cifsi, false);
+	wrcfile = find_writable_file(cifsi, FIND_WR_ANY);
 	if (wrcfile) {
 		filemap_write_and_wait(inode->i_mapping);
 		smb2_flush_file(xid, tcon, &wrcfile->fid);
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2749,6 +2749,7 @@ SMB2_open(const unsigned int xid, struct
 	atomic_inc(&tcon->num_remote_opens);
 	oparms->fid->persistent_fid = rsp->PersistentFileId;
 	oparms->fid->volatile_fid = rsp->VolatileFileId;
+	oparms->fid->access = oparms->desired_access;
 #ifdef CONFIG_CIFS_DEBUG2
 	oparms->fid->mid = le64_to_cpu(rsp->sync_hdr.MessageId);
 #endif /* CIFS_DEBUG2 */


