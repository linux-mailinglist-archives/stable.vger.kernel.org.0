Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D18103F46
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbfKTPmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:42:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52838 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730066AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004b2-DM; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004ME-5a; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hulk Robot" <hulkci@huawei.com>,
        "Jason Wang" <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Yang Yingliang" <yangyingliang@huawei.com>
Date:   Wed, 20 Nov 2019 15:38:20 +0000
Message-ID: <lsq.1574264230.663866428@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 70/83] tun: fix use-after-free when register netdev
 failed
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

commit 77f22f92dff8e7b45c7786a430626d38071d4670 upstream.

I got a UAF repport in tun driver when doing fuzzy test:

[  466.269490] ==================================================================
[  466.271792] BUG: KASAN: use-after-free in tun_chr_read_iter+0x2ca/0x2d0
[  466.271806] Read of size 8 at addr ffff888372139250 by task tun-test/2699
[  466.271810]
[  466.271824] CPU: 1 PID: 2699 Comm: tun-test Not tainted 5.3.0-rc1-00001-g5a9433db2614-dirty #427
[  466.271833] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[  466.271838] Call Trace:
[  466.271858]  dump_stack+0xca/0x13e
[  466.271871]  ? tun_chr_read_iter+0x2ca/0x2d0
[  466.271890]  print_address_description+0x79/0x440
[  466.271906]  ? vprintk_func+0x5e/0xf0
[  466.271920]  ? tun_chr_read_iter+0x2ca/0x2d0
[  466.271935]  __kasan_report+0x15c/0x1df
[  466.271958]  ? tun_chr_read_iter+0x2ca/0x2d0
[  466.271976]  kasan_report+0xe/0x20
[  466.271987]  tun_chr_read_iter+0x2ca/0x2d0
[  466.272013]  do_iter_readv_writev+0x4b7/0x740
[  466.272032]  ? default_llseek+0x2d0/0x2d0
[  466.272072]  do_iter_read+0x1c5/0x5e0
[  466.272110]  vfs_readv+0x108/0x180
[  466.299007]  ? compat_rw_copy_check_uvector+0x440/0x440
[  466.299020]  ? fsnotify+0x888/0xd50
[  466.299040]  ? __fsnotify_parent+0xd0/0x350
[  466.299064]  ? fsnotify_first_mark+0x1e0/0x1e0
[  466.304548]  ? vfs_write+0x264/0x510
[  466.304569]  ? ksys_write+0x101/0x210
[  466.304591]  ? do_preadv+0x116/0x1a0
[  466.304609]  do_preadv+0x116/0x1a0
[  466.309829]  do_syscall_64+0xc8/0x600
[  466.309849]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  466.309861] RIP: 0033:0x4560f9
[  466.309875] Code: 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
[  466.309889] RSP: 002b:00007ffffa5166e8 EFLAGS: 00000206 ORIG_RAX: 0000000000000127
[  466.322992] RAX: ffffffffffffffda RBX: 0000000000400460 RCX: 00000000004560f9
[  466.322999] RDX: 0000000000000003 RSI: 00000000200008c0 RDI: 0000000000000003
[  466.323007] RBP: 00007ffffa516700 R08: 0000000000000004 R09: 0000000000000000
[  466.323014] R10: 0000000000000000 R11: 0000000000000206 R12: 000000000040cb10
[  466.323021] R13: 0000000000000000 R14: 00000000006d7018 R15: 0000000000000000
[  466.323057]
[  466.323064] Allocated by task 2605:
[  466.335165]  save_stack+0x19/0x80
[  466.336240]  __kasan_kmalloc.constprop.8+0xa0/0xd0
[  466.337755]  kmem_cache_alloc+0xe8/0x320
[  466.339050]  getname_flags+0xca/0x560
[  466.340229]  user_path_at_empty+0x2c/0x50
[  466.341508]  vfs_statx+0xe6/0x190
[  466.342619]  __do_sys_newstat+0x81/0x100
[  466.343908]  do_syscall_64+0xc8/0x600
[  466.345303]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  466.347034]
[  466.347517] Freed by task 2605:
[  466.348471]  save_stack+0x19/0x80
[  466.349476]  __kasan_slab_free+0x12e/0x180
[  466.350726]  kmem_cache_free+0xc8/0x430
[  466.351874]  putname+0xe2/0x120
[  466.352921]  filename_lookup+0x257/0x3e0
[  466.354319]  vfs_statx+0xe6/0x190
[  466.355498]  __do_sys_newstat+0x81/0x100
[  466.356889]  do_syscall_64+0xc8/0x600
[  466.358037]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  466.359567]
[  466.360050] The buggy address belongs to the object at ffff888372139100
[  466.360050]  which belongs to the cache names_cache of size 4096
[  466.363735] The buggy address is located 336 bytes inside of
[  466.363735]  4096-byte region [ffff888372139100, ffff88837213a100)
[  466.367179] The buggy address belongs to the page:
[  466.368604] page:ffffea000dc84e00 refcount:1 mapcount:0 mapping:ffff8883df1b4f00 index:0x0 compound_mapcount: 0
[  466.371582] flags: 0x2fffff80010200(slab|head)
[  466.372910] raw: 002fffff80010200 dead000000000100 dead000000000122 ffff8883df1b4f00
[  466.375209] raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
[  466.377778] page dumped because: kasan: bad access detected
[  466.379730]
[  466.380288] Memory state around the buggy address:
[  466.381844]  ffff888372139100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  466.384009]  ffff888372139180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  466.386131] >ffff888372139200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  466.388257]                                                  ^
[  466.390234]  ffff888372139280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  466.392512]  ffff888372139300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  466.394667] ==================================================================

tun_chr_read_iter() accessed the memory which freed by free_netdev()
called by tun_set_iff():

        CPUA                                           CPUB
  tun_set_iff()
    alloc_netdev_mqs()
    tun_attach()
                                                  tun_chr_read_iter()
                                                    tun_get()
                                                    tun_do_read()
                                                      tun_ring_recv()
    register_netdevice() <-- inject error
    goto err_detach
    tun_detach_all() <-- set RCV_SHUTDOWN
    free_netdev() <-- called from
                     err_free_dev path
      netdev_freemem() <-- free the memory
                        without check refcount
      (In this path, the refcount cannot prevent
       freeing the memory of dev, and the memory
       will be used by dev_put() called by
       tun_chr_read_iter() on CPUB.)
                                                     (Break from tun_ring_recv(),
                                                     because RCV_SHUTDOWN is set)
                                                   tun_put()
                                                     dev_put() <-- use the memory
                                                                   freed by netdev_freemem()

Put the publishing of tfile->tun after register_netdevice(),
so tun_get() won't get the tun pointer that freed by
err_detach path if register_netdevice() failed.

Fixes: eb0fb363f920 ("tuntap: attach queue 0 before registering netdevice")
Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/tun.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -528,7 +528,8 @@ static void tun_detach_all(struct net_de
 		module_put(THIS_MODULE);
 }
 
-static int tun_attach(struct tun_struct *tun, struct file *file, bool skip_filter)
+static int tun_attach(struct tun_struct *tun, struct file *file,
+		      bool skip_filter, bool publish_tun)
 {
 	struct tun_file *tfile = file->private_data;
 	int err;
@@ -561,7 +562,8 @@ static int tun_attach(struct tun_struct
 	}
 	tfile->queue_index = tun->numqueues;
 	tfile->socket.sk->sk_shutdown &= ~RCV_SHUTDOWN;
-	rcu_assign_pointer(tfile->tun, tun);
+	if (publish_tun)
+		rcu_assign_pointer(tfile->tun, tun);
 	rcu_assign_pointer(tun->tfiles[tun->numqueues], tfile);
 	tun->numqueues++;
 
@@ -1599,7 +1601,8 @@ static int tun_set_iff(struct net *net,
 		if (err < 0)
 			return err;
 
-		err = tun_attach(tun, file, ifr->ifr_flags & IFF_NOFILTER);
+		err = tun_attach(tun, file, ifr->ifr_flags & IFF_NOFILTER,
+				 true);
 		if (err < 0)
 			return err;
 
@@ -1678,13 +1681,17 @@ static int tun_set_iff(struct net *net,
 				       NETIF_F_HW_VLAN_STAG_TX);
 
 		INIT_LIST_HEAD(&tun->disabled);
-		err = tun_attach(tun, file, false);
+		err = tun_attach(tun, file, false, false);
 		if (err < 0)
 			goto err_free_flow;
 
 		err = register_netdevice(tun->dev);
 		if (err < 0)
 			goto err_detach;
+		/* free_netdev() won't check refcnt, to aovid race
+		 * with dev_put() we need publish tun after registration.
+		 */
+		rcu_assign_pointer(tfile->tun, tun);
 
 		if (device_create_file(&tun->dev->dev, &dev_attr_tun_flags) ||
 		    device_create_file(&tun->dev->dev, &dev_attr_owner) ||
@@ -1848,7 +1855,7 @@ static int tun_set_queue(struct file *fi
 		ret = security_tun_dev_attach_queue(tun->security);
 		if (ret < 0)
 			goto unlock;
-		ret = tun_attach(tun, file, false);
+		ret = tun_attach(tun, file, false, true);
 	} else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
 		tun = rtnl_dereference(tfile->tun);
 		if (!tun || !(tun->flags & TUN_TAP_MQ) || tfile->detached)

