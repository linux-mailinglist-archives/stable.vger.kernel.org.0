Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFCC3C48B1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhGLGkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237882AbhGLGjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D63EE61151;
        Mon, 12 Jul 2021 06:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071738;
        bh=TbsfBF/06lTy+h1drp/8oRI59/zCtxta1qITByGw/KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzY44memKnBbsgegJZz7PVpFG1VmAskGkc7Ban/K4Z4wU+64y8WykdXQ2a1YXpZJ8
         tI9tWrlkp6g9xbfdnqT7tPDoWHQhz8EoHdooHUZTdb8TksovrebZaCLe7LJOBxGniW
         lZMPL5Dhd1ANPPwYDDdmGSaJ89h670mfgwzCtGak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Aurelien Aptel <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/593] cifs: improve fallocate emulation
Date:   Mon, 12 Jul 2021 08:05:56 +0200
Message-Id: <20210712060904.577112228@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit 966a3cb7c7db786452a87afdc3b48858fc4d4d6b ]

RHBZ: 1866684

We don't have a real fallocate in the SMB2 protocol so we used to emulate fallocate
by simply switching the file to become non-sparse. But as that could potantially consume
a lot more data than we intended to fallocate (large sparse file and fallocating a thin
slice in the middle) we would only do this IFF the fallocate request was for virtually
the entire file.

This patch improves this and starts allowing us to fallocate smaller chunks of a file by
overwriting the region with 0, for the parts that are unallocated.

The method used is to first query the server for FSCTL_QUERY_ALLOCATED_RANGES to find what
is unallocated in the fallocate range and then to only overwrite-with-zero the unallocated
ranges to fill in the holes.

As overwriting-with-zero is different from just allocating blocks, and potentially much
more expensive, we limit this to only allow fallocate ranges up to 1Mb in size.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Aurelien Aptel <aaptel@suse.com>
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a9d155530144..f6ceb79a995d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3459,6 +3459,119 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	return rc;
 }
 
+static int smb3_simple_fallocate_write_range(unsigned int xid,
+					     struct cifs_tcon *tcon,
+					     struct cifsFileInfo *cfile,
+					     loff_t off, loff_t len,
+					     char *buf)
+{
+	struct cifs_io_parms io_parms = {0};
+	int nbytes;
+	struct kvec iov[2];
+
+	io_parms.netfid = cfile->fid.netfid;
+	io_parms.pid = current->tgid;
+	io_parms.tcon = tcon;
+	io_parms.persistent_fid = cfile->fid.persistent_fid;
+	io_parms.volatile_fid = cfile->fid.volatile_fid;
+	io_parms.offset = off;
+	io_parms.length = len;
+
+	/* iov[0] is reserved for smb header */
+	iov[1].iov_base = buf;
+	iov[1].iov_len = io_parms.length;
+	return SMB2_write(xid, &io_parms, &nbytes, iov, 1);
+}
+
+static int smb3_simple_fallocate_range(unsigned int xid,
+				       struct cifs_tcon *tcon,
+				       struct cifsFileInfo *cfile,
+				       loff_t off, loff_t len)
+{
+	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
+	u32 out_data_len;
+	char *buf = NULL;
+	loff_t l;
+	int rc;
+
+	in_data.file_offset = cpu_to_le64(off);
+	in_data.length = cpu_to_le64(len);
+	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+			cfile->fid.volatile_fid,
+			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			(char *)&in_data, sizeof(in_data),
+			1024 * sizeof(struct file_allocated_range_buffer),
+			(char **)&out_data, &out_data_len);
+	if (rc)
+		goto out;
+	/*
+	 * It is already all allocated
+	 */
+	if (out_data_len == 0)
+		goto out;
+
+	buf = kzalloc(1024 * 1024, GFP_KERNEL);
+	if (buf == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	tmp_data = out_data;
+	while (len) {
+		/*
+		 * The rest of the region is unmapped so write it all.
+		 */
+		if (out_data_len == 0) {
+			rc = smb3_simple_fallocate_write_range(xid, tcon,
+					       cfile, off, len, buf);
+			goto out;
+		}
+
+		if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		if (off < le64_to_cpu(tmp_data->file_offset)) {
+			/*
+			 * We are at a hole. Write until the end of the region
+			 * or until the next allocated data,
+			 * whichever comes next.
+			 */
+			l = le64_to_cpu(tmp_data->file_offset) - off;
+			if (len < l)
+				l = len;
+			rc = smb3_simple_fallocate_write_range(xid, tcon,
+					       cfile, off, l, buf);
+			if (rc)
+				goto out;
+			off = off + l;
+			len = len - l;
+			if (len == 0)
+				goto out;
+		}
+		/*
+		 * We are at a section of allocated data, just skip forward
+		 * until the end of the data or the end of the region
+		 * we are supposed to fallocate, whichever comes first.
+		 */
+		l = le64_to_cpu(tmp_data->length);
+		if (len < l)
+			l = len;
+		off += l;
+		len -= l;
+
+		tmp_data = &tmp_data[1];
+		out_data_len -= sizeof(struct file_allocated_range_buffer);
+	}
+
+ out:
+	kfree(out_data);
+	kfree(buf);
+	return rc;
+}
+
+
 static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			    loff_t off, loff_t len, bool keep_size)
 {
@@ -3519,6 +3632,26 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
+		/*
+		 * At this point, we are trying to fallocate an internal
+		 * regions of a sparse file. Since smb2 does not have a
+		 * fallocate command we have two otions on how to emulate this.
+		 * We can either turn the entire file to become non-sparse
+		 * which we only do if the fallocate is for virtually
+		 * the whole file,  or we can overwrite the region with zeroes
+		 * using SMB2_write, which could be prohibitevly expensive
+		 * if len is large.
+		 */
+		/*
+		 * We are only trying to fallocate a small region so
+		 * just write it with zero.
+		 */
+		if (len <= 1024 * 1024) {
+			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
+							 off, len);
+			goto out;
+		}
+
 		/*
 		 * Check if falloc starts within first few pages of file
 		 * and ends within a few pages of the end of file to
-- 
2.30.2



