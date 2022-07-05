Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51829566D33
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbiGEMVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbiGEMRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58191903D;
        Tue,  5 Jul 2022 05:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15183B817D3;
        Tue,  5 Jul 2022 12:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B19DC341C7;
        Tue,  5 Jul 2022 12:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023141;
        bh=nDqnT0a3GMYx49O8X8pyg+RfjChObP2zEbKBWHMzPug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kK3z4rlFHQ5BDaw/hLpgA6tPp/nCkajeNGdlHCNC6ZVYONg4QrxzCWEmBlEGnMt1j
         sdxa/ss+4MD++5uhd+McP4M3TmpDLHplsDbdA32kbBtTb3PEWxhqTf0IfNIDDuQTrm
         WTryk7vsWNeFzaIIQ27pRadmajl3UQd3pFXmLT9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        kernel test robot <oliver.sang@intel.com>,
        Luis Henriques <lhenriques@suse.de>,
        He Zhe <zhe.he@windriver.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 35/98] vfs: fix copy_file_range() regression in cross-fs copies
Date:   Tue,  5 Jul 2022 13:57:53 +0200
Message-Id: <20220705115618.587635919@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 868f9f2f8e004bfe0d3935b1976f625b2924893b upstream.

A regression has been reported by Nicolas Boichat, found while using the
copy_file_range syscall to copy a tracefs file.

Before commit 5dae222a5ff0 ("vfs: allow copy_file_range to copy across
devices") the kernel would return -EXDEV to userspace when trying to
copy a file across different filesystems.  After this commit, the
syscall doesn't fail anymore and instead returns zero (zero bytes
copied), as this file's content is generated on-the-fly and thus reports
a size of zero.

Another regression has been reported by He Zhe - the assertion of
WARN_ON_ONCE(ret == -EOPNOTSUPP) can be triggered from userspace when
copying from a sysfs file whose read operation may return -EOPNOTSUPP.

Since we do not have test coverage for copy_file_range() between any two
types of filesystems, the best way to avoid these sort of issues in the
future is for the kernel to be more picky about filesystems that are
allowed to do copy_file_range().

This patch restores some cross-filesystem copy restrictions that existed
prior to commit 5dae222a5ff0 ("vfs: allow copy_file_range to copy across
devices"), namely, cross-sb copy is not allowed for filesystems that do
not implement ->copy_file_range().

Filesystems that do implement ->copy_file_range() have full control of
the result - if this method returns an error, the error is returned to
the user.  Before this change this was only true for fs that did not
implement the ->remap_file_range() operation (i.e.  nfsv3).

Filesystems that do not implement ->copy_file_range() still fall-back to
the generic_copy_file_range() implementation when the copy is within the
same sb.  This helps the kernel can maintain a more consistent story
about which filesystems support copy_file_range().

nfsd and ksmbd servers are modified to fall-back to the
generic_copy_file_range() implementation in case vfs_copy_file_range()
fails with -EOPNOTSUPP or -EXDEV, which preserves behavior of
server-side-copy.

fall-back to generic_copy_file_range() is not implemented for the smb
operation FSCTL_DUPLICATE_EXTENTS_TO_FILE, which is arguably a correct
change of behavior.

Fixes: 5dae222a5ff0 ("vfs: allow copy_file_range to copy across devices")
Link: https://lore.kernel.org/linux-fsdevel/20210212044405.4120619-1-drinkcat@chromium.org/
Link: https://lore.kernel.org/linux-fsdevel/CANMq1KDZuxir2LM5jOTm0xx+BnvW=ZmpsG47CyHFJwnw7zSX6Q@mail.gmail.com/
Link: https://lore.kernel.org/linux-fsdevel/20210126135012.1.If45b7cdc3ff707bc1efa17f5366057d60603c45f@changeid/
Link: https://lore.kernel.org/linux-fsdevel/20210630161320.29006-1-lhenriques@suse.de/
Reported-by: Nicolas Boichat <drinkcat@chromium.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Luis Henriques <lhenriques@suse.de>
Fixes: 64bf5ff58dff ("vfs: no fallback for ->copy_file_range")
Link: https://lore.kernel.org/linux-fsdevel/20f17f64-88cb-4e80-07c1-85cb96c83619@windriver.com/
Reported-by: He Zhe <zhe.he@windriver.com>
Tested-by: Namjae Jeon <linkinjeon@kernel.org>
Tested-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   16 ++++++++---
 fs/ksmbd/vfs.c     |    4 ++
 fs/nfsd/vfs.c      |    8 ++++-
 fs/read_write.c    |   77 ++++++++++++++++++++++++++++++-----------------------
 4 files changed, 68 insertions(+), 37 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7794,14 +7794,24 @@ int smb2_ioctl(struct ksmbd_work *work)
 		src_off = le64_to_cpu(dup_ext->SourceFileOffset);
 		dst_off = le64_to_cpu(dup_ext->TargetFileOffset);
 		length = le64_to_cpu(dup_ext->ByteCount);
-		cloned = vfs_clone_file_range(fp_in->filp, src_off, fp_out->filp,
-					      dst_off, length, 0);
+		/*
+		 * XXX: It is not clear if FSCTL_DUPLICATE_EXTENTS_TO_FILE
+		 * should fall back to vfs_copy_file_range().  This could be
+		 * beneficial when re-exporting nfs/smb mount, but note that
+		 * this can result in partial copy that returns an error status.
+		 * If/when FSCTL_DUPLICATE_EXTENTS_TO_FILE_EX is implemented,
+		 * fall back to vfs_copy_file_range(), should be avoided when
+		 * the flag DUPLICATE_EXTENTS_DATA_EX_SOURCE_ATOMIC is set.
+		 */
+		cloned = vfs_clone_file_range(fp_in->filp, src_off,
+					      fp_out->filp, dst_off, length, 0);
 		if (cloned == -EXDEV || cloned == -EOPNOTSUPP) {
 			ret = -EOPNOTSUPP;
 			goto dup_ext_out;
 		} else if (cloned != length) {
 			cloned = vfs_copy_file_range(fp_in->filp, src_off,
-						     fp_out->filp, dst_off, length, 0);
+						     fp_out->filp, dst_off,
+						     length, 0);
 			if (cloned != length) {
 				if (cloned < 0)
 					ret = cloned;
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1782,6 +1782,10 @@ int ksmbd_vfs_copy_file_ranges(struct ks
 
 		ret = vfs_copy_file_range(src_fp->filp, src_off,
 					  dst_fp->filp, dst_off, len, 0);
+		if (ret == -EOPNOTSUPP || ret == -EXDEV)
+			ret = generic_copy_file_range(src_fp->filp, src_off,
+						      dst_fp->filp, dst_off,
+						      len, 0);
 		if (ret < 0)
 			return ret;
 
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -560,6 +560,7 @@ out_err:
 ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
 			     u64 dst_pos, u64 count)
 {
+	ssize_t ret;
 
 	/*
 	 * Limit copy to 4MB to prevent indefinitely blocking an nfsd
@@ -570,7 +571,12 @@ ssize_t nfsd_copy_file_range(struct file
 	 * limit like this and pipeline multiple COPY requests.
 	 */
 	count = min_t(u64, count, 1 << 22);
-	return vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
+	ret = vfs_copy_file_range(src, src_pos, dst, dst_pos, count, 0);
+
+	if (ret == -EOPNOTSUPP || ret == -EXDEV)
+		ret = generic_copy_file_range(src, src_pos, dst, dst_pos,
+					      count, 0);
+	return ret;
 }
 
 __be32 nfsd4_vfs_fallocate(struct svc_rqst *rqstp, struct svc_fh *fhp,
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1384,28 +1384,6 @@ ssize_t generic_copy_file_range(struct f
 }
 EXPORT_SYMBOL(generic_copy_file_range);
 
-static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
-				  struct file *file_out, loff_t pos_out,
-				  size_t len, unsigned int flags)
-{
-	/*
-	 * Although we now allow filesystems to handle cross sb copy, passing
-	 * a file of the wrong filesystem type to filesystem driver can result
-	 * in an attempt to dereference the wrong type of ->private_data, so
-	 * avoid doing that until we really have a good reason.  NFS defines
-	 * several different file_system_type structures, but they all end up
-	 * using the same ->copy_file_range() function pointer.
-	 */
-	if (file_out->f_op->copy_file_range &&
-	    file_out->f_op->copy_file_range == file_in->f_op->copy_file_range)
-		return file_out->f_op->copy_file_range(file_in, pos_in,
-						       file_out, pos_out,
-						       len, flags);
-
-	return generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
-				       flags);
-}
-
 /*
  * Performs necessary checks before doing a file copy
  *
@@ -1427,6 +1405,24 @@ static int generic_copy_file_checks(stru
 	if (ret)
 		return ret;
 
+	/*
+	 * We allow some filesystems to handle cross sb copy, but passing
+	 * a file of the wrong filesystem type to filesystem driver can result
+	 * in an attempt to dereference the wrong type of ->private_data, so
+	 * avoid doing that until we really have a good reason.
+	 *
+	 * nfs and cifs define several different file_system_type structures
+	 * and several different sets of file_operations, but they all end up
+	 * using the same ->copy_file_range() function pointer.
+	 */
+	if (file_out->f_op->copy_file_range) {
+		if (file_in->f_op->copy_file_range !=
+		    file_out->f_op->copy_file_range)
+			return -EXDEV;
+	} else if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb) {
+		return -EXDEV;
+	}
+
 	/* Don't touch certain kinds of inodes */
 	if (IS_IMMUTABLE(inode_out))
 		return -EPERM;
@@ -1492,26 +1488,41 @@ ssize_t vfs_copy_file_range(struct file
 	file_start_write(file_out);
 
 	/*
-	 * Try cloning first, this is supported by more file systems, and
-	 * more efficient if both clone and copy are supported (e.g. NFS).
+	 * Cloning is supported by more file systems, so we implement copy on
+	 * same sb using clone, but for filesystems where both clone and copy
+	 * are supported (e.g. nfs,cifs), we only call the copy method.
 	 */
+	if (file_out->f_op->copy_file_range) {
+		ret = file_out->f_op->copy_file_range(file_in, pos_in,
+						      file_out, pos_out,
+						      len, flags);
+		goto done;
+	}
+
 	if (file_in->f_op->remap_file_range &&
 	    file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
-		loff_t cloned;
-
-		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
+		ret = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
 				min_t(loff_t, MAX_RW_COUNT, len),
 				REMAP_FILE_CAN_SHORTEN);
-		if (cloned > 0) {
-			ret = cloned;
+		if (ret > 0)
 			goto done;
-		}
 	}
 
-	ret = do_copy_file_range(file_in, pos_in, file_out, pos_out, len,
-				flags);
-	WARN_ON_ONCE(ret == -EOPNOTSUPP);
+	/*
+	 * We can get here for same sb copy of filesystems that do not implement
+	 * ->copy_file_range() in case filesystem does not support clone or in
+	 * case filesystem supports clone but rejected the clone request (e.g.
+	 * because it was not block aligned).
+	 *
+	 * In both cases, fall back to kernel copy so we are able to maintain a
+	 * consistent story about which filesystems support copy_file_range()
+	 * and which filesystems do not, that will allow userspace tools to
+	 * make consistent desicions w.r.t using copy_file_range().
+	 */
+	ret = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
+				      flags);
+
 done:
 	if (ret > 0) {
 		fsnotify_access(file_in);


