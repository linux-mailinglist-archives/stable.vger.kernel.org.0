Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BAE64B5D3
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 14:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbiLMNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 08:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbiLMNNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 08:13:52 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919B01F2E1;
        Tue, 13 Dec 2022 05:13:51 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u12so15544080wrr.11;
        Tue, 13 Dec 2022 05:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5S3OJ3rP9eXEqtRVPEmfPbbz89ZCpe7zZTVhDJWIPd4=;
        b=XR3gyMeViEaQhFwXOs73arW+SW0pL/pjEavQ5F2BN/eJniMEVoyeUNSvypvDuq7KaL
         Ag//k5r7gUUVdwcDs5dlSZI2X/MPEfQXWJl+OyfGgIL/YOIHpAEdd6fBTz/WP4Jbtc1N
         /DCOhv1Xf9u5G0iy7/9viU/MP9JHhTe2lXhE2i38kR/14e6RXzufm0i3xbLCSgZ2KfWn
         PYJreWYFeJN4tS11GQDB64+FExX1XjXDEDM/KpxgfaCs9gZ9rrEwg1elStv7DExkh1p2
         Lk4JzaumAaA8s4W4hiyGTxEB7lnoEGImQrM1khr0mu4HA0AFl4jNvjB+izZ1GrmwtFpC
         GIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5S3OJ3rP9eXEqtRVPEmfPbbz89ZCpe7zZTVhDJWIPd4=;
        b=VyesNby3HKy2oqya6chFocGkaMHBYyK9CzDwu6DTgXgzItZeOy5GNqnFNDq2WQocYS
         I5S4oyDLVBct26YX5uhlyFEdgdy6YG+dOTixOpBTc0Be674FDAgHq/K3YMp0kUapy8ap
         7T1ZjmDYzfimfYxS49atGnkOVGSk/7W6lh6HmPkySKoDBje7cR+aqJ7KDHJnCKz9K1et
         dm/19LMec/o9krTbkXOkY9X/KILd9Zry61aPUeugJYNwesgLDJdgKTDy7h5brFs2E2ey
         5dLxdlrIKHFp+p3mankRq2O8uxkTl6TQVhGZyZsv6lFbru+XsAoYR+Wlk4Hqqi50JPzt
         ZFew==
X-Gm-Message-State: ANoB5pmPlB21NJnbetWuU2syYhiAbwgEdmuPEvXAuPqf8OtEaMFxms5g
        B2LzoMcJAPe1pPVtVnWQPbs=
X-Google-Smtp-Source: AA0mqf6+wyw838uffp+joS7RWwtTK1LYiI63lKptQX/P5nW6vt9SDnUAF09wW0KHZWT9WgGkvNv91w==
X-Received: by 2002:a05:6000:1004:b0:242:9e3:72b8 with SMTP id a4-20020a056000100400b0024209e372b8mr16410148wrx.31.1670937229849;
        Tue, 13 Dec 2022 05:13:49 -0800 (PST)
Received: from localhost.localdomain ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id y11-20020adff14b000000b002365b759b65sm11643563wro.86.2022.12.13.05.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 05:13:49 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Nicolas Boichat <drinkcat@chromium.org>,
        kernel test robot <oliver.sang@intel.com>,
        He Zhe <zhe.he@windriver.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 1/2] vfs: fix copy_file_range() regression in cross-fs copies
Date:   Tue, 13 Dec 2022 15:13:40 +0200
Message-Id: <20221213131341.951049-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221213131341.951049-1-amir73il@gmail.com>
References: <20221213131341.951049-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 868f9f2f8e004bfe0d3935b1976f625b2924893b upstream.

[backport comments for pre v5.15:
- This commit has a bug fixed by commit 10bc8e4af659 ("vfs: fix
  copy_file_range() averts filesystem freeze protection")
- ksmbd mentions are irrelevant - ksmbd hunks were dropped
]

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
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216800
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/nfsd/vfs.c   |  8 +++++-
 fs/read_write.c | 77 ++++++++++++++++++++++++++++++++-------------------------
 2 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index d8c5b67f06f4..9ecaf9481a37 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -568,6 +568,7 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
 			     u64 dst_pos, u64 count)
 {
+	ssize_t ret;
 
 	/*
 	 * Limit copy to 4MB to prevent indefinitely blocking an nfsd
@@ -578,7 +579,12 @@ ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
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
diff --git a/fs/read_write.c b/fs/read_write.c
index b5fb534cebe6..e1e83d6c21e6 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1413,28 +1413,6 @@ ssize_t generic_copy_file_range(struct file *file_in, loff_t pos_in,
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
@@ -1456,6 +1434,24 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
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
@@ -1521,26 +1517,41 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
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
-- 
2.16.5

