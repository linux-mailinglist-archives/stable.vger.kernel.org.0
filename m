Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2354262A0D9
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 18:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237900AbiKOR6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 12:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiKOR6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 12:58:05 -0500
Received: from frasgout11.his.huawei.com (frasgout11.his.huawei.com [14.137.139.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1C62F382;
        Tue, 15 Nov 2022 09:57:59 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout11.his.huawei.com (SkyGuard) with ESMTP id 4NBYdD5Dt0z9xqpp;
        Wed, 16 Nov 2022 01:51:12 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwCHcW7o0nNj73dpAA--.16599S5;
        Tue, 15 Nov 2022 18:57:36 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, revest@chromium.org,
        jackmanb@chromium.org, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: [RFC][PATCH 3/4] lsm: Redefine LSM_HOOK() macro to add return value flags as argument
Date:   Tue, 15 Nov 2022 18:56:51 +0100
Message-Id: <20221115175652.3836811-4-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221115175652.3836811-1-roberto.sassu@huaweicloud.com>
References: <20221115175652.3836811-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwCHcW7o0nNj73dpAA--.16599S5
X-Coremail-Antispam: 1UD129KBjvAXoWfKrW7tr45uryUJw48uFyxuFg_yoW7CF4xCo
        W2gasrZw4rKw1kAay5Kr4fJFZ2v34UZr48tr1DW34DXFs2kw1DCws3tr1UJF47XFs5G398
        AFy7A3s5CF4DX3Z8n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUO57kC6x804xWl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK
        8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr
        Wl82xGYIkIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
        xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
        z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2
        AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
        x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6r
        W5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
        v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuY
        vjxU4R6zUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQARBF1jj4V5bgAAs3
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Define four return value flags (LSM_RET_NEG, LSM_RET_ZERO, LSM_RET_ONE,
LSM_RET_GT_ONE), one for each interval of interest (< 0, = 0, = 1, > 1).

Redefine the LSM_HOOK() macro to add return value flags as argument, and
set the correct flags for each LSM hook.

Implementors of new LSM hooks should do the same as well.

Cc: stable@vger.kernel.org # 5.7.x
Fixes: 9d3fdea789c8 ("bpf: lsm: Provide attachment points for BPF LSM programs")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/bpf_lsm.h       |   2 +-
 include/linux/lsm_hook_defs.h | 779 ++++++++++++++++++++--------------
 include/linux/lsm_hooks.h     |   9 +-
 kernel/bpf/bpf_lsm.c          |   5 +-
 security/bpf/hooks.c          |   2 +-
 security/security.c           |   4 +-
 6 files changed, 466 insertions(+), 335 deletions(-)

diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 4bcf76a9bb06..650ab044e705 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -13,7 +13,7 @@
 
 #ifdef CONFIG_BPF_LSM
 
-#define LSM_HOOK(RET, DEFAULT, NAME, ...) \
+#define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) \
 	RET bpf_lsm_##NAME(__VA_ARGS__);
 #include <linux/lsm_hook_defs.h>
 #undef LSM_HOOK
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index ec119da1d89b..ed8336a5a0d8 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -18,395 +18,520 @@
  * The macro LSM_HOOK is used to define the data structures required by
  * the LSM framework using the pattern:
  *
- *	LSM_HOOK(<return_type>, <default_value>, <hook_name>, args...)
+ *	LSM_HOOK(<return_type>, <default_value>, <return_flags>, <hook_name>, args...)
  *
  * struct security_hook_heads {
- *   #define LSM_HOOK(RET, DEFAULT, NAME, ...) struct hlist_head NAME;
+ *   #define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) struct hlist_head NAME;
  *   #include <linux/lsm_hook_defs.h>
  *   #undef LSM_HOOK
  * };
  */
-LSM_HOOK(int, 0, binder_set_context_mgr, const struct cred *mgr)
-LSM_HOOK(int, 0, binder_transaction, const struct cred *from,
-	 const struct cred *to)
-LSM_HOOK(int, 0, binder_transfer_binder, const struct cred *from,
-	 const struct cred *to)
-LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
-	 const struct cred *to, struct file *file)
-LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
-	 unsigned int mode)
-LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
-LSM_HOOK(int, 0, capget, struct task_struct *target, kernel_cap_t *effective,
-	 kernel_cap_t *inheritable, kernel_cap_t *permitted)
-LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
-	 const kernel_cap_t *effective, const kernel_cap_t *inheritable,
-	 const kernel_cap_t *permitted)
-LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
-	 int cap, unsigned int opts)
-LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, struct super_block *sb)
-LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
-LSM_HOOK(int, 0, syslog, int type)
-LSM_HOOK(int, 0, settime, const struct timespec64 *ts,
-	 const struct timezone *tz)
-LSM_HOOK(int, 0, vm_enough_memory, struct mm_struct *mm, long pages)
-LSM_HOOK(int, 0, bprm_creds_for_exec, struct linux_binprm *bprm)
-LSM_HOOK(int, 0, bprm_creds_from_file, struct linux_binprm *bprm, struct file *file)
-LSM_HOOK(int, 0, bprm_check_security, struct linux_binprm *bprm)
-LSM_HOOK(void, LSM_RET_VOID, bprm_committing_creds, struct linux_binprm *bprm)
-LSM_HOOK(void, LSM_RET_VOID, bprm_committed_creds, struct linux_binprm *bprm)
-LSM_HOOK(int, 0, fs_context_dup, struct fs_context *fc,
-	 struct fs_context *src_sc)
-LSM_HOOK(int, -ENOPARAM, fs_context_parse_param, struct fs_context *fc,
+
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, binder_set_context_mgr,
+	 const struct cred *mgr)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, binder_transaction,
+	 const struct cred *from, const struct cred *to)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, binder_transfer_binder,
+	 const struct cred *from, const struct cred *to)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, binder_transfer_file,
+	 const struct cred *from, const struct cred *to, struct file *file)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, ptrace_access_check,
+	 struct task_struct *child, unsigned int mode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, ptrace_traceme,
+	 struct task_struct *parent)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, capget, struct task_struct *target,
+	 kernel_cap_t *effective, kernel_cap_t *inheritable,
+	 kernel_cap_t *permitted)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, capset, struct cred *new,
+	 const struct cred *old, const kernel_cap_t *effective,
+	 const kernel_cap_t *inheritable, const kernel_cap_t *permitted)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, capable, const struct cred *cred,
+	 struct user_namespace *ns, int cap, unsigned int opts)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, quotactl, int cmds, int type,
+	 int id, struct super_block *sb)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, quota_on, struct dentry *dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, syslog, int type)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, settime,
+	 const struct timespec64 *ts, const struct timezone *tz)
+LSM_HOOK(int, 0, LSM_RET_ZERO | LSM_RET_ONE, vm_enough_memory,
+	 struct mm_struct *mm, long pages)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, bprm_creds_for_exec,
+	 struct linux_binprm *bprm)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, bprm_creds_from_file,
+	 struct linux_binprm *bprm, struct file *file)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, bprm_check_security,
+	 struct linux_binprm *bprm)
+LSM_HOOK(void, LSM_RET_VOID, 0, bprm_committing_creds, struct linux_binprm *bprm)
+LSM_HOOK(void, LSM_RET_VOID, 0, bprm_committed_creds, struct linux_binprm *bprm)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, fs_context_dup,
+	 struct fs_context *fc, struct fs_context *src_sc)
+LSM_HOOK(int, -ENOPARAM, LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE,
+	 fs_context_parse_param, struct fs_context *fc,
 	 struct fs_parameter *param)
-LSM_HOOK(int, 0, sb_alloc_security, struct super_block *sb)
-LSM_HOOK(void, LSM_RET_VOID, sb_delete, struct super_block *sb)
-LSM_HOOK(void, LSM_RET_VOID, sb_free_security, struct super_block *sb)
-LSM_HOOK(void, LSM_RET_VOID, sb_free_mnt_opts, void *mnt_opts)
-LSM_HOOK(int, 0, sb_eat_lsm_opts, char *orig, void **mnt_opts)
-LSM_HOOK(int, 0, sb_mnt_opts_compat, struct super_block *sb, void *mnt_opts)
-LSM_HOOK(int, 0, sb_remount, struct super_block *sb, void *mnt_opts)
-LSM_HOOK(int, 0, sb_kern_mount, struct super_block *sb)
-LSM_HOOK(int, 0, sb_show_options, struct seq_file *m, struct super_block *sb)
-LSM_HOOK(int, 0, sb_statfs, struct dentry *dentry)
-LSM_HOOK(int, 0, sb_mount, const char *dev_name, const struct path *path,
-	 const char *type, unsigned long flags, void *data)
-LSM_HOOK(int, 0, sb_umount, struct vfsmount *mnt, int flags)
-LSM_HOOK(int, 0, sb_pivotroot, const struct path *old_path,
-	 const struct path *new_path)
-LSM_HOOK(int, 0, sb_set_mnt_opts, struct super_block *sb, void *mnt_opts,
-	 unsigned long kern_flags, unsigned long *set_kern_flags)
-LSM_HOOK(int, 0, sb_clone_mnt_opts, const struct super_block *oldsb,
-	 struct super_block *newsb, unsigned long kern_flags,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_alloc_security,
+	 struct super_block *sb)
+LSM_HOOK(void, LSM_RET_VOID, 0, sb_delete, struct super_block *sb)
+LSM_HOOK(void, LSM_RET_VOID, 0, sb_free_security, struct super_block *sb)
+LSM_HOOK(void, LSM_RET_VOID, 0, sb_free_mnt_opts, void *mnt_opts)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_eat_lsm_opts, char *orig,
+	 void **mnt_opts)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_mnt_opts_compat,
+	 struct super_block *sb, void *mnt_opts)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_remount, struct super_block *sb,
+	 void *mnt_opts)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_kern_mount,
+	 struct super_block *sb)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_show_options,
+	 struct seq_file *m, struct super_block *sb)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_statfs, struct dentry *dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_mount, const char *dev_name,
+	 const struct path *path, const char *type, unsigned long flags,
+	 void *data)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_umount, struct vfsmount *mnt,
+	 int flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_pivotroot,
+	 const struct path *old_path, const struct path *new_path)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_set_mnt_opts,
+	 struct super_block *sb, void *mnt_opts, unsigned long kern_flags,
 	 unsigned long *set_kern_flags)
-LSM_HOOK(int, 0, move_mount, const struct path *from_path,
-	 const struct path *to_path)
-LSM_HOOK(int, -EOPNOTSUPP, dentry_init_security, struct dentry *dentry,
-	 int mode, const struct qstr *name, const char **xattr_name,
-	 void **ctx, u32 *ctxlen)
-LSM_HOOK(int, 0, dentry_create_files_as, struct dentry *dentry, int mode,
-	 struct qstr *name, const struct cred *old, struct cred *new)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sb_clone_mnt_opts,
+	 const struct super_block *oldsb, struct super_block *newsb,
+	 unsigned long kern_flags, unsigned long *set_kern_flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, move_mount,
+	 const struct path *from_path, const struct path *to_path)
+LSM_HOOK(int, -EOPNOTSUPP, LSM_RET_NEG | LSM_RET_ZERO, dentry_init_security,
+	 struct dentry *dentry, int mode, const struct qstr *name,
+	 const char **xattr_name, void **ctx, u32 *ctxlen)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, dentry_create_files_as,
+	 struct dentry *dentry, int mode, struct qstr *name,
+	 const struct cred *old, struct cred *new)
 
 #ifdef CONFIG_SECURITY_PATH
-LSM_HOOK(int, 0, path_unlink, const struct path *dir, struct dentry *dentry)
-LSM_HOOK(int, 0, path_mkdir, const struct path *dir, struct dentry *dentry,
-	 umode_t mode)
-LSM_HOOK(int, 0, path_rmdir, const struct path *dir, struct dentry *dentry)
-LSM_HOOK(int, 0, path_mknod, const struct path *dir, struct dentry *dentry,
-	 umode_t mode, unsigned int dev)
-LSM_HOOK(int, 0, path_truncate, const struct path *path)
-LSM_HOOK(int, 0, path_symlink, const struct path *dir, struct dentry *dentry,
-	 const char *old_name)
-LSM_HOOK(int, 0, path_link, struct dentry *old_dentry,
-	 const struct path *new_dir, struct dentry *new_dentry)
-LSM_HOOK(int, 0, path_rename, const struct path *old_dir,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_unlink,
+	 const struct path *dir, struct dentry *dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_mkdir, const struct path *dir,
+	 struct dentry *dentry, umode_t mode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_rmdir, const struct path *dir,
+	 struct dentry *dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_mknod, const struct path *dir,
+	 struct dentry *dentry, umode_t mode, unsigned int dev)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_truncate,
+	 const struct path *path)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_symlink,
+	 const struct path *dir, struct dentry *dentry, const char *old_name)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_link,
 	 struct dentry *old_dentry, const struct path *new_dir,
-	 struct dentry *new_dentry, unsigned int flags)
-LSM_HOOK(int, 0, path_chmod, const struct path *path, umode_t mode)
-LSM_HOOK(int, 0, path_chown, const struct path *path, kuid_t uid, kgid_t gid)
-LSM_HOOK(int, 0, path_chroot, const struct path *path)
+	 struct dentry *new_dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_rename,
+	 const struct path *old_dir, struct dentry *old_dentry,
+	 const struct path *new_dir, struct dentry *new_dentry,
+	 unsigned int flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_chmod,
+	 const struct path *path, umode_t mode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_chown,
+	 const struct path *path, kuid_t uid, kgid_t gid)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_chroot,
+	 const struct path *path)
 #endif /* CONFIG_SECURITY_PATH */
 
 /* Needed for inode based security check */
-LSM_HOOK(int, 0, path_notify, const struct path *path, u64 mask,
-	 unsigned int obj_type)
-LSM_HOOK(int, 0, inode_alloc_security, struct inode *inode)
-LSM_HOOK(void, LSM_RET_VOID, inode_free_security, struct inode *inode)
-LSM_HOOK(int, 0, inode_init_security, struct inode *inode,
-	 struct inode *dir, const struct qstr *qstr, const char **name,
-	 void **value, size_t *len)
-LSM_HOOK(int, 0, inode_init_security_anon, struct inode *inode,
-	 const struct qstr *name, const struct inode *context_inode)
-LSM_HOOK(int, 0, inode_create, struct inode *dir, struct dentry *dentry,
-	 umode_t mode)
-LSM_HOOK(int, 0, inode_link, struct dentry *old_dentry, struct inode *dir,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, path_notify,
+	 const struct path *path, u64 mask, unsigned int obj_type)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_alloc_security,
+	 struct inode *inode)
+LSM_HOOK(void, LSM_RET_VOID, 0, inode_free_security, struct inode *inode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_init_security,
+	 struct inode *inode, struct inode *dir, const struct qstr *qstr,
+	 const char **name, void **value, size_t *len)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_init_security_anon,
+	 struct inode *inode, const struct qstr *name,
+	 const struct inode *context_inode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_create, struct inode *dir,
+	 struct dentry *dentry, umode_t mode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_link,
+	 struct dentry *old_dentry, struct inode *dir,
 	 struct dentry *new_dentry)
-LSM_HOOK(int, 0, inode_unlink, struct inode *dir, struct dentry *dentry)
-LSM_HOOK(int, 0, inode_symlink, struct inode *dir, struct dentry *dentry,
-	 const char *old_name)
-LSM_HOOK(int, 0, inode_mkdir, struct inode *dir, struct dentry *dentry,
-	 umode_t mode)
-LSM_HOOK(int, 0, inode_rmdir, struct inode *dir, struct dentry *dentry)
-LSM_HOOK(int, 0, inode_mknod, struct inode *dir, struct dentry *dentry,
-	 umode_t mode, dev_t dev)
-LSM_HOOK(int, 0, inode_rename, struct inode *old_dir, struct dentry *old_dentry,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_unlink, struct inode *dir,
+	 struct dentry *dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_symlink, struct inode *dir,
+	 struct dentry *dentry, const char *old_name)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_mkdir, struct inode *dir,
+	 struct dentry *dentry, umode_t mode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_rmdir, struct inode *dir,
+	 struct dentry *dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_mknod, struct inode *dir,
+	 struct dentry *dentry, umode_t mode, dev_t dev)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_rename,
+	 struct inode *old_dir, struct dentry *old_dentry,
 	 struct inode *new_dir, struct dentry *new_dentry)
-LSM_HOOK(int, 0, inode_readlink, struct dentry *dentry)
-LSM_HOOK(int, 0, inode_follow_link, struct dentry *dentry, struct inode *inode,
-	 bool rcu)
-LSM_HOOK(int, 0, inode_permission, struct inode *inode, int mask)
-LSM_HOOK(int, 0, inode_setattr, struct dentry *dentry, struct iattr *attr)
-LSM_HOOK(int, 0, inode_getattr, const struct path *path)
-LSM_HOOK(int, 0, inode_setxattr, struct user_namespace *mnt_userns,
-	 struct dentry *dentry, const char *name, const void *value,
-	 size_t size, int flags)
-LSM_HOOK(void, LSM_RET_VOID, inode_post_setxattr, struct dentry *dentry,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_readlink,
+	 struct dentry *dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_follow_link,
+	 struct dentry *dentry, struct inode *inode, bool rcu)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_permission,
+	 struct inode *inode, int mask)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_setattr,
+	 struct dentry *dentry, struct iattr *attr)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_getattr,
+	 const struct path *path)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_setxattr,
+	 struct user_namespace *mnt_userns, struct dentry *dentry,
+	 const char *name, const void *value, size_t size, int flags)
+LSM_HOOK(void, LSM_RET_VOID, 0, inode_post_setxattr, struct dentry *dentry,
 	 const char *name, const void *value, size_t size, int flags)
-LSM_HOOK(int, 0, inode_getxattr, struct dentry *dentry, const char *name)
-LSM_HOOK(int, 0, inode_listxattr, struct dentry *dentry)
-LSM_HOOK(int, 0, inode_removexattr, struct user_namespace *mnt_userns,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_getxattr,
 	 struct dentry *dentry, const char *name)
-LSM_HOOK(int, 0, inode_need_killpriv, struct dentry *dentry)
-LSM_HOOK(int, 0, inode_killpriv, struct user_namespace *mnt_userns,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_listxattr,
 	 struct dentry *dentry)
-LSM_HOOK(int, -EOPNOTSUPP, inode_getsecurity, struct user_namespace *mnt_userns,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_removexattr,
+	 struct user_namespace *mnt_userns, struct dentry *dentry,
+	 const char *name)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE | LSM_RET_GT_ONE,
+	 inode_need_killpriv, struct dentry *dentry)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_killpriv,
+	 struct user_namespace *mnt_userns, struct dentry *dentry)
+LSM_HOOK(int, -EOPNOTSUPP,
+	 LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE | LSM_RET_GT_ONE,
+	 inode_getsecurity, struct user_namespace *mnt_userns,
 	 struct inode *inode, const char *name, void **buffer, bool alloc)
-LSM_HOOK(int, -EOPNOTSUPP, inode_setsecurity, struct inode *inode,
-	 const char *name, const void *value, size_t size, int flags)
-LSM_HOOK(int, 0, inode_listsecurity, struct inode *inode, char *buffer,
+LSM_HOOK(int, -EOPNOTSUPP, LSM_RET_NEG | LSM_RET_ZERO, inode_setsecurity,
+	 struct inode *inode, const char *name, const void *value, size_t size,
+	 int flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE | LSM_RET_GT_ONE,
+	 inode_listsecurity, struct inode *inode, char *buffer,
 	 size_t buffer_size)
-LSM_HOOK(void, LSM_RET_VOID, inode_getsecid, struct inode *inode, u32 *secid)
-LSM_HOOK(int, 0, inode_copy_up, struct dentry *src, struct cred **new)
-LSM_HOOK(int, -EOPNOTSUPP, inode_copy_up_xattr, const char *name)
-LSM_HOOK(int, 0, kernfs_init_security, struct kernfs_node *kn_dir,
-	 struct kernfs_node *kn)
-LSM_HOOK(int, 0, file_permission, struct file *file, int mask)
-LSM_HOOK(int, 0, file_alloc_security, struct file *file)
-LSM_HOOK(void, LSM_RET_VOID, file_free_security, struct file *file)
-LSM_HOOK(int, 0, file_ioctl, struct file *file, unsigned int cmd,
-	 unsigned long arg)
-LSM_HOOK(int, 0, mmap_addr, unsigned long addr)
-LSM_HOOK(int, 0, mmap_file, struct file *file, unsigned long reqprot,
-	 unsigned long prot, unsigned long flags)
-LSM_HOOK(int, 0, file_mprotect, struct vm_area_struct *vma,
-	 unsigned long reqprot, unsigned long prot)
-LSM_HOOK(int, 0, file_lock, struct file *file, unsigned int cmd)
-LSM_HOOK(int, 0, file_fcntl, struct file *file, unsigned int cmd,
-	 unsigned long arg)
-LSM_HOOK(void, LSM_RET_VOID, file_set_fowner, struct file *file)
-LSM_HOOK(int, 0, file_send_sigiotask, struct task_struct *tsk,
-	 struct fown_struct *fown, int sig)
-LSM_HOOK(int, 0, file_receive, struct file *file)
-LSM_HOOK(int, 0, file_open, struct file *file)
-LSM_HOOK(int, 0, task_alloc, struct task_struct *task,
-	 unsigned long clone_flags)
-LSM_HOOK(void, LSM_RET_VOID, task_free, struct task_struct *task)
-LSM_HOOK(int, 0, cred_alloc_blank, struct cred *cred, gfp_t gfp)
-LSM_HOOK(void, LSM_RET_VOID, cred_free, struct cred *cred)
-LSM_HOOK(int, 0, cred_prepare, struct cred *new, const struct cred *old,
-	 gfp_t gfp)
-LSM_HOOK(void, LSM_RET_VOID, cred_transfer, struct cred *new,
+LSM_HOOK(void, LSM_RET_VOID, 0, inode_getsecid, struct inode *inode, u32 *secid)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_copy_up, struct dentry *src,
+	 struct cred **new)
+LSM_HOOK(int, -EOPNOTSUPP, LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE,
+	 inode_copy_up_xattr, const char *name)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, kernfs_init_security,
+	 struct kernfs_node *kn_dir, struct kernfs_node *kn)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_permission, struct file *file,
+	 int mask)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_alloc_security,
+	 struct file *file)
+LSM_HOOK(void, LSM_RET_VOID, 0, file_free_security, struct file *file)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_ioctl, struct file *file,
+	 unsigned int cmd, unsigned long arg)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, mmap_addr, unsigned long addr)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, mmap_file, struct file *file,
+	 unsigned long reqprot, unsigned long prot, unsigned long flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_mprotect,
+	 struct vm_area_struct *vma, unsigned long reqprot, unsigned long prot)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_lock, struct file *file,
+	 unsigned int cmd)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_fcntl, struct file *file,
+	 unsigned int cmd, unsigned long arg)
+LSM_HOOK(void, LSM_RET_VOID, 0, file_set_fowner, struct file *file)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_send_sigiotask,
+	 struct task_struct *tsk, struct fown_struct *fown, int sig)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_receive, struct file *file)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, file_open, struct file *file)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_alloc,
+	 struct task_struct *task, unsigned long clone_flags)
+LSM_HOOK(void, LSM_RET_VOID, 0, task_free, struct task_struct *task)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, cred_alloc_blank,
+	 struct cred *cred, gfp_t gfp)
+LSM_HOOK(void, LSM_RET_VOID, 0, cred_free, struct cred *cred)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, cred_prepare, struct cred *new,
+	 const struct cred *old, gfp_t gfp)
+LSM_HOOK(void, LSM_RET_VOID, 0, cred_transfer, struct cred *new,
 	 const struct cred *old)
-LSM_HOOK(void, LSM_RET_VOID, cred_getsecid, const struct cred *c, u32 *secid)
-LSM_HOOK(int, 0, kernel_act_as, struct cred *new, u32 secid)
-LSM_HOOK(int, 0, kernel_create_files_as, struct cred *new, struct inode *inode)
-LSM_HOOK(int, 0, kernel_module_request, char *kmod_name)
-LSM_HOOK(int, 0, kernel_load_data, enum kernel_load_data_id id, bool contents)
-LSM_HOOK(int, 0, kernel_post_load_data, char *buf, loff_t size,
-	 enum kernel_load_data_id id, char *description)
-LSM_HOOK(int, 0, kernel_read_file, struct file *file,
-	 enum kernel_read_file_id id, bool contents)
-LSM_HOOK(int, 0, kernel_post_read_file, struct file *file, char *buf,
-	 loff_t size, enum kernel_read_file_id id)
-LSM_HOOK(int, 0, task_fix_setuid, struct cred *new, const struct cred *old,
-	 int flags)
-LSM_HOOK(int, 0, task_fix_setgid, struct cred *new, const struct cred * old,
-	 int flags)
-LSM_HOOK(int, 0, task_fix_setgroups, struct cred *new, const struct cred * old)
-LSM_HOOK(int, 0, task_setpgid, struct task_struct *p, pid_t pgid)
-LSM_HOOK(int, 0, task_getpgid, struct task_struct *p)
-LSM_HOOK(int, 0, task_getsid, struct task_struct *p)
-LSM_HOOK(void, LSM_RET_VOID, current_getsecid_subj, u32 *secid)
-LSM_HOOK(void, LSM_RET_VOID, task_getsecid_obj,
+LSM_HOOK(void, LSM_RET_VOID, 0, cred_getsecid, const struct cred *c, u32 *secid)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, kernel_act_as, struct cred *new,
+	 u32 secid)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, kernel_create_files_as,
+	 struct cred *new, struct inode *inode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, kernel_module_request,
+	 char *kmod_name)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, kernel_load_data,
+	 enum kernel_load_data_id id, bool contents)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, kernel_post_load_data, char *buf,
+	 loff_t size, enum kernel_load_data_id id, char *description)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, kernel_read_file,
+	 struct file *file, enum kernel_read_file_id id, bool contents)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, kernel_post_read_file,
+	 struct file *file, char *buf, loff_t size, enum kernel_read_file_id id)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_fix_setuid, struct cred *new,
+	 const struct cred *old, int flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_fix_setgid, struct cred *new,
+	 const struct cred *old, int flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_fix_setgroups,
+	 struct cred *new, const struct cred *old)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_setpgid,
+	 struct task_struct *p, pid_t pgid)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_getpgid,
+	 struct task_struct *p)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_getsid, struct task_struct *p)
+LSM_HOOK(void, LSM_RET_VOID, 0, current_getsecid_subj, u32 *secid)
+LSM_HOOK(void, LSM_RET_VOID, 0, task_getsecid_obj,
 	 struct task_struct *p, u32 *secid)
-LSM_HOOK(int, 0, task_setnice, struct task_struct *p, int nice)
-LSM_HOOK(int, 0, task_setioprio, struct task_struct *p, int ioprio)
-LSM_HOOK(int, 0, task_getioprio, struct task_struct *p)
-LSM_HOOK(int, 0, task_prlimit, const struct cred *cred,
-	 const struct cred *tcred, unsigned int flags)
-LSM_HOOK(int, 0, task_setrlimit, struct task_struct *p, unsigned int resource,
-	 struct rlimit *new_rlim)
-LSM_HOOK(int, 0, task_setscheduler, struct task_struct *p)
-LSM_HOOK(int, 0, task_getscheduler, struct task_struct *p)
-LSM_HOOK(int, 0, task_movememory, struct task_struct *p)
-LSM_HOOK(int, 0, task_kill, struct task_struct *p, struct kernel_siginfo *info,
-	 int sig, const struct cred *cred)
-LSM_HOOK(int, -ENOSYS, task_prctl, int option, unsigned long arg2,
-	 unsigned long arg3, unsigned long arg4, unsigned long arg5)
-LSM_HOOK(void, LSM_RET_VOID, task_to_inode, struct task_struct *p,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_setnice,
+	 struct task_struct *p, int nice)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_setioprio,
+	 struct task_struct *p, int ioprio)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_getioprio,
+	 struct task_struct *p)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_prlimit,
+	 const struct cred *cred, const struct cred *tcred, unsigned int flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_setrlimit,
+	 struct task_struct *p, unsigned int resource, struct rlimit *new_rlim)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_setscheduler,
+	 struct task_struct *p)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_getscheduler,
+	 struct task_struct *p)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_movememory,
+	 struct task_struct *p)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, task_kill, struct task_struct *p,
+	 struct kernel_siginfo *info, int sig, const struct cred *cred)
+LSM_HOOK(int, -ENOSYS,
+	 LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE | LSM_RET_GT_ONE, task_prctl,
+	 int option, unsigned long arg2, unsigned long arg3, unsigned long arg4,
+	 unsigned long arg5)
+LSM_HOOK(void, LSM_RET_VOID, 0, task_to_inode, struct task_struct *p,
 	 struct inode *inode)
-LSM_HOOK(int, 0, userns_create, const struct cred *cred)
-LSM_HOOK(int, 0, ipc_permission, struct kern_ipc_perm *ipcp, short flag)
-LSM_HOOK(void, LSM_RET_VOID, ipc_getsecid, struct kern_ipc_perm *ipcp,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, userns_create,
+	 const struct cred *cred)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, ipc_permission,
+	 struct kern_ipc_perm *ipcp, short flag)
+LSM_HOOK(void, LSM_RET_VOID, 0, ipc_getsecid, struct kern_ipc_perm *ipcp,
 	 u32 *secid)
-LSM_HOOK(int, 0, msg_msg_alloc_security, struct msg_msg *msg)
-LSM_HOOK(void, LSM_RET_VOID, msg_msg_free_security, struct msg_msg *msg)
-LSM_HOOK(int, 0, msg_queue_alloc_security, struct kern_ipc_perm *perm)
-LSM_HOOK(void, LSM_RET_VOID, msg_queue_free_security,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, msg_msg_alloc_security,
+	 struct msg_msg *msg)
+LSM_HOOK(void, LSM_RET_VOID, 0, msg_msg_free_security, struct msg_msg *msg)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, msg_queue_alloc_security,
+	 struct kern_ipc_perm *perm)
+LSM_HOOK(void, LSM_RET_VOID, 0, msg_queue_free_security,
+	 struct kern_ipc_perm *perm)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, msg_queue_associate,
+	 struct kern_ipc_perm *perm, int msqflg)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, msg_queue_msgctl,
+	 struct kern_ipc_perm *perm, int cmd)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, msg_queue_msgsnd,
+	 struct kern_ipc_perm *perm, struct msg_msg *msg, int msqflg)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, msg_queue_msgrcv,
+	 struct kern_ipc_perm *perm, struct msg_msg *msg,
+	 struct task_struct *target, long type, int mode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, shm_alloc_security,
 	 struct kern_ipc_perm *perm)
-LSM_HOOK(int, 0, msg_queue_associate, struct kern_ipc_perm *perm, int msqflg)
-LSM_HOOK(int, 0, msg_queue_msgctl, struct kern_ipc_perm *perm, int cmd)
-LSM_HOOK(int, 0, msg_queue_msgsnd, struct kern_ipc_perm *perm,
-	 struct msg_msg *msg, int msqflg)
-LSM_HOOK(int, 0, msg_queue_msgrcv, struct kern_ipc_perm *perm,
-	 struct msg_msg *msg, struct task_struct *target, long type, int mode)
-LSM_HOOK(int, 0, shm_alloc_security, struct kern_ipc_perm *perm)
-LSM_HOOK(void, LSM_RET_VOID, shm_free_security, struct kern_ipc_perm *perm)
-LSM_HOOK(int, 0, shm_associate, struct kern_ipc_perm *perm, int shmflg)
-LSM_HOOK(int, 0, shm_shmctl, struct kern_ipc_perm *perm, int cmd)
-LSM_HOOK(int, 0, shm_shmat, struct kern_ipc_perm *perm, char __user *shmaddr,
-	 int shmflg)
-LSM_HOOK(int, 0, sem_alloc_security, struct kern_ipc_perm *perm)
-LSM_HOOK(void, LSM_RET_VOID, sem_free_security, struct kern_ipc_perm *perm)
-LSM_HOOK(int, 0, sem_associate, struct kern_ipc_perm *perm, int semflg)
-LSM_HOOK(int, 0, sem_semctl, struct kern_ipc_perm *perm, int cmd)
-LSM_HOOK(int, 0, sem_semop, struct kern_ipc_perm *perm, struct sembuf *sops,
-	 unsigned nsops, int alter)
-LSM_HOOK(int, 0, netlink_send, struct sock *sk, struct sk_buff *skb)
-LSM_HOOK(void, LSM_RET_VOID, d_instantiate, struct dentry *dentry,
+LSM_HOOK(void, LSM_RET_VOID, 0, shm_free_security, struct kern_ipc_perm *perm)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, shm_associate,
+	 struct kern_ipc_perm *perm, int shmflg)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, shm_shmctl,
+	 struct kern_ipc_perm *perm, int cmd)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, shm_shmat,
+	 struct kern_ipc_perm *perm, char __user *shmaddr, int shmflg)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sem_alloc_security,
+	 struct kern_ipc_perm *perm)
+LSM_HOOK(void, LSM_RET_VOID, 0, sem_free_security, struct kern_ipc_perm *perm)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sem_associate,
+	 struct kern_ipc_perm *perm, int semflg)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sem_semctl,
+	 struct kern_ipc_perm *perm, int cmd)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sem_semop,
+	 struct kern_ipc_perm *perm, struct sembuf *sops, unsigned nsops,
+	 int alter)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, netlink_send, struct sock *sk,
+	 struct sk_buff *skb)
+LSM_HOOK(void, LSM_RET_VOID, 0, d_instantiate, struct dentry *dentry,
 	 struct inode *inode)
-LSM_HOOK(int, -EINVAL, getprocattr, struct task_struct *p, const char *name,
-	 char **value)
-LSM_HOOK(int, -EINVAL, setprocattr, const char *name, void *value, size_t size)
-LSM_HOOK(int, 0, ismaclabel, const char *name)
-LSM_HOOK(int, -EOPNOTSUPP, secid_to_secctx, u32 secid, char **secdata,
-	 u32 *seclen)
-LSM_HOOK(int, 0, secctx_to_secid, const char *secdata, u32 seclen, u32 *secid)
-LSM_HOOK(void, LSM_RET_VOID, release_secctx, char *secdata, u32 seclen)
-LSM_HOOK(void, LSM_RET_VOID, inode_invalidate_secctx, struct inode *inode)
-LSM_HOOK(int, 0, inode_notifysecctx, struct inode *inode, void *ctx, u32 ctxlen)
-LSM_HOOK(int, 0, inode_setsecctx, struct dentry *dentry, void *ctx, u32 ctxlen)
-LSM_HOOK(int, 0, inode_getsecctx, struct inode *inode, void **ctx,
-	 u32 *ctxlen)
+LSM_HOOK(int, -EINVAL,
+	 LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE | LSM_RET_GT_ONE, getprocattr,
+	 struct task_struct *p, const char *name, char **value)
+LSM_HOOK(int, -EINVAL,
+	 LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE | LSM_RET_GT_ONE, setprocattr,
+	 const char *name, void *value, size_t size)
+LSM_HOOK(int, 0, LSM_RET_ZERO | LSM_RET_ONE, ismaclabel, const char *name)
+LSM_HOOK(int, -EOPNOTSUPP, LSM_RET_NEG | LSM_RET_ZERO, secid_to_secctx,
+	 u32 secid, char **secdata, u32 *seclen)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, secctx_to_secid,
+	 const char *secdata, u32 seclen, u32 *secid)
+LSM_HOOK(void, LSM_RET_VOID, 0, release_secctx, char *secdata, u32 seclen)
+LSM_HOOK(void, LSM_RET_VOID, 0, inode_invalidate_secctx, struct inode *inode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_notifysecctx,
+	 struct inode *inode, void *ctx, u32 ctxlen)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_setsecctx,
+	 struct dentry *dentry, void *ctx, u32 ctxlen)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inode_getsecctx,
+	 struct inode *inode, void **ctx, u32 *ctxlen)
 
 #if defined(CONFIG_SECURITY) && defined(CONFIG_WATCH_QUEUE)
-LSM_HOOK(int, 0, post_notification, const struct cred *w_cred,
-	 const struct cred *cred, struct watch_notification *n)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, post_notification,
+	 const struct cred *w_cred, const struct cred *cred,
+	 struct watch_notification *n)
 #endif /* CONFIG_SECURITY && CONFIG_WATCH_QUEUE */
 
 #if defined(CONFIG_SECURITY) && defined(CONFIG_KEY_NOTIFICATIONS)
-LSM_HOOK(int, 0, watch_key, struct key *key)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, watch_key, struct key *key)
 #endif /* CONFIG_SECURITY && CONFIG_KEY_NOTIFICATIONS */
 
 #ifdef CONFIG_SECURITY_NETWORK
-LSM_HOOK(int, 0, unix_stream_connect, struct sock *sock, struct sock *other,
-	 struct sock *newsk)
-LSM_HOOK(int, 0, unix_may_send, struct socket *sock, struct socket *other)
-LSM_HOOK(int, 0, socket_create, int family, int type, int protocol, int kern)
-LSM_HOOK(int, 0, socket_post_create, struct socket *sock, int family, int type,
-	 int protocol, int kern)
-LSM_HOOK(int, 0, socket_socketpair, struct socket *socka, struct socket *sockb)
-LSM_HOOK(int, 0, socket_bind, struct socket *sock, struct sockaddr *address,
-	 int addrlen)
-LSM_HOOK(int, 0, socket_connect, struct socket *sock, struct sockaddr *address,
-	 int addrlen)
-LSM_HOOK(int, 0, socket_listen, struct socket *sock, int backlog)
-LSM_HOOK(int, 0, socket_accept, struct socket *sock, struct socket *newsock)
-LSM_HOOK(int, 0, socket_sendmsg, struct socket *sock, struct msghdr *msg,
-	 int size)
-LSM_HOOK(int, 0, socket_recvmsg, struct socket *sock, struct msghdr *msg,
-	 int size, int flags)
-LSM_HOOK(int, 0, socket_getsockname, struct socket *sock)
-LSM_HOOK(int, 0, socket_getpeername, struct socket *sock)
-LSM_HOOK(int, 0, socket_getsockopt, struct socket *sock, int level, int optname)
-LSM_HOOK(int, 0, socket_setsockopt, struct socket *sock, int level, int optname)
-LSM_HOOK(int, 0, socket_shutdown, struct socket *sock, int how)
-LSM_HOOK(int, 0, socket_sock_rcv_skb, struct sock *sk, struct sk_buff *skb)
-LSM_HOOK(int, 0, socket_getpeersec_stream, struct socket *sock,
-	 char __user *optval, int __user *optlen, unsigned len)
-LSM_HOOK(int, 0, socket_getpeersec_dgram, struct socket *sock,
-	 struct sk_buff *skb, u32 *secid)
-LSM_HOOK(int, 0, sk_alloc_security, struct sock *sk, int family, gfp_t priority)
-LSM_HOOK(void, LSM_RET_VOID, sk_free_security, struct sock *sk)
-LSM_HOOK(void, LSM_RET_VOID, sk_clone_security, const struct sock *sk,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, unix_stream_connect,
+	 struct sock *sock, struct sock *other, struct sock *newsk)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, unix_may_send, struct socket *sock,
+	 struct socket *other)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_create, int family,
+	 int type, int protocol, int kern)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_post_create,
+	 struct socket *sock, int family, int type, int protocol, int kern)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_socketpair,
+	 struct socket *socka, struct socket *sockb)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_bind, struct socket *sock,
+	 struct sockaddr *address, int addrlen)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_connect,
+	 struct socket *sock, struct sockaddr *address, int addrlen)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_listen, struct socket *sock,
+	 int backlog)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_accept, struct socket *sock,
+	 struct socket *newsock)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_sendmsg,
+	 struct socket *sock, struct msghdr *msg, int size)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_recvmsg,
+	 struct socket *sock, struct msghdr *msg, int size, int flags)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_getsockname,
+	 struct socket *sock)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_getpeername,
+	 struct socket *sock)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_getsockopt,
+	 struct socket *sock, int level, int optname)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_setsockopt,
+	 struct socket *sock, int level, int optname)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_shutdown,
+	 struct socket *sock, int how)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_sock_rcv_skb,
+	 struct sock *sk, struct sk_buff *skb)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_getpeersec_stream,
+	 struct socket *sock, char __user *optval, int __user *optlen,
+	 unsigned len)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, socket_getpeersec_dgram,
+	 struct socket *sock, struct sk_buff *skb, u32 *secid)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sk_alloc_security, struct sock *sk,
+	 int family, gfp_t priority)
+LSM_HOOK(void, LSM_RET_VOID, 0, sk_free_security, struct sock *sk)
+LSM_HOOK(void, LSM_RET_VOID, 0, sk_clone_security, const struct sock *sk,
 	 struct sock *newsk)
-LSM_HOOK(void, LSM_RET_VOID, sk_getsecid, struct sock *sk, u32 *secid)
-LSM_HOOK(void, LSM_RET_VOID, sock_graft, struct sock *sk, struct socket *parent)
-LSM_HOOK(int, 0, inet_conn_request, const struct sock *sk, struct sk_buff *skb,
-	 struct request_sock *req)
-LSM_HOOK(void, LSM_RET_VOID, inet_csk_clone, struct sock *newsk,
+LSM_HOOK(void, LSM_RET_VOID, 0, sk_getsecid, struct sock *sk, u32 *secid)
+LSM_HOOK(void, LSM_RET_VOID, 0, sock_graft, struct sock *sk, struct socket *parent)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, inet_conn_request,
+	 const struct sock *sk, struct sk_buff *skb, struct request_sock *req)
+LSM_HOOK(void, LSM_RET_VOID, 0, inet_csk_clone, struct sock *newsk,
 	 const struct request_sock *req)
-LSM_HOOK(void, LSM_RET_VOID, inet_conn_established, struct sock *sk,
+LSM_HOOK(void, LSM_RET_VOID, 0, inet_conn_established, struct sock *sk,
 	 struct sk_buff *skb)
-LSM_HOOK(int, 0, secmark_relabel_packet, u32 secid)
-LSM_HOOK(void, LSM_RET_VOID, secmark_refcount_inc, void)
-LSM_HOOK(void, LSM_RET_VOID, secmark_refcount_dec, void)
-LSM_HOOK(void, LSM_RET_VOID, req_classify_flow, const struct request_sock *req,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, secmark_relabel_packet, u32 secid)
+LSM_HOOK(void, LSM_RET_VOID, 0, secmark_refcount_inc, void)
+LSM_HOOK(void, LSM_RET_VOID, 0, secmark_refcount_dec, void)
+LSM_HOOK(void, LSM_RET_VOID, 0, req_classify_flow, const struct request_sock *req,
 	 struct flowi_common *flic)
-LSM_HOOK(int, 0, tun_dev_alloc_security, void **security)
-LSM_HOOK(void, LSM_RET_VOID, tun_dev_free_security, void *security)
-LSM_HOOK(int, 0, tun_dev_create, void)
-LSM_HOOK(int, 0, tun_dev_attach_queue, void *security)
-LSM_HOOK(int, 0, tun_dev_attach, struct sock *sk, void *security)
-LSM_HOOK(int, 0, tun_dev_open, void *security)
-LSM_HOOK(int, 0, sctp_assoc_request, struct sctp_association *asoc,
-	 struct sk_buff *skb)
-LSM_HOOK(int, 0, sctp_bind_connect, struct sock *sk, int optname,
-	 struct sockaddr *address, int addrlen)
-LSM_HOOK(void, LSM_RET_VOID, sctp_sk_clone, struct sctp_association *asoc,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, tun_dev_alloc_security,
+	 void **security)
+LSM_HOOK(void, LSM_RET_VOID, 0, tun_dev_free_security, void *security)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, tun_dev_create, void)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, tun_dev_attach_queue,
+	 void *security)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, tun_dev_attach, struct sock *sk,
+	 void *security)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, tun_dev_open, void *security)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sctp_assoc_request,
+	 struct sctp_association *asoc, struct sk_buff *skb)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sctp_bind_connect, struct sock *sk,
+	 int optname, struct sockaddr *address, int addrlen)
+LSM_HOOK(void, LSM_RET_VOID, 0, sctp_sk_clone, struct sctp_association *asoc,
 	 struct sock *sk, struct sock *newsk)
-LSM_HOOK(int, 0, sctp_assoc_established, struct sctp_association *asoc,
-	 struct sk_buff *skb)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, sctp_assoc_established,
+	 struct sctp_association *asoc, struct sk_buff *skb)
 #endif /* CONFIG_SECURITY_NETWORK */
 
 #ifdef CONFIG_SECURITY_INFINIBAND
-LSM_HOOK(int, 0, ib_pkey_access, void *sec, u64 subnet_prefix, u16 pkey)
-LSM_HOOK(int, 0, ib_endport_manage_subnet, void *sec, const char *dev_name,
-	 u8 port_num)
-LSM_HOOK(int, 0, ib_alloc_security, void **sec)
-LSM_HOOK(void, LSM_RET_VOID, ib_free_security, void *sec)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, ib_pkey_access, void *sec,
+	 u64 subnet_prefix, u16 pkey)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, ib_endport_manage_subnet,
+	 void *sec, const char *dev_name, u8 port_num)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, ib_alloc_security, void **sec)
+LSM_HOOK(void, LSM_RET_VOID, 0, ib_free_security, void *sec)
 #endif /* CONFIG_SECURITY_INFINIBAND */
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
-LSM_HOOK(int, 0, xfrm_policy_alloc_security, struct xfrm_sec_ctx **ctxp,
-	 struct xfrm_user_sec_ctx *sec_ctx, gfp_t gfp)
-LSM_HOOK(int, 0, xfrm_policy_clone_security, struct xfrm_sec_ctx *old_ctx,
-	 struct xfrm_sec_ctx **new_ctx)
-LSM_HOOK(void, LSM_RET_VOID, xfrm_policy_free_security,
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, xfrm_policy_alloc_security,
+	 struct xfrm_sec_ctx **ctxp, struct xfrm_user_sec_ctx *sec_ctx,
+	 gfp_t gfp)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, xfrm_policy_clone_security,
+	 struct xfrm_sec_ctx *old_ctx, struct xfrm_sec_ctx **new_ctx)
+LSM_HOOK(void, LSM_RET_VOID, 0, xfrm_policy_free_security,
+	 struct xfrm_sec_ctx *ctx)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, xfrm_policy_delete_security,
 	 struct xfrm_sec_ctx *ctx)
-LSM_HOOK(int, 0, xfrm_policy_delete_security, struct xfrm_sec_ctx *ctx)
-LSM_HOOK(int, 0, xfrm_state_alloc, struct xfrm_state *x,
-	 struct xfrm_user_sec_ctx *sec_ctx)
-LSM_HOOK(int, 0, xfrm_state_alloc_acquire, struct xfrm_state *x,
-	 struct xfrm_sec_ctx *polsec, u32 secid)
-LSM_HOOK(void, LSM_RET_VOID, xfrm_state_free_security, struct xfrm_state *x)
-LSM_HOOK(int, 0, xfrm_state_delete_security, struct xfrm_state *x)
-LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid)
-LSM_HOOK(int, 1, xfrm_state_pol_flow_match, struct xfrm_state *x,
-	 struct xfrm_policy *xp, const struct flowi_common *flic)
-LSM_HOOK(int, 0, xfrm_decode_session, struct sk_buff *skb, u32 *secid,
-	 int ckall)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, xfrm_state_alloc,
+	 struct xfrm_state *x, struct xfrm_user_sec_ctx *sec_ctx)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, xfrm_state_alloc_acquire,
+	 struct xfrm_state *x, struct xfrm_sec_ctx *polsec, u32 secid)
+LSM_HOOK(void, LSM_RET_VOID, 0, xfrm_state_free_security, struct xfrm_state *x)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, xfrm_state_delete_security,
+	 struct xfrm_state *x)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, xfrm_policy_lookup,
+	 struct xfrm_sec_ctx *ctx, u32 fl_secid)
+LSM_HOOK(int, 1, LSM_RET_ZERO | LSM_RET_ONE, xfrm_state_pol_flow_match,
+	 struct xfrm_state *x, struct xfrm_policy *xp,
+	 const struct flowi_common *flic)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, xfrm_decode_session,
+	 struct sk_buff *skb, u32 *secid, int ckall)
 #endif /* CONFIG_SECURITY_NETWORK_XFRM */
 
 /* key management security hooks */
 #ifdef CONFIG_KEYS
-LSM_HOOK(int, 0, key_alloc, struct key *key, const struct cred *cred,
-	 unsigned long flags)
-LSM_HOOK(void, LSM_RET_VOID, key_free, struct key *key)
-LSM_HOOK(int, 0, key_permission, key_ref_t key_ref, const struct cred *cred,
-	 enum key_need_perm need_perm)
-LSM_HOOK(int, 0, key_getsecurity, struct key *key, char **_buffer)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, key_alloc, struct key *key,
+	 const struct cred *cred, unsigned long flags)
+LSM_HOOK(void, LSM_RET_VOID, 0, key_free, struct key *key)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, key_permission, key_ref_t key_ref,
+	 const struct cred *cred, enum key_need_perm need_perm)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE | LSM_RET_GT_ONE,
+	 key_getsecurity, struct key *key, char **_buffer)
 #endif /* CONFIG_KEYS */
 
 #ifdef CONFIG_AUDIT
-LSM_HOOK(int, 0, audit_rule_init, u32 field, u32 op, char *rulestr,
-	 void **lsmrule)
-LSM_HOOK(int, 0, audit_rule_known, struct audit_krule *krule)
-LSM_HOOK(int, 0, audit_rule_match, u32 secid, u32 field, u32 op, void *lsmrule)
-LSM_HOOK(void, LSM_RET_VOID, audit_rule_free, void *lsmrule)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, audit_rule_init, u32 field, u32 op,
+	 char *rulestr, void **lsmrule)
+LSM_HOOK(int, 0, LSM_RET_ZERO | LSM_RET_ONE, audit_rule_known,
+	 struct audit_krule *krule)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO | LSM_RET_ONE, audit_rule_match,
+	 u32 secid, u32 field, u32 op, void *lsmrule)
+LSM_HOOK(void, LSM_RET_VOID, 0, audit_rule_free, void *lsmrule)
 #endif /* CONFIG_AUDIT */
 
 #ifdef CONFIG_BPF_SYSCALL
-LSM_HOOK(int, 0, bpf, int cmd, union bpf_attr *attr, unsigned int size)
-LSM_HOOK(int, 0, bpf_map, struct bpf_map *map, fmode_t fmode)
-LSM_HOOK(int, 0, bpf_prog, struct bpf_prog *prog)
-LSM_HOOK(int, 0, bpf_map_alloc_security, struct bpf_map *map)
-LSM_HOOK(void, LSM_RET_VOID, bpf_map_free_security, struct bpf_map *map)
-LSM_HOOK(int, 0, bpf_prog_alloc_security, struct bpf_prog_aux *aux)
-LSM_HOOK(void, LSM_RET_VOID, bpf_prog_free_security, struct bpf_prog_aux *aux)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, bpf, int cmd, union bpf_attr *attr,
+	 unsigned int size)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, bpf_map, struct bpf_map *map,
+	 fmode_t fmode)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, bpf_prog, struct bpf_prog *prog)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, bpf_map_alloc_security,
+	 struct bpf_map *map)
+LSM_HOOK(void, LSM_RET_VOID, 0, bpf_map_free_security, struct bpf_map *map)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, bpf_prog_alloc_security,
+	 struct bpf_prog_aux *aux)
+LSM_HOOK(void, LSM_RET_VOID, 0, bpf_prog_free_security, struct bpf_prog_aux *aux)
 #endif /* CONFIG_BPF_SYSCALL */
 
-LSM_HOOK(int, 0, locked_down, enum lockdown_reason what)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, locked_down,
+	 enum lockdown_reason what)
 
 #ifdef CONFIG_PERF_EVENTS
-LSM_HOOK(int, 0, perf_event_open, struct perf_event_attr *attr, int type)
-LSM_HOOK(int, 0, perf_event_alloc, struct perf_event *event)
-LSM_HOOK(void, LSM_RET_VOID, perf_event_free, struct perf_event *event)
-LSM_HOOK(int, 0, perf_event_read, struct perf_event *event)
-LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, perf_event_open,
+	 struct perf_event_attr *attr, int type)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, perf_event_alloc,
+	 struct perf_event *event)
+LSM_HOOK(void, LSM_RET_VOID, 0, perf_event_free, struct perf_event *event)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, perf_event_read,
+	 struct perf_event *event)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, perf_event_write,
+	 struct perf_event *event)
 #endif /* CONFIG_PERF_EVENTS */
 
 #ifdef CONFIG_IO_URING
-LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
-LSM_HOOK(int, 0, uring_sqpoll, void)
-LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, uring_override_creds,
+	 const struct cred *new)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, uring_sqpoll, void)
+LSM_HOOK(int, 0, LSM_RET_NEG | LSM_RET_ZERO, uring_cmd,
+	 struct io_uring_cmd *ioucmd)
 #endif /* CONFIG_IO_URING */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index c0c570b7eabd..1911675a0da0 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1642,13 +1642,13 @@
  *
  */
 union security_list_options {
-	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
+	#define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) RET (*NAME)(__VA_ARGS__);
 	#include "lsm_hook_defs.h"
 	#undef LSM_HOOK
 };
 
 struct security_hook_heads {
-	#define LSM_HOOK(RET, DEFAULT, NAME, ...) struct hlist_head NAME;
+	#define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) struct hlist_head NAME;
 	#include "lsm_hook_defs.h"
 	#undef LSM_HOOK
 } __randomize_layout;
@@ -1683,6 +1683,11 @@ struct lsm_blob_sizes {
  */
 #define LSM_RET_VOID ((void) 0)
 
+#define LSM_RET_NEG	0x00000001
+#define LSM_RET_ZERO	0x00000002
+#define LSM_RET_ONE	0x00000004
+#define LSM_RET_GT_ONE	0x00000008
+
 /*
  * Initializing a security_hook_list structure takes
  * up a lot of space in a source file. This macro takes
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index d6c9b3705f24..37bcedf5a44e 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -21,7 +21,7 @@
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached.
  */
-#define LSM_HOOK(RET, DEFAULT, NAME, ...)	\
+#define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...)	\
 noinline RET bpf_lsm_##NAME(__VA_ARGS__)	\
 {						\
 	return DEFAULT;				\
@@ -30,7 +30,8 @@ noinline RET bpf_lsm_##NAME(__VA_ARGS__)	\
 #include <linux/lsm_hook_defs.h>
 #undef LSM_HOOK
 
-#define LSM_HOOK(RET, DEFAULT, NAME, ...) BTF_ID(func, bpf_lsm_##NAME)
+#define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) \
+	BTF_ID(func, bpf_lsm_##NAME)
 BTF_SET_START(bpf_lsm_hooks)
 #include <linux/lsm_hook_defs.h>
 #undef LSM_HOOK
diff --git a/security/bpf/hooks.c b/security/bpf/hooks.c
index e5971fa74fd7..a2a3b2be345f 100644
--- a/security/bpf/hooks.c
+++ b/security/bpf/hooks.c
@@ -7,7 +7,7 @@
 #include <linux/bpf_lsm.h>
 
 static struct security_hook_list bpf_lsm_hooks[] __lsm_ro_after_init = {
-	#define LSM_HOOK(RET, DEFAULT, NAME, ...) \
+	#define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) \
 	LSM_HOOK_INIT(NAME, bpf_lsm_##NAME),
 	#include <linux/lsm_hook_defs.h>
 	#undef LSM_HOOK
diff --git a/security/security.c b/security/security.c
index 79d82cb6e469..4041d24e3283 100644
--- a/security/security.c
+++ b/security/security.c
@@ -371,7 +371,7 @@ int __init early_security_init(void)
 {
 	struct lsm_info *lsm;
 
-#define LSM_HOOK(RET, DEFAULT, NAME, ...) \
+#define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) \
 	INIT_HLIST_HEAD(&security_hook_heads.NAME);
 #include "linux/lsm_hook_defs.h"
 #undef LSM_HOOK
@@ -710,7 +710,7 @@ static int lsm_superblock_alloc(struct super_block *sb)
 #define DECLARE_LSM_RET_DEFAULT_void(DEFAULT, NAME)
 #define DECLARE_LSM_RET_DEFAULT_int(DEFAULT, NAME) \
 	static const int __maybe_unused LSM_RET_DEFAULT(NAME) = (DEFAULT);
-#define LSM_HOOK(RET, DEFAULT, NAME, ...) \
+#define LSM_HOOK(RET, DEFAULT, RET_FLAGS, NAME, ...) \
 	DECLARE_LSM_RET_DEFAULT_##RET(DEFAULT, NAME)
 
 #include <linux/lsm_hook_defs.h>
-- 
2.25.1

