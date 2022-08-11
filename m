Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB7958FBAD
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiHKLyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbiHKLyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:54:20 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFF89750A
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 04:54:16 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gb36so33015945ejc.10
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 04:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=k5GZigCc0HksSDtPLa6/qnvMC6ao2GPu/vtsNeWXw+A=;
        b=KrpEJdKUiokOVFyXVxTSVYw5osDD3ytQJY6zbmM6TrfMs1M2ezlhtZQ4yvI2H901Ed
         WkcTNVEUzoGZXUUaKSHGWXrVoIO8amZyQREWqK1yfl/drn1jvB70j4qasVSmxfONcx/L
         TI+xOWUb5Btr5wS5ec93zVXLDxtD09rWShihGYToHM4dVISShICqnzEYZPe2gsj6CBTP
         u3zHUfsV1tKu9fzORZFeuTVHuPDo60q60n+rD1BV83Nx96wRawBPqIQ01V2IPIHje+wB
         VhLqok+2PGWQjW4L5g6TmqR1wEOYNk65+C9SOWsqOIoXAvEk96xDnYumSjjAqYS5gfUO
         0J+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=k5GZigCc0HksSDtPLa6/qnvMC6ao2GPu/vtsNeWXw+A=;
        b=6cLykuZq3pfp+906HhewiHDEtcHBnaW7azKxRiTk66t8fNZmMxzeSBOG1rHCWl8t7h
         awTuSdUIuP631YdagU3PMjhxl2UfvxtE3VI5hki2jHV9+NgjWiD1DbC1Nhuuwv3MOtpT
         92C0rD/zgisB1h9AU1sKpkPToedwrqSWQNJerB7pRAUrG/ShzcPtTJ+bJOhYOn6b+Con
         NlbYOGjdwfUVpVMiG4aWukmCJASa0072c3ZBQEpL9VJXAPwOYzE9ryPher7qXwqFlf89
         56700tTt/NkhhvHWR+Z2pE/tfXNAHNUnmeEhlTnaCpmDcLZVt3csbOivx5NdsJ8Nc82Y
         AxsQ==
X-Gm-Message-State: ACgBeo3/LifDhkevEjjjtnAJyeK6m+6bSDTqCBhmqdQcBet1LG4God36
        YgsCQ1AtPpEEyeL8uz6zotRlkcZmB90=
X-Google-Smtp-Source: AA6agR6XboKsACM/WxLFXGOqyYmnvyQ2qtxMuEDP4mo+ReHNgCXIz6HkVjT6keKMt1bHBSpCzfD7Ww==
X-Received: by 2002:a17:907:9816:b0:730:73fc:1fae with SMTP id ji22-20020a170907981600b0073073fc1faemr23370154ejc.310.1660218855434;
        Thu, 11 Aug 2022 04:54:15 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af09a700e423d3e6c12e483e.dip0.t-ipconnect.de. [2003:f6:af09:a700:e423:d3e6:c12e:483e])
        by smtp.googlemail.com with ESMTPSA id mb11-20020a170906eb0b00b0072f4f4dc038sm3396049ejb.42.2022.08.11.04.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 04:54:15 -0700 (PDT)
From:   Alexander Grund <theflamefire89@gmail.com>
To:     stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Alexander Grund <theflamefire89@gmail.com>
Subject: [PATCH 4.9 1/1] LSM: Initialize security_hook_heads upon registration.
Date:   Thu, 11 Aug 2022 13:53:40 +0200
Message-Id: <20220811115340.137901-2-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220811115340.137901-1-theflamefire89@gmail.com>
References: <20220811115340.137901-1-theflamefire89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 3dfc9b02864b19f4dab376f14479ee4ad1de6c9e upstream.

"struct security_hook_heads" is an array of "struct list_head"
where elements can be initialized just before registration.

There is no need to waste 350+ lines for initialization. Let's
initialize "struct security_hook_heads" just before registration.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
[ bp: 4.9 backported: Adjust for changed hooks and missing __lsm_ro_after_init ]
Signed-off-by: Alexander Grund <theflamefire89@gmail.com>
---
 security/security.c | 359 +-------------------------------------------
 1 file changed, 7 insertions(+), 352 deletions(-)

diff --git a/security/security.c b/security/security.c
index 5171c3cd1d304..edf0eacfc19a9 100644
--- a/security/security.c
+++ b/security/security.c
@@ -32,6 +32,7 @@
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
 
+struct security_hook_heads security_hook_heads;
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
@@ -53,6 +54,12 @@ static void __init do_security_initcalls(void)
  */
 int __init security_init(void)
 {
+	int i;
+	struct list_head *list = (struct list_head *) &security_hook_heads;
+
+	for (i = 0; i < sizeof(security_hook_heads) / sizeof(struct list_head);
+	     i++)
+		INIT_LIST_HEAD(&list[i]);
 	pr_info("Security Framework initialized\n");
 
 	/*
@@ -1590,355 +1597,3 @@ int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
 				actx);
 }
 #endif /* CONFIG_AUDIT */
-
-struct security_hook_heads security_hook_heads = {
-	.binder_set_context_mgr =
-		LIST_HEAD_INIT(security_hook_heads.binder_set_context_mgr),
-	.binder_transaction =
-		LIST_HEAD_INIT(security_hook_heads.binder_transaction),
-	.binder_transfer_binder =
-		LIST_HEAD_INIT(security_hook_heads.binder_transfer_binder),
-	.binder_transfer_file =
-		LIST_HEAD_INIT(security_hook_heads.binder_transfer_file),
-
-	.ptrace_access_check =
-		LIST_HEAD_INIT(security_hook_heads.ptrace_access_check),
-	.ptrace_traceme =
-		LIST_HEAD_INIT(security_hook_heads.ptrace_traceme),
-	.capget =	LIST_HEAD_INIT(security_hook_heads.capget),
-	.capset =	LIST_HEAD_INIT(security_hook_heads.capset),
-	.capable =	LIST_HEAD_INIT(security_hook_heads.capable),
-	.quotactl =	LIST_HEAD_INIT(security_hook_heads.quotactl),
-	.quota_on =	LIST_HEAD_INIT(security_hook_heads.quota_on),
-	.syslog =	LIST_HEAD_INIT(security_hook_heads.syslog),
-	.settime =	LIST_HEAD_INIT(security_hook_heads.settime),
-	.vm_enough_memory =
-		LIST_HEAD_INIT(security_hook_heads.vm_enough_memory),
-	.bprm_set_creds =
-		LIST_HEAD_INIT(security_hook_heads.bprm_set_creds),
-	.bprm_check_security =
-		LIST_HEAD_INIT(security_hook_heads.bprm_check_security),
-	.bprm_secureexec =
-		LIST_HEAD_INIT(security_hook_heads.bprm_secureexec),
-	.bprm_committing_creds =
-		LIST_HEAD_INIT(security_hook_heads.bprm_committing_creds),
-	.bprm_committed_creds =
-		LIST_HEAD_INIT(security_hook_heads.bprm_committed_creds),
-	.sb_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.sb_alloc_security),
-	.sb_free_security =
-		LIST_HEAD_INIT(security_hook_heads.sb_free_security),
-	.sb_copy_data =	LIST_HEAD_INIT(security_hook_heads.sb_copy_data),
-	.sb_remount =	LIST_HEAD_INIT(security_hook_heads.sb_remount),
-	.sb_kern_mount =
-		LIST_HEAD_INIT(security_hook_heads.sb_kern_mount),
-	.sb_show_options =
-		LIST_HEAD_INIT(security_hook_heads.sb_show_options),
-	.sb_statfs =	LIST_HEAD_INIT(security_hook_heads.sb_statfs),
-	.sb_mount =	LIST_HEAD_INIT(security_hook_heads.sb_mount),
-	.sb_umount =	LIST_HEAD_INIT(security_hook_heads.sb_umount),
-	.sb_pivotroot =	LIST_HEAD_INIT(security_hook_heads.sb_pivotroot),
-	.sb_set_mnt_opts =
-		LIST_HEAD_INIT(security_hook_heads.sb_set_mnt_opts),
-	.sb_clone_mnt_opts =
-		LIST_HEAD_INIT(security_hook_heads.sb_clone_mnt_opts),
-	.sb_parse_opts_str =
-		LIST_HEAD_INIT(security_hook_heads.sb_parse_opts_str),
-	.dentry_init_security =
-		LIST_HEAD_INIT(security_hook_heads.dentry_init_security),
-	.dentry_create_files_as =
-		LIST_HEAD_INIT(security_hook_heads.dentry_create_files_as),
-#ifdef CONFIG_SECURITY_PATH
-	.path_unlink =	LIST_HEAD_INIT(security_hook_heads.path_unlink),
-	.path_mkdir =	LIST_HEAD_INIT(security_hook_heads.path_mkdir),
-	.path_rmdir =	LIST_HEAD_INIT(security_hook_heads.path_rmdir),
-	.path_mknod =	LIST_HEAD_INIT(security_hook_heads.path_mknod),
-	.path_truncate =
-		LIST_HEAD_INIT(security_hook_heads.path_truncate),
-	.path_symlink =	LIST_HEAD_INIT(security_hook_heads.path_symlink),
-	.path_link =	LIST_HEAD_INIT(security_hook_heads.path_link),
-	.path_rename =	LIST_HEAD_INIT(security_hook_heads.path_rename),
-	.path_chmod =	LIST_HEAD_INIT(security_hook_heads.path_chmod),
-	.path_chown =	LIST_HEAD_INIT(security_hook_heads.path_chown),
-	.path_chroot =	LIST_HEAD_INIT(security_hook_heads.path_chroot),
-#endif
-	.inode_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.inode_alloc_security),
-	.inode_free_security =
-		LIST_HEAD_INIT(security_hook_heads.inode_free_security),
-	.inode_init_security =
-		LIST_HEAD_INIT(security_hook_heads.inode_init_security),
-	.inode_create =	LIST_HEAD_INIT(security_hook_heads.inode_create),
-	.inode_link =	LIST_HEAD_INIT(security_hook_heads.inode_link),
-	.inode_unlink =	LIST_HEAD_INIT(security_hook_heads.inode_unlink),
-	.inode_symlink =
-		LIST_HEAD_INIT(security_hook_heads.inode_symlink),
-	.inode_mkdir =	LIST_HEAD_INIT(security_hook_heads.inode_mkdir),
-	.inode_rmdir =	LIST_HEAD_INIT(security_hook_heads.inode_rmdir),
-	.inode_mknod =	LIST_HEAD_INIT(security_hook_heads.inode_mknod),
-	.inode_rename =	LIST_HEAD_INIT(security_hook_heads.inode_rename),
-	.inode_readlink =
-		LIST_HEAD_INIT(security_hook_heads.inode_readlink),
-	.inode_follow_link =
-		LIST_HEAD_INIT(security_hook_heads.inode_follow_link),
-	.inode_permission =
-		LIST_HEAD_INIT(security_hook_heads.inode_permission),
-	.inode_setattr =
-		LIST_HEAD_INIT(security_hook_heads.inode_setattr),
-	.inode_getattr =
-		LIST_HEAD_INIT(security_hook_heads.inode_getattr),
-	.inode_setxattr =
-		LIST_HEAD_INIT(security_hook_heads.inode_setxattr),
-	.inode_post_setxattr =
-		LIST_HEAD_INIT(security_hook_heads.inode_post_setxattr),
-	.inode_getxattr =
-		LIST_HEAD_INIT(security_hook_heads.inode_getxattr),
-	.inode_listxattr =
-		LIST_HEAD_INIT(security_hook_heads.inode_listxattr),
-	.inode_removexattr =
-		LIST_HEAD_INIT(security_hook_heads.inode_removexattr),
-	.inode_need_killpriv =
-		LIST_HEAD_INIT(security_hook_heads.inode_need_killpriv),
-	.inode_killpriv =
-		LIST_HEAD_INIT(security_hook_heads.inode_killpriv),
-	.inode_getsecurity =
-		LIST_HEAD_INIT(security_hook_heads.inode_getsecurity),
-	.inode_setsecurity =
-		LIST_HEAD_INIT(security_hook_heads.inode_setsecurity),
-	.inode_listsecurity =
-		LIST_HEAD_INIT(security_hook_heads.inode_listsecurity),
-	.inode_getsecid =
-		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
-	.inode_copy_up =
-		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
-	.inode_copy_up_xattr =
-		LIST_HEAD_INIT(security_hook_heads.inode_copy_up_xattr),
-	.file_permission =
-		LIST_HEAD_INIT(security_hook_heads.file_permission),
-	.file_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.file_alloc_security),
-	.file_free_security =
-		LIST_HEAD_INIT(security_hook_heads.file_free_security),
-	.file_ioctl =	LIST_HEAD_INIT(security_hook_heads.file_ioctl),
-	.mmap_addr =	LIST_HEAD_INIT(security_hook_heads.mmap_addr),
-	.mmap_file =	LIST_HEAD_INIT(security_hook_heads.mmap_file),
-	.file_mprotect =
-		LIST_HEAD_INIT(security_hook_heads.file_mprotect),
-	.file_lock =	LIST_HEAD_INIT(security_hook_heads.file_lock),
-	.file_fcntl =	LIST_HEAD_INIT(security_hook_heads.file_fcntl),
-	.file_set_fowner =
-		LIST_HEAD_INIT(security_hook_heads.file_set_fowner),
-	.file_send_sigiotask =
-		LIST_HEAD_INIT(security_hook_heads.file_send_sigiotask),
-	.file_receive =	LIST_HEAD_INIT(security_hook_heads.file_receive),
-	.file_open =	LIST_HEAD_INIT(security_hook_heads.file_open),
-	.task_create =	LIST_HEAD_INIT(security_hook_heads.task_create),
-	.task_free =	LIST_HEAD_INIT(security_hook_heads.task_free),
-	.cred_alloc_blank =
-		LIST_HEAD_INIT(security_hook_heads.cred_alloc_blank),
-	.cred_free =	LIST_HEAD_INIT(security_hook_heads.cred_free),
-	.cred_prepare =	LIST_HEAD_INIT(security_hook_heads.cred_prepare),
-	.cred_transfer =
-		LIST_HEAD_INIT(security_hook_heads.cred_transfer),
-	.kernel_act_as =
-		LIST_HEAD_INIT(security_hook_heads.kernel_act_as),
-	.kernel_create_files_as =
-		LIST_HEAD_INIT(security_hook_heads.kernel_create_files_as),
-	.kernel_module_request =
-		LIST_HEAD_INIT(security_hook_heads.kernel_module_request),
-	.kernel_read_file =
-		LIST_HEAD_INIT(security_hook_heads.kernel_read_file),
-	.kernel_post_read_file =
-		LIST_HEAD_INIT(security_hook_heads.kernel_post_read_file),
-	.task_fix_setuid =
-		LIST_HEAD_INIT(security_hook_heads.task_fix_setuid),
-	.task_setpgid =	LIST_HEAD_INIT(security_hook_heads.task_setpgid),
-	.task_getpgid =	LIST_HEAD_INIT(security_hook_heads.task_getpgid),
-	.task_getsid =	LIST_HEAD_INIT(security_hook_heads.task_getsid),
-	.task_getsecid =
-		LIST_HEAD_INIT(security_hook_heads.task_getsecid),
-	.task_setnice =	LIST_HEAD_INIT(security_hook_heads.task_setnice),
-	.task_setioprio =
-		LIST_HEAD_INIT(security_hook_heads.task_setioprio),
-	.task_getioprio =
-		LIST_HEAD_INIT(security_hook_heads.task_getioprio),
-	.task_setrlimit =
-		LIST_HEAD_INIT(security_hook_heads.task_setrlimit),
-	.task_setscheduler =
-		LIST_HEAD_INIT(security_hook_heads.task_setscheduler),
-	.task_getscheduler =
-		LIST_HEAD_INIT(security_hook_heads.task_getscheduler),
-	.task_movememory =
-		LIST_HEAD_INIT(security_hook_heads.task_movememory),
-	.task_kill =	LIST_HEAD_INIT(security_hook_heads.task_kill),
-	.task_prctl =	LIST_HEAD_INIT(security_hook_heads.task_prctl),
-	.task_to_inode =
-		LIST_HEAD_INIT(security_hook_heads.task_to_inode),
-	.ipc_permission =
-		LIST_HEAD_INIT(security_hook_heads.ipc_permission),
-	.ipc_getsecid =	LIST_HEAD_INIT(security_hook_heads.ipc_getsecid),
-	.msg_msg_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.msg_msg_alloc_security),
-	.msg_msg_free_security =
-		LIST_HEAD_INIT(security_hook_heads.msg_msg_free_security),
-	.msg_queue_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.msg_queue_alloc_security),
-	.msg_queue_free_security =
-		LIST_HEAD_INIT(security_hook_heads.msg_queue_free_security),
-	.msg_queue_associate =
-		LIST_HEAD_INIT(security_hook_heads.msg_queue_associate),
-	.msg_queue_msgctl =
-		LIST_HEAD_INIT(security_hook_heads.msg_queue_msgctl),
-	.msg_queue_msgsnd =
-		LIST_HEAD_INIT(security_hook_heads.msg_queue_msgsnd),
-	.msg_queue_msgrcv =
-		LIST_HEAD_INIT(security_hook_heads.msg_queue_msgrcv),
-	.shm_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.shm_alloc_security),
-	.shm_free_security =
-		LIST_HEAD_INIT(security_hook_heads.shm_free_security),
-	.shm_associate =
-		LIST_HEAD_INIT(security_hook_heads.shm_associate),
-	.shm_shmctl =	LIST_HEAD_INIT(security_hook_heads.shm_shmctl),
-	.shm_shmat =	LIST_HEAD_INIT(security_hook_heads.shm_shmat),
-	.sem_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.sem_alloc_security),
-	.sem_free_security =
-		LIST_HEAD_INIT(security_hook_heads.sem_free_security),
-	.sem_associate =
-		LIST_HEAD_INIT(security_hook_heads.sem_associate),
-	.sem_semctl =	LIST_HEAD_INIT(security_hook_heads.sem_semctl),
-	.sem_semop =	LIST_HEAD_INIT(security_hook_heads.sem_semop),
-	.netlink_send =	LIST_HEAD_INIT(security_hook_heads.netlink_send),
-	.d_instantiate =
-		LIST_HEAD_INIT(security_hook_heads.d_instantiate),
-	.getprocattr =	LIST_HEAD_INIT(security_hook_heads.getprocattr),
-	.setprocattr =	LIST_HEAD_INIT(security_hook_heads.setprocattr),
-	.ismaclabel =	LIST_HEAD_INIT(security_hook_heads.ismaclabel),
-	.secid_to_secctx =
-		LIST_HEAD_INIT(security_hook_heads.secid_to_secctx),
-	.secctx_to_secid =
-		LIST_HEAD_INIT(security_hook_heads.secctx_to_secid),
-	.release_secctx =
-		LIST_HEAD_INIT(security_hook_heads.release_secctx),
-	.inode_invalidate_secctx =
-		LIST_HEAD_INIT(security_hook_heads.inode_invalidate_secctx),
-	.inode_notifysecctx =
-		LIST_HEAD_INIT(security_hook_heads.inode_notifysecctx),
-	.inode_setsecctx =
-		LIST_HEAD_INIT(security_hook_heads.inode_setsecctx),
-	.inode_getsecctx =
-		LIST_HEAD_INIT(security_hook_heads.inode_getsecctx),
-#ifdef CONFIG_SECURITY_NETWORK
-	.unix_stream_connect =
-		LIST_HEAD_INIT(security_hook_heads.unix_stream_connect),
-	.unix_may_send =
-		LIST_HEAD_INIT(security_hook_heads.unix_may_send),
-	.socket_create =
-		LIST_HEAD_INIT(security_hook_heads.socket_create),
-	.socket_post_create =
-		LIST_HEAD_INIT(security_hook_heads.socket_post_create),
-	.socket_bind =	LIST_HEAD_INIT(security_hook_heads.socket_bind),
-	.socket_connect =
-		LIST_HEAD_INIT(security_hook_heads.socket_connect),
-	.socket_listen =
-		LIST_HEAD_INIT(security_hook_heads.socket_listen),
-	.socket_accept =
-		LIST_HEAD_INIT(security_hook_heads.socket_accept),
-	.socket_sendmsg =
-		LIST_HEAD_INIT(security_hook_heads.socket_sendmsg),
-	.socket_recvmsg =
-		LIST_HEAD_INIT(security_hook_heads.socket_recvmsg),
-	.socket_getsockname =
-		LIST_HEAD_INIT(security_hook_heads.socket_getsockname),
-	.socket_getpeername =
-		LIST_HEAD_INIT(security_hook_heads.socket_getpeername),
-	.socket_getsockopt =
-		LIST_HEAD_INIT(security_hook_heads.socket_getsockopt),
-	.socket_setsockopt =
-		LIST_HEAD_INIT(security_hook_heads.socket_setsockopt),
-	.socket_shutdown =
-		LIST_HEAD_INIT(security_hook_heads.socket_shutdown),
-	.socket_sock_rcv_skb =
-		LIST_HEAD_INIT(security_hook_heads.socket_sock_rcv_skb),
-	.socket_getpeersec_stream =
-		LIST_HEAD_INIT(security_hook_heads.socket_getpeersec_stream),
-	.socket_getpeersec_dgram =
-		LIST_HEAD_INIT(security_hook_heads.socket_getpeersec_dgram),
-	.sk_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.sk_alloc_security),
-	.sk_free_security =
-		LIST_HEAD_INIT(security_hook_heads.sk_free_security),
-	.sk_clone_security =
-		LIST_HEAD_INIT(security_hook_heads.sk_clone_security),
-	.sk_getsecid =	LIST_HEAD_INIT(security_hook_heads.sk_getsecid),
-	.sock_graft =	LIST_HEAD_INIT(security_hook_heads.sock_graft),
-	.inet_conn_request =
-		LIST_HEAD_INIT(security_hook_heads.inet_conn_request),
-	.inet_csk_clone =
-		LIST_HEAD_INIT(security_hook_heads.inet_csk_clone),
-	.inet_conn_established =
-		LIST_HEAD_INIT(security_hook_heads.inet_conn_established),
-	.secmark_relabel_packet =
-		LIST_HEAD_INIT(security_hook_heads.secmark_relabel_packet),
-	.secmark_refcount_inc =
-		LIST_HEAD_INIT(security_hook_heads.secmark_refcount_inc),
-	.secmark_refcount_dec =
-		LIST_HEAD_INIT(security_hook_heads.secmark_refcount_dec),
-	.req_classify_flow =
-		LIST_HEAD_INIT(security_hook_heads.req_classify_flow),
-	.tun_dev_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.tun_dev_alloc_security),
-	.tun_dev_free_security =
-		LIST_HEAD_INIT(security_hook_heads.tun_dev_free_security),
-	.tun_dev_create =
-		LIST_HEAD_INIT(security_hook_heads.tun_dev_create),
-	.tun_dev_attach_queue =
-		LIST_HEAD_INIT(security_hook_heads.tun_dev_attach_queue),
-	.tun_dev_attach =
-		LIST_HEAD_INIT(security_hook_heads.tun_dev_attach),
-	.tun_dev_open =	LIST_HEAD_INIT(security_hook_heads.tun_dev_open),
-#endif	/* CONFIG_SECURITY_NETWORK */
-#ifdef CONFIG_SECURITY_NETWORK_XFRM
-	.xfrm_policy_alloc_security =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_alloc_security),
-	.xfrm_policy_clone_security =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_clone_security),
-	.xfrm_policy_free_security =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_free_security),
-	.xfrm_policy_delete_security =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_delete_security),
-	.xfrm_state_alloc =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_state_alloc),
-	.xfrm_state_alloc_acquire =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_state_alloc_acquire),
-	.xfrm_state_free_security =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_state_free_security),
-	.xfrm_state_delete_security =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_state_delete_security),
-	.xfrm_policy_lookup =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_lookup),
-	.xfrm_state_pol_flow_match =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_state_pol_flow_match),
-	.xfrm_decode_session =
-		LIST_HEAD_INIT(security_hook_heads.xfrm_decode_session),
-#endif	/* CONFIG_SECURITY_NETWORK_XFRM */
-#ifdef CONFIG_KEYS
-	.key_alloc =	LIST_HEAD_INIT(security_hook_heads.key_alloc),
-	.key_free =	LIST_HEAD_INIT(security_hook_heads.key_free),
-	.key_permission =
-		LIST_HEAD_INIT(security_hook_heads.key_permission),
-	.key_getsecurity =
-		LIST_HEAD_INIT(security_hook_heads.key_getsecurity),
-#endif	/* CONFIG_KEYS */
-#ifdef CONFIG_AUDIT
-	.audit_rule_init =
-		LIST_HEAD_INIT(security_hook_heads.audit_rule_init),
-	.audit_rule_known =
-		LIST_HEAD_INIT(security_hook_heads.audit_rule_known),
-	.audit_rule_match =
-		LIST_HEAD_INIT(security_hook_heads.audit_rule_match),
-	.audit_rule_free =
-		LIST_HEAD_INIT(security_hook_heads.audit_rule_free),
-#endif /* CONFIG_AUDIT */
-};
-- 
2.25.1

