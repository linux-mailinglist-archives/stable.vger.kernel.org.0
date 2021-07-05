Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57E63BBF44
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhGEPb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhGEPbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32A986198D;
        Mon,  5 Jul 2021 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498946;
        bh=YiVkQDLRAapwLNvBwX9UK9D5pXW8BaYdNU8onEnEyeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vwf2NGTW/YtdImHsWQRYIXg/6JfLcj2SMkvY6rZFJVRmGlC30l6u9UfZN/SsYiRCM
         8x0ceHw8Ro1mTWPYKEBsztNqgtP7nr5y4AY5EOelPDwIDcbTLKkyGPz6rEetiwi/iA
         qANPURVAm3Xjc2ObDMebaQKZgo2GGdicWvHXVXKaOSVbSljFw3e1tDy8TwTxhQoL+3
         P2Xv/+JaHrzvcHTztpQPGyt4JqPILP/KZuG6U44pdXCO/XPxzkNWfyOEBtHG9fXwKN
         ojhcS22GgTYqJcVyin5bf4z6ibgW6Nb/rOkkZrOkzs0TI+3IRv1BSurlidAbWdp6Xx
         zUAnP204vp+Aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        kernel test robot <lkp@intel.com>,
        Aurelien Aptel <aaptel@suse.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.13 38/59] cifs: improve fallocate emulation
Date:   Mon,  5 Jul 2021 11:27:54 -0400
Message-Id: <20210705152815.1520546-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 21ef51d338e0..b68ba92893b6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3601,6 +3601,119 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
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
@@ -3661,6 +3774,26 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
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

