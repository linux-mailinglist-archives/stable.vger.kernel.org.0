Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C7E5640E1
	for <lists+stable@lfdr.de>; Sat,  2 Jul 2022 16:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiGBO6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jul 2022 10:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiGBO5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jul 2022 10:57:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042C9DF11;
        Sat,  2 Jul 2022 07:57:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65D2960EE0;
        Sat,  2 Jul 2022 14:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE0FC34114;
        Sat,  2 Jul 2022 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656773867;
        bh=HtIFy0Bg4T7C0dbP0V4YAmzSY1/QWP/o37HGESosVrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjSSdu0Z3rC3KVSn4TDx6DCac0G5LzEqcZ4BMWvpZNkqRS4p+opMhG9u47uiAdkgu
         4q0rVoFNpDasiW+v1zoyqLXmfstbIMQEvWWM6/Revdbfi/ZhjEXZ0BCHOju9Og4TOj
         3Qp7k20GJ06nh1LjOVLbYqEGWjABNzyT3nH7cCj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.52
Date:   Sat,  2 Jul 2022 16:57:38 +0200
Message-Id: <1656773858157215@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <16567738587380@kroah.com>
References: <16567738587380@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/filesystems/idmappings.rst b/Documentation/filesystems/idmappings.rst
index 1229a75ec75d..7a879ec3b6bf 100644
--- a/Documentation/filesystems/idmappings.rst
+++ b/Documentation/filesystems/idmappings.rst
@@ -952,75 +952,3 @@ The raw userspace id that is put on disk is ``u1000`` so when the user takes
 their home directory back to their home computer where they are assigned
 ``u1000`` using the initial idmapping and mount the filesystem with the initial
 idmapping they will see all those files owned by ``u1000``.
-
-Shortcircuting
---------------
-
-Currently, the implementation of idmapped mounts enforces that the filesystem
-is mounted with the initial idmapping. The reason is simply that none of the
-filesystems that we targeted were mountable with a non-initial idmapping. But
-that might change soon enough. As we've seen above, thanks to the properties of
-idmappings the translation works for both filesystems mounted with the initial
-idmapping and filesystem with non-initial idmappings.
-
-Based on this current restriction to filesystem mounted with the initial
-idmapping two noticeable shortcuts have been taken:
-
-1. We always stash a reference to the initial user namespace in ``struct
-   vfsmount``. Idmapped mounts are thus mounts that have a non-initial user
-   namespace attached to them.
-
-   In order to support idmapped mounts this needs to be changed. Instead of
-   stashing the initial user namespace the user namespace the filesystem was
-   mounted with must be stashed. An idmapped mount is then any mount that has
-   a different user namespace attached then the filesystem was mounted with.
-   This has no user-visible consequences.
-
-2. The translation algorithms in ``mapped_fs*id()`` and ``i_*id_into_mnt()``
-   are simplified.
-
-   Let's consider ``mapped_fs*id()`` first. This function translates the
-   caller's kernel id into a kernel id in the filesystem's idmapping via
-   a mount's idmapping. The full algorithm is::
-
-    mapped_fsuid(kid):
-      /* Map the kernel id up into a userspace id in the mount's idmapping. */
-      from_kuid(mount-idmapping, kid) = uid
-
-      /* Map the userspace id down into a kernel id in the filesystem's idmapping. */
-      make_kuid(filesystem-idmapping, uid) = kuid
-
-   We know that the filesystem is always mounted with the initial idmapping as
-   we enforce this in ``mount_setattr()``. So this can be shortened to::
-
-    mapped_fsuid(kid):
-      /* Map the kernel id up into a userspace id in the mount's idmapping. */
-      from_kuid(mount-idmapping, kid) = uid
-
-      /* Map the userspace id down into a kernel id in the filesystem's idmapping. */
-      KUIDT_INIT(uid) = kuid
-
-   Similarly, for ``i_*id_into_mnt()`` which translated the filesystem's kernel
-   id into a mount's kernel id::
-
-    i_uid_into_mnt(kid):
-      /* Map the kernel id up into a userspace id in the filesystem's idmapping. */
-      from_kuid(filesystem-idmapping, kid) = uid
-
-      /* Map the userspace id down into a kernel id in the mounts's idmapping. */
-      make_kuid(mount-idmapping, uid) = kuid
-
-   Again, we know that the filesystem is always mounted with the initial
-   idmapping as we enforce this in ``mount_setattr()``. So this can be
-   shortened to::
-
-    i_uid_into_mnt(kid):
-      /* Map the kernel id up into a userspace id in the filesystem's idmapping. */
-      __kuid_val(kid) = uid
-
-      /* Map the userspace id down into a kernel id in the mounts's idmapping. */
-      make_kuid(mount-idmapping, uid) = kuid
-
-Handling filesystems mounted with non-initial idmappings requires that the
-translation functions be converted to their full form. They can still be
-shortcircuited on non-idmapped mounts. This has no user-visible consequences.
diff --git a/Makefile b/Makefile
index b3bc9d907bed..777e0a0eeccd 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 51
+SUBLEVEL = 52
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index debe8c4f7062..02d32d6422cd 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -96,7 +96,7 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 #endif /* PPC64_ELF_ABI_v1 */
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
-#ifdef CONFIG_PPC64
+#if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)
 #include <asm/paca.h>
 
 static inline void this_cpu_disable_ftrace(void)
@@ -120,11 +120,13 @@ static inline u8 this_cpu_get_ftrace_enabled(void)
 	return get_paca()->ftrace_enabled;
 }
 
+void ftrace_free_init_tramp(void);
 #else /* CONFIG_PPC64 */
 static inline void this_cpu_disable_ftrace(void) { }
 static inline void this_cpu_enable_ftrace(void) { }
 static inline void this_cpu_set_ftrace_enabled(u8 ftrace_enabled) { }
 static inline u8 this_cpu_get_ftrace_enabled(void) { return 1; }
+static inline void ftrace_free_init_tramp(void) { }
 #endif /* CONFIG_PPC64 */
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
index d89c5df4f206..660040c2d7b5 100644
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -336,9 +336,7 @@ static int setup_mcount_compiler_tramp(unsigned long tramp)
 
 	/* Is this a known long jump tramp? */
 	for (i = 0; i < NUM_FTRACE_TRAMPS; i++)
-		if (!ftrace_tramps[i])
-			break;
-		else if (ftrace_tramps[i] == tramp)
+		if (ftrace_tramps[i] == tramp)
 			return 0;
 
 	/* Is this a known plt tramp? */
@@ -881,6 +879,17 @@ void arch_ftrace_update_code(int command)
 
 extern unsigned int ftrace_tramp_text[], ftrace_tramp_init[];
 
+void ftrace_free_init_tramp(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_FTRACE_TRAMPS && ftrace_tramps[i]; i++)
+		if (ftrace_tramps[i] == (unsigned long)ftrace_tramp_init) {
+			ftrace_tramps[i] = 0;
+			return;
+		}
+}
+
 int __init ftrace_dyn_arch_init(void)
 {
 	int i;
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 05b9c3f31456..543a044560e9 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -22,6 +22,7 @@
 #include <asm/kasan.h>
 #include <asm/svm.h>
 #include <asm/mmzone.h>
+#include <asm/ftrace.h>
 
 #include <mm/mmu_decl.h>
 
@@ -314,6 +315,7 @@ void free_initmem(void)
 	mark_initmem_nx();
 	init_mem_is_free = true;
 	free_initmem_default(POISON_FREE_INITMEM);
+	ftrace_free_init_tramp();
 }
 
 /*
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9e3af56747e8..eba6485a59a3 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -948,7 +948,7 @@ asm(
 "movq	__per_cpu_offset(,%rdi,8), %rax;"
 "cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
 "setne	%al;"
-"ret;"
+ASM_RET
 ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
 ".popsection");
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 7b6f8bfef927..98daa9d200f7 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2017,6 +2017,7 @@ int bch_btree_check(struct cache_set *c)
 	if (c->root->level == 0)
 		return 0;
 
+	memset(&check_state, 0, sizeof(struct btree_check_state));
 	check_state.c = c;
 	check_state.total_threads = bch_btree_chkthread_nr();
 	check_state.key_idx = 0;
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 9699ce076b77..96a07839864b 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -947,6 +947,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		return;
 	}
 
+	memset(&state, 0, sizeof(struct bch_dirty_init_state));
 	state.c = c;
 	state.d = d;
 	state.total_threads = bch_btre_dirty_init_thread_nr();
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a59300d9e000..96b1e394a397 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2206,11 +2206,15 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID, PGID_MC);
+	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
+		       ANA_PGID_PGID, PGID_MCIPV6);
 	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID, PGID_BC);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
 
 	/* Allow manual injection via DEVCPU_QS registers, and byte swap these
 	 * registers endianness.
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index f405f42d1c1b..897da3ed2f02 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -304,7 +304,8 @@ static void rtw8821c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
 	if (channel <= 14) {
 		if (rtwdev->efuse.rfe_option == 0)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_WLG);
-		else if (rtwdev->efuse.rfe_option == 2)
+		else if (rtwdev->efuse.rfe_option == 2 ||
+			 rtwdev->efuse.rfe_option == 4)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_BTG);
 		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTDBG, BIT(6), 0x1);
 		rtw_write_rf(rtwdev, RF_PATH_A, 0x64, 0xf, 0xf);
@@ -777,6 +778,15 @@ static void rtw8821c_coex_cfg_ant_switch(struct rtw_dev *rtwdev, u8 ctrl_type,
 	if (switch_status == coex_dm->cur_switch_status)
 		return;
 
+	if (coex_rfe->wlg_at_btg) {
+		ctrl_type = COEX_SWITCH_CTRL_BY_BBSW;
+
+		if (coex_rfe->ant_switch_polarity)
+			pos_type = COEX_SWITCH_TO_WLA;
+		else
+			pos_type = COEX_SWITCH_TO_WLG_BT;
+	}
+
 	coex_dm->cur_switch_status = switch_status;
 
 	if (coex_rfe->ant_switch_diversity &&
@@ -1502,6 +1512,8 @@ static const struct rtw_intf_phy_para_table phy_para_table_8821c = {
 static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8821c, 0, 0),
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[6] = RTW_DEF_RFE(8821c, 0, 0),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
diff --git a/fs/attr.c b/fs/attr.c
index 66899b6e9bd8..dbe996b0dedf 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -61,9 +61,15 @@ static bool chgrp_ok(struct user_namespace *mnt_userns,
 		     const struct inode *inode, kgid_t gid)
 {
 	kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
-	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode)) &&
-	    (in_group_p(gid) || gid_eq(gid, inode->i_gid)))
-		return true;
+	if (uid_eq(current_fsuid(), i_uid_into_mnt(mnt_userns, inode))) {
+		kgid_t mapped_gid;
+
+		if (gid_eq(gid, inode->i_gid))
+			return true;
+		mapped_gid = mapped_kgid_fs(mnt_userns, i_user_ns(inode), gid);
+		if (in_group_p(mapped_gid))
+			return true;
+	}
 	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_CHOWN))
 		return true;
 	if (gid_eq(kgid, INVALID_GID) &&
@@ -123,12 +129,20 @@ int setattr_prepare(struct user_namespace *mnt_userns, struct dentry *dentry,
 
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
+		kgid_t mapped_gid;
+
 		if (!inode_owner_or_capable(mnt_userns, inode))
 			return -EPERM;
+
+		if (ia_valid & ATTR_GID)
+			mapped_gid = mapped_kgid_fs(mnt_userns,
+						i_user_ns(inode), attr->ia_gid);
+		else
+			mapped_gid = i_gid_into_mnt(mnt_userns, inode);
+
 		/* Also check the setgid bit! */
-               if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-                                i_gid_into_mnt(mnt_userns, inode)) &&
-                    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_p(mapped_gid) &&
+		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index d463d89f5db8..146291be6263 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -117,7 +117,7 @@ static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
 	root = path.dentry;
 
 	ret = -EINVAL;
-	if (mnt_user_ns(path.mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path.mnt)) {
 		pr_warn("File cache on idmapped mounts not supported");
 		goto error_unsupported;
 	}
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d66bbd2df191..2dd23a82e0de 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -537,7 +537,7 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 		goto out_free;
 	}
 
-	if (mnt_user_ns(path.mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path.mnt)) {
 		rc = -EINVAL;
 		printk(KERN_ERR "Mounting on idmapped mounts currently disallowed\n");
 		goto out_free;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index be2176575353..a8470a98f84d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2932,15 +2932,24 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	/* used for fixed read/write too - just read unconditionally */
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	req->imu = NULL;
+
 	if (req->opcode == IORING_OP_READ_FIXED ||
 	    req->opcode == IORING_OP_WRITE_FIXED) {
-		req->imu = NULL;
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
 		io_req_set_rsrc_node(req);
 	}
 
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	req->buf_index = READ_ONCE(sqe->buf_index);
 	return 0;
 }
 
@@ -3066,18 +3075,9 @@ static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter
 
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_mapped_ubuf *imu = req->imu;
-	u16 index, buf_index = req->buf_index;
-
-	if (likely(!imu)) {
-		if (unlikely(buf_index >= ctx->nr_user_bufs))
-			return -EFAULT;
-		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
-		imu = READ_ONCE(ctx->user_bufs[index]);
-		req->imu = imu;
-	}
-	return __io_import_fixed(req, rw, iter, imu);
+	if (WARN_ON_ONCE(!req->imu))
+		return -EFAULT;
+	return __io_import_fixed(req, rw, iter, req->imu);
 }
 
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 7e57ffdb4ce3..38f23bf981ac 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/mnt_idmapping.h>
 
 #include "smbacl.h"
 #include "smb_common.h"
@@ -274,14 +275,7 @@ static int sid_to_id(struct user_namespace *user_ns,
 		uid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		/*
-		 * Translate raw sid into kuid in the server's user
-		 * namespace.
-		 */
-		uid = make_kuid(&init_user_ns, id);
-
-		/* If this is an idmapped mount, apply the idmapping. */
-		uid = kuid_from_mnt(user_ns, uid);
+		uid = mapped_kuid_user(user_ns, &init_user_ns, KUIDT_INIT(id));
 		if (uid_valid(uid)) {
 			fattr->cf_uid = uid;
 			rc = 0;
@@ -291,14 +285,7 @@ static int sid_to_id(struct user_namespace *user_ns,
 		gid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		/*
-		 * Translate raw sid into kgid in the server's user
-		 * namespace.
-		 */
-		gid = make_kgid(&init_user_ns, id);
-
-		/* If this is an idmapped mount, apply the idmapping. */
-		gid = kgid_from_mnt(user_ns, gid);
+		gid = mapped_kgid_user(user_ns, &init_user_ns, KGIDT_INIT(id));
 		if (gid_valid(gid)) {
 			fattr->cf_gid = gid;
 			rc = 0;
diff --git a/fs/ksmbd/smbacl.h b/fs/ksmbd/smbacl.h
index 73e08cad412b..811af3309429 100644
--- a/fs/ksmbd/smbacl.h
+++ b/fs/ksmbd/smbacl.h
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
+#include <linux/mnt_idmapping.h>
 
 #include "mgmt/tree_connect.h"
 
@@ -216,7 +217,7 @@ static inline uid_t posix_acl_uid_translate(struct user_namespace *mnt_userns,
 	kuid_t kuid;
 
 	/* If this is an idmapped mount, apply the idmapping. */
-	kuid = kuid_into_mnt(mnt_userns, pace->e_uid);
+	kuid = mapped_kuid_fs(mnt_userns, &init_user_ns, pace->e_uid);
 
 	/* Translate the kuid into a userspace id ksmbd would see. */
 	return from_kuid(&init_user_ns, kuid);
@@ -228,7 +229,7 @@ static inline gid_t posix_acl_gid_translate(struct user_namespace *mnt_userns,
 	kgid_t kgid;
 
 	/* If this is an idmapped mount, apply the idmapping. */
-	kgid = kgid_into_mnt(mnt_userns, pace->e_gid);
+	kgid = mapped_kgid_fs(mnt_userns, &init_user_ns, pace->e_gid);
 
 	/* Translate the kgid into a userspace id ksmbd would see. */
 	return from_kgid(&init_user_ns, kgid);
diff --git a/fs/namespace.c b/fs/namespace.c
index b696543adab8..dc31ad6b370f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -31,6 +31,7 @@
 #include <uapi/linux/mount.h>
 #include <linux/fs_context.h>
 #include <linux/shmem_fs.h>
+#include <linux/mnt_idmapping.h>
 
 #include "pnode.h"
 #include "internal.h"
@@ -561,7 +562,7 @@ static void free_vfsmnt(struct mount *mnt)
 	struct user_namespace *mnt_userns;
 
 	mnt_userns = mnt_user_ns(&mnt->mnt);
-	if (mnt_userns != &init_user_ns)
+	if (!initial_idmapping(mnt_userns))
 		put_user_ns(mnt_userns);
 	kfree_const(mnt->mnt_devname);
 #ifdef CONFIG_SMP
@@ -965,6 +966,7 @@ static struct mount *skip_mnt_tree(struct mount *p)
 struct vfsmount *vfs_create_mount(struct fs_context *fc)
 {
 	struct mount *mnt;
+	struct user_namespace *fs_userns;
 
 	if (!fc->root)
 		return ERR_PTR(-EINVAL);
@@ -982,6 +984,10 @@ struct vfsmount *vfs_create_mount(struct fs_context *fc)
 	mnt->mnt_mountpoint	= mnt->mnt.mnt_root;
 	mnt->mnt_parent		= mnt;
 
+	fs_userns = mnt->mnt.mnt_sb->s_user_ns;
+	if (!initial_idmapping(fs_userns))
+		mnt->mnt.mnt_userns = get_user_ns(fs_userns);
+
 	lock_mount_hash();
 	list_add_tail(&mnt->mnt_instance, &mnt->mnt.mnt_sb->s_mounts);
 	unlock_mount_hash();
@@ -1072,7 +1078,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 
 	atomic_inc(&sb->s_active);
 	mnt->mnt.mnt_userns = mnt_user_ns(&old->mnt);
-	if (mnt->mnt.mnt_userns != &init_user_ns)
+	if (!initial_idmapping(mnt->mnt.mnt_userns))
 		mnt->mnt.mnt_userns = get_user_ns(mnt->mnt.mnt_userns);
 	mnt->mnt.mnt_sb = sb;
 	mnt->mnt.mnt_root = dget(root);
@@ -3927,28 +3933,32 @@ static unsigned int recalc_flags(struct mount_kattr *kattr, struct mount *mnt)
 static int can_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 {
 	struct vfsmount *m = &mnt->mnt;
+	struct user_namespace *fs_userns = m->mnt_sb->s_user_ns;
 
 	if (!kattr->mnt_userns)
 		return 0;
 
+	/*
+	 * Creating an idmapped mount with the filesystem wide idmapping
+	 * doesn't make sense so block that. We don't allow mushy semantics.
+	 */
+	if (kattr->mnt_userns == fs_userns)
+		return -EINVAL;
+
 	/*
 	 * Once a mount has been idmapped we don't allow it to change its
 	 * mapping. It makes things simpler and callers can just create
 	 * another bind-mount they can idmap if they want to.
 	 */
-	if (mnt_user_ns(m) != &init_user_ns)
+	if (is_idmapped_mnt(m))
 		return -EPERM;
 
 	/* The underlying filesystem doesn't support idmapped mounts yet. */
 	if (!(m->mnt_sb->s_type->fs_flags & FS_ALLOW_IDMAP))
 		return -EINVAL;
 
-	/* Don't yet support filesystem mountable in user namespaces. */
-	if (m->mnt_sb->s_user_ns != &init_user_ns)
-		return -EINVAL;
-
 	/* We're not controlling the superblock. */
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(fs_userns, CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* Mount has already been visible in the filesystem hierarchy. */
@@ -4002,14 +4012,27 @@ static struct mount *mount_setattr_prepare(struct mount_kattr *kattr,
 
 static void do_idmap_mount(const struct mount_kattr *kattr, struct mount *mnt)
 {
-	struct user_namespace *mnt_userns;
+	struct user_namespace *mnt_userns, *old_mnt_userns;
 
 	if (!kattr->mnt_userns)
 		return;
 
+	/*
+	 * We're the only ones able to change the mount's idmapping. So
+	 * mnt->mnt.mnt_userns is stable and we can retrieve it directly.
+	 */
+	old_mnt_userns = mnt->mnt.mnt_userns;
+
 	mnt_userns = get_user_ns(kattr->mnt_userns);
 	/* Pairs with smp_load_acquire() in mnt_user_ns(). */
 	smp_store_release(&mnt->mnt.mnt_userns, mnt_userns);
+
+	/*
+	 * If this is an idmapped filesystem drop the reference we've taken
+	 * in vfs_create_mount() before.
+	 */
+	if (!initial_idmapping(old_mnt_userns))
+		put_user_ns(old_mnt_userns);
 }
 
 static void mount_setattr_commit(struct mount_kattr *kattr,
@@ -4133,13 +4156,15 @@ static int build_mount_idmapped(const struct mount_attr *attr, size_t usize,
 	}
 
 	/*
-	 * The init_user_ns is used to indicate that a vfsmount is not idmapped.
-	 * This is simpler than just having to treat NULL as unmapped. Users
-	 * wanting to idmap a mount to init_user_ns can just use a namespace
-	 * with an identity mapping.
+	 * The initial idmapping cannot be used to create an idmapped
+	 * mount. We use the initial idmapping as an indicator of a mount
+	 * that is not idmapped. It can simply be passed into helpers that
+	 * are aware of idmapped mounts as a convenient shortcut. A user
+	 * can just create a dedicated identity mapping to achieve the same
+	 * result.
 	 */
 	mnt_userns = container_of(ns, struct user_namespace, ns);
-	if (mnt_userns == &init_user_ns) {
+	if (initial_idmapping(mnt_userns)) {
 		err = -EPERM;
 		goto out_fput;
 	}
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 9421dae22737..668c7527b17e 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -427,7 +427,7 @@ static int check_export(struct path *path, int *flags, unsigned char *uuid)
 		return -EINVAL;
 	}
 
-	if (mnt_user_ns(path->mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path->mnt)) {
 		dprintk("exp_export: export of idmapped mounts not yet supported.\n");
 		return -EINVAL;
 	}
diff --git a/fs/open.c b/fs/open.c
index e0df1536eb69..1ba1d2ab2ef0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -32,6 +32,7 @@
 #include <linux/ima.h>
 #include <linux/dnotify.h>
 #include <linux/compat.h>
+#include <linux/mnt_idmapping.h>
 
 #include "internal.h"
 
@@ -640,7 +641,7 @@ SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
 
 int chown_common(const struct path *path, uid_t user, gid_t group)
 {
-	struct user_namespace *mnt_userns;
+	struct user_namespace *mnt_userns, *fs_userns;
 	struct inode *inode = path->dentry->d_inode;
 	struct inode *delegated_inode = NULL;
 	int error;
@@ -652,8 +653,9 @@ int chown_common(const struct path *path, uid_t user, gid_t group)
 	gid = make_kgid(current_user_ns(), group);
 
 	mnt_userns = mnt_user_ns(path->mnt);
-	uid = kuid_from_mnt(mnt_userns, uid);
-	gid = kgid_from_mnt(mnt_userns, gid);
+	fs_userns = i_user_ns(inode);
+	uid = mapped_kuid_user(mnt_userns, fs_userns, uid);
+	gid = mapped_kgid_user(mnt_userns, fs_userns, gid);
 
 retry_deleg:
 	newattrs.ia_valid =  ATTR_CTIME;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 265181c110ae..7bb0a47cb615 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -873,7 +873,7 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
 		pr_err("filesystem on '%s' not supported\n", name);
 		goto out_put;
 	}
-	if (mnt_user_ns(path->mnt) != &init_user_ns) {
+	if (is_idmapped_mnt(path->mnt)) {
 		pr_err("idmapped layers are currently not supported\n");
 		goto out_put;
 	}
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index f5c25f580dd9..ceb1e3b86857 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -23,6 +23,7 @@
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 #include <linux/namei.h>
+#include <linux/mnt_idmapping.h>
 
 static struct posix_acl **acl_by_type(struct inode *inode, int type)
 {
@@ -375,7 +376,9 @@ posix_acl_permission(struct user_namespace *mnt_userns, struct inode *inode,
                                         goto check_perm;
                                 break;
                         case ACL_USER:
-				uid = kuid_into_mnt(mnt_userns, pa->e_uid);
+				uid = mapped_kuid_fs(mnt_userns,
+						     i_user_ns(inode),
+						     pa->e_uid);
 				if (uid_eq(uid, current_fsuid()))
                                         goto mask;
 				break;
@@ -388,7 +391,9 @@ posix_acl_permission(struct user_namespace *mnt_userns, struct inode *inode,
                                 }
 				break;
                         case ACL_GROUP:
-				gid = kgid_into_mnt(mnt_userns, pa->e_gid);
+				gid = mapped_kgid_fs(mnt_userns,
+						     i_user_ns(inode),
+						     pa->e_gid);
 				if (in_group_p(gid)) {
 					found = 1;
 					if ((pa->e_perm & want) == want)
@@ -735,17 +740,17 @@ static void posix_acl_fix_xattr_userns(
 		case ACL_USER:
 			uid = make_kuid(from, le32_to_cpu(entry->e_id));
 			if (from_user)
-				uid = kuid_from_mnt(mnt_userns, uid);
+				uid = mapped_kuid_user(mnt_userns, &init_user_ns, uid);
 			else
-				uid = kuid_into_mnt(mnt_userns, uid);
+				uid = mapped_kuid_fs(mnt_userns, &init_user_ns, uid);
 			entry->e_id = cpu_to_le32(from_kuid(to, uid));
 			break;
 		case ACL_GROUP:
 			gid = make_kgid(from, le32_to_cpu(entry->e_id));
 			if (from_user)
-				gid = kgid_from_mnt(mnt_userns, gid);
+				gid = mapped_kgid_user(mnt_userns, &init_user_ns, gid);
 			else
-				gid = kgid_into_mnt(mnt_userns, gid);
+				gid = mapped_kgid_fs(mnt_userns, &init_user_ns, gid);
 			entry->e_id = cpu_to_le32(from_kgid(to, gid));
 			break;
 		default:
@@ -755,9 +760,14 @@ static void posix_acl_fix_xattr_userns(
 }
 
 void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				   void *value, size_t size)
 {
 	struct user_namespace *user_ns = current_user_ns();
+
+	/* Leave ids untouched on non-idmapped mounts. */
+	if (no_idmapping(mnt_userns, i_user_ns(inode)))
+		mnt_userns = &init_user_ns;
 	if ((user_ns == &init_user_ns) && (mnt_userns == &init_user_ns))
 		return;
 	posix_acl_fix_xattr_userns(&init_user_ns, user_ns, mnt_userns, value,
@@ -765,9 +775,14 @@ void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
 }
 
 void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+				 struct inode *inode,
 				 void *value, size_t size)
 {
 	struct user_namespace *user_ns = current_user_ns();
+
+	/* Leave ids untouched on non-idmapped mounts. */
+	if (no_idmapping(mnt_userns, i_user_ns(inode)))
+		mnt_userns = &init_user_ns;
 	if ((user_ns == &init_user_ns) && (mnt_userns == &init_user_ns))
 		return;
 	posix_acl_fix_xattr_userns(user_ns, &init_user_ns, mnt_userns, value,
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 392ef5162655..49650e54d2f8 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -80,7 +80,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 			seq_puts(m, fs_infop->str);
 	}
 
-	if (mnt_user_ns(mnt) != &init_user_ns)
+	if (is_idmapped_mnt(mnt))
 		seq_puts(m, ",idmapped");
 }
 
diff --git a/fs/xattr.c b/fs/xattr.c
index 5c8c5175b385..998045165916 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -569,7 +569,8 @@ setxattr(struct user_namespace *mnt_userns, struct dentry *d,
 		}
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, kvalue, size);
+			posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
+						      kvalue, size);
 	}
 
 	error = vfs_setxattr(mnt_userns, d, kname, kvalue, size, flags);
@@ -667,7 +668,8 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
 	if (error > 0) {
 		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
 		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_to_user(mnt_userns, kvalue, error);
+			posix_acl_fix_xattr_to_user(mnt_userns, d_inode(d),
+						    kvalue, error);
 		if (size && copy_to_user(value, kvalue, error))
 			error = -EFAULT;
 	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fbc9d816882c..23523b802539 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1077,21 +1077,18 @@ xfs_attr_node_hasname(
 
 	state = xfs_da_state_alloc(args);
 	if (statep != NULL)
-		*statep = NULL;
+		*statep = state;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error) {
-		xfs_da_state_free(state);
-		return error;
-	}
+	if (error)
+		retval = error;
 
-	if (statep != NULL)
-		*statep = state;
-	else
+	if (!statep)
 		xfs_da_state_free(state);
+
 	return retval;
 }
 
@@ -1112,7 +1109,7 @@ xfs_attr_node_addname_find_attr(
 	 */
 	retval = xfs_attr_node_hasname(args, &dac->da_state);
 	if (retval != -ENOATTR && retval != -EEXIST)
-		return retval;
+		goto error;
 
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto error;
@@ -1337,7 +1334,7 @@ int xfs_attr_node_removename_setup(
 
 	error = xfs_attr_node_hasname(args, state);
 	if (error != -EEXIST)
-		return error;
+		goto out;
 	error = 0;
 
 	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 34fc6148032a..c8c15c3c3147 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -82,6 +82,7 @@ xfs_end_ioend(
 	struct iomap_ioend	*ioend)
 {
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 	unsigned int		nofs_flag;
@@ -97,18 +98,26 @@ xfs_end_ioend(
 	/*
 	 * Just clean up the in-memory structures if the fs has been shut down.
 	 */
-	if (xfs_is_shutdown(ip->i_mount)) {
+	if (xfs_is_shutdown(mp)) {
 		error = -EIO;
 		goto done;
 	}
 
 	/*
-	 * Clean up any COW blocks on an I/O error.
+	 * Clean up all COW blocks and underlying data fork delalloc blocks on
+	 * I/O error. The delalloc punch is required because this ioend was
+	 * mapped to blocks in the COW fork and the associated pages are no
+	 * longer dirty. If we don't remove delalloc blocks here, they become
+	 * stale and can corrupt free space accounting on unmount.
 	 */
 	error = blk_status_to_errno(ioend->io_bio->bi_status);
 	if (unlikely(error)) {
-		if (ioend->io_flags & IOMAP_F_SHARED)
+		if (ioend->io_flags & IOMAP_F_SHARED) {
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
+			xfs_bmap_punch_delalloc_range(ip,
+						      XFS_B_TO_FSBT(mp, offset),
+						      XFS_B_TO_FSB(mp, size));
+		}
 		goto done;
 	}
 
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index a476c7ef5d53..991fbf1eb564 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -816,7 +816,7 @@ xlog_recover_get_buf_lsn(
 	}
 
 	if (lsn != (xfs_lsn_t)-1) {
-		if (!uuid_equal(&mp->m_sb.sb_uuid, uuid))
+		if (!uuid_equal(&mp->m_sb.sb_meta_uuid, uuid))
 			goto recover_immediately;
 		return lsn;
 	}
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3f8a0713573a..a4b8caa2c601 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -482,7 +482,7 @@ xfs_extent_free_finish_item(
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&free->xefi_oinfo, free->xefi_skip_discard);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
@@ -502,7 +502,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -564,7 +564,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a4f6f034fb81..2477e301fa82 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -994,8 +994,8 @@ xfs_create(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns),
-			mapped_fsgid(mnt_userns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
+			mapped_fsgid(mnt_userns, &init_user_ns), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1148,8 +1148,8 @@ xfs_create_tmpfile(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns),
-			mapped_fsgid(mnt_userns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
+			mapped_fsgid(mnt_userns, &init_user_ns), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index c174262a074e..09a8fba84ff9 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -61,6 +61,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/ratelimit.h>
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
+#include <linux/mnt_idmapping.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 6c93c8ada6f3..b59cc9c0961c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1442,9 +1442,9 @@ xlog_cil_force_seq(
  */
 bool
 xfs_log_item_in_current_chkpt(
-	struct xfs_log_item *lip)
+	struct xfs_log_item	*lip)
 {
-	struct xfs_cil_ctx *ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
+	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
 
 	if (list_empty(&lip->li_cil))
 		return false;
@@ -1454,7 +1454,7 @@ xfs_log_item_in_current_chkpt(
 	 * first checkpoint it is written to. Hence if it is different to the
 	 * current sequence, we're in a new checkpoint.
 	 */
-	return lip->li_seq == ctx->sequence;
+	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
 }
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 170fee98c45c..e8d19916ba99 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1768,7 +1768,15 @@ static int
 xfs_remount_ro(
 	struct xfs_mount	*mp)
 {
-	int error;
+	struct xfs_icwalk	icw = {
+		.icw_flags	= XFS_ICWALK_FLAG_SYNC,
+	};
+	int			error;
+
+	/* Flush all the dirty data to disk. */
+	error = sync_filesystem(mp->m_super);
+	if (error)
+		return error;
 
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
@@ -1776,8 +1784,13 @@ xfs_remount_ro(
 	 */
 	xfs_blockgc_stop(mp);
 
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_blockgc_free_space(mp, NULL);
+	/*
+	 * Clear out all remaining COW staging extents and speculative post-EOF
+	 * preallocations so that we don't leave inodes requiring inactivation
+	 * cleanups during reclaim on a read-only mount.  We must process every
+	 * cached inode, so this requires a synchronous cache scan.
+	 */
+	error = xfs_blockgc_free_space(mp, &icw);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
@@ -1843,8 +1856,6 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index fc2c6a404647..a31d2e5d0321 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -184,8 +184,8 @@ xfs_symlink(
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns),
-			mapped_fsgid(mnt_userns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
+			mapped_fsgid(mnt_userns, &init_user_ns), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 56eba723477e..76162f046670 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -41,6 +41,7 @@
 #include <linux/stddef.h>
 #include <linux/mount.h>
 #include <linux/cred.h>
+#include <linux/mnt_idmapping.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1601,6 +1602,11 @@ struct super_block {
 	struct list_head	s_inodes_wb;	/* writeback inodes */
 } __randomize_layout;
 
+static inline struct user_namespace *i_user_ns(const struct inode *inode)
+{
+	return inode->i_sb->s_user_ns;
+}
+
 /* Helper functions so that in most cases filesystems will
  * not need to deal directly with kuid_t and kgid_t and can
  * instead deal with the raw numeric values that are stored
@@ -1608,50 +1614,22 @@ struct super_block {
  */
 static inline uid_t i_uid_read(const struct inode *inode)
 {
-	return from_kuid(inode->i_sb->s_user_ns, inode->i_uid);
+	return from_kuid(i_user_ns(inode), inode->i_uid);
 }
 
 static inline gid_t i_gid_read(const struct inode *inode)
 {
-	return from_kgid(inode->i_sb->s_user_ns, inode->i_gid);
+	return from_kgid(i_user_ns(inode), inode->i_gid);
 }
 
 static inline void i_uid_write(struct inode *inode, uid_t uid)
 {
-	inode->i_uid = make_kuid(inode->i_sb->s_user_ns, uid);
+	inode->i_uid = make_kuid(i_user_ns(inode), uid);
 }
 
 static inline void i_gid_write(struct inode *inode, gid_t gid)
 {
-	inode->i_gid = make_kgid(inode->i_sb->s_user_ns, gid);
-}
-
-/**
- * kuid_into_mnt - map a kuid down into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kuid: kuid to be mapped
- *
- * Return: @kuid mapped according to @mnt_userns.
- * If @kuid has no mapping INVALID_UID is returned.
- */
-static inline kuid_t kuid_into_mnt(struct user_namespace *mnt_userns,
-				   kuid_t kuid)
-{
-	return make_kuid(mnt_userns, __kuid_val(kuid));
-}
-
-/**
- * kgid_into_mnt - map a kgid down into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kgid: kgid to be mapped
- *
- * Return: @kgid mapped according to @mnt_userns.
- * If @kgid has no mapping INVALID_GID is returned.
- */
-static inline kgid_t kgid_into_mnt(struct user_namespace *mnt_userns,
-				   kgid_t kgid)
-{
-	return make_kgid(mnt_userns, __kgid_val(kgid));
+	inode->i_gid = make_kgid(i_user_ns(inode), gid);
 }
 
 /**
@@ -1665,7 +1643,7 @@ static inline kgid_t kgid_into_mnt(struct user_namespace *mnt_userns,
 static inline kuid_t i_uid_into_mnt(struct user_namespace *mnt_userns,
 				    const struct inode *inode)
 {
-	return kuid_into_mnt(mnt_userns, inode->i_uid);
+	return mapped_kuid_fs(mnt_userns, i_user_ns(inode), inode->i_uid);
 }
 
 /**
@@ -1679,69 +1657,7 @@ static inline kuid_t i_uid_into_mnt(struct user_namespace *mnt_userns,
 static inline kgid_t i_gid_into_mnt(struct user_namespace *mnt_userns,
 				    const struct inode *inode)
 {
-	return kgid_into_mnt(mnt_userns, inode->i_gid);
-}
-
-/**
- * kuid_from_mnt - map a kuid up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kuid: kuid to be mapped
- *
- * Return: @kuid mapped up according to @mnt_userns.
- * If @kuid has no mapping INVALID_UID is returned.
- */
-static inline kuid_t kuid_from_mnt(struct user_namespace *mnt_userns,
-				   kuid_t kuid)
-{
-	return KUIDT_INIT(from_kuid(mnt_userns, kuid));
-}
-
-/**
- * kgid_from_mnt - map a kgid up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- * @kgid: kgid to be mapped
- *
- * Return: @kgid mapped up according to @mnt_userns.
- * If @kgid has no mapping INVALID_GID is returned.
- */
-static inline kgid_t kgid_from_mnt(struct user_namespace *mnt_userns,
-				   kgid_t kgid)
-{
-	return KGIDT_INIT(from_kgid(mnt_userns, kgid));
-}
-
-/**
- * mapped_fsuid - return caller's fsuid mapped up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- *
- * Use this helper to initialize a new vfs or filesystem object based on
- * the caller's fsuid. A common example is initializing the i_uid field of
- * a newly allocated inode triggered by a creation event such as mkdir or
- * O_CREAT. Other examples include the allocation of quotas for a specific
- * user.
- *
- * Return: the caller's current fsuid mapped up according to @mnt_userns.
- */
-static inline kuid_t mapped_fsuid(struct user_namespace *mnt_userns)
-{
-	return kuid_from_mnt(mnt_userns, current_fsuid());
-}
-
-/**
- * mapped_fsgid - return caller's fsgid mapped up into a mnt_userns
- * @mnt_userns: user namespace of the relevant mount
- *
- * Use this helper to initialize a new vfs or filesystem object based on
- * the caller's fsgid. A common example is initializing the i_gid field of
- * a newly allocated inode triggered by a creation event such as mkdir or
- * O_CREAT. Other examples include the allocation of quotas for a specific
- * user.
- *
- * Return: the caller's current fsgid mapped up according to @mnt_userns.
- */
-static inline kgid_t mapped_fsgid(struct user_namespace *mnt_userns)
-{
-	return kgid_from_mnt(mnt_userns, current_fsgid());
+	return mapped_kgid_fs(mnt_userns, i_user_ns(inode), inode->i_gid);
 }
 
 /**
@@ -1755,7 +1671,7 @@ static inline kgid_t mapped_fsgid(struct user_namespace *mnt_userns)
 static inline void inode_fsuid_set(struct inode *inode,
 				   struct user_namespace *mnt_userns)
 {
-	inode->i_uid = mapped_fsuid(mnt_userns);
+	inode->i_uid = mapped_fsuid(mnt_userns, i_user_ns(inode));
 }
 
 /**
@@ -1769,7 +1685,7 @@ static inline void inode_fsuid_set(struct inode *inode,
 static inline void inode_fsgid_set(struct inode *inode,
 				   struct user_namespace *mnt_userns)
 {
-	inode->i_gid = mapped_fsgid(mnt_userns);
+	inode->i_gid = mapped_fsgid(mnt_userns, i_user_ns(inode));
 }
 
 /**
@@ -1786,10 +1702,18 @@ static inline void inode_fsgid_set(struct inode *inode,
 static inline bool fsuidgid_has_mapping(struct super_block *sb,
 					struct user_namespace *mnt_userns)
 {
-	struct user_namespace *s_user_ns = sb->s_user_ns;
+	struct user_namespace *fs_userns = sb->s_user_ns;
+	kuid_t kuid;
+	kgid_t kgid;
 
-	return kuid_has_mapping(s_user_ns, mapped_fsuid(mnt_userns)) &&
-	       kgid_has_mapping(s_user_ns, mapped_fsgid(mnt_userns));
+	kuid = mapped_fsuid(mnt_userns, fs_userns);
+	if (!uid_valid(kuid))
+		return false;
+	kgid = mapped_fsgid(mnt_userns, fs_userns);
+	if (!gid_valid(kgid))
+		return false;
+	return kuid_has_mapping(fs_userns, kuid) &&
+	       kgid_has_mapping(fs_userns, kgid);
 }
 
 extern struct timespec64 current_time(struct inode *inode);
@@ -2726,6 +2650,21 @@ static inline struct user_namespace *file_mnt_user_ns(struct file *file)
 {
 	return mnt_user_ns(file->f_path.mnt);
 }
+
+/**
+ * is_idmapped_mnt - check whether a mount is mapped
+ * @mnt: the mount to check
+ *
+ * If @mnt has an idmapping attached different from the
+ * filesystem's idmapping then @mnt is mapped.
+ *
+ * Return: true if mount is mapped, false if not.
+ */
+static inline bool is_idmapped_mnt(const struct vfsmount *mnt)
+{
+	return mnt_user_ns(mnt) != mnt->mnt_sb->s_user_ns;
+}
+
 extern long vfs_truncate(const struct path *, loff_t);
 int do_truncate(struct user_namespace *, struct dentry *, loff_t start,
 		unsigned int time_attrs, struct file *filp);
diff --git a/include/linux/mnt_idmapping.h b/include/linux/mnt_idmapping.h
new file mode 100644
index 000000000000..ee5a217de2a8
--- /dev/null
+++ b/include/linux/mnt_idmapping.h
@@ -0,0 +1,234 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MNT_IDMAPPING_H
+#define _LINUX_MNT_IDMAPPING_H
+
+#include <linux/types.h>
+#include <linux/uidgid.h>
+
+struct user_namespace;
+/*
+ * Carries the initial idmapping of 0:0:4294967295 which is an identity
+ * mapping. This means that {g,u}id 0 is mapped to {g,u}id 0, {g,u}id 1 is
+ * mapped to {g,u}id 1, [...], {g,u}id 1000 to {g,u}id 1000, [...].
+ */
+extern struct user_namespace init_user_ns;
+
+/**
+ * initial_idmapping - check whether this is the initial mapping
+ * @ns: idmapping to check
+ *
+ * Check whether this is the initial mapping, mapping 0 to 0, 1 to 1,
+ * [...], 1000 to 1000 [...].
+ *
+ * Return: true if this is the initial mapping, false if not.
+ */
+static inline bool initial_idmapping(const struct user_namespace *ns)
+{
+	return ns == &init_user_ns;
+}
+
+/**
+ * no_idmapping - check whether we can skip remapping a kuid/gid
+ * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
+ *
+ * This function can be used to check whether a remapping between two
+ * idmappings is required.
+ * An idmapped mount is a mount that has an idmapping attached to it that
+ * is different from the filsystem's idmapping and the initial idmapping.
+ * If the initial mapping is used or the idmapping of the mount and the
+ * filesystem are identical no remapping is required.
+ *
+ * Return: true if remapping can be skipped, false if not.
+ */
+static inline bool no_idmapping(const struct user_namespace *mnt_userns,
+				const struct user_namespace *fs_userns)
+{
+	return initial_idmapping(mnt_userns) || mnt_userns == fs_userns;
+}
+
+/**
+ * mapped_kuid_fs - map a filesystem kuid into a mnt_userns
+ * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
+ * @kuid : kuid to be mapped
+ *
+ * Take a @kuid and remap it from @fs_userns into @mnt_userns. Use this
+ * function when preparing a @kuid to be reported to userspace.
+ *
+ * If no_idmapping() determines that this is not an idmapped mount we can
+ * simply return @kuid unchanged.
+ * If initial_idmapping() tells us that the filesystem is not mounted with an
+ * idmapping we know the value of @kuid won't change when calling
+ * from_kuid() so we can simply retrieve the value via __kuid_val()
+ * directly.
+ *
+ * Return: @kuid mapped according to @mnt_userns.
+ * If @kuid has no mapping in either @mnt_userns or @fs_userns INVALID_UID is
+ * returned.
+ */
+static inline kuid_t mapped_kuid_fs(struct user_namespace *mnt_userns,
+				    struct user_namespace *fs_userns,
+				    kuid_t kuid)
+{
+	uid_t uid;
+
+	if (no_idmapping(mnt_userns, fs_userns))
+		return kuid;
+	if (initial_idmapping(fs_userns))
+		uid = __kuid_val(kuid);
+	else
+		uid = from_kuid(fs_userns, kuid);
+	if (uid == (uid_t)-1)
+		return INVALID_UID;
+	return make_kuid(mnt_userns, uid);
+}
+
+/**
+ * mapped_kgid_fs - map a filesystem kgid into a mnt_userns
+ * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
+ * @kgid : kgid to be mapped
+ *
+ * Take a @kgid and remap it from @fs_userns into @mnt_userns. Use this
+ * function when preparing a @kgid to be reported to userspace.
+ *
+ * If no_idmapping() determines that this is not an idmapped mount we can
+ * simply return @kgid unchanged.
+ * If initial_idmapping() tells us that the filesystem is not mounted with an
+ * idmapping we know the value of @kgid won't change when calling
+ * from_kgid() so we can simply retrieve the value via __kgid_val()
+ * directly.
+ *
+ * Return: @kgid mapped according to @mnt_userns.
+ * If @kgid has no mapping in either @mnt_userns or @fs_userns INVALID_GID is
+ * returned.
+ */
+static inline kgid_t mapped_kgid_fs(struct user_namespace *mnt_userns,
+				    struct user_namespace *fs_userns,
+				    kgid_t kgid)
+{
+	gid_t gid;
+
+	if (no_idmapping(mnt_userns, fs_userns))
+		return kgid;
+	if (initial_idmapping(fs_userns))
+		gid = __kgid_val(kgid);
+	else
+		gid = from_kgid(fs_userns, kgid);
+	if (gid == (gid_t)-1)
+		return INVALID_GID;
+	return make_kgid(mnt_userns, gid);
+}
+
+/**
+ * mapped_kuid_user - map a user kuid into a mnt_userns
+ * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
+ * @kuid : kuid to be mapped
+ *
+ * Use the idmapping of @mnt_userns to remap a @kuid into @fs_userns. Use this
+ * function when preparing a @kuid to be written to disk or inode.
+ *
+ * If no_idmapping() determines that this is not an idmapped mount we can
+ * simply return @kuid unchanged.
+ * If initial_idmapping() tells us that the filesystem is not mounted with an
+ * idmapping we know the value of @kuid won't change when calling
+ * make_kuid() so we can simply retrieve the value via KUIDT_INIT()
+ * directly.
+ *
+ * Return: @kuid mapped according to @mnt_userns.
+ * If @kuid has no mapping in either @mnt_userns or @fs_userns INVALID_UID is
+ * returned.
+ */
+static inline kuid_t mapped_kuid_user(struct user_namespace *mnt_userns,
+				      struct user_namespace *fs_userns,
+				      kuid_t kuid)
+{
+	uid_t uid;
+
+	if (no_idmapping(mnt_userns, fs_userns))
+		return kuid;
+	uid = from_kuid(mnt_userns, kuid);
+	if (uid == (uid_t)-1)
+		return INVALID_UID;
+	if (initial_idmapping(fs_userns))
+		return KUIDT_INIT(uid);
+	return make_kuid(fs_userns, uid);
+}
+
+/**
+ * mapped_kgid_user - map a user kgid into a mnt_userns
+ * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
+ * @kgid : kgid to be mapped
+ *
+ * Use the idmapping of @mnt_userns to remap a @kgid into @fs_userns. Use this
+ * function when preparing a @kgid to be written to disk or inode.
+ *
+ * If no_idmapping() determines that this is not an idmapped mount we can
+ * simply return @kgid unchanged.
+ * If initial_idmapping() tells us that the filesystem is not mounted with an
+ * idmapping we know the value of @kgid won't change when calling
+ * make_kgid() so we can simply retrieve the value via KGIDT_INIT()
+ * directly.
+ *
+ * Return: @kgid mapped according to @mnt_userns.
+ * If @kgid has no mapping in either @mnt_userns or @fs_userns INVALID_GID is
+ * returned.
+ */
+static inline kgid_t mapped_kgid_user(struct user_namespace *mnt_userns,
+				      struct user_namespace *fs_userns,
+				      kgid_t kgid)
+{
+	gid_t gid;
+
+	if (no_idmapping(mnt_userns, fs_userns))
+		return kgid;
+	gid = from_kgid(mnt_userns, kgid);
+	if (gid == (gid_t)-1)
+		return INVALID_GID;
+	if (initial_idmapping(fs_userns))
+		return KGIDT_INIT(gid);
+	return make_kgid(fs_userns, gid);
+}
+
+/**
+ * mapped_fsuid - return caller's fsuid mapped up into a mnt_userns
+ * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
+ *
+ * Use this helper to initialize a new vfs or filesystem object based on
+ * the caller's fsuid. A common example is initializing the i_uid field of
+ * a newly allocated inode triggered by a creation event such as mkdir or
+ * O_CREAT. Other examples include the allocation of quotas for a specific
+ * user.
+ *
+ * Return: the caller's current fsuid mapped up according to @mnt_userns.
+ */
+static inline kuid_t mapped_fsuid(struct user_namespace *mnt_userns,
+				  struct user_namespace *fs_userns)
+{
+	return mapped_kuid_user(mnt_userns, fs_userns, current_fsuid());
+}
+
+/**
+ * mapped_fsgid - return caller's fsgid mapped up into a mnt_userns
+ * @mnt_userns: the mount's idmapping
+ * @fs_userns: the filesystem's idmapping
+ *
+ * Use this helper to initialize a new vfs or filesystem object based on
+ * the caller's fsgid. A common example is initializing the i_gid field of
+ * a newly allocated inode triggered by a creation event such as mkdir or
+ * O_CREAT. Other examples include the allocation of quotas for a specific
+ * user.
+ *
+ * Return: the caller's current fsgid mapped up according to @mnt_userns.
+ */
+static inline kgid_t mapped_fsgid(struct user_namespace *mnt_userns,
+				  struct user_namespace *fs_userns)
+{
+	return mapped_kgid_user(mnt_userns, fs_userns, current_fsgid());
+}
+
+#endif /* _LINUX_MNT_IDMAPPING_H */
diff --git a/include/linux/posix_acl_xattr.h b/include/linux/posix_acl_xattr.h
index 060e8d203181..1766e1de6956 100644
--- a/include/linux/posix_acl_xattr.h
+++ b/include/linux/posix_acl_xattr.h
@@ -34,15 +34,19 @@ posix_acl_xattr_count(size_t size)
 
 #ifdef CONFIG_FS_POSIX_ACL
 void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				   void *value, size_t size);
 void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+				   struct inode *inode,
 				 void *value, size_t size);
 #else
 static inline void posix_acl_fix_xattr_from_user(struct user_namespace *mnt_userns,
+						 struct inode *inode,
 						 void *value, size_t size)
 {
 }
 static inline void posix_acl_fix_xattr_to_user(struct user_namespace *mnt_userns,
+					       struct inode *inode,
 					       void *value, size_t size)
 {
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 19e6b861de97..9c6f661fb436 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -509,7 +509,6 @@ void __init tick_nohz_full_setup(cpumask_var_t cpumask)
 	cpumask_copy(tick_nohz_full_mask, cpumask);
 	tick_nohz_full_running = true;
 }
-EXPORT_SYMBOL_GPL(tick_nohz_full_setup);
 
 static int tick_nohz_cpu_down(unsigned int cpu)
 {
diff --git a/security/commoncap.c b/security/commoncap.c
index 3f810d37b71b..5fc8986c3c77 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -24,6 +24,7 @@
 #include <linux/user_namespace.h>
 #include <linux/binfmts.h>
 #include <linux/personality.h>
+#include <linux/mnt_idmapping.h>
 
 /*
  * If a non-root user executes a setuid-root binary in
@@ -418,7 +419,7 @@ int cap_inode_getsecurity(struct user_namespace *mnt_userns,
 	kroot = make_kuid(fs_ns, root);
 
 	/* If this is an idmapped mount shift the kuid. */
-	kroot = kuid_into_mnt(mnt_userns, kroot);
+	kroot = mapped_kuid_fs(mnt_userns, fs_ns, kroot);
 
 	/* If the root kuid maps to a valid uid in current ns, then return
 	 * this as a nscap. */
@@ -488,6 +489,7 @@ int cap_inode_getsecurity(struct user_namespace *mnt_userns,
  * @size:	size of @ivalue
  * @task_ns:	user namespace of the caller
  * @mnt_userns:	user namespace of the mount the inode was found from
+ * @fs_userns:	user namespace of the filesystem
  *
  * If the inode has been found through an idmapped mount the user namespace of
  * the vfsmount must be passed through @mnt_userns. This function will then
@@ -497,7 +499,8 @@ int cap_inode_getsecurity(struct user_namespace *mnt_userns,
  */
 static kuid_t rootid_from_xattr(const void *value, size_t size,
 				struct user_namespace *task_ns,
-				struct user_namespace *mnt_userns)
+				struct user_namespace *mnt_userns,
+				struct user_namespace *fs_userns)
 {
 	const struct vfs_ns_cap_data *nscap = value;
 	kuid_t rootkid;
@@ -507,7 +510,7 @@ static kuid_t rootid_from_xattr(const void *value, size_t size,
 		rootid = le32_to_cpu(nscap->rootid);
 
 	rootkid = make_kuid(task_ns, rootid);
-	return kuid_from_mnt(mnt_userns, rootkid);
+	return mapped_kuid_user(mnt_userns, fs_userns, rootkid);
 }
 
 static bool validheader(size_t size, const struct vfs_cap_data *cap)
@@ -553,12 +556,12 @@ int cap_convert_nscap(struct user_namespace *mnt_userns, struct dentry *dentry,
 		return -EINVAL;
 	if (!capable_wrt_inode_uidgid(mnt_userns, inode, CAP_SETFCAP))
 		return -EPERM;
-	if (size == XATTR_CAPS_SZ_2 && (mnt_userns == &init_user_ns))
+	if (size == XATTR_CAPS_SZ_2 && (mnt_userns == fs_ns))
 		if (ns_capable(inode->i_sb->s_user_ns, CAP_SETFCAP))
 			/* user is privileged, just write the v2 */
 			return size;
 
-	rootid = rootid_from_xattr(*ivalue, size, task_ns, mnt_userns);
+	rootid = rootid_from_xattr(*ivalue, size, task_ns, mnt_userns, fs_ns);
 	if (!uid_valid(rootid))
 		return -EINVAL;
 
@@ -699,7 +702,7 @@ int get_vfs_caps_from_disk(struct user_namespace *mnt_userns,
 	/* Limit the caps to the mounter of the filesystem
 	 * or the more limited uid specified in the xattr.
 	 */
-	rootkuid = kuid_into_mnt(mnt_userns, rootkuid);
+	rootkuid = mapped_kuid_fs(mnt_userns, fs_ns, rootkuid);
 	if (!rootid_owns_currentns(rootkuid))
 		return -ENODATA;
 
