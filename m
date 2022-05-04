Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC0551A877
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355691AbiEDRLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356849AbiEDRJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFC240A33;
        Wed,  4 May 2022 09:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE080616B8;
        Wed,  4 May 2022 16:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36067C385A5;
        Wed,  4 May 2022 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683358;
        bh=dF0EmH5rX/p6/vVhDhSdVqRIOShLnMTADUfEzcQ2mgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Or9WvxCBYZiCJIKgnPUDfxnozzP6msy42wpDgTyZRr2K8yeT0/20w0bDFP6MvwMs/
         TWRHH2B1AJGhqvw2n0oLN8UACemwG/LAYi8nPUMR5FGOsqPNySTGe1NTw/ds60RnW6
         fkVphcd5050uf/FZd1GX6d1SDQhnGbo0yrAXcjyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jirka Hladky <jhladky@redhat.com>,
        Tejun Heo <tj@kernel.org>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH 5.17 031/225] kernfs: fix NULL dereferencing in kernfs_remove
Date:   Wed,  4 May 2022 18:44:29 +0200
Message-Id: <20220504153113.041944007@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

commit ad8d869343ae4a07a2038a4ca923f699308c8323 upstream.

kernfs_remove supported NULL kernfs_node param to bail out but revent
per-fs lock change introduced regression that dereferencing the
param without NULL check so kernel goes crash.

This patch checks the NULL kernfs_node in kernfs_remove and if so,
just return.

Quote from bug report by Jirka

```
The bug is triggered by running NAS Parallel benchmark suite on
SuperMicro servers with 2x Xeon(R) Gold 6126 CPU. Here is the error
log:

[  247.035564] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  247.036009] #PF: supervisor read access in kernel mode
[  247.036009] #PF: error_code(0x0000) - not-present page
[  247.036009] PGD 0 P4D 0
[  247.036009] Oops: 0000 [#1] PREEMPT SMP PTI
[  247.058060] CPU: 1 PID: 6546 Comm: umount Not tainted
5.16.0393c3714081a53795bbff0e985d24146def6f57f+ #16
[  247.058060] Hardware name: Supermicro Super Server/X11DDW-L, BIOS
2.0b 03/07/2018
[  247.058060] RIP: 0010:kernfs_remove+0x8/0x50
[  247.058060] Code: 4c 89 e0 5b 5d 41 5c 41 5d 41 5e c3 49 c7 c4 f4
ff ff ff eb b2 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 0f 1f 44 00 00
41 54 55 <48> 8b 47 08 48 89 fd 48 85 c0 48 0f 44 c7 4c 8b 60 50 49 83
c4 60
[  247.058060] RSP: 0018:ffffbbfa48a27e48 EFLAGS: 00010246
[  247.058060] RAX: 0000000000000001 RBX: ffffffff89e31f98 RCX: 0000000080200018
[  247.058060] RDX: 0000000080200019 RSI: fffff6760786c900 RDI: 0000000000000000
[  247.058060] RBP: ffffffff89e31f98 R08: ffff926b61b24d00 R09: 0000000080200018
[  247.122048] R10: ffff926b61b24d00 R11: ffff926a8040c000 R12: ffff927bd09a2000
[  247.122048] R13: ffffffff89e31fa0 R14: dead000000000122 R15: dead000000000100
[  247.122048] FS:  00007f01be0a8c40(0000) GS:ffff926fa8e40000(0000)
knlGS:0000000000000000
[  247.122048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  247.122048] CR2: 0000000000000008 CR3: 00000001145c6003 CR4: 00000000007706e0
[  247.122048] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  247.122048] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  247.122048] PKRU: 55555554
[  247.122048] Call Trace:
[  247.122048]  <TASK>
[  247.122048]  rdt_kill_sb+0x29d/0x350
[  247.122048]  deactivate_locked_super+0x36/0xa0
[  247.122048]  cleanup_mnt+0x131/0x190
[  247.122048]  task_work_run+0x5c/0x90
[  247.122048]  exit_to_user_mode_prepare+0x229/0x230
[  247.122048]  syscall_exit_to_user_mode+0x18/0x40
[  247.122048]  do_syscall_64+0x48/0x90
[  247.122048]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  247.122048] RIP: 0033:0x7f01be2d735b
```

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215696
Link: https://lore.kernel.org/lkml/CAE4VaGDZr_4wzRn2___eDYRtmdPaGGJdzu_LCSkJYuY9BEO3cw@mail.gmail.com/
Fixes: 393c3714081a (kernfs: switch global kernfs_rwsem lock to per-fs lock)
Cc: stable@vger.kernel.org
Reported-by: Jirka Hladky <jhladky@redhat.com>
Tested-by: Jirka Hladky <jhladky@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Link: https://lore.kernel.org/r/20220427172152.3505364-1-minchan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1397,7 +1397,12 @@ static void __kernfs_remove(struct kernf
  */
 void kernfs_remove(struct kernfs_node *kn)
 {
-	struct kernfs_root *root = kernfs_root(kn);
+	struct kernfs_root *root;
+
+	if (!kn)
+		return;
+
+	root = kernfs_root(kn);
 
 	down_write(&root->kernfs_rwsem);
 	__kernfs_remove(kn);


