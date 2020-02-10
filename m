Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D265E1576F3
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgBJMlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbgBJMlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:36 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8706E20842;
        Mon, 10 Feb 2020 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338495;
        bh=qzTJ6JCH6xztQ7FzsBuS5j6ruBXmSmK1Uw/HSFCLJFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRdmhnwHraBZ1ZaT9piPLZvaxTp6OS5LQSkDN+EOlTcoIrAiHqTc1F7jygpgK39Zw
         a9lgP0aEKckBJ1ieGn0Ojn7PAPbP6t9QnbgMrsMJSbkaufXy1Y4WmXcRA3OCgp9UOa
         zM+b11jcWvPLEnddhxF+D1eprEjHf9qDdUvl1MXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.5 284/367] compat: scsi: sg: fix v3 compat read/write interface
Date:   Mon, 10 Feb 2020 04:33:17 -0800
Message-Id: <20200210122450.176337512@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 78ed001d9e7106171e0ee761cd854137dd731302 upstream.

In the v5.4 merge window, a cleanup patch from Al Viro conflicted
with my rework of the compat handling for sg.c read(). Linus Torvalds
did a correct merge but pointed out that the resulting code is still
unsatisfactory.

I later noticed that the sg_new_read() function still gets the compat
mode wrong, when the 'count' argument is large enough to pass a
compat_sg_io_hdr object, but not a nativ sg_io_hdr.

To address both of these, move the definition of compat_sg_io_hdr
into a scsi/sg.h to make it visible to sg.c and rewrite the logic
for reading req_pack_id as well as the size check to a simpler
version that gets the expected results.

Fixes: c35a5cfb4150 ("scsi: sg: sg_read(): simplify reading ->pack_id of userland sg_io_hdr_t")
Fixes: 98aaaec4a150 ("compat_ioctl: reimplement SG_IO handling")
Reviewed-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/scsi_ioctl.c |   29 ------------
 drivers/scsi/sg.c  |  126 ++++++++++++++++++++++++-----------------------------
 include/scsi/sg.h  |   30 ++++++++++++
 3 files changed, 90 insertions(+), 95 deletions(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -20,6 +20,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/sg.h>
 
 struct blk_cmd_filter {
 	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
@@ -550,34 +551,6 @@ static inline int blk_send_start_stop(st
 	return __blk_send_generic(q, bd_disk, GPCMD_START_STOP_UNIT, data);
 }
 
-#ifdef CONFIG_COMPAT
-struct compat_sg_io_hdr {
-	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
-	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
-	unsigned char cmd_len;		/* [i] SCSI command length ( <= 16 bytes) */
-	unsigned char mx_sb_len;	/* [i] max length to write to sbp */
-	unsigned short iovec_count;	/* [i] 0 implies no scatter gather */
-	compat_uint_t dxfer_len;	/* [i] byte count of data transfer */
-	compat_uint_t dxferp;		/* [i], [*io] points to data transfer memory
-						or scatter gather list */
-	compat_uptr_t cmdp;		/* [i], [*i] points to command to perform */
-	compat_uptr_t sbp;		/* [i], [*o] points to sense_buffer memory */
-	compat_uint_t timeout;		/* [i] MAX_UINT->no timeout (unit: millisec) */
-	compat_uint_t flags;		/* [i] 0 -> default, see SG_FLAG... */
-	compat_int_t pack_id;		/* [i->o] unused internally (normally) */
-	compat_uptr_t usr_ptr;		/* [i->o] unused internally */
-	unsigned char status;		/* [o] scsi status */
-	unsigned char masked_status;	/* [o] shifted, masked scsi status */
-	unsigned char msg_status;	/* [o] messaging level data (optional) */
-	unsigned char sb_len_wr;	/* [o] byte count actually written to sbp */
-	unsigned short host_status;	/* [o] errors from host adapter */
-	unsigned short driver_status;	/* [o] errors from software driver */
-	compat_int_t resid;		/* [o] dxfer_len - actual_transferred */
-	compat_uint_t duration;		/* [o] time taken by cmd (unit: millisec) */
-	compat_uint_t info;		/* [o] auxiliary information */
-};
-#endif
-
 int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp)
 {
 #ifdef CONFIG_COMPAT
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -405,6 +405,38 @@ sg_release(struct inode *inode, struct f
 	return 0;
 }
 
+static int get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
+{
+	struct sg_header __user *old_hdr = buf;
+	int reply_len;
+
+	if (count >= SZ_SG_HEADER) {
+		/* negative reply_len means v3 format, otherwise v1/v2 */
+		if (get_user(reply_len, &old_hdr->reply_len))
+			return -EFAULT;
+
+		if (reply_len >= 0)
+			return get_user(*pack_id, &old_hdr->pack_id);
+
+		if (in_compat_syscall() &&
+		    count >= sizeof(struct compat_sg_io_hdr)) {
+			struct compat_sg_io_hdr __user *hp = buf;
+
+			return get_user(*pack_id, &hp->pack_id);
+		}
+
+		if (count >= sizeof(struct sg_io_hdr)) {
+			struct sg_io_hdr __user *hp = buf;
+
+			return get_user(*pack_id, &hp->pack_id);
+		}
+	}
+
+	/* no valid header was passed, so ignore the pack_id */
+	*pack_id = -1;
+	return 0;
+}
+
 static ssize_t
 sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 {
@@ -413,8 +445,8 @@ sg_read(struct file *filp, char __user *
 	Sg_request *srp;
 	int req_pack_id = -1;
 	sg_io_hdr_t *hp;
-	struct sg_header *old_hdr = NULL;
-	int retval = 0;
+	struct sg_header *old_hdr;
+	int retval;
 
 	/*
 	 * This could cause a response to be stranded. Close the associated
@@ -429,79 +461,34 @@ sg_read(struct file *filp, char __user *
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				      "sg_read: count=%d\n", (int) count));
 
-	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-		old_hdr = memdup_user(buf, SZ_SG_HEADER);
-		if (IS_ERR(old_hdr))
-			return PTR_ERR(old_hdr);
-		if (old_hdr->reply_len < 0) {
-			if (count >= SZ_SG_IO_HDR) {
-				/*
-				 * This is stupid.
-				 *
-				 * We're copying the whole sg_io_hdr_t from user
-				 * space just to get the 'pack_id' field. But the
-				 * field is at different offsets for the compat
-				 * case, so we'll use "get_sg_io_hdr()" to copy
-				 * the whole thing and convert it.
-				 *
-				 * We could do something like just calculating the
-				 * offset based of 'in_compat_syscall()', but the
-				 * 'compat_sg_io_hdr' definition is in the wrong
-				 * place for that.
-				 */
-				sg_io_hdr_t *new_hdr;
-				new_hdr = kmalloc(SZ_SG_IO_HDR, GFP_KERNEL);
-				if (!new_hdr) {
-					retval = -ENOMEM;
-					goto free_old_hdr;
-				}
-				retval = get_sg_io_hdr(new_hdr, buf);
-				req_pack_id = new_hdr->pack_id;
-				kfree(new_hdr);
-				if (retval) {
-					retval = -EFAULT;
-					goto free_old_hdr;
-				}
-			}
-		} else
-			req_pack_id = old_hdr->pack_id;
-	}
+	if (sfp->force_packid)
+		retval = get_sg_io_pack_id(&req_pack_id, buf, count);
+	if (retval)
+		return retval;
+
 	srp = sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (filp->f_flags & O_NONBLOCK) {
-			retval = -EAGAIN;
-			goto free_old_hdr;
-		}
+		if (atomic_read(&sdp->detaching))
+			return -ENODEV;
+		if (filp->f_flags & O_NONBLOCK)
+			return -EAGAIN;
 		retval = wait_event_interruptible(sfp->read_wait,
 			(atomic_read(&sdp->detaching) ||
 			(srp = sg_get_rq_mark(sfp, req_pack_id))));
-		if (atomic_read(&sdp->detaching)) {
-			retval = -ENODEV;
-			goto free_old_hdr;
-		}
-		if (retval) {
+		if (atomic_read(&sdp->detaching))
+			return -ENODEV;
+		if (retval)
 			/* -ERESTARTSYS as signal hit process */
-			goto free_old_hdr;
-		}
-	}
-	if (srp->header.interface_id != '\0') {
-		retval = sg_new_read(sfp, buf, count, srp);
-		goto free_old_hdr;
+			return retval;
 	}
+	if (srp->header.interface_id != '\0')
+		return sg_new_read(sfp, buf, count, srp);
 
 	hp = &srp->header;
-	if (old_hdr == NULL) {
-		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
-		if (! old_hdr) {
-			retval = -ENOMEM;
-			goto free_old_hdr;
-		}
-	}
-	memset(old_hdr, 0, SZ_SG_HEADER);
+	old_hdr = kzalloc(SZ_SG_HEADER, GFP_KERNEL);
+	if (!old_hdr)
+		return -ENOMEM;
+
 	old_hdr->reply_len = (int) hp->timeout;
 	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
 	old_hdr->pack_id = hp->pack_id;
@@ -575,7 +562,12 @@ sg_new_read(Sg_fd * sfp, char __user *bu
 	int err = 0, err2;
 	int len;
 
-	if (count < SZ_SG_IO_HDR) {
+	if (in_compat_syscall()) {
+		if (count < sizeof(struct compat_sg_io_hdr)) {
+			err = -EINVAL;
+			goto err_out;
+		}
+	} else if (count < SZ_SG_IO_HDR) {
 		err = -EINVAL;
 		goto err_out;
 	}
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -68,6 +68,36 @@ typedef struct sg_io_hdr
     unsigned int info;          /* [o] auxiliary information */
 } sg_io_hdr_t;  /* 64 bytes long (on i386) */
 
+#if defined(__KERNEL__)
+#include <linux/compat.h>
+
+struct compat_sg_io_hdr {
+	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
+	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
+	unsigned char cmd_len;		/* [i] SCSI command length ( <= 16 bytes) */
+	unsigned char mx_sb_len;	/* [i] max length to write to sbp */
+	unsigned short iovec_count;	/* [i] 0 implies no scatter gather */
+	compat_uint_t dxfer_len;	/* [i] byte count of data transfer */
+	compat_uint_t dxferp;		/* [i], [*io] points to data transfer memory
+						or scatter gather list */
+	compat_uptr_t cmdp;		/* [i], [*i] points to command to perform */
+	compat_uptr_t sbp;		/* [i], [*o] points to sense_buffer memory */
+	compat_uint_t timeout;		/* [i] MAX_UINT->no timeout (unit: millisec) */
+	compat_uint_t flags;		/* [i] 0 -> default, see SG_FLAG... */
+	compat_int_t pack_id;		/* [i->o] unused internally (normally) */
+	compat_uptr_t usr_ptr;		/* [i->o] unused internally */
+	unsigned char status;		/* [o] scsi status */
+	unsigned char masked_status;	/* [o] shifted, masked scsi status */
+	unsigned char msg_status;	/* [o] messaging level data (optional) */
+	unsigned char sb_len_wr;	/* [o] byte count actually written to sbp */
+	unsigned short host_status;	/* [o] errors from host adapter */
+	unsigned short driver_status;	/* [o] errors from software driver */
+	compat_int_t resid;		/* [o] dxfer_len - actual_transferred */
+	compat_uint_t duration;		/* [o] time taken by cmd (unit: millisec) */
+	compat_uint_t info;		/* [o] auxiliary information */
+};
+#endif
+
 #define SG_INTERFACE_ID_ORIG 'S'
 
 /* Use negative values to flag difference from original sg_header structure */


