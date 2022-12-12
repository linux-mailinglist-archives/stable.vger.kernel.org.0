Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D74164A0B4
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiLLN3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbiLLN3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:29:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5AC259
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:29:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B51B61053
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48B1C433EF;
        Mon, 12 Dec 2022 13:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851740;
        bh=LRfe16lCtSJyGtjW8AgZg6bL1gxLZ0gvVfSkxgU0NuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3KBIr0qU8/jcc/4aCZayprsA/6Nvia6kfcKBOcNisJws/osfbRoxfnoyD8Vwt7Of
         TeA3ZWIOCEo6b0NAOrNLy2ZufZ6OFu4jPCpSbrNXkkLc8Kfqp3ZU3jkxJ7atU/Yrjt
         e9d9LtrwYbk+zD6yWjkIneue/v72VSNUpFJfLxVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zeng Heng <zengheng4@huawei.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/123] cifs: fix use-after-free caused by invalid pointer `hostname`
Date:   Mon, 12 Dec 2022 14:16:40 +0100
Message-Id: <20221212130928.344469149@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 153695d36ead0ccc4d0256953c751cabf673e621 ]

`hostname` needs to be set as null-pointer after free in
`cifs_put_tcp_session` function, or when `cifsd` thread attempts
to resolve hostname and reconnect the host, the thread would deref
the invalid pointer.

Here is one of practical backtrace examples as reference:

Task 477
---------------------------
 do_mount
  path_mount
   do_new_mount
    vfs_get_tree
     smb3_get_tree
      smb3_get_tree_common
       cifs_smb3_do_mount
        cifs_mount
         mount_put_conns
          cifs_put_tcp_session
          --> kfree(server->hostname)

cifsd
---------------------------
 kthread
  cifs_demultiplex_thread
   cifs_reconnect
    reconn_set_ipaddr_from_hostname
    --> if (!server->hostname)
    --> if (server->hostname[0] == '\0')  // !! UAF fault here

CIFS: VFS: cifs_mount failed w/return code = -112
mount error(112): Host is down
BUG: KASAN: use-after-free in reconn_set_ipaddr_from_hostname+0x2ba/0x310
Read of size 1 at addr ffff888108f35380 by task cifsd/480
CPU: 2 PID: 480 Comm: cifsd Not tainted 6.1.0-rc2-00106-gf705792f89dd-dirty #25
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x68/0x85
 print_report+0x16c/0x4a3
 kasan_report+0x95/0x190
 reconn_set_ipaddr_from_hostname+0x2ba/0x310
 __cifs_reconnect.part.0+0x241/0x800
 cifs_reconnect+0x65f/0xb60
 cifs_demultiplex_thread+0x1570/0x2570
 kthread+0x2c5/0x380
 ret_from_fork+0x22/0x30
 </TASK>
Allocated by task 477:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x7e/0x90
 __kmalloc_node_track_caller+0x52/0x1b0
 kstrdup+0x3b/0x70
 cifs_get_tcp_session+0xbc/0x19b0
 mount_get_conns+0xa9/0x10c0
 cifs_mount+0xdf/0x1970
 cifs_smb3_do_mount+0x295/0x1660
 smb3_get_tree+0x352/0x5e0
 vfs_get_tree+0x8e/0x2e0
 path_mount+0xf8c/0x1990
 do_mount+0xee/0x110
 __x64_sys_mount+0x14b/0x1f0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
Freed by task 477:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x50
 __kasan_slab_free+0x10a/0x190
 __kmem_cache_free+0xca/0x3f0
 cifs_put_tcp_session+0x30c/0x450
 cifs_mount+0xf95/0x1970
 cifs_smb3_do_mount+0x295/0x1660
 smb3_get_tree+0x352/0x5e0
 vfs_get_tree+0x8e/0x2e0
 path_mount+0xf8c/0x1990
 do_mount+0xee/0x110
 __x64_sys_mount+0x14b/0x1f0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
The buggy address belongs to the object at ffff888108f35380
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 0 bytes inside of
 16-byte region [ffff888108f35380, ffff888108f35390)
The buggy address belongs to the physical page:
page:00000000333f8e58 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888108f350e0 pfn:0x108f35
flags: 0x200000000000200(slab|node=0|zone=2)
raw: 0200000000000200 0000000000000000 dead000000000122 ffff8881000423c0
raw: ffff888108f350e0 000000008080007a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff888108f35280: fa fb fc fc fa fb fc fc fa fb fc fc fa fb fc fc
 ffff888108f35300: fa fb fc fc fa fb fc fc fa fb fc fc fa fb fc fc
>ffff888108f35380: fa fb fc fc fa fb fc fc fa fb fc fc fa fb fc fc
                   ^
 ffff888108f35400: fa fb fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888108f35480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

Fixes: 7be3248f3139 ("cifs: To match file servers, make sure the server hostname matches")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c6e2a0ff8f0c..a4284c4d7e03 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1392,6 +1392,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
 	kfree(server->hostname);
+	server->hostname = NULL;
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
-- 
2.35.1



