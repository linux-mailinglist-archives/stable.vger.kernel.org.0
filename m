Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E2A1F44E8
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388480AbgFISJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:09:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41372 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388163AbgFISF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001p4-3G; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006VvX-1Q; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Douglas Gilbert" <dgilbert@interlog.com>,
        "Hannes Reinecke" <hare@suse.de>
Date:   Tue, 09 Jun 2020 19:04:14 +0100
Message-ID: <lsq.1591725832.665317527@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 23/61] sg: O_EXCL and other lock handling
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Gilbert <dgilbert@interlog.com>

commit cc833acbee9db5ca8c6162b015b4c93863c6f821 upstream.

This addresses a problem reported by Vaughan Cao concerning
the correctness of the O_EXCL logic in the sg driver. POSIX
doesn't defined O_EXCL semantics on devices but "allow only
one open file descriptor at a time per sg device" is a rough
definition. The sg driver's semantics have been to wait
on an open() when O_NONBLOCK is not given and there are
O_EXCL headwinds. Nasty things can happen during that wait
such as the device being detached (removed). So multiple
locks are reworked in this patch making it large and hard
to break down into digestible bits.

This patch is against Linus's current git repository which
doesn't include any sg patches sent in the last few weeks.
Hence this patch touches as little as possible that it
doesn't need to and strips out most SCSI_LOG_TIMEOUT()
changes in v3 because Hannes said he was going to rework all
that stuff.

The sg3_utils package has several test programs written to
test this patch. See examples/sg_tst_excl*.cpp .

Not all the locks and flags in sg have been re-worked in
this patch, notably sg_request::done . That can wait for
a follow-up patch if this one meets with approval.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sg.c | 424 +++++++++++++++++++++++++---------------------
 1 file changed, 230 insertions(+), 194 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -51,6 +51,7 @@ static int sg_version_num = 30534;	/* 2
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/mutex.h>
+#include <linux/atomic.h>
 #include <linux/ratelimit.h>
 #include <linux/cred.h> /* for sg_check_file_access() */
 
@@ -103,18 +104,16 @@ static int scatter_elem_sz_prev = SG_SCA
 
 #define SG_SECTOR_SZ 512
 
-static int sg_add(struct device *, struct class_interface *);
-static void sg_remove(struct device *, struct class_interface *);
-
-static DEFINE_SPINLOCK(sg_open_exclusive_lock);
+static int sg_add_device(struct device *, struct class_interface *);
+static void sg_remove_device(struct device *, struct class_interface *);
 
 static DEFINE_IDR(sg_index_idr);
 static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
 							   file descriptor list for device */
 
 static struct class_interface sg_interface = {
-	.add_dev	= sg_add,
-	.remove_dev	= sg_remove,
+	.add_dev        = sg_add_device,
+	.remove_dev     = sg_remove_device,
 };
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
@@ -147,8 +146,7 @@ typedef struct sg_request {	/* SG_MAX_QU
 } Sg_request;
 
 typedef struct sg_fd {		/* holds the state of a file descriptor */
-	/* sfd_siblings is protected by sg_index_lock */
-	struct list_head sfd_siblings;
+	struct list_head sfd_siblings;  /* protected by device's sfd_lock */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
@@ -171,14 +169,15 @@ typedef struct sg_fd {		/* holds the sta
 
 typedef struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
-	wait_queue_head_t o_excl_wait;	/* queue open() when O_EXCL in use */
+	wait_queue_head_t open_wait;    /* queue open() when O_EXCL present */
+	struct mutex open_rel_lock;     /* held when in open() or release() */
 	int sg_tablesize;	/* adapter's max scatter-gather table size */
 	u32 index;		/* device index number */
-	/* sfds is protected by sg_index_lock */
 	struct list_head sfds;
-	volatile char detached;	/* 0->attached, 1->detached pending removal */
-	/* exclude protected by sg_open_exclusive_lock */
-	char exclude;		/* opened for exclusive access */
+	rwlock_t sfd_lock;      /* protect access to sfd list */
+	atomic_t detaching;     /* 0->device usable, 1->device detaching */
+	bool exclude;		/* 1->open(O_EXCL) succeeded and is active */
+	int open_cnt;		/* count of opens (perhaps < num(sfds) ) */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
 	struct gendisk *disk;
 	struct cdev * cdev;	/* char_dev [sysfs: /sys/cdev/major/sg<n>] */
@@ -209,7 +208,7 @@ static Sg_request *sg_add_request(Sg_fd
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
 static int sg_res_in_use(Sg_fd * sfp);
 static Sg_device *sg_get_dev(int dev);
-static void sg_put_dev(Sg_device *sdp);
+static void sg_device_destroy(struct kref *kref);
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
@@ -253,38 +252,43 @@ static int sg_allow_access(struct file *
 	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
 }
 
-static int get_exclude(Sg_device *sdp)
-{
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	ret = sdp->exclude;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return ret;
-}
-
-static int set_exclude(Sg_device *sdp, char val)
+static int
+open_wait(Sg_device *sdp, int flags)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&sg_open_exclusive_lock, flags);
-	sdp->exclude = val;
-	spin_unlock_irqrestore(&sg_open_exclusive_lock, flags);
-	return val;
-}
+	int retval = 0;
 
-static int sfds_list_empty(Sg_device *sdp)
-{
-	unsigned long flags;
-	int ret;
+	if (flags & O_EXCL) {
+		while (sdp->open_cnt > 0) {
+			mutex_unlock(&sdp->open_rel_lock);
+			retval = wait_event_interruptible(sdp->open_wait,
+					(atomic_read(&sdp->detaching) ||
+					 !sdp->open_cnt));
+			mutex_lock(&sdp->open_rel_lock);
+
+			if (retval) /* -ERESTARTSYS */
+				return retval;
+			if (atomic_read(&sdp->detaching))
+				return -ENODEV;
+		}
+	} else {
+		while (sdp->exclude) {
+			mutex_unlock(&sdp->open_rel_lock);
+			retval = wait_event_interruptible(sdp->open_wait,
+					(atomic_read(&sdp->detaching) ||
+					 !sdp->exclude));
+			mutex_lock(&sdp->open_rel_lock);
+
+			if (retval) /* -ERESTARTSYS */
+				return retval;
+			if (atomic_read(&sdp->detaching))
+				return -ENODEV;
+		}
+	}
 
-	read_lock_irqsave(&sg_index_lock, flags);
-	ret = list_empty(&sdp->sfds);
-	read_unlock_irqrestore(&sg_index_lock, flags);
-	return ret;
+	return retval;
 }
 
+/* Returns 0 on success, else a negated errno value */
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -293,17 +297,15 @@ sg_open(struct inode *inode, struct file
 	struct request_queue *q;
 	Sg_device *sdp;
 	Sg_fd *sfp;
-	int res;
 	int retval;
 
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
+	if ((flags & O_EXCL) && (O_RDONLY == (flags & O_ACCMODE)))
+		return -EPERM; /* Can't lock it with read only access */
 	sdp = sg_get_dev(dev);
-	if (IS_ERR(sdp)) {
-		retval = PTR_ERR(sdp);
-		sdp = NULL;
-		goto sg_put;
-	}
+	if (IS_ERR(sdp))
+		return PTR_ERR(sdp);
 
 	/* This driver's module count bumped by fops_get in <linux/fs.h> */
 	/* Prevent the device driver from vanishing while we sleep */
@@ -315,6 +317,9 @@ sg_open(struct inode *inode, struct file
 	if (retval)
 		goto sdp_put;
 
+	/* scsi_block_when_processing_errors() may block so bypass
+	 * check if O_NONBLOCK. Permits SCSI commands to be issued
+	 * during error recovery. Tread carefully. */
 	if (!((flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device))) {
 		retval = -ENXIO;
@@ -322,65 +327,65 @@ sg_open(struct inode *inode, struct file
 		goto error_out;
 	}
 
-	if (flags & O_EXCL) {
-		if (O_RDONLY == (flags & O_ACCMODE)) {
-			retval = -EPERM; /* Can't lock it with read only access */
-			goto error_out;
-		}
-		if (!sfds_list_empty(sdp) && (flags & O_NONBLOCK)) {
-			retval = -EBUSY;
-			goto error_out;
-		}
-		res = wait_event_interruptible(sdp->o_excl_wait,
-					   ((!sfds_list_empty(sdp) || get_exclude(sdp)) ? 0 : set_exclude(sdp, 1)));
-		if (res) {
-			retval = res;	/* -ERESTARTSYS because signal hit process */
-			goto error_out;
-		}
-	} else if (get_exclude(sdp)) {	/* some other fd has an exclusive lock on dev */
-		if (flags & O_NONBLOCK) {
-			retval = -EBUSY;
-			goto error_out;
-		}
-		res = wait_event_interruptible(sdp->o_excl_wait, !get_exclude(sdp));
-		if (res) {
-			retval = res;	/* -ERESTARTSYS because signal hit process */
-			goto error_out;
+	mutex_lock(&sdp->open_rel_lock);
+	if (flags & O_NONBLOCK) {
+		if (flags & O_EXCL) {
+			if (sdp->open_cnt > 0) {
+				retval = -EBUSY;
+				goto error_mutex_locked;
+			}
+		} else {
+			if (sdp->exclude) {
+				retval = -EBUSY;
+				goto error_mutex_locked;
+			}
 		}
+	} else {
+		retval = open_wait(sdp, flags);
+		if (retval) /* -ERESTARTSYS or -ENODEV */
+			goto error_mutex_locked;
 	}
-	if (sdp->detached) {
-		retval = -ENODEV;
-		goto error_out;
-	}
-	if (sfds_list_empty(sdp)) {	/* no existing opens on this device */
+
+	/* N.B. at this point we are holding the open_rel_lock */
+	if (flags & O_EXCL)
+		sdp->exclude = true;
+
+	if (sdp->open_cnt < 1) {  /* no existing opens */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
 		sdp->sg_tablesize = queue_max_segments(q);
 	}
-	if ((sfp = sg_add_sfp(sdp, dev)))
-		filp->private_data = sfp;
-	else {
-		if (flags & O_EXCL) {
-			set_exclude(sdp, 0);	/* undo if error */
-			wake_up_interruptible(&sdp->o_excl_wait);
-		}
-		retval = -ENOMEM;
-		goto error_out;
+	sfp = sg_add_sfp(sdp, dev);
+	if (IS_ERR(sfp)) {
+		retval = PTR_ERR(sfp);
+		goto out_undo;
 	}
+
+	filp->private_data = sfp;
+	sdp->open_cnt++;
+	mutex_unlock(&sdp->open_rel_lock);
+
 	retval = 0;
-error_out:
-	if (retval) {
-		scsi_autopm_put_device(sdp->device);
-sdp_put:
-		scsi_device_put(sdp->device);
-	}
 sg_put:
-	if (sdp)
-		sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	return retval;
+
+out_undo:
+	if (flags & O_EXCL) {
+		sdp->exclude = false;   /* undo if error */
+		wake_up_interruptible(&sdp->open_wait);
+	}
+error_mutex_locked:
+	mutex_unlock(&sdp->open_rel_lock);
+error_out:
+	scsi_autopm_put_device(sdp->device);
+sdp_put:
+	scsi_device_put(sdp->device);
+	goto sg_put;
 }
 
-/* Following function was formerly called 'sg_close' */
+/* Release resources associated with a successful sg_open()
+ * Returns 0 on success, else a negated errno value */
 static int
 sg_release(struct inode *inode, struct file *filp)
 {
@@ -391,11 +396,20 @@ sg_release(struct inode *inode, struct f
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
-	set_exclude(sdp, 0);
-	wake_up_interruptible(&sdp->o_excl_wait);
-
+	mutex_lock(&sdp->open_rel_lock);
 	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
+	sdp->open_cnt--;
+
+	/* possibly many open()s waiting on exlude clearing, start many;
+	 * only open(O_EXCL)s wait on 0==open_cnt so only start one */
+	if (sdp->exclude) {
+		sdp->exclude = false;
+		wake_up_interruptible_all(&sdp->open_wait);
+	} else if (0 == sdp->open_cnt) {
+		wake_up_interruptible(&sdp->open_wait);
+	}
+	mutex_unlock(&sdp->open_rel_lock);
 	return 0;
 }
 
@@ -455,7 +469,7 @@ sg_read(struct file *filp, char __user *
 	}
 	srp = sg_get_rq_mark(sfp, req_pack_id);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (sdp->detached) {
+		if (atomic_read(&sdp->detaching)) {
 			retval = -ENODEV;
 			goto free_old_hdr;
 		}
@@ -464,9 +478,9 @@ sg_read(struct file *filp, char __user *
 			goto free_old_hdr;
 		}
 		retval = wait_event_interruptible(sfp->read_wait,
-			(sdp->detached ||
+			(atomic_read(&sdp->detaching) ||
 			(srp = sg_get_rq_mark(sfp, req_pack_id))));
-		if (sdp->detached) {
+		if (atomic_read(&sdp->detaching)) {
 			retval = -ENODEV;
 			goto free_old_hdr;
 		}
@@ -613,7 +627,7 @@ sg_write(struct file *filp, const char _
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_write: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
-	if (sdp->detached)
+	if (atomic_read(&sdp->detaching))
 		return -ENODEV;
 	if (!((filp->f_flags & O_NONBLOCK) ||
 	      scsi_block_when_processing_errors(sdp->device)))
@@ -806,7 +820,7 @@ sg_common_write(Sg_fd * sfp, Sg_request
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if (sdp->detached) {
+	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio) {
 			blk_end_request_all(srp->rq, -EIO);
 			srp->rq = NULL;
@@ -871,7 +885,7 @@ sg_ioctl(struct file *filp, unsigned int
 
 	switch (cmd_in) {
 	case SG_IO:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (!scsi_block_when_processing_errors(sdp->device))
 			return -ENXIO;
@@ -882,8 +896,8 @@ sg_ioctl(struct file *filp, unsigned int
 		if (result < 0)
 			return result;
 		result = wait_event_interruptible(sfp->read_wait,
-			(srp_done(sfp, srp) || sdp->detached));
-		if (sdp->detached)
+			(srp_done(sfp, srp) || atomic_read(&sdp->detaching)));
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		write_lock_irq(&sfp->rq_list_lock);
 		if (srp->done) {
@@ -922,7 +936,7 @@ sg_ioctl(struct file *filp, unsigned int
 				sg_build_reserve(sfp, val);
 			}
 		} else {
-			if (sdp->detached)
+			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
 			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
 		}
@@ -935,7 +949,7 @@ sg_ioctl(struct file *filp, unsigned int
 		else {
 			sg_scsi_id_t __user *sg_idp = p;
 
-			if (sdp->detached)
+			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
 			__put_user((int) sdp->device->host->host_no,
 				   &sg_idp->host_no);
@@ -1077,11 +1091,11 @@ sg_ioctl(struct file *filp, unsigned int
 			return result;
 		}
 	case SG_EMULATED_HOST:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		return put_user(sdp->device->host->hostt->emulated, ip);
 	case SG_SCSI_RESET:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (filp->f_flags & O_NONBLOCK) {
 			if (scsi_host_in_recovery(sdp->device->host))
@@ -1114,7 +1128,7 @@ sg_ioctl(struct file *filp, unsigned int
 		return (scsi_reset_provider(sdp->device, val) ==
 			SUCCESS) ? 0 : -EIO;
 	case SCSI_IOCTL_SEND_COMMAND:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		if (read_only) {
 			unsigned char opcode = WRITE_6;
@@ -1136,7 +1150,7 @@ sg_ioctl(struct file *filp, unsigned int
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 	case SCSI_IOCTL_PROBE_HOST:
 	case SG_GET_TRANSFORM:
-		if (sdp->detached)
+		if (atomic_read(&sdp->detaching))
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
@@ -1210,7 +1224,7 @@ sg_poll(struct file *filp, poll_table *
 	}
 	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
-	if (sdp->detached)
+	if (atomic_read(&sdp->detaching))
 		res |= POLLHUP;
 	else if (!sfp->cmd_q) {
 		if (0 == count)
@@ -1309,7 +1323,8 @@ sg_mmap(struct file *filp, struct vm_are
 	return 0;
 }
 
-static void sg_rq_end_io_usercontext(struct work_struct *work)
+static void
+sg_rq_end_io_usercontext(struct work_struct *work)
 {
 	struct sg_request *srp = container_of(work, struct sg_request, ew.work);
 	struct sg_fd *sfp = srp->parentfp;
@@ -1322,7 +1337,8 @@ static void sg_rq_end_io_usercontext(str
  * This function is a "bottom half" handler that is called by the mid
  * level when a command is completed (or has failed).
  */
-static void sg_rq_end_io(struct request *rq, int uptodate)
+static void
+sg_rq_end_io(struct request *rq, int uptodate)
 {
 	struct sg_request *srp = rq->end_io_data;
 	Sg_device *sdp;
@@ -1340,8 +1356,8 @@ static void sg_rq_end_io(struct request
 		return;
 
 	sdp = sfp->parentdp;
-	if (unlikely(sdp->detached))
-		printk(KERN_INFO "sg_rq_end_io: device detached\n");
+	if (unlikely(atomic_read(&sdp->detaching)))
+		pr_info("%s: device detaching\n", __func__);
 
 	sense = rq->sense;
 	result = rq->errors;
@@ -1364,7 +1380,7 @@ static void sg_rq_end_io(struct request
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense("sg_cmd_done", sense,
+			__scsi_print_sense(__func__, sense,
 					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
@@ -1423,7 +1439,8 @@ static struct class *sg_sysfs_class;
 
 static int sg_sysfs_valid = 0;
 
-static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
+static Sg_device *
+sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 {
 	struct request_queue *q = scsidp->request_queue;
 	Sg_device *sdp;
@@ -1433,7 +1450,8 @@ static Sg_device *sg_alloc(struct gendis
 
 	sdp = kzalloc(sizeof(Sg_device), GFP_KERNEL);
 	if (!sdp) {
-		printk(KERN_WARNING "kmalloc Sg_device failure\n");
+		sdev_printk(KERN_WARNING, scsidp, "%s: kmalloc Sg_device "
+			    "failure\n", __func__);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1448,8 +1466,9 @@ static Sg_device *sg_alloc(struct gendis
 				    scsidp->type, SG_MAX_DEVS - 1);
 			error = -ENODEV;
 		} else {
-			printk(KERN_WARNING
-			       "idr allocation Sg_device failure: %d\n", error);
+			sdev_printk(KERN_WARNING, scsidp, "%s: idr "
+				    "allocation Sg_device failure: %d\n",
+				    __func__, error);
 		}
 		goto out_unlock;
 	}
@@ -1460,8 +1479,11 @@ static Sg_device *sg_alloc(struct gendis
 	disk->first_minor = k;
 	sdp->disk = disk;
 	sdp->device = scsidp;
+	mutex_init(&sdp->open_rel_lock);
 	INIT_LIST_HEAD(&sdp->sfds);
-	init_waitqueue_head(&sdp->o_excl_wait);
+	init_waitqueue_head(&sdp->open_wait);
+	atomic_set(&sdp->detaching, 0);
+	rwlock_init(&sdp->sfd_lock);
 	sdp->sg_tablesize = queue_max_segments(q);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
@@ -1479,7 +1501,7 @@ out_unlock:
 }
 
 static int
-sg_add(struct device *cl_dev, struct class_interface *cl_intf)
+sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	struct gendisk *disk;
@@ -1490,7 +1512,7 @@ sg_add(struct device *cl_dev, struct cla
 
 	disk = alloc_disk(1);
 	if (!disk) {
-		printk(KERN_WARNING "alloc_disk failed\n");
+		pr_warn("%s: alloc_disk failed\n", __func__);
 		return -ENOMEM;
 	}
 	disk->major = SCSI_GENERIC_MAJOR;
@@ -1498,7 +1520,7 @@ sg_add(struct device *cl_dev, struct cla
 	error = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev) {
-		printk(KERN_WARNING "cdev_alloc failed\n");
+		pr_warn("%s: cdev_alloc failed\n", __func__);
 		goto out;
 	}
 	cdev->owner = THIS_MODULE;
@@ -1506,7 +1528,7 @@ sg_add(struct device *cl_dev, struct cla
 
 	sdp = sg_alloc(disk, scsidp);
 	if (IS_ERR(sdp)) {
-		printk(KERN_WARNING "sg_alloc failed\n");
+		pr_warn("%s: sg_alloc failed\n", __func__);
 		error = PTR_ERR(sdp);
 		goto out;
 	}
@@ -1524,22 +1546,20 @@ sg_add(struct device *cl_dev, struct cla
 						      sdp->index),
 						sdp, "%s", disk->disk_name);
 		if (IS_ERR(sg_class_member)) {
-			printk(KERN_ERR "sg_add: "
-			       "device_create failed\n");
+			pr_err("%s: device_create failed\n", __func__);
 			error = PTR_ERR(sg_class_member);
 			goto cdev_add_err;
 		}
 		error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
 					  &sg_class_member->kobj, "generic");
 		if (error)
-			printk(KERN_ERR "sg_add: unable to make symlink "
-					"'generic' back to sg%d\n", sdp->index);
+			pr_err("%s: unable to make symlink 'generic' back "
+			       "to sg%d\n", __func__, sdp->index);
 	} else
-		printk(KERN_WARNING "sg_add: sg_sys Invalid\n");
+		pr_warn("%s: sg_sys Invalid\n", __func__);
 
-	sdev_printk(KERN_NOTICE, scsidp,
-		    "Attached scsi generic sg%d type %d\n", sdp->index,
-		    scsidp->type);
+	sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d "
+		    "type %d\n", sdp->index, scsidp->type);
 
 	dev_set_drvdata(cl_dev, sdp);
 
@@ -1558,7 +1578,8 @@ out:
 	return error;
 }
 
-static void sg_device_destroy(struct kref *kref)
+static void
+sg_device_destroy(struct kref *kref)
 {
 	struct sg_device *sdp = container_of(kref, struct sg_device, d_ref);
 	unsigned long flags;
@@ -1580,33 +1601,39 @@ static void sg_device_destroy(struct kre
 	kfree(sdp);
 }
 
-static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
+static void
+sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	Sg_device *sdp = dev_get_drvdata(cl_dev);
 	unsigned long iflags;
 	Sg_fd *sfp;
+	int val;
 
-	if (!sdp || sdp->detached)
+	if (!sdp)
 		return;
+	/* want sdp->detaching non-zero as soon as possible */
+	val = atomic_inc_return(&sdp->detaching);
+	if (val > 1)
+		return; /* only want to do following once per device */
 
-	SCSI_LOG_TIMEOUT(3, printk("sg_remove: %s\n", sdp->disk->disk_name));
+	SCSI_LOG_TIMEOUT(3, printk("%s: %s\n", __func__,
+			 sdp->disk->disk_name));
 
-	/* Need a write lock to set sdp->detached. */
-	write_lock_irqsave(&sg_index_lock, iflags);
-	sdp->detached = 1;
+	read_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_for_each_entry(sfp, &sdp->sfds, sfd_siblings) {
-		wake_up_interruptible(&sfp->read_wait);
+		wake_up_interruptible_all(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	wake_up_interruptible_all(&sdp->open_wait);
+	read_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
 	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
 	cdev_del(sdp->cdev);
 	sdp->cdev = NULL;
 
-	sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 }
 
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
@@ -1676,7 +1703,8 @@ exit_sg(void)
 	idr_destroy(&sg_index_idr);
 }
 
-static int sg_start_req(Sg_request *srp, unsigned char *cmd)
+static int
+sg_start_req(Sg_request *srp, unsigned char *cmd)
 {
 	int res;
 	struct request *rq;
@@ -1778,7 +1806,8 @@ static int sg_start_req(Sg_request *srp,
 	return res;
 }
 
-static int sg_finish_rem_req(Sg_request * srp)
+static int
+sg_finish_rem_req(Sg_request *srp)
 {
 	int ret = 0;
 
@@ -2115,7 +2144,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
@@ -2129,9 +2158,13 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	sfp->cmd_q = SG_DEF_COMMAND_Q;
 	sfp->keep_orphan = SG_DEF_KEEP_ORPHAN;
 	sfp->parentdp = sdp;
-	write_lock_irqsave(&sg_index_lock, iflags);
+	write_lock_irqsave(&sdp->sfd_lock, iflags);
+	if (atomic_read(&sdp->detaching)) {
+		write_unlock_irqrestore(&sdp->sfd_lock, iflags);
+		return ERR_PTR(-ENODEV);
+	}
 	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
+	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp: sfp=0x%p\n", sfp));
 	if (unlikely(sg_big_buff != def_reserved_size))
 		sg_big_buff = def_reserved_size;
@@ -2147,7 +2180,8 @@ sg_add_sfp(Sg_device * sdp, int dev)
 	return sfp;
 }
 
-static void sg_remove_sfp_usercontext(struct work_struct *work)
+static void
+sg_remove_sfp_usercontext(struct work_struct *work)
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
@@ -2171,20 +2205,20 @@ static void sg_remove_sfp_usercontext(st
 	kfree(sfp);
 
 	scsi_device_put(sdp->device);
-	sg_put_dev(sdp);
+	kref_put(&sdp->d_ref, sg_device_destroy);
 	module_put(THIS_MODULE);
 }
 
-static void sg_remove_sfp(struct kref *kref)
+static void
+sg_remove_sfp(struct kref *kref)
 {
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
 	struct sg_device *sdp = sfp->parentdp;
 	unsigned long iflags;
 
-	write_lock_irqsave(&sg_index_lock, iflags);
+	write_lock_irqsave(&sdp->sfd_lock, iflags);
 	list_del(&sfp->sfd_siblings);
-	write_unlock_irqrestore(&sg_index_lock, iflags);
-	wake_up_interruptible(&sdp->o_excl_wait);
+	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	INIT_WORK(&sfp->ew.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew.work);
@@ -2235,7 +2269,8 @@ static Sg_device *sg_lookup_dev(int dev)
 	return idr_find(&sg_index_idr, dev);
 }
 
-static Sg_device *sg_get_dev(int dev)
+static Sg_device *
+sg_get_dev(int dev)
 {
 	struct sg_device *sdp;
 	unsigned long flags;
@@ -2244,8 +2279,8 @@ static Sg_device *sg_get_dev(int dev)
 	sdp = sg_lookup_dev(dev);
 	if (!sdp)
 		sdp = ERR_PTR(-ENXIO);
-	else if (sdp->detached) {
-		/* If sdp->detached, then the refcount may already be 0, in
+	else if (atomic_read(&sdp->detaching)) {
+		/* If sdp->detaching, then the refcount may already be 0, in
 		 * which case it would be a bug to do kref_get().
 		 */
 		sdp = ERR_PTR(-ENODEV);
@@ -2256,11 +2291,6 @@ static Sg_device *sg_get_dev(int dev)
 	return sdp;
 }
 
-static void sg_put_dev(struct sg_device *sdp)
-{
-	kref_put(&sdp->d_ref, sg_device_destroy);
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
@@ -2477,8 +2507,7 @@ static int sg_proc_single_open_version(s
 
 static int sg_proc_seq_show_devhdr(struct seq_file *s, void *v)
 {
-	seq_printf(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\t"
-		   "online\n");
+	seq_puts(s, "host\tchan\tid\tlun\ttype\topens\tqdepth\tbusy\tonline\n");
 	return 0;
 }
 
@@ -2534,7 +2563,11 @@ static int sg_proc_seq_show_dev(struct s
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
+	if ((NULL == sdp) || (NULL == sdp->device) ||
+	    (atomic_read(&sdp->detaching)))
+		seq_puts(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	else {
+		scsidp = sdp->device;
 		seq_printf(s, "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, scsidp->channel,
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
@@ -2542,8 +2575,7 @@ static int sg_proc_seq_show_dev(struct s
 			      (int) scsidp->queue_depth,
 			      (int) scsidp->device_busy,
 			      (int) scsi_device_online(scsidp));
-	else
-		seq_printf(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
+	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
@@ -2562,11 +2594,12 @@ static int sg_proc_seq_show_devstrs(stru
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
+	scsidp = sdp ? sdp->device : NULL;
+	if (sdp && scsidp && (!atomic_read(&sdp->detaching)))
 		seq_printf(s, "%8.8s\t%16.16s\t%4.4s\n",
 			   scsidp->vendor, scsidp->model, scsidp->rev);
 	else
-		seq_printf(s, "<no active device>\n");
+		seq_puts(s, "<no active device>\n");
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }
@@ -2611,12 +2644,12 @@ static void sg_proc_debug_helper(struct
 				else
 					cp = "     ";
 			}
-			seq_printf(s, cp);
+			seq_puts(s, cp);
 			blen = srp->data.bufflen;
 			usg = srp->data.k_use_sg;
-			seq_printf(s, srp->done ? 
-				   ((1 == srp->done) ?  "rcv:" : "fin:")
-				   : "act:");
+			seq_puts(s, srp->done ?
+				 ((1 == srp->done) ?  "rcv:" : "fin:")
+				  : "act:");
 			seq_printf(s, " id=%d blen=%d",
 				   srp->header.pack_id, blen);
 			if (srp->done)
@@ -2632,7 +2665,7 @@ static void sg_proc_debug_helper(struct
 				   (int) srp->data.cmd_opcode);
 		}
 		if (0 == m)
-			seq_printf(s, "     No requests active\n");
+			seq_puts(s, "     No requests active\n");
 		read_unlock(&fp->rq_list_lock);
 	}
 }
@@ -2648,31 +2681,34 @@ static int sg_proc_seq_show_debug(struct
 	Sg_device *sdp;
 	unsigned long iflags;
 
-	if (it && (0 == it->index)) {
-		seq_printf(s, "max_active_device=%d(origin 1)\n",
-			   (int)it->max);
-		seq_printf(s, " def_reserved_size=%d\n", sg_big_buff);
-	}
+	if (it && (0 == it->index))
+		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n",
+			   (int)it->max, sg_big_buff);
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (sdp && !list_empty(&sdp->sfds)) {
-		struct scsi_device *scsidp = sdp->device;
-
+	if (NULL == sdp)
+		goto skip;
+	read_lock(&sdp->sfd_lock);
+	if (!list_empty(&sdp->sfds)) {
 		seq_printf(s, " >>> device=%s ", sdp->disk->disk_name);
-		if (sdp->detached)
-			seq_printf(s, "detached pending close ");
-		else
-			seq_printf
-			    (s, "scsi%d chan=%d id=%d lun=%d   em=%d",
-			     scsidp->host->host_no,
-			     scsidp->channel, scsidp->id,
-			     scsidp->lun,
-			     scsidp->host->hostt->emulated);
-		seq_printf(s, " sg_tablesize=%d excl=%d\n",
-			   sdp->sg_tablesize, get_exclude(sdp));
+		if (atomic_read(&sdp->detaching))
+			seq_puts(s, "detaching pending close ");
+		else if (sdp->device) {
+			struct scsi_device *scsidp = sdp->device;
+
+			seq_printf(s, "%d:%d:%d:%d   em=%d",
+				   scsidp->host->host_no,
+				   scsidp->channel, scsidp->id,
+				   scsidp->lun,
+				   scsidp->host->hostt->emulated);
+		}
+		seq_printf(s, " sg_tablesize=%d excl=%d open_cnt=%d\n",
+			   sdp->sg_tablesize, sdp->exclude, sdp->open_cnt);
 		sg_proc_debug_helper(s, sdp);
 	}
+	read_unlock(&sdp->sfd_lock);
+skip:
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
 }

