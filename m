Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0914279EB
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 13:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244887AbhJIMBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 08:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244888AbhJIMBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Oct 2021 08:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FBD760EE9;
        Sat,  9 Oct 2021 11:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633780784;
        bh=BJs6Eesi4ez8APKRcQuQBGToQzwLOfLf0Bfj/clV2WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4VFclNXKf9ocDbQXG9W1VCNQKKzewKjdnFnZhV9+myqGFADuUPD6o4wRO17jWXbC
         sxQeepsaayl8rXoIwvYUZ5KbwdXXdntoq/8c/BLM4KlWcoQPaHS6qu8CNSVeErc7nr
         26tWAbiKlgSBChPez5L4cfBbAxSPhRrhm2CVz90o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.288
Date:   Sat,  9 Oct 2021 13:59:36 +0200
Message-Id: <163378077519262@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163378077523426@kroah.com>
References: <163378077523426@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index fc14cb0bf5e0..823d7d08088c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 287
+SUBLEVEL = 288
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/arch/sparc/lib/iomap.c b/arch/sparc/lib/iomap.c
index c4d42a50ebc0..fa4abbaf27de 100644
--- a/arch/sparc/lib/iomap.c
+++ b/arch/sparc/lib/iomap.c
@@ -18,8 +18,10 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
+#ifdef CONFIG_PCI
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	/* nothing to do */
 }
 EXPORT_SYMBOL(pci_iounmap);
+#endif
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8e7ce9bab0db..7120da5a03f3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2077,6 +2077,25 @@ static inline u8 ata_dev_knobble(struct ata_device *dev)
 	return ((ap->cbl == ATA_CBL_SATA) && (!ata_id_is_sata(dev->id)));
 }
 
+static bool ata_dev_check_adapter(struct ata_device *dev,
+				  unsigned short vendor_id)
+{
+	struct pci_dev *pcidev = NULL;
+	struct device *parent_dev = NULL;
+
+	for (parent_dev = dev->tdev.parent; parent_dev != NULL;
+	     parent_dev = parent_dev->parent) {
+		if (dev_is_pci(parent_dev)) {
+			pcidev = to_pci_dev(parent_dev);
+			if (pcidev->vendor == vendor_id)
+				return true;
+			break;
+		}
+	}
+
+	return false;
+}
+
 static int ata_dev_config_ncq(struct ata_device *dev,
 			       char *desc, size_t desc_sz)
 {
@@ -2093,6 +2112,13 @@ static int ata_dev_config_ncq(struct ata_device *dev,
 		snprintf(desc, desc_sz, "NCQ (not used)");
 		return 0;
 	}
+
+	if (dev->horkage & ATA_HORKAGE_NO_NCQ_ON_ATI &&
+	    ata_dev_check_adapter(dev, PCI_VENDOR_ID_ATI)) {
+		snprintf(desc, desc_sz, "NCQ (not used)");
+		return 0;
+	}
+
 	if (ap->flags & ATA_FLAG_NCQ) {
 		hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
 		dev->flags |= ATA_DFLAG_NCQ;
@@ -4270,9 +4296,11 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Samsung SSD 850*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 	{ "Samsung SSD 860*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
-						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NO_NCQ_ON_ATI, },
 	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
-						ATA_HORKAGE_ZERO_AFTER_TRIM, },
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NO_NCQ_ON_ATI, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM, },
 
@@ -6520,6 +6548,8 @@ static int __init ata_parse_force_one(char **cur,
 		{ "ncq",	.horkage_off	= ATA_HORKAGE_NONCQ },
 		{ "noncqtrim",	.horkage_on	= ATA_HORKAGE_NO_NCQ_TRIM },
 		{ "ncqtrim",	.horkage_off	= ATA_HORKAGE_NO_NCQ_TRIM },
+		{ "noncqati",	.horkage_on	= ATA_HORKAGE_NO_NCQ_ON_ATI },
+		{ "ncqati",	.horkage_off	= ATA_HORKAGE_NO_NCQ_ON_ATI },
 		{ "dump_id",	.horkage_on	= ATA_HORKAGE_DUMP_ID },
 		{ "pio0",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 0) },
 		{ "pio1",	.xfer_mask	= 1 << (ATA_SHIFT_PIO + 1) },
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index c8c6afc0ab51..15c73ebe5efc 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -994,7 +994,7 @@ check_frags:
 				 * the header's copy failed, and they are
 				 * sharing a slot, send an error
 				 */
-				if (i == 0 && sharedslot)
+				if (i == 0 && !first_shinfo && sharedslot)
 					xenvif_idx_release(queue, pending_idx,
 							   XEN_NETIF_RSP_ERROR);
 				else
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9176fb1b1615..935add4d6f83 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3146,15 +3146,16 @@ static int sd_probe(struct device *dev)
 	}
 
 	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = dev;
+	sdkp->dev.parent = get_device(dev);
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
 	error = device_add(&sdkp->dev);
-	if (error)
-		goto out_free_index;
+	if (error) {
+		put_device(&sdkp->dev);
+		goto out;
+	}
 
-	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 9f9992b37924..2e4747e0aaf0 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -46,10 +46,9 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 	if (block_group >= sbi->s_groups_count) {
-		ext2_error (sb, "ext2_get_group_desc",
-			    "block_group >= groups_count - "
-			    "block_group = %d, groups_count = %lu",
-			    block_group, sbi->s_groups_count);
+		WARN(1, "block_group >= groups_count - "
+		     "block_group = %d, groups_count = %lu",
+		     block_group, sbi->s_groups_count);
 
 		return NULL;
 	}
@@ -57,10 +56,9 @@ struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 	group_desc = block_group >> EXT2_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT2_DESC_PER_BLOCK(sb) - 1);
 	if (!sbi->s_group_desc[group_desc]) {
-		ext2_error (sb, "ext2_get_group_desc",
-			    "Group descriptor not loaded - "
-			    "block_group = %d, group_desc = %lu, desc = %lu",
-			     block_group, group_desc, offset);
+		WARN(1, "Group descriptor not loaded - "
+		     "block_group = %d, group_desc = %lu, desc = %lu",
+		      block_group, group_desc, offset);
 		return NULL;
 	}
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ec49344f7555..ae4a5a1ae381 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -437,6 +437,7 @@ enum {
 	ATA_HORKAGE_NO_NCQ_LOG	= (1 << 23),	/* don't use NCQ for log read */
 	ATA_HORKAGE_NOTRIM	= (1 << 24),	/* don't use TRIM */
 	ATA_HORKAGE_MAX_SEC_1024 = (1 << 25),	/* Limit max sects to 1024 */
+	ATA_HORKAGE_NO_NCQ_ON_ATI = (1 << 27),	/* Disable NCQ on ATI chipset */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
diff --git a/include/net/sock.h b/include/net/sock.h
index 1b657a3a30b5..3671bc7b7bc1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -429,8 +429,10 @@ struct sock {
 #if IS_ENABLED(CONFIG_CGROUP_NET_PRIO)
 	__u32			sk_cgrp_prioidx;
 #endif
+	spinlock_t		sk_peer_lock;
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
+
 	long			sk_rcvtimeo;
 	long			sk_sndtimeo;
 	struct timer_list	sk_timer;
diff --git a/net/core/sock.c b/net/core/sock.c
index 82f9a7dbea6f..5e9ff8d9f9e3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1014,7 +1014,6 @@ set_rcvbuf:
 }
 EXPORT_SYMBOL(sock_setsockopt);
 
-
 static void cred_to_ucred(struct pid *pid, const struct cred *cred,
 			  struct ucred *ucred)
 {
@@ -1174,7 +1173,11 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
+
+		spin_lock(&sk->sk_peer_lock);
 		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		spin_unlock(&sk->sk_peer_lock);
+
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
@@ -1467,9 +1470,10 @@ void sk_destruct(struct sock *sk)
 		sk->sk_frag.page = NULL;
 	}
 
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	/* We do not need to acquire sk->sk_peer_lock, we are the last user. */
+	put_cred(sk->sk_peer_cred);
 	put_pid(sk->sk_peer_pid);
+
 	if (likely(sk->sk_net_refcnt))
 		put_net(sock_net(sk));
 	sk_prot_free(sk->sk_prot_creator, sk);
@@ -2442,6 +2446,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	sk->sk_peer_pid 	=	NULL;
 	sk->sk_peer_cred	=	NULL;
+	spin_lock_init(&sk->sk_peer_lock);
+
 	sk->sk_write_pending	=	0;
 	sk->sk_rcvlowat		=	1;
 	sk->sk_rcvtimeo		=	MAX_SCHEDULE_TIMEOUT;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index cb9911dcafdb..242d170991b4 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -594,20 +594,42 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 static void init_peercred(struct sock *sk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	spin_lock(&sk->sk_peer_lock);
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(task_tgid(current));
 	sk->sk_peer_cred = get_current_cred();
+	spin_unlock(&sk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	if (sk < peersk) {
+		spin_lock(&sk->sk_peer_lock);
+		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&peersk->sk_peer_lock);
+		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	}
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
 	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
+
+	spin_unlock(&sk->sk_peer_lock);
+	spin_unlock(&peersk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static int unix_listen(struct socket *sock, int backlog)
diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index 0692d99b6d8f..18c895654e76 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -278,12 +278,6 @@ nomem:
 	}
 
 	entry->ifnum = ifnum;
-
-	/* FIXME update USBDEVFS_CONNECTINFO so it tells about high speed etc */
-
-	fprintf(stderr, "%s speed\t%s\t%u\n",
-		speed(entry->speed), entry->name, entry->ifnum);
-
 	entry->next = testdevs;
 	testdevs = entry;
 	return 0;
@@ -312,6 +306,14 @@ static void *handle_testdev (void *arg)
 		return 0;
 	}
 
+	status  =  ioctl(fd, USBDEVFS_GET_SPEED, NULL);
+	if (status < 0)
+		fprintf(stderr, "USBDEVFS_GET_SPEED failed %d\n", status);
+	else
+		dev->speed = status;
+	fprintf(stderr, "%s speed\t%s\t%u\n",
+			speed(dev->speed), dev->name, dev->ifnum);
+
 restart:
 	for (i = 0; i < TEST_CASES; i++) {
 		if (dev->test != -1 && dev->test != i)
