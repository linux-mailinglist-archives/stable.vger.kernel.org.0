Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193E54F2504
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiDEHoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiDEHoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:44:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C6F939FE;
        Tue,  5 Apr 2022 00:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEA2AB81B14;
        Tue,  5 Apr 2022 07:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F34C340EE;
        Tue,  5 Apr 2022 07:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144442;
        bh=sbrwT/SUZKgQS5k/o8rRHTPmV5lhx0fWxEXy5URgNCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ed0JQs2aQQL7eS6tXUYKpdi8tg5N7oVw6tqa8aanw1s5WzNJDWw1mLBVq2NYTiC8U
         lhz/xvzWTgzkScUzvtJWwGiO7BGIFrXVioklleIJ1h9Cjm0cg/8qloyHst8vUhsqSH
         ddB4+97C6d2toQGyD0BQlReMFprcbUlKLq+4y+o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 0045/1126] cifs: we do not need a spinlock around the tree access during umount
Date:   Tue,  5 Apr 2022 09:13:12 +0200
Message-Id: <20220405070408.882278419@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 9a14b65d590105d393b63f5320e1594edda7c672 upstream.

Remove the spinlock around the tree traversal as we are calling possibly
sleeping functions.
We do not need a spinlock here as there will be no modifications to this
tree at this point.

This prevents warnings like this to occur in dmesg:
[  653.774996] BUG: sleeping function called from invalid context at kernel/loc\
king/mutex.c:280
[  653.775088] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1827, nam\
e: umount
[  653.775152] preempt_count: 1, expected: 0
[  653.775191] CPU: 0 PID: 1827 Comm: umount Tainted: G        W  OE     5.17.0\
-rc7-00006-g4eb628dd74df #135
[  653.775195] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-\
1.fc33 04/01/2014
[  653.775197] Call Trace:
[  653.775199]  <TASK>
[  653.775202]  dump_stack_lvl+0x34/0x44
[  653.775209]  __might_resched.cold+0x13f/0x172
[  653.775213]  mutex_lock+0x75/0xf0
[  653.775217]  ? __mutex_lock_slowpath+0x10/0x10
[  653.775220]  ? _raw_write_lock_irq+0xd0/0xd0
[  653.775224]  ? dput+0x6b/0x360
[  653.775228]  cifs_kill_sb+0xff/0x1d0 [cifs]
[  653.775285]  deactivate_locked_super+0x85/0x130
[  653.775289]  cleanup_mnt+0x32c/0x4d0
[  653.775292]  ? path_umount+0x228/0x380
[  653.775296]  task_work_run+0xd8/0x180
[  653.775301]  exit_to_user_mode_loop+0x152/0x160
[  653.775306]  exit_to_user_mode_prepare+0x89/0xd0
[  653.775315]  syscall_exit_to_user_mode+0x12/0x30
[  653.775322]  do_syscall_64+0x48/0x90
[  653.775326]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 187af6e98b44e5d8f25e1d41a92db138eb54416f ("cifs: fix handlecache and multiuser")
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -266,7 +266,6 @@ static void cifs_kill_sb(struct super_bl
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
 	}
-	spin_lock(&cifs_sb->tlink_tree_lock);
 	node = rb_first(root);
 	while (node != NULL) {
 		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
@@ -280,7 +279,6 @@ static void cifs_kill_sb(struct super_bl
 		mutex_unlock(&cfid->fid_mutex);
 		node = rb_next(node);
 	}
-	spin_unlock(&cifs_sb->tlink_tree_lock);
 
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);


