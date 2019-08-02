Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7097F0D8
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391313AbfHBJdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391311AbfHBJdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:33:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23B642183F;
        Fri,  2 Aug 2019 09:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738397;
        bh=j48qG6dIvVozn032tp1cQKdMmVUqmTfBJGpM/YjJxRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oafE5cgTLt9fG4uB/aiPkLDgW+ELiP58yywvcMUU2OKvj50mkHfgGiBcsRzxKNw+G
         w0Trmq5EoC+7Vd9C3XDfE8NW4WdaHohCCAWM0Qn1k/anuqJSHLq0R0zBUyMBqf2nSf
         YxhvPha+EveJn1TUD1Ss1StjHP4815t6SzHuTF5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 071/158] take floppy compat ioctls to sodding floppy.c
Date:   Fri,  2 Aug 2019 11:28:12 +0200
Message-Id: <20190802092218.375369354@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 229b53c9bf4e1132a4aa6feb9632a7a1f1d08c5c ]

all other drivers recognizing those ioctls are very much *not*
biarch.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/compat_ioctl.c   |  340 -------------------------------------------------
 drivers/block/floppy.c |  328 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 328 insertions(+), 340 deletions(-)

--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -4,7 +4,6 @@
 #include <linux/cdrom.h>
 #include <linux/compat.h>
 #include <linux/elevator.h>
-#include <linux/fd.h>
 #include <linux/hdreg.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
@@ -209,318 +208,6 @@ static int compat_blkpg_ioctl(struct blo
 #define BLKBSZSET_32		_IOW(0x12, 113, int)
 #define BLKGETSIZE64_32		_IOR(0x12, 114, int)
 
-struct compat_floppy_drive_params {
-	char		cmos;
-	compat_ulong_t	max_dtr;
-	compat_ulong_t	hlt;
-	compat_ulong_t	hut;
-	compat_ulong_t	srt;
-	compat_ulong_t	spinup;
-	compat_ulong_t	spindown;
-	unsigned char	spindown_offset;
-	unsigned char	select_delay;
-	unsigned char	rps;
-	unsigned char	tracks;
-	compat_ulong_t	timeout;
-	unsigned char	interleave_sect;
-	struct floppy_max_errors max_errors;
-	char		flags;
-	char		read_track;
-	short		autodetect[8];
-	compat_int_t	checkfreq;
-	compat_int_t	native_format;
-};
-
-struct compat_floppy_drive_struct {
-	signed char	flags;
-	compat_ulong_t	spinup_date;
-	compat_ulong_t	select_date;
-	compat_ulong_t	first_read_date;
-	short		probed_format;
-	short		track;
-	short		maxblock;
-	short		maxtrack;
-	compat_int_t	generation;
-	compat_int_t	keep_data;
-	compat_int_t	fd_ref;
-	compat_int_t	fd_device;
-	compat_int_t	last_checked;
-	compat_caddr_t dmabuf;
-	compat_int_t	bufblocks;
-};
-
-struct compat_floppy_fdc_state {
-	compat_int_t	spec1;
-	compat_int_t	spec2;
-	compat_int_t	dtr;
-	unsigned char	version;
-	unsigned char	dor;
-	compat_ulong_t	address;
-	unsigned int	rawcmd:2;
-	unsigned int	reset:1;
-	unsigned int	need_configure:1;
-	unsigned int	perp_mode:2;
-	unsigned int	has_fifo:1;
-	unsigned int	driver_version;
-	unsigned char	track[4];
-};
-
-struct compat_floppy_write_errors {
-	unsigned int	write_errors;
-	compat_ulong_t	first_error_sector;
-	compat_int_t	first_error_generation;
-	compat_ulong_t	last_error_sector;
-	compat_int_t	last_error_generation;
-	compat_uint_t	badness;
-};
-
-#define FDSETPRM32 _IOW(2, 0x42, struct compat_floppy_struct)
-#define FDDEFPRM32 _IOW(2, 0x43, struct compat_floppy_struct)
-#define FDSETDRVPRM32 _IOW(2, 0x90, struct compat_floppy_drive_params)
-#define FDGETDRVPRM32 _IOR(2, 0x11, struct compat_floppy_drive_params)
-#define FDGETDRVSTAT32 _IOR(2, 0x12, struct compat_floppy_drive_struct)
-#define FDPOLLDRVSTAT32 _IOR(2, 0x13, struct compat_floppy_drive_struct)
-#define FDGETFDCSTAT32 _IOR(2, 0x15, struct compat_floppy_fdc_state)
-#define FDWERRORGET32  _IOR(2, 0x17, struct compat_floppy_write_errors)
-
-static struct {
-	unsigned int	cmd32;
-	unsigned int	cmd;
-} fd_ioctl_trans_table[] = {
-	{ FDSETPRM32, FDSETPRM },
-	{ FDDEFPRM32, FDDEFPRM },
-	{ FDGETPRM32, FDGETPRM },
-	{ FDSETDRVPRM32, FDSETDRVPRM },
-	{ FDGETDRVPRM32, FDGETDRVPRM },
-	{ FDGETDRVSTAT32, FDGETDRVSTAT },
-	{ FDPOLLDRVSTAT32, FDPOLLDRVSTAT },
-	{ FDGETFDCSTAT32, FDGETFDCSTAT },
-	{ FDWERRORGET32, FDWERRORGET }
-};
-
-#define NR_FD_IOCTL_TRANS ARRAY_SIZE(fd_ioctl_trans_table)
-
-static int compat_fd_ioctl(struct block_device *bdev, fmode_t mode,
-		unsigned int cmd, unsigned long arg)
-{
-	mm_segment_t old_fs = get_fs();
-	void *karg = NULL;
-	unsigned int kcmd = 0;
-	int i, err;
-
-	for (i = 0; i < NR_FD_IOCTL_TRANS; i++)
-		if (cmd == fd_ioctl_trans_table[i].cmd32) {
-			kcmd = fd_ioctl_trans_table[i].cmd;
-			break;
-		}
-	if (!kcmd)
-		return -EINVAL;
-
-	switch (cmd) {
-	case FDSETPRM32:
-	case FDDEFPRM32:
-	case FDGETPRM32:
-	{
-		compat_uptr_t name;
-		struct compat_floppy_struct __user *uf;
-		struct floppy_struct *f;
-
-		uf = compat_ptr(arg);
-		f = karg = kmalloc(sizeof(struct floppy_struct), GFP_KERNEL);
-		if (!karg)
-			return -ENOMEM;
-		if (cmd == FDGETPRM32)
-			break;
-		err = __get_user(f->size, &uf->size);
-		err |= __get_user(f->sect, &uf->sect);
-		err |= __get_user(f->head, &uf->head);
-		err |= __get_user(f->track, &uf->track);
-		err |= __get_user(f->stretch, &uf->stretch);
-		err |= __get_user(f->gap, &uf->gap);
-		err |= __get_user(f->rate, &uf->rate);
-		err |= __get_user(f->spec1, &uf->spec1);
-		err |= __get_user(f->fmt_gap, &uf->fmt_gap);
-		err |= __get_user(name, &uf->name);
-		f->name = compat_ptr(name);
-		if (err) {
-			err = -EFAULT;
-			goto out;
-		}
-		break;
-	}
-	case FDSETDRVPRM32:
-	case FDGETDRVPRM32:
-	{
-		struct compat_floppy_drive_params __user *uf;
-		struct floppy_drive_params *f;
-
-		uf = compat_ptr(arg);
-		f = karg = kmalloc(sizeof(struct floppy_drive_params), GFP_KERNEL);
-		if (!karg)
-			return -ENOMEM;
-		if (cmd == FDGETDRVPRM32)
-			break;
-		err = __get_user(f->cmos, &uf->cmos);
-		err |= __get_user(f->max_dtr, &uf->max_dtr);
-		err |= __get_user(f->hlt, &uf->hlt);
-		err |= __get_user(f->hut, &uf->hut);
-		err |= __get_user(f->srt, &uf->srt);
-		err |= __get_user(f->spinup, &uf->spinup);
-		err |= __get_user(f->spindown, &uf->spindown);
-		err |= __get_user(f->spindown_offset, &uf->spindown_offset);
-		err |= __get_user(f->select_delay, &uf->select_delay);
-		err |= __get_user(f->rps, &uf->rps);
-		err |= __get_user(f->tracks, &uf->tracks);
-		err |= __get_user(f->timeout, &uf->timeout);
-		err |= __get_user(f->interleave_sect, &uf->interleave_sect);
-		err |= __copy_from_user(&f->max_errors, &uf->max_errors, sizeof(f->max_errors));
-		err |= __get_user(f->flags, &uf->flags);
-		err |= __get_user(f->read_track, &uf->read_track);
-		err |= __copy_from_user(f->autodetect, uf->autodetect, sizeof(f->autodetect));
-		err |= __get_user(f->checkfreq, &uf->checkfreq);
-		err |= __get_user(f->native_format, &uf->native_format);
-		if (err) {
-			err = -EFAULT;
-			goto out;
-		}
-		break;
-	}
-	case FDGETDRVSTAT32:
-	case FDPOLLDRVSTAT32:
-		karg = kmalloc(sizeof(struct floppy_drive_struct), GFP_KERNEL);
-		if (!karg)
-			return -ENOMEM;
-		break;
-	case FDGETFDCSTAT32:
-		karg = kmalloc(sizeof(struct floppy_fdc_state), GFP_KERNEL);
-		if (!karg)
-			return -ENOMEM;
-		break;
-	case FDWERRORGET32:
-		karg = kmalloc(sizeof(struct floppy_write_errors), GFP_KERNEL);
-		if (!karg)
-			return -ENOMEM;
-		break;
-	default:
-		return -EINVAL;
-	}
-	set_fs(KERNEL_DS);
-	err = __blkdev_driver_ioctl(bdev, mode, kcmd, (unsigned long)karg);
-	set_fs(old_fs);
-	if (err)
-		goto out;
-	switch (cmd) {
-	case FDGETPRM32:
-	{
-		struct floppy_struct *f = karg;
-		struct compat_floppy_struct __user *uf = compat_ptr(arg);
-
-		err = __put_user(f->size, &uf->size);
-		err |= __put_user(f->sect, &uf->sect);
-		err |= __put_user(f->head, &uf->head);
-		err |= __put_user(f->track, &uf->track);
-		err |= __put_user(f->stretch, &uf->stretch);
-		err |= __put_user(f->gap, &uf->gap);
-		err |= __put_user(f->rate, &uf->rate);
-		err |= __put_user(f->spec1, &uf->spec1);
-		err |= __put_user(f->fmt_gap, &uf->fmt_gap);
-		err |= __put_user((u64)f->name, (compat_caddr_t __user *)&uf->name);
-		break;
-	}
-	case FDGETDRVPRM32:
-	{
-		struct compat_floppy_drive_params __user *uf;
-		struct floppy_drive_params *f = karg;
-
-		uf = compat_ptr(arg);
-		err = __put_user(f->cmos, &uf->cmos);
-		err |= __put_user(f->max_dtr, &uf->max_dtr);
-		err |= __put_user(f->hlt, &uf->hlt);
-		err |= __put_user(f->hut, &uf->hut);
-		err |= __put_user(f->srt, &uf->srt);
-		err |= __put_user(f->spinup, &uf->spinup);
-		err |= __put_user(f->spindown, &uf->spindown);
-		err |= __put_user(f->spindown_offset, &uf->spindown_offset);
-		err |= __put_user(f->select_delay, &uf->select_delay);
-		err |= __put_user(f->rps, &uf->rps);
-		err |= __put_user(f->tracks, &uf->tracks);
-		err |= __put_user(f->timeout, &uf->timeout);
-		err |= __put_user(f->interleave_sect, &uf->interleave_sect);
-		err |= __copy_to_user(&uf->max_errors, &f->max_errors, sizeof(f->max_errors));
-		err |= __put_user(f->flags, &uf->flags);
-		err |= __put_user(f->read_track, &uf->read_track);
-		err |= __copy_to_user(uf->autodetect, f->autodetect, sizeof(f->autodetect));
-		err |= __put_user(f->checkfreq, &uf->checkfreq);
-		err |= __put_user(f->native_format, &uf->native_format);
-		break;
-	}
-	case FDGETDRVSTAT32:
-	case FDPOLLDRVSTAT32:
-	{
-		struct compat_floppy_drive_struct __user *uf;
-		struct floppy_drive_struct *f = karg;
-
-		uf = compat_ptr(arg);
-		err = __put_user(f->flags, &uf->flags);
-		err |= __put_user(f->spinup_date, &uf->spinup_date);
-		err |= __put_user(f->select_date, &uf->select_date);
-		err |= __put_user(f->first_read_date, &uf->first_read_date);
-		err |= __put_user(f->probed_format, &uf->probed_format);
-		err |= __put_user(f->track, &uf->track);
-		err |= __put_user(f->maxblock, &uf->maxblock);
-		err |= __put_user(f->maxtrack, &uf->maxtrack);
-		err |= __put_user(f->generation, &uf->generation);
-		err |= __put_user(f->keep_data, &uf->keep_data);
-		err |= __put_user(f->fd_ref, &uf->fd_ref);
-		err |= __put_user(f->fd_device, &uf->fd_device);
-		err |= __put_user(f->last_checked, &uf->last_checked);
-		err |= __put_user((u64)f->dmabuf, &uf->dmabuf);
-		err |= __put_user((u64)f->bufblocks, &uf->bufblocks);
-		break;
-	}
-	case FDGETFDCSTAT32:
-	{
-		struct compat_floppy_fdc_state __user *uf;
-		struct floppy_fdc_state *f = karg;
-
-		uf = compat_ptr(arg);
-		err = __put_user(f->spec1, &uf->spec1);
-		err |= __put_user(f->spec2, &uf->spec2);
-		err |= __put_user(f->dtr, &uf->dtr);
-		err |= __put_user(f->version, &uf->version);
-		err |= __put_user(f->dor, &uf->dor);
-		err |= __put_user(f->address, &uf->address);
-		err |= __copy_to_user((char __user *)&uf->address + sizeof(uf->address),
-				   (char *)&f->address + sizeof(f->address), sizeof(int));
-		err |= __put_user(f->driver_version, &uf->driver_version);
-		err |= __copy_to_user(uf->track, f->track, sizeof(f->track));
-		break;
-	}
-	case FDWERRORGET32:
-	{
-		struct compat_floppy_write_errors __user *uf;
-		struct floppy_write_errors *f = karg;
-
-		uf = compat_ptr(arg);
-		err = __put_user(f->write_errors, &uf->write_errors);
-		err |= __put_user(f->first_error_sector, &uf->first_error_sector);
-		err |= __put_user(f->first_error_generation, &uf->first_error_generation);
-		err |= __put_user(f->last_error_sector, &uf->last_error_sector);
-		err |= __put_user(f->last_error_generation, &uf->last_error_generation);
-		err |= __put_user(f->badness, &uf->badness);
-		break;
-	}
-	default:
-		break;
-	}
-	if (err)
-		err = -EFAULT;
-
-out:
-	kfree(karg);
-	return err;
-}
-
 static int compat_blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned cmd, unsigned long arg)
 {
@@ -537,16 +224,6 @@ static int compat_blkdev_driver_ioctl(st
 	case HDIO_GET_ADDRESS:
 	case HDIO_GET_BUSSTATE:
 		return compat_hdio_ioctl(bdev, mode, cmd, arg);
-	case FDSETPRM32:
-	case FDDEFPRM32:
-	case FDGETPRM32:
-	case FDSETDRVPRM32:
-	case FDGETDRVPRM32:
-	case FDGETDRVSTAT32:
-	case FDPOLLDRVSTAT32:
-	case FDGETFDCSTAT32:
-	case FDWERRORGET32:
-		return compat_fd_ioctl(bdev, mode, cmd, arg);
 	case CDROMREADAUDIO:
 		return compat_cdrom_read_audio(bdev, mode, cmd, arg);
 	case CDROM_SEND_PACKET:
@@ -566,23 +243,6 @@ static int compat_blkdev_driver_ioctl(st
 	case HDIO_DRIVE_CMD:
 	/* 0x330 is reserved -- it used to be HDIO_GETGEO_BIG */
 	case 0x330:
-	/* 0x02 -- Floppy ioctls */
-	case FDMSGON:
-	case FDMSGOFF:
-	case FDSETEMSGTRESH:
-	case FDFLUSH:
-	case FDWERRORCLR:
-	case FDSETMAXERRS:
-	case FDGETMAXERRS:
-	case FDGETDRVTYP:
-	case FDEJECT:
-	case FDCLRPRM:
-	case FDFMTBEG:
-	case FDFMTEND:
-	case FDRESET:
-	case FDTWADDLE:
-	case FDFMTTRK:
-	case FDRAWCMD:
 	/* CDROM stuff */
 	case CDROMPAUSE:
 	case CDROMRESUME:
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -192,6 +192,7 @@ static int print_unex = 1;
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/async.h>
+#include <linux/compat.h>
 
 /*
  * PS/2 floppies have much slower step rates than regular floppies.
@@ -3569,6 +3570,330 @@ static int fd_ioctl(struct block_device
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+
+struct compat_floppy_drive_params {
+	char		cmos;
+	compat_ulong_t	max_dtr;
+	compat_ulong_t	hlt;
+	compat_ulong_t	hut;
+	compat_ulong_t	srt;
+	compat_ulong_t	spinup;
+	compat_ulong_t	spindown;
+	unsigned char	spindown_offset;
+	unsigned char	select_delay;
+	unsigned char	rps;
+	unsigned char	tracks;
+	compat_ulong_t	timeout;
+	unsigned char	interleave_sect;
+	struct floppy_max_errors max_errors;
+	char		flags;
+	char		read_track;
+	short		autodetect[8];
+	compat_int_t	checkfreq;
+	compat_int_t	native_format;
+};
+
+struct compat_floppy_drive_struct {
+	signed char	flags;
+	compat_ulong_t	spinup_date;
+	compat_ulong_t	select_date;
+	compat_ulong_t	first_read_date;
+	short		probed_format;
+	short		track;
+	short		maxblock;
+	short		maxtrack;
+	compat_int_t	generation;
+	compat_int_t	keep_data;
+	compat_int_t	fd_ref;
+	compat_int_t	fd_device;
+	compat_int_t	last_checked;
+	compat_caddr_t dmabuf;
+	compat_int_t	bufblocks;
+};
+
+struct compat_floppy_fdc_state {
+	compat_int_t	spec1;
+	compat_int_t	spec2;
+	compat_int_t	dtr;
+	unsigned char	version;
+	unsigned char	dor;
+	compat_ulong_t	address;
+	unsigned int	rawcmd:2;
+	unsigned int	reset:1;
+	unsigned int	need_configure:1;
+	unsigned int	perp_mode:2;
+	unsigned int	has_fifo:1;
+	unsigned int	driver_version;
+	unsigned char	track[4];
+};
+
+struct compat_floppy_write_errors {
+	unsigned int	write_errors;
+	compat_ulong_t	first_error_sector;
+	compat_int_t	first_error_generation;
+	compat_ulong_t	last_error_sector;
+	compat_int_t	last_error_generation;
+	compat_uint_t	badness;
+};
+
+#define FDSETPRM32 _IOW(2, 0x42, struct compat_floppy_struct)
+#define FDDEFPRM32 _IOW(2, 0x43, struct compat_floppy_struct)
+#define FDSETDRVPRM32 _IOW(2, 0x90, struct compat_floppy_drive_params)
+#define FDGETDRVPRM32 _IOR(2, 0x11, struct compat_floppy_drive_params)
+#define FDGETDRVSTAT32 _IOR(2, 0x12, struct compat_floppy_drive_struct)
+#define FDPOLLDRVSTAT32 _IOR(2, 0x13, struct compat_floppy_drive_struct)
+#define FDGETFDCSTAT32 _IOR(2, 0x15, struct compat_floppy_fdc_state)
+#define FDWERRORGET32  _IOR(2, 0x17, struct compat_floppy_write_errors)
+
+static int compat_set_geometry(struct block_device *bdev, fmode_t mode, unsigned int cmd,
+		    struct compat_floppy_struct __user *arg)
+{
+	struct floppy_struct v;
+	int drive, type;
+	int err;
+
+	BUILD_BUG_ON(offsetof(struct floppy_struct, name) !=
+		     offsetof(struct compat_floppy_struct, name));
+
+	if (!(mode & (FMODE_WRITE | FMODE_WRITE_IOCTL)))
+		return -EPERM;
+
+	memset(&v, 0, sizeof(struct floppy_struct));
+	if (copy_from_user(&v, arg, offsetof(struct floppy_struct, name)))
+		return -EFAULT;
+
+	mutex_lock(&floppy_mutex);
+	drive = (long)bdev->bd_disk->private_data;
+	type = ITYPE(UDRS->fd_device);
+	err = set_geometry(cmd == FDSETPRM32 ? FDSETPRM : FDDEFPRM,
+			&v, drive, type, bdev);
+	mutex_unlock(&floppy_mutex);
+	return err;
+}
+
+static int compat_get_prm(int drive,
+			  struct compat_floppy_struct __user *arg)
+{
+	struct compat_floppy_struct v;
+	struct floppy_struct *p;
+	int err;
+
+	memset(&v, 0, sizeof(v));
+	mutex_lock(&floppy_mutex);
+	err = get_floppy_geometry(drive, ITYPE(UDRS->fd_device), &p);
+	if (err) {
+		mutex_unlock(&floppy_mutex);
+		return err;
+	}
+	memcpy(&v, p, offsetof(struct floppy_struct, name));
+	mutex_unlock(&floppy_mutex);
+	if (copy_to_user(arg, &v, sizeof(struct compat_floppy_struct)))
+		return -EFAULT;
+	return 0;
+}
+
+static int compat_setdrvprm(int drive,
+			    struct compat_floppy_drive_params __user *arg)
+{
+	struct compat_floppy_drive_params v;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (copy_from_user(&v, arg, sizeof(struct compat_floppy_drive_params)))
+		return -EFAULT;
+	mutex_lock(&floppy_mutex);
+	UDP->cmos = v.cmos;
+	UDP->max_dtr = v.max_dtr;
+	UDP->hlt = v.hlt;
+	UDP->hut = v.hut;
+	UDP->srt = v.srt;
+	UDP->spinup = v.spinup;
+	UDP->spindown = v.spindown;
+	UDP->spindown_offset = v.spindown_offset;
+	UDP->select_delay = v.select_delay;
+	UDP->rps = v.rps;
+	UDP->tracks = v.tracks;
+	UDP->timeout = v.timeout;
+	UDP->interleave_sect = v.interleave_sect;
+	UDP->max_errors = v.max_errors;
+	UDP->flags = v.flags;
+	UDP->read_track = v.read_track;
+	memcpy(UDP->autodetect, v.autodetect, sizeof(v.autodetect));
+	UDP->checkfreq = v.checkfreq;
+	UDP->native_format = v.native_format;
+	mutex_unlock(&floppy_mutex);
+	return 0;
+}
+
+static int compat_getdrvprm(int drive,
+			    struct compat_floppy_drive_params __user *arg)
+{
+	struct compat_floppy_drive_params v;
+
+	memset(&v, 0, sizeof(struct compat_floppy_drive_params));
+	mutex_lock(&floppy_mutex);
+	v.cmos = UDP->cmos;
+	v.max_dtr = UDP->max_dtr;
+	v.hlt = UDP->hlt;
+	v.hut = UDP->hut;
+	v.srt = UDP->srt;
+	v.spinup = UDP->spinup;
+	v.spindown = UDP->spindown;
+	v.spindown_offset = UDP->spindown_offset;
+	v.select_delay = UDP->select_delay;
+	v.rps = UDP->rps;
+	v.tracks = UDP->tracks;
+	v.timeout = UDP->timeout;
+	v.interleave_sect = UDP->interleave_sect;
+	v.max_errors = UDP->max_errors;
+	v.flags = UDP->flags;
+	v.read_track = UDP->read_track;
+	memcpy(v.autodetect, UDP->autodetect, sizeof(v.autodetect));
+	v.checkfreq = UDP->checkfreq;
+	v.native_format = UDP->native_format;
+	mutex_unlock(&floppy_mutex);
+
+	if (copy_from_user(arg, &v, sizeof(struct compat_floppy_drive_params)))
+		return -EFAULT;
+	return 0;
+}
+
+static int compat_getdrvstat(int drive, bool poll,
+			    struct compat_floppy_drive_struct __user *arg)
+{
+	struct compat_floppy_drive_struct v;
+
+	memset(&v, 0, sizeof(struct compat_floppy_drive_struct));
+	mutex_lock(&floppy_mutex);
+
+	if (poll) {
+		if (lock_fdc(drive, true))
+			goto Eintr;
+		if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
+			goto Eintr;
+		process_fd_request();
+	}
+	v.spinup_date = UDRS->spinup_date;
+	v.select_date = UDRS->select_date;
+	v.first_read_date = UDRS->first_read_date;
+	v.probed_format = UDRS->probed_format;
+	v.track = UDRS->track;
+	v.maxblock = UDRS->maxblock;
+	v.maxtrack = UDRS->maxtrack;
+	v.generation = UDRS->generation;
+	v.keep_data = UDRS->keep_data;
+	v.fd_ref = UDRS->fd_ref;
+	v.fd_device = UDRS->fd_device;
+	v.last_checked = UDRS->last_checked;
+	v.dmabuf = (uintptr_t)UDRS->dmabuf;
+	v.bufblocks = UDRS->bufblocks;
+	mutex_unlock(&floppy_mutex);
+
+	if (copy_from_user(arg, &v, sizeof(struct compat_floppy_drive_struct)))
+		return -EFAULT;
+	return 0;
+Eintr:
+	mutex_unlock(&floppy_mutex);
+	return -EINTR;
+}
+
+static int compat_getfdcstat(int drive,
+			    struct compat_floppy_fdc_state __user *arg)
+{
+	struct compat_floppy_fdc_state v32;
+	struct floppy_fdc_state v;
+
+	mutex_lock(&floppy_mutex);
+	v = *UFDCS;
+	mutex_unlock(&floppy_mutex);
+
+	memset(&v32, 0, sizeof(struct compat_floppy_fdc_state));
+	v32.spec1 = v.spec1;
+	v32.spec2 = v.spec2;
+	v32.dtr = v.dtr;
+	v32.version = v.version;
+	v32.dor = v.dor;
+	v32.address = v.address;
+	v32.rawcmd = v.rawcmd;
+	v32.reset = v.reset;
+	v32.need_configure = v.need_configure;
+	v32.perp_mode = v.perp_mode;
+	v32.has_fifo = v.has_fifo;
+	v32.driver_version = v.driver_version;
+	memcpy(v32.track, v.track, 4);
+	if (copy_to_user(arg, &v32, sizeof(struct compat_floppy_fdc_state)))
+		return -EFAULT;
+	return 0;
+}
+
+static int compat_werrorget(int drive,
+			    struct compat_floppy_write_errors __user *arg)
+{
+	struct compat_floppy_write_errors v32;
+	struct floppy_write_errors v;
+
+	memset(&v32, 0, sizeof(struct compat_floppy_write_errors));
+	mutex_lock(&floppy_mutex);
+	v = *UDRWE;
+	mutex_unlock(&floppy_mutex);
+	v32.write_errors = v.write_errors;
+	v32.first_error_sector = v.first_error_sector;
+	v32.first_error_generation = v.first_error_generation;
+	v32.last_error_sector = v.last_error_sector;
+	v32.last_error_generation = v.last_error_generation;
+	v32.badness = v.badness;
+	if (copy_to_user(arg, &v32, sizeof(struct compat_floppy_write_errors)))
+		return -EFAULT;
+	return 0;
+}
+
+static int fd_compat_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
+		    unsigned long param)
+{
+	int drive = (long)bdev->bd_disk->private_data;
+	switch (cmd) {
+	case FDMSGON:
+	case FDMSGOFF:
+	case FDSETEMSGTRESH:
+	case FDFLUSH:
+	case FDWERRORCLR:
+	case FDEJECT:
+	case FDCLRPRM:
+	case FDFMTBEG:
+	case FDRESET:
+	case FDTWADDLE:
+		return fd_ioctl(bdev, mode, cmd, param);
+	case FDSETMAXERRS:
+	case FDGETMAXERRS:
+	case FDGETDRVTYP:
+	case FDFMTEND:
+	case FDFMTTRK:
+	case FDRAWCMD:
+		return fd_ioctl(bdev, mode, cmd,
+				(unsigned long)compat_ptr(param));
+	case FDSETPRM32:
+	case FDDEFPRM32:
+		return compat_set_geometry(bdev, mode, cmd, compat_ptr(param));
+	case FDGETPRM32:
+		return compat_get_prm(drive, compat_ptr(param));
+	case FDSETDRVPRM32:
+		return compat_setdrvprm(drive, compat_ptr(param));
+	case FDGETDRVPRM32:
+		return compat_getdrvprm(drive, compat_ptr(param));
+	case FDPOLLDRVSTAT32:
+		return compat_getdrvstat(drive, true, compat_ptr(param));
+	case FDGETDRVSTAT32:
+		return compat_getdrvstat(drive, false, compat_ptr(param));
+	case FDGETFDCSTAT32:
+		return compat_getfdcstat(drive, compat_ptr(param));
+	case FDWERRORGET32:
+		return compat_werrorget(drive, compat_ptr(param));
+	}
+	return -EINVAL;
+}
+#endif
+
 static void __init config_types(void)
 {
 	bool has_drive = false;
@@ -3885,6 +4210,9 @@ static const struct block_device_operati
 	.getgeo			= fd_getgeo,
 	.check_events		= floppy_check_events,
 	.revalidate_disk	= floppy_revalidate,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl		= fd_compat_ioctl,
+#endif
 };
 
 /*


