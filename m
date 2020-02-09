Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD359156A58
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgBINCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:02:13 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42899 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:02:13 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DB5A521368;
        Sun,  9 Feb 2020 08:02:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:02:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6Tfrq/
        Q3AvCjH59H2aCmRVxBlBbGfBgMfHIDt3oVQus=; b=IJXo99P5CL6fsBvyxWKQZs
        dgD9KDHp2ajYpWKQ4LX1FOn/WSbJrqdWjEL7JpPDrDRJQfPEobrL0Vb38PAz2RdD
        6f0kBUPF8lm5JGaCnlrQLCbhjKe8/4D+umxDolt5akgzO4FosBpEYloEzDy6vs8O
        VkZaoeo9136TO9ekAHLq5y6vgXfVU+lyoYyWSBhdwrH7DPq0dZEIrgV7b8Flx/w1
        6VRw6UYZ93Jd637/MXNcPKWQJ4faqLBoWurutT3fLFkyIx5M4Yc0yRWphd8OyO4W
        MQmKcvua+KkWKzLsyZr1Bsbk9peIcZL2v6kwJsUcbt2R5DevBZzx44agmSd8WmZQ
        ==
X-ME-Sender: <xms:0wJAXijw5KEeHvFXgbbLMdd7-mAv9tuARdz35Qic-ZWXpGu89QHtgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculddqiedmnecujfgurhepuffvhf
    ffkfggtgfgsehtkeertddttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhho
    uhhnuggrthhiohhnrdhorhhgqeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluh
    hsthgvrhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhr
    ohgrhhdrtghomh
X-ME-Proxy: <xmx:0wJAXqkAsAnfegTBTAw-mBaw6YtvjY6_cfLo0RJTvxGeKvbyKeSsLA>
    <xmx:0wJAXpso_4RjWLVTaGqxpN86RLL1_bcISt3uz_NmuJ53xHp1Eyq0mg>
    <xmx:0wJAXoDrtmt2m5D8OQwBw4QtYtxHgzmWNlVZyD18ii1YIy8_Xuz8Tw>
    <xmx:0wJAXqrW2G-ZfKTpWRltO2xo1z0yJw7vyvpE8ckuSwf-bn-FH4a7Bw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7885C3060272;
        Sun,  9 Feb 2020 08:02:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] selinux: reorder hooks to make runtime disable less broken" failed to apply to 4.4-stable tree
To:     omosnace@redhat.com, paul@paul-moore.com, sds@tycho.nsa.gov
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:38:39 +0100
Message-ID: <1581248319249155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cfff75d8973ae4a90b3df3ae7fbba1ce9af9c8f0 Mon Sep 17 00:00:00 2001
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Wed, 8 Jan 2020 15:09:58 +0100
Subject: [PATCH] selinux: reorder hooks to make runtime disable less broken

Commit b1d9e6b0646d ("LSM: Switch to lists of hooks") switched the LSM
infrastructure to use per-hook lists, which meant that removing the
hooks for a given module was no longer atomic. Even though the commit
clearly documents that modules implementing runtime revmoval of hooks
(only SELinux attempts this madness) need to take special precautions to
avoid race conditions, SELinux has never addressed this.

By inserting an artificial delay between the loop iterations of
security_delete_hooks() (I used 100 ms), booting to a state where
SELinux is enabled, but policy is not yet loaded, and running these
commands:

    while true; do ping -c 1 <some IP>; done &
    echo -n 1 >/sys/fs/selinux/disable
    kill %1
    wait

...I was able to trigger NULL pointer dereferences in various places. I
also have a report of someone getting panics on a stock RHEL-8 kernel
after setting SELINUX=disabled in /etc/selinux/config and rebooting
(without adding "selinux=0" to kernel command-line).

Reordering the SELinux hooks such that those that allocate structures
are removed last seems to prevent these panics. It is very much possible
that this doesn't make the runtime disable completely race-free, but at
least it makes the operation much less fragile.

Cc: stable@vger.kernel.org
Fixes: b1d9e6b0646d ("LSM: Switch to lists of hooks")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a81631f8cc5d..2c84b12d50bc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6892,6 +6892,21 @@ static int selinux_perf_event_write(struct perf_event *event)
 }
 #endif
 
+/*
+ * IMPORTANT NOTE: When adding new hooks, please be careful to keep this order:
+ * 1. any hooks that don't belong to (2.) or (3.) below,
+ * 2. hooks that both access structures allocated by other hooks, and allocate
+ *    structures that can be later accessed by other hooks (mostly "cloning"
+ *    hooks),
+ * 3. hooks that only allocate structures that can be later accessed by other
+ *    hooks ("allocating" hooks).
+ *
+ * Please follow block comment delimiters in the list to keep this order.
+ *
+ * This ordering is needed for SELinux runtime disable to work at least somewhat
+ * safely. Breaking the ordering rules above might lead to NULL pointer derefs
+ * when disabling SELinux at runtime.
+ */
 static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(binder_set_context_mgr, selinux_binder_set_context_mgr),
 	LSM_HOOK_INIT(binder_transaction, selinux_binder_transaction),
@@ -6914,12 +6929,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(bprm_committing_creds, selinux_bprm_committing_creds),
 	LSM_HOOK_INIT(bprm_committed_creds, selinux_bprm_committed_creds),
 
-	LSM_HOOK_INIT(fs_context_dup, selinux_fs_context_dup),
-	LSM_HOOK_INIT(fs_context_parse_param, selinux_fs_context_parse_param),
-
-	LSM_HOOK_INIT(sb_alloc_security, selinux_sb_alloc_security),
 	LSM_HOOK_INIT(sb_free_security, selinux_sb_free_security),
-	LSM_HOOK_INIT(sb_eat_lsm_opts, selinux_sb_eat_lsm_opts),
 	LSM_HOOK_INIT(sb_free_mnt_opts, selinux_free_mnt_opts),
 	LSM_HOOK_INIT(sb_remount, selinux_sb_remount),
 	LSM_HOOK_INIT(sb_kern_mount, selinux_sb_kern_mount),
@@ -6929,12 +6939,10 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_umount, selinux_umount),
 	LSM_HOOK_INIT(sb_set_mnt_opts, selinux_set_mnt_opts),
 	LSM_HOOK_INIT(sb_clone_mnt_opts, selinux_sb_clone_mnt_opts),
-	LSM_HOOK_INIT(sb_add_mnt_opt, selinux_add_mnt_opt),
 
 	LSM_HOOK_INIT(dentry_init_security, selinux_dentry_init_security),
 	LSM_HOOK_INIT(dentry_create_files_as, selinux_dentry_create_files_as),
 
-	LSM_HOOK_INIT(inode_alloc_security, selinux_inode_alloc_security),
 	LSM_HOOK_INIT(inode_free_security, selinux_inode_free_security),
 	LSM_HOOK_INIT(inode_init_security, selinux_inode_init_security),
 	LSM_HOOK_INIT(inode_create, selinux_inode_create),
@@ -7006,21 +7014,15 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ipc_permission, selinux_ipc_permission),
 	LSM_HOOK_INIT(ipc_getsecid, selinux_ipc_getsecid),
 
-	LSM_HOOK_INIT(msg_msg_alloc_security, selinux_msg_msg_alloc_security),
-
-	LSM_HOOK_INIT(msg_queue_alloc_security,
-			selinux_msg_queue_alloc_security),
 	LSM_HOOK_INIT(msg_queue_associate, selinux_msg_queue_associate),
 	LSM_HOOK_INIT(msg_queue_msgctl, selinux_msg_queue_msgctl),
 	LSM_HOOK_INIT(msg_queue_msgsnd, selinux_msg_queue_msgsnd),
 	LSM_HOOK_INIT(msg_queue_msgrcv, selinux_msg_queue_msgrcv),
 
-	LSM_HOOK_INIT(shm_alloc_security, selinux_shm_alloc_security),
 	LSM_HOOK_INIT(shm_associate, selinux_shm_associate),
 	LSM_HOOK_INIT(shm_shmctl, selinux_shm_shmctl),
 	LSM_HOOK_INIT(shm_shmat, selinux_shm_shmat),
 
-	LSM_HOOK_INIT(sem_alloc_security, selinux_sem_alloc_security),
 	LSM_HOOK_INIT(sem_associate, selinux_sem_associate),
 	LSM_HOOK_INIT(sem_semctl, selinux_sem_semctl),
 	LSM_HOOK_INIT(sem_semop, selinux_sem_semop),
@@ -7031,13 +7033,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(setprocattr, selinux_setprocattr),
 
 	LSM_HOOK_INIT(ismaclabel, selinux_ismaclabel),
-	LSM_HOOK_INIT(secid_to_secctx, selinux_secid_to_secctx),
 	LSM_HOOK_INIT(secctx_to_secid, selinux_secctx_to_secid),
 	LSM_HOOK_INIT(release_secctx, selinux_release_secctx),
 	LSM_HOOK_INIT(inode_invalidate_secctx, selinux_inode_invalidate_secctx),
 	LSM_HOOK_INIT(inode_notifysecctx, selinux_inode_notifysecctx),
 	LSM_HOOK_INIT(inode_setsecctx, selinux_inode_setsecctx),
-	LSM_HOOK_INIT(inode_getsecctx, selinux_inode_getsecctx),
 
 	LSM_HOOK_INIT(unix_stream_connect, selinux_socket_unix_stream_connect),
 	LSM_HOOK_INIT(unix_may_send, selinux_socket_unix_may_send),
@@ -7060,7 +7060,6 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(socket_getpeersec_stream,
 			selinux_socket_getpeersec_stream),
 	LSM_HOOK_INIT(socket_getpeersec_dgram, selinux_socket_getpeersec_dgram),
-	LSM_HOOK_INIT(sk_alloc_security, selinux_sk_alloc_security),
 	LSM_HOOK_INIT(sk_free_security, selinux_sk_free_security),
 	LSM_HOOK_INIT(sk_clone_security, selinux_sk_clone_security),
 	LSM_HOOK_INIT(sk_getsecid, selinux_sk_getsecid),
@@ -7075,7 +7074,6 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(secmark_refcount_inc, selinux_secmark_refcount_inc),
 	LSM_HOOK_INIT(secmark_refcount_dec, selinux_secmark_refcount_dec),
 	LSM_HOOK_INIT(req_classify_flow, selinux_req_classify_flow),
-	LSM_HOOK_INIT(tun_dev_alloc_security, selinux_tun_dev_alloc_security),
 	LSM_HOOK_INIT(tun_dev_free_security, selinux_tun_dev_free_security),
 	LSM_HOOK_INIT(tun_dev_create, selinux_tun_dev_create),
 	LSM_HOOK_INIT(tun_dev_attach_queue, selinux_tun_dev_attach_queue),
@@ -7085,17 +7083,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(ib_pkey_access, selinux_ib_pkey_access),
 	LSM_HOOK_INIT(ib_endport_manage_subnet,
 		      selinux_ib_endport_manage_subnet),
-	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
 	LSM_HOOK_INIT(ib_free_security, selinux_ib_free_security),
 #endif
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
-	LSM_HOOK_INIT(xfrm_policy_alloc_security, selinux_xfrm_policy_alloc),
-	LSM_HOOK_INIT(xfrm_policy_clone_security, selinux_xfrm_policy_clone),
 	LSM_HOOK_INIT(xfrm_policy_free_security, selinux_xfrm_policy_free),
 	LSM_HOOK_INIT(xfrm_policy_delete_security, selinux_xfrm_policy_delete),
-	LSM_HOOK_INIT(xfrm_state_alloc, selinux_xfrm_state_alloc),
-	LSM_HOOK_INIT(xfrm_state_alloc_acquire,
-			selinux_xfrm_state_alloc_acquire),
 	LSM_HOOK_INIT(xfrm_state_free_security, selinux_xfrm_state_free),
 	LSM_HOOK_INIT(xfrm_state_delete_security, selinux_xfrm_state_delete),
 	LSM_HOOK_INIT(xfrm_policy_lookup, selinux_xfrm_policy_lookup),
@@ -7105,14 +7097,12 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 #endif
 
 #ifdef CONFIG_KEYS
-	LSM_HOOK_INIT(key_alloc, selinux_key_alloc),
 	LSM_HOOK_INIT(key_free, selinux_key_free),
 	LSM_HOOK_INIT(key_permission, selinux_key_permission),
 	LSM_HOOK_INIT(key_getsecurity, selinux_key_getsecurity),
 #endif
 
 #ifdef CONFIG_AUDIT
-	LSM_HOOK_INIT(audit_rule_init, selinux_audit_rule_init),
 	LSM_HOOK_INIT(audit_rule_known, selinux_audit_rule_known),
 	LSM_HOOK_INIT(audit_rule_match, selinux_audit_rule_match),
 	LSM_HOOK_INIT(audit_rule_free, selinux_audit_rule_free),
@@ -7122,21 +7112,66 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(bpf, selinux_bpf),
 	LSM_HOOK_INIT(bpf_map, selinux_bpf_map),
 	LSM_HOOK_INIT(bpf_prog, selinux_bpf_prog),
-	LSM_HOOK_INIT(bpf_map_alloc_security, selinux_bpf_map_alloc),
-	LSM_HOOK_INIT(bpf_prog_alloc_security, selinux_bpf_prog_alloc),
 	LSM_HOOK_INIT(bpf_map_free_security, selinux_bpf_map_free),
 	LSM_HOOK_INIT(bpf_prog_free_security, selinux_bpf_prog_free),
 #endif
 
 #ifdef CONFIG_PERF_EVENTS
 	LSM_HOOK_INIT(perf_event_open, selinux_perf_event_open),
-	LSM_HOOK_INIT(perf_event_alloc, selinux_perf_event_alloc),
 	LSM_HOOK_INIT(perf_event_free, selinux_perf_event_free),
 	LSM_HOOK_INIT(perf_event_read, selinux_perf_event_read),
 	LSM_HOOK_INIT(perf_event_write, selinux_perf_event_write),
 #endif
 
 	LSM_HOOK_INIT(locked_down, selinux_lockdown),
+
+	/*
+	 * PUT "CLONING" (ACCESSING + ALLOCATING) HOOKS HERE
+	 */
+	LSM_HOOK_INIT(fs_context_dup, selinux_fs_context_dup),
+	LSM_HOOK_INIT(fs_context_parse_param, selinux_fs_context_parse_param),
+	LSM_HOOK_INIT(sb_eat_lsm_opts, selinux_sb_eat_lsm_opts),
+	LSM_HOOK_INIT(sb_add_mnt_opt, selinux_add_mnt_opt),
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	LSM_HOOK_INIT(xfrm_policy_clone_security, selinux_xfrm_policy_clone),
+#endif
+
+	/*
+	 * PUT "ALLOCATING" HOOKS HERE
+	 */
+	LSM_HOOK_INIT(msg_msg_alloc_security, selinux_msg_msg_alloc_security),
+	LSM_HOOK_INIT(msg_queue_alloc_security,
+		      selinux_msg_queue_alloc_security),
+	LSM_HOOK_INIT(shm_alloc_security, selinux_shm_alloc_security),
+	LSM_HOOK_INIT(sb_alloc_security, selinux_sb_alloc_security),
+	LSM_HOOK_INIT(inode_alloc_security, selinux_inode_alloc_security),
+	LSM_HOOK_INIT(sem_alloc_security, selinux_sem_alloc_security),
+	LSM_HOOK_INIT(secid_to_secctx, selinux_secid_to_secctx),
+	LSM_HOOK_INIT(inode_getsecctx, selinux_inode_getsecctx),
+	LSM_HOOK_INIT(sk_alloc_security, selinux_sk_alloc_security),
+	LSM_HOOK_INIT(tun_dev_alloc_security, selinux_tun_dev_alloc_security),
+#ifdef CONFIG_SECURITY_INFINIBAND
+	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
+#endif
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+	LSM_HOOK_INIT(xfrm_policy_alloc_security, selinux_xfrm_policy_alloc),
+	LSM_HOOK_INIT(xfrm_state_alloc, selinux_xfrm_state_alloc),
+	LSM_HOOK_INIT(xfrm_state_alloc_acquire,
+		      selinux_xfrm_state_alloc_acquire),
+#endif
+#ifdef CONFIG_KEYS
+	LSM_HOOK_INIT(key_alloc, selinux_key_alloc),
+#endif
+#ifdef CONFIG_AUDIT
+	LSM_HOOK_INIT(audit_rule_init, selinux_audit_rule_init),
+#endif
+#ifdef CONFIG_BPF_SYSCALL
+	LSM_HOOK_INIT(bpf_map_alloc_security, selinux_bpf_map_alloc),
+	LSM_HOOK_INIT(bpf_prog_alloc_security, selinux_bpf_prog_alloc),
+#endif
+#ifdef CONFIG_PERF_EVENTS
+	LSM_HOOK_INIT(perf_event_alloc, selinux_perf_event_alloc),
+#endif
 };
 
 static __init int selinux_init(void)
@@ -7315,14 +7350,18 @@ int selinux_disable(struct selinux_state *state)
 
 	pr_info("SELinux:  Disabled at runtime.\n");
 
+	/*
+	 * Unregister netfilter hooks.
+	 * Must be done before security_delete_hooks() to avoid breaking
+	 * runtime disable.
+	 */
+	selinux_nf_ip_exit();
+
 	security_delete_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks));
 
 	/* Try to destroy the avc node cache */
 	avc_disable();
 
-	/* Unregister netfilter hooks. */
-	selinux_nf_ip_exit();
-
 	/* Unregister selinuxfs. */
 	exit_sel_fs();
 

