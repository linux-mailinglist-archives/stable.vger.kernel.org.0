Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C50F7C86
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfKKSrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbfKKSrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 289842173B;
        Mon, 11 Nov 2019 18:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498021;
        bh=6mYWoWCr+wnP85dfUqdvwRiIq3qhD6vYLfspAb68KTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=my7UUj3dd3ODfP3WeuCmmvsfKnfE9aqZjy1GNFVZz8gSAOEBA45+TR8g3ir+UxDHb
         iVwcTP3hyXmuF1E5wc/5quFEOTo/Nove14KiTJMzVVae7Y3znxNpFUSWo95QJVNCYY
         +ewpONPg/hg/XWyNWiv+0jKBI9EK5ja1g1iM8hN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/125] ipvs: dont ignore errors in case refcounting ip_vs module fails
Date:   Mon, 11 Nov 2019 19:28:44 +0100
Message-Id: <20191111181451.515223862@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 62931f59ce9cbabb934a431f48f2f1f441c605ac ]

if the IPVS module is removed while the sync daemon is starting, there is
a small gap where try_module_get() might fail getting the refcount inside
ip_vs_use_count_inc(). Then, the refcounts of IPVS module are unbalanced,
and the subsequent call to stop_sync_thread() causes the following splat:

 WARNING: CPU: 0 PID: 4013 at kernel/module.c:1146 module_put.part.44+0x15b/0x290
  Modules linked in: ip_vs(-) nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 veth ip6table_filter ip6_tables iptable_filter binfmt_misc intel_rapl_msr intel_rapl_common crct10dif_pclmul crc32_pclmul ext4 mbcache jbd2 ghash_clmulni_intel snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_nhlt snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm aesni_intel crypto_simd cryptd glue_helper joydev pcspkr snd_timer virtio_balloon snd soundcore i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c ata_generic pata_acpi virtio_net net_failover virtio_blk failover virtio_console qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ata_piix ttm crc32c_intel serio_raw drm virtio_pci libata virtio_ring virtio floppy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: nf_defrag_ipv6]
  CPU: 0 PID: 4013 Comm: modprobe Tainted: G        W         5.4.0-rc1.upstream+ #741
  Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
  RIP: 0010:module_put.part.44+0x15b/0x290
  Code: 04 25 28 00 00 00 0f 85 18 01 00 00 48 83 c4 68 5b 5d 41 5c 41 5d 41 5e 41 5f c3 89 44 24 28 83 e8 01 89 c5 0f 89 57 ff ff ff <0f> 0b e9 78 ff ff ff 65 8b 1d 67 83 26 4a 89 db be 08 00 00 00 48
  RSP: 0018:ffff888050607c78 EFLAGS: 00010297
  RAX: 0000000000000003 RBX: ffffffffc1420590 RCX: ffffffffb5db0ef9
  RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffffc1420590
  RBP: 00000000ffffffff R08: fffffbfff82840b3 R09: fffffbfff82840b3
  R10: 0000000000000001 R11: fffffbfff82840b2 R12: 1ffff1100a0c0f90
  R13: ffffffffc1420200 R14: ffff88804f533300 R15: ffff88804f533ca0
  FS:  00007f8ea9720740(0000) GS:ffff888053800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f3245abe000 CR3: 000000004c28a006 CR4: 00000000001606f0
  Call Trace:
   stop_sync_thread+0x3a3/0x7c0 [ip_vs]
   ip_vs_sync_net_cleanup+0x13/0x50 [ip_vs]
   ops_exit_list.isra.5+0x94/0x140
   unregister_pernet_operations+0x29d/0x460
   unregister_pernet_device+0x26/0x60
   ip_vs_cleanup+0x11/0x38 [ip_vs]
   __x64_sys_delete_module+0x2d5/0x400
   do_syscall_64+0xa5/0x4e0
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7f8ea8bf0db7
  Code: 73 01 c3 48 8b 0d b9 80 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 89 80 2c 00 f7 d8 64 89 01 48
  RSP: 002b:00007ffcd38d2fe8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
  RAX: ffffffffffffffda RBX: 0000000002436240 RCX: 00007f8ea8bf0db7
  RDX: 0000000000000000 RSI: 0000000000000800 RDI: 00000000024362a8
  RBP: 0000000000000000 R08: 00007f8ea8eba060 R09: 00007f8ea8c658a0
  R10: 00007ffcd38d2a60 R11: 0000000000000206 R12: 0000000000000000
  R13: 0000000000000001 R14: 00000000024362a8 R15: 0000000000000000
  irq event stamp: 4538
  hardirqs last  enabled at (4537): [<ffffffffb6193dde>] quarantine_put+0x9e/0x170
  hardirqs last disabled at (4538): [<ffffffffb5a0556a>] trace_hardirqs_off_thunk+0x1a/0x20
  softirqs last  enabled at (4522): [<ffffffffb6f8ebe9>] sk_common_release+0x169/0x2d0
  softirqs last disabled at (4520): [<ffffffffb6f8eb3e>] sk_common_release+0xbe/0x2d0

Check the return value of ip_vs_use_count_inc() and let its caller return
proper error. Inside do_ip_vs_set_ctl() the module is already refcounted,
we don't need refcount/derefcount there. Finally, in register_ip_vs_app()
and start_sync_thread(), take the module refcount earlier and ensure it's
released in the error path.

Change since v1:
 - better return values in case of failure of ip_vs_use_count_inc(),
   thanks to Julian Anastasov
 - no need to increase/decrease the module refcount in ip_vs_set_ctl(),
   thanks to Julian Anastasov

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_app.c   | 12 ++++++++++--
 net/netfilter/ipvs/ip_vs_ctl.c   | 14 ++++----------
 net/netfilter/ipvs/ip_vs_pe.c    |  3 ++-
 net/netfilter/ipvs/ip_vs_sched.c |  3 ++-
 net/netfilter/ipvs/ip_vs_sync.c  | 13 ++++++++++---
 5 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 7588aeaa605ff..80759aadd3e06 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -198,21 +198,29 @@ struct ip_vs_app *register_ip_vs_app(struct netns_ipvs *ipvs, struct ip_vs_app *
 
 	mutex_lock(&__ip_vs_app_mutex);
 
+	/* increase the module use count */
+	if (!ip_vs_use_count_inc()) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
 	list_for_each_entry(a, &ipvs->app_list, a_list) {
 		if (!strcmp(app->name, a->name)) {
 			err = -EEXIST;
+			/* decrease the module use count */
+			ip_vs_use_count_dec();
 			goto out_unlock;
 		}
 	}
 	a = kmemdup(app, sizeof(*app), GFP_KERNEL);
 	if (!a) {
 		err = -ENOMEM;
+		/* decrease the module use count */
+		ip_vs_use_count_dec();
 		goto out_unlock;
 	}
 	INIT_LIST_HEAD(&a->incs_list);
 	list_add(&a->a_list, &ipvs->app_list);
-	/* increase the module use count */
-	ip_vs_use_count_inc();
 
 out_unlock:
 	mutex_unlock(&__ip_vs_app_mutex);
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 3df94a4991266..b2134c3894289 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1204,7 +1204,8 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	struct ip_vs_service *svc = NULL;
 
 	/* increase the module use count */
-	ip_vs_use_count_inc();
+	if (!ip_vs_use_count_inc())
+		return -ENOPROTOOPT;
 
 	/* Lookup the scheduler by 'u->sched_name' */
 	if (strcmp(u->sched_name, "none")) {
@@ -2363,9 +2364,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 	if (copy_from_user(arg, user, len) != 0)
 		return -EFAULT;
 
-	/* increase the module use count */
-	ip_vs_use_count_inc();
-
 	/* Handle daemons since they have another lock */
 	if (cmd == IP_VS_SO_SET_STARTDAEMON ||
 	    cmd == IP_VS_SO_SET_STOPDAEMON) {
@@ -2378,13 +2376,13 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 			ret = -EINVAL;
 			if (strscpy(cfg.mcast_ifn, dm->mcast_ifn,
 				    sizeof(cfg.mcast_ifn)) <= 0)
-				goto out_dec;
+				return ret;
 			cfg.syncid = dm->syncid;
 			ret = start_sync_thread(ipvs, &cfg, dm->state);
 		} else {
 			ret = stop_sync_thread(ipvs, dm->state);
 		}
-		goto out_dec;
+		return ret;
 	}
 
 	mutex_lock(&__ip_vs_mutex);
@@ -2479,10 +2477,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 
   out_unlock:
 	mutex_unlock(&__ip_vs_mutex);
-  out_dec:
-	/* decrease the module use count */
-	ip_vs_use_count_dec();
-
 	return ret;
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_pe.c b/net/netfilter/ipvs/ip_vs_pe.c
index 0df17caa8af6c..714e7e05c1021 100644
--- a/net/netfilter/ipvs/ip_vs_pe.c
+++ b/net/netfilter/ipvs/ip_vs_pe.c
@@ -67,7 +67,8 @@ int register_ip_vs_pe(struct ip_vs_pe *pe)
 	struct ip_vs_pe *tmp;
 
 	/* increase the module use count */
-	ip_vs_use_count_inc();
+	if (!ip_vs_use_count_inc())
+		return -ENOENT;
 
 	mutex_lock(&ip_vs_pe_mutex);
 	/* Make sure that the pe with this name doesn't exist
diff --git a/net/netfilter/ipvs/ip_vs_sched.c b/net/netfilter/ipvs/ip_vs_sched.c
index a2ff7d746ebf4..3bd0ff36dc41b 100644
--- a/net/netfilter/ipvs/ip_vs_sched.c
+++ b/net/netfilter/ipvs/ip_vs_sched.c
@@ -184,7 +184,8 @@ int register_ip_vs_scheduler(struct ip_vs_scheduler *scheduler)
 	}
 
 	/* increase the module use count */
-	ip_vs_use_count_inc();
+	if (!ip_vs_use_count_inc())
+		return -ENOENT;
 
 	mutex_lock(&ip_vs_sched_mutex);
 
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index ecb71062fcb3c..5acd99f83166b 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1762,6 +1762,10 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 	IP_VS_DBG(7, "Each ip_vs_sync_conn entry needs %zd bytes\n",
 		  sizeof(struct ip_vs_sync_conn_v0));
 
+	/* increase the module use count */
+	if (!ip_vs_use_count_inc())
+		return -ENOPROTOOPT;
+
 	/* Do not hold one mutex and then to block on another */
 	for (;;) {
 		rtnl_lock();
@@ -1892,9 +1896,6 @@ int start_sync_thread(struct netns_ipvs *ipvs, struct ipvs_sync_daemon_cfg *c,
 	mutex_unlock(&ipvs->sync_mutex);
 	rtnl_unlock();
 
-	/* increase the module use count */
-	ip_vs_use_count_inc();
-
 	return 0;
 
 out:
@@ -1924,11 +1925,17 @@ out:
 		}
 		kfree(ti);
 	}
+
+	/* decrease the module use count */
+	ip_vs_use_count_dec();
 	return result;
 
 out_early:
 	mutex_unlock(&ipvs->sync_mutex);
 	rtnl_unlock();
+
+	/* decrease the module use count */
+	ip_vs_use_count_dec();
 	return result;
 }
 
-- 
2.20.1



