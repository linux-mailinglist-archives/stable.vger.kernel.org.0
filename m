Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758A23FFCA9
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348668AbhICJDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234897AbhICJDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B3AB61051;
        Fri,  3 Sep 2021 09:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659771;
        bh=4y7sNGcdnI2sqXR1ySVfR5f8X3RUvbzt/oJVRFat4gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUCM0usZtiLtEXXI5QdaGc/Rpt19XAMbsnCvBu6h4aD3Jczus4melXvnCXs9aSQWg
         9WTTwj0VqRLoIr7NMBccvvZrNzQIE1bbTFk55dRs0QsRaWqC8Epx6N1Ol1JVRB6+pK
         5r/UZRJjYamkWTj5QrVRfyPB5ooelhnjMR8Xh0fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.14.1
Date:   Fri,  3 Sep 2021 11:02:41 +0200
Message-Id: <163065976093214@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <16306597601523@kroah.com>
References: <16306597601523@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 61741e9d9c6e..83d1f7c1fd30 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 14
-SUBLEVEL = 0
+SUBLEVEL = 1
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 87460e0e5c72..fef79ea52e3e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4029,23 +4029,23 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	if (fdc_state[FDC(drive)].rawcmd == 1)
 		fdc_state[FDC(drive)].rawcmd = 2;
 
-	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		drive_state[drive].last_checked = 0;
-		clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags);
-		if (bdev_check_media_change(bdev))
-			floppy_revalidate(bdev->bd_disk);
-		if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
-			goto out;
-		if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
+	if (!(mode & FMODE_NDELAY)) {
+		if (mode & (FMODE_READ|FMODE_WRITE)) {
+			drive_state[drive].last_checked = 0;
+			clear_bit(FD_OPEN_SHOULD_FAIL_BIT,
+				  &drive_state[drive].flags);
+			if (bdev_check_media_change(bdev))
+				floppy_revalidate(bdev->bd_disk);
+			if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
+				goto out;
+			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
+				goto out;
+		}
+		res = -EROFS;
+		if ((mode & FMODE_WRITE) &&
+		    !test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
 			goto out;
 	}
-
-	res = -EROFS;
-
-	if ((mode & FMODE_WRITE) &&
-			!test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
-		goto out;
-
 	mutex_unlock(&open_lock);
 	mutex_unlock(&floppy_mutex);
 	return 0;
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a9855a2dd561..a552e7b48360 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -525,6 +525,7 @@ static const struct dmi_system_id btusb_needs_reset_resume_table[] = {
 #define BTUSB_HW_RESET_ACTIVE	12
 #define BTUSB_TX_WAIT_VND_EVT	13
 #define BTUSB_WAKEUP_DISABLE	14
+#define BTUSB_USE_ALT3_FOR_WBS	15
 
 struct btusb_data {
 	struct hci_dev       *hdev;
@@ -1757,16 +1758,20 @@ static void btusb_work(struct work_struct *work)
 			/* Bluetooth USB spec recommends alt 6 (63 bytes), but
 			 * many adapters do not support it.  Alt 1 appears to
 			 * work for all adapters that do not have alt 6, and
-			 * which work with WBS at all.
+			 * which work with WBS at all.  Some devices prefer
+			 * alt 3 (HCI payload >= 60 Bytes let air packet
+			 * data satisfy 60 bytes), requiring
+			 * MTU >= 3 (packets) * 25 (size) - 3 (headers) = 72
+			 * see also Core spec 5, vol 4, B 2.1.1 & Table 2.1.
 			 */
-			new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
-			/* Because mSBC frames do not need to be aligned to the
-			 * SCO packet boundary. If support the Alt 3, use the
-			 * Alt 3 for HCI payload >= 60 Bytes let air packet
-			 * data satisfy 60 bytes.
-			 */
-			if (new_alts == 1 && btusb_find_altsetting(data, 3))
+			if (btusb_find_altsetting(data, 6))
+				new_alts = 6;
+			else if (btusb_find_altsetting(data, 3) &&
+				 hdev->sco_mtu >= 72 &&
+				 test_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags))
 				new_alts = 3;
+			else
+				new_alts = 1;
 		}
 
 		if (btusb_switch_alt_setting(hdev, new_alts) < 0)
@@ -4742,6 +4747,7 @@ static int btusb_probe(struct usb_interface *intf,
 		 * (DEVICE_REMOTE_WAKEUP)
 		 */
 		set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
+		set_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags);
 	}
 
 	if (!reset)
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 632f0fcc5aa7..05bc46634b36 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1308,11 +1308,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		/* Remove this port from the port matrix of the other ports
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
-		 * And the other port's port matrix cannot be broken when the
-		 * other port is still a VLAN-aware port.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port &&
-		   !dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
+		if (dsa_is_user_port(ds, i) && i != port) {
 			if (dsa_to_port(ds, i)->bridge_dev != bridge)
 				continue;
 			if (priv->ports[i].enable)
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 0e0cd9e9e589..3639bb6dc372 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -246,6 +246,8 @@ int vt_waitactive(int n)
  *
  * XXX It should at least call into the driver, fbdev's definitely need to
  * restore their engine state. --BenH
+ *
+ * Called with the console lock held.
  */
 static int vt_kdsetmode(struct vc_data *vc, unsigned long mode)
 {
@@ -262,7 +264,6 @@ static int vt_kdsetmode(struct vc_data *vc, unsigned long mode)
 		return -EINVAL;
 	}
 
-	/* FIXME: this needs the console lock extending */
 	if (vc->vc_mode == mode)
 		return 0;
 
@@ -271,12 +272,10 @@ static int vt_kdsetmode(struct vc_data *vc, unsigned long mode)
 		return 0;
 
 	/* explicitly blank/unblank the screen if switching modes */
-	console_lock();
 	if (mode == KD_TEXT)
 		do_unblank_screen(1);
 	else
 		do_blank_screen(1);
-	console_unlock();
 
 	return 0;
 }
@@ -378,7 +377,10 @@ static int vt_k_ioctl(struct tty_struct *tty, unsigned int cmd,
 		if (!perm)
 			return -EPERM;
 
-		return vt_kdsetmode(vc, arg);
+		console_lock();
+		ret = vt_kdsetmode(vc, arg);
+		console_unlock();
+		return ret;
 
 	case KDGETMODE:
 		return put_user(vc->vc_mode, (int __user *)arg);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 70f94b75f25a..354ffd8f81af 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2137,7 +2137,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	if (IS_ERR(device)) {
 		if (PTR_ERR(device) == -ENOENT &&
-		    strcmp(device_path, "missing") == 0)
+		    device_path && strcmp(device_path, "missing") == 0)
 			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
 		else
 			ret = PTR_ERR(device);
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index a73b0376e6f3..af74599ae1cf 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -384,3 +384,47 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(fscrypt_get_symlink);
+
+/**
+ * fscrypt_symlink_getattr() - set the correct st_size for encrypted symlinks
+ * @path: the path for the encrypted symlink being queried
+ * @stat: the struct being filled with the symlink's attributes
+ *
+ * Override st_size of encrypted symlinks to be the length of the decrypted
+ * symlink target (or the no-key encoded symlink target, if the key is
+ * unavailable) rather than the length of the encrypted symlink target.  This is
+ * necessary for st_size to match the symlink target that userspace actually
+ * sees.  POSIX requires this, and some userspace programs depend on it.
+ *
+ * This requires reading the symlink target from disk if needed, setting up the
+ * inode's encryption key if possible, and then decrypting or encoding the
+ * symlink target.  This makes lstat() more heavyweight than is normally the
+ * case.  However, decrypted symlink targets will be cached in ->i_link, so
+ * usually the symlink won't have to be read and decrypted again later if/when
+ * it is actually followed, readlink() is called, or lstat() is called again.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fscrypt_symlink_getattr(const struct path *path, struct kstat *stat)
+{
+	struct dentry *dentry = path->dentry;
+	struct inode *inode = d_inode(dentry);
+	const char *link;
+	DEFINE_DELAYED_CALL(done);
+
+	/*
+	 * To get the symlink target that userspace will see (whether it's the
+	 * decrypted target or the no-key encoded target), we can just get it in
+	 * the same way the VFS does during path resolution and readlink().
+	 */
+	link = READ_ONCE(inode->i_link);
+	if (!link) {
+		link = inode->i_op->get_link(dentry, inode, &done);
+		if (IS_ERR(link))
+			return PTR_ERR(link);
+	}
+	stat->size = strlen(link);
+	do_delayed_call(&done);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fscrypt_symlink_getattr);
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index dd05af983092..69109746e6e2 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -52,10 +52,20 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	return paddr;
 }
 
+static int ext4_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	ext4_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.get_link	= ext4_encrypted_get_link,
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
+	.getattr	= ext4_encrypted_symlink_getattr,
 	.listxattr	= ext4_listxattr,
 };
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index e149c8c66a71..9c528e583c9d 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1323,9 +1323,19 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	return target;
 }
 
+static int f2fs_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	f2fs_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations f2fs_encrypted_symlink_inode_operations = {
 	.get_link	= f2fs_encrypted_get_link,
-	.getattr	= f2fs_getattr,
+	.getattr	= f2fs_encrypted_symlink_getattr,
 	.setattr	= f2fs_setattr,
 	.listxattr	= f2fs_listxattr,
 };
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 2e4e1d159969..5cfa28cd00cd 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1630,6 +1630,17 @@ static const char *ubifs_get_link(struct dentry *dentry,
 	return fscrypt_get_symlink(inode, ui->data, ui->data_len, done);
 }
 
+static int ubifs_symlink_getattr(struct user_namespace *mnt_userns,
+				 const struct path *path, struct kstat *stat,
+				 u32 request_mask, unsigned int query_flags)
+{
+	ubifs_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	if (IS_ENCRYPTED(d_inode(path->dentry)))
+		return fscrypt_symlink_getattr(path, stat);
+	return 0;
+}
+
 const struct address_space_operations ubifs_file_address_operations = {
 	.readpage       = ubifs_readpage,
 	.writepage      = ubifs_writepage,
@@ -1655,7 +1666,7 @@ const struct inode_operations ubifs_file_inode_operations = {
 const struct inode_operations ubifs_symlink_inode_operations = {
 	.get_link    = ubifs_get_link,
 	.setattr     = ubifs_setattr,
-	.getattr     = ubifs_getattr,
+	.getattr     = ubifs_symlink_getattr,
 	.listxattr   = ubifs_listxattr,
 	.update_time = ubifs_update_time,
 };
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 2ea1387bb497..b7bfd0cd4f3e 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -253,6 +253,7 @@ int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 				unsigned int max_size,
 				struct delayed_call *done);
+int fscrypt_symlink_getattr(const struct path *path, struct kstat *stat);
 static inline void fscrypt_set_ops(struct super_block *sb,
 				   const struct fscrypt_operations *s_cop)
 {
@@ -583,6 +584,12 @@ static inline const char *fscrypt_get_symlink(struct inode *inode,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline int fscrypt_symlink_getattr(const struct path *path,
+					  struct kstat *stat)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void fscrypt_set_ops(struct super_block *sb,
 				   const struct fscrypt_operations *s_cop)
 {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb008aa9..d65ce093e5a7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4012,6 +4012,10 @@ int netdev_rx_handler_register(struct net_device *dev,
 void netdev_rx_handler_unregister(struct net_device *dev);
 
 bool dev_valid_name(const char *name);
+static inline bool is_socket_ioctl_cmd(unsigned int cmd)
+{
+	return _IOC_TYPE(cmd) == SOCK_IOC_TYPE;
+}
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf *, int);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index b2be4e978ba3..2cd7b5694422 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -593,7 +593,6 @@ static void prune_tree_chunks(struct audit_tree *victim, bool tagged)
 		spin_lock(&hash_lock);
 	}
 	spin_unlock(&hash_lock);
-	put_tree(victim);
 }
 
 /*
@@ -602,6 +601,7 @@ static void prune_tree_chunks(struct audit_tree *victim, bool tagged)
 static void prune_one(struct audit_tree *victim)
 {
 	prune_tree_chunks(victim, false);
+	put_tree(victim);
 }
 
 /* trim the uncommitted chunks from tree */
diff --git a/net/socket.c b/net/socket.c
index 0b2dad3bdf7f..8808b3617dac 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1109,7 +1109,7 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 		rtnl_unlock();
 		if (!err && copy_to_user(argp, &ifc, sizeof(struct ifconf)))
 			err = -EFAULT;
-	} else {
+	} else if (is_socket_ioctl_cmd(cmd)) {
 		struct ifreq ifr;
 		bool need_copyout;
 		if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
@@ -1118,6 +1118,8 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 		if (!err && need_copyout)
 			if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
 				return -EFAULT;
+	} else {
+		err = -ENOTTY;
 	}
 	return err;
 }
@@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
 	struct ifreq ifreq;
 	u32 data32;
 
+	if (!is_socket_ioctl_cmd(cmd))
+		return -ENOTTY;
 	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
 		return -EFAULT;
 	if (get_user(data32, &u_ifreq32->ifr_data))
