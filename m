Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01554F6A3
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730826AbfD3LuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731161AbfD3LuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 773992054F;
        Tue, 30 Apr 2019 11:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625020;
        bh=A8JBLSC1ofHW3Q7bGp97qpoxftwAKyrj4FTUS/yfBaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evSNSkJDBKFGNdxwBUFEFezdRT8ZVYbl3WsgWqTEhD6R0VYW//NX0soirXPbLl4Y9
         Zp6JobLG9YwbBZr01giXOKRfP+tQ/UPwTaEtdNsHkzG8jwHJYlYnJwfYwoCb5wUsv9
         B5yI9Ww3tojnEGMAsbmjifOMm/nzjrmKfyRKgmg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 61/89] net: netrom: Fix error cleanup path of nr_proto_init
Date:   Tue, 30 Apr 2019 13:38:52 +0200
Message-Id: <20190430113612.553999280@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit d3706566ae3d92677b932dd156157fd6c72534b1 upstream.

Syzkaller report this:

BUG: unable to handle kernel paging request at fffffbfff830524b
PGD 237fe8067 P4D 237fe8067 PUD 237e64067 PMD 1c9716067 PTE 0
Oops: 0000 [#1] SMP KASAN PTI
CPU: 1 PID: 4465 Comm: syz-executor.0 Not tainted 5.0.0+ #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:__list_add_valid+0x21/0xe0 lib/list_debug.c:23
Code: 8b 0c 24 e9 17 fd ff ff 90 55 48 89 fd 48 8d 7a 08 53 48 89 d3 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 48 83 ec 08 <80> 3c 02 00 0f 85 8b 00 00 00 48 8b 53 08 48 39 f2 75 35 48 89 f2
RSP: 0018:ffff8881ea2278d0 EFLAGS: 00010282
RAX: dffffc0000000000 RBX: ffffffffc1829250 RCX: 1ffff1103d444ef4
RDX: 1ffffffff830524b RSI: ffffffff85659300 RDI: ffffffffc1829258
RBP: ffffffffc1879250 R08: fffffbfff0acb269 R09: fffffbfff0acb269
R10: ffff8881ea2278f0 R11: fffffbfff0acb268 R12: ffffffffc1829250
R13: dffffc0000000000 R14: 0000000000000008 R15: ffffffffc187c830
FS:  00007fe0361df700(0000) GS:ffff8881f7300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff830524b CR3: 00000001eb39a001 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 __list_add include/linux/list.h:60 [inline]
 list_add include/linux/list.h:79 [inline]
 proto_register+0x444/0x8f0 net/core/sock.c:3375
 nr_proto_init+0x73/0x4b3 [netrom]
 ? 0xffffffffc1628000
 ? 0xffffffffc1628000
 do_one_initcall+0xbc/0x47d init/main.c:887
 do_init_module+0x1b5/0x547 kernel/module.c:3456
 load_module+0x6405/0x8c10 kernel/module.c:3804
 __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
 do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x462e99
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe0361dec58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462e99
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00007fe0361dec70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe0361df6bc
R13: 00000000004bcefa R14: 00000000006f6fb0 R15: 0000000000000004
Modules linked in: netrom(+) ax25 fcrypt pcbc af_alg arizona_ldo1 v4l2_common videodev media v4l2_dv_timings hdlc ide_cd_mod snd_soc_sigmadsp_regmap snd_soc_sigmadsp intel_spi_platform intel_spi mtd spi_nor snd_usbmidi_lib usbcore lcd ti_ads7950 hi6421_regulator snd_soc_kbl_rt5663_max98927 snd_soc_hdac_hdmi snd_hda_ext_core snd_hda_core snd_soc_rt5663 snd_soc_core snd_pcm_dmaengine snd_compress snd_soc_rl6231 mac80211 rtc_rc5t583 spi_slave_time leds_pwm hid_gt683r hid industrialio_triggered_buffer kfifo_buf industrialio ir_kbd_i2c rc_core led_class_flash dwc_xlgmac snd_ymfpci gameport snd_mpu401_uart snd_rawmidi snd_ac97_codec snd_pcm ac97_bus snd_opl3_lib snd_timer snd_seq_device snd_hwdep snd soundcore iptable_security iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter bpfilter ip6_vti ip_vti ip_gre ipip sit tunnel4 ip_tunnel hsr veth netdevsim vxcan batman_adv cfg80211 rfkill chnl_net caif nlmon dummy team bonding vcan
 bridge stp llc ip6_gre gre ip6_tunnel tunnel6 tun joydev mousedev ppdev tpm kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ide_pci_generic piix aesni_intel aes_x86_64 crypto_simd cryptd glue_helper ide_core psmouse input_leds i2c_piix4 serio_raw intel_agp intel_gtt ata_generic agpgart pata_acpi parport_pc rtc_cmos parport floppy sch_fq_codel ip_tables x_tables sha1_ssse3 sha1_generic ipv6 [last unloaded: rxrpc]
Dumping ftrace buffer:
   (ftrace buffer empty)
CR2: fffffbfff830524b
---[ end trace 039ab24b305c4b19 ]---

If nr_proto_init failed, it may forget to call proto_unregister,
tiggering this issue.This patch rearrange code of nr_proto_init
to avoid such issues.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netrom.h           |    2 -
 net/netrom/af_netrom.c         |   76 +++++++++++++++++++++++++++++------------
 net/netrom/nr_loopback.c       |    2 -
 net/netrom/nr_route.c          |    2 -
 net/netrom/sysctl_net_netrom.c |    5 ++
 5 files changed, 61 insertions(+), 26 deletions(-)

--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -266,7 +266,7 @@ void nr_stop_idletimer(struct sock *);
 int nr_t1timer_running(struct sock *);
 
 /* sysctl_net_netrom.c */
-void nr_register_sysctl(void);
+int nr_register_sysctl(void);
 void nr_unregister_sysctl(void);
 
 #endif
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1392,18 +1392,22 @@ static int __init nr_proto_init(void)
 	int i;
 	int rc = proto_register(&nr_proto, 0);
 
-	if (rc != 0)
-		goto out;
+	if (rc)
+		return rc;
 
 	if (nr_ndevs > 0x7fffffff/sizeof(struct net_device *)) {
-		printk(KERN_ERR "NET/ROM: nr_proto_init - nr_ndevs parameter to large\n");
-		return -1;
+		pr_err("NET/ROM: %s - nr_ndevs parameter too large\n",
+		       __func__);
+		rc = -EINVAL;
+		goto unregister_proto;
 	}
 
 	dev_nr = kcalloc(nr_ndevs, sizeof(struct net_device *), GFP_KERNEL);
-	if (dev_nr == NULL) {
-		printk(KERN_ERR "NET/ROM: nr_proto_init - unable to allocate device array\n");
-		return -1;
+	if (!dev_nr) {
+		pr_err("NET/ROM: %s - unable to allocate device array\n",
+		       __func__);
+		rc = -ENOMEM;
+		goto unregister_proto;
 	}
 
 	for (i = 0; i < nr_ndevs; i++) {
@@ -1413,13 +1417,13 @@ static int __init nr_proto_init(void)
 		sprintf(name, "nr%d", i);
 		dev = alloc_netdev(0, name, NET_NAME_UNKNOWN, nr_setup);
 		if (!dev) {
-			printk(KERN_ERR "NET/ROM: nr_proto_init - unable to allocate device structure\n");
+			rc = -ENOMEM;
 			goto fail;
 		}
 
 		dev->base_addr = i;
-		if (register_netdev(dev)) {
-			printk(KERN_ERR "NET/ROM: nr_proto_init - unable to register network device\n");
+		rc = register_netdev(dev);
+		if (rc) {
 			free_netdev(dev);
 			goto fail;
 		}
@@ -1427,36 +1431,64 @@ static int __init nr_proto_init(void)
 		dev_nr[i] = dev;
 	}
 
-	if (sock_register(&nr_family_ops)) {
-		printk(KERN_ERR "NET/ROM: nr_proto_init - unable to register socket family\n");
+	rc = sock_register(&nr_family_ops);
+	if (rc)
 		goto fail;
-	}
 
-	register_netdevice_notifier(&nr_dev_notifier);
+	rc = register_netdevice_notifier(&nr_dev_notifier);
+	if (rc)
+		goto out_sock;
 
 	ax25_register_pid(&nr_pid);
 	ax25_linkfail_register(&nr_linkfail_notifier);
 
 #ifdef CONFIG_SYSCTL
-	nr_register_sysctl();
+	rc = nr_register_sysctl();
+	if (rc)
+		goto out_sysctl;
 #endif
 
 	nr_loopback_init();
 
-	proc_create_seq("nr", 0444, init_net.proc_net, &nr_info_seqops);
-	proc_create_seq("nr_neigh", 0444, init_net.proc_net, &nr_neigh_seqops);
-	proc_create_seq("nr_nodes", 0444, init_net.proc_net, &nr_node_seqops);
-out:
-	return rc;
+	rc = -ENOMEM;
+	if (!proc_create_seq("nr", 0444, init_net.proc_net, &nr_info_seqops))
+		goto proc_remove1;
+	if (!proc_create_seq("nr_neigh", 0444, init_net.proc_net,
+			     &nr_neigh_seqops))
+		goto proc_remove2;
+	if (!proc_create_seq("nr_nodes", 0444, init_net.proc_net,
+			     &nr_node_seqops))
+		goto proc_remove3;
+
+	return 0;
+
+proc_remove3:
+	remove_proc_entry("nr_neigh", init_net.proc_net);
+proc_remove2:
+	remove_proc_entry("nr", init_net.proc_net);
+proc_remove1:
+
+	nr_loopback_clear();
+	nr_rt_free();
+
+#ifdef CONFIG_SYSCTL
+	nr_unregister_sysctl();
+out_sysctl:
+#endif
+	ax25_linkfail_release(&nr_linkfail_notifier);
+	ax25_protocol_release(AX25_P_NETROM);
+	unregister_netdevice_notifier(&nr_dev_notifier);
+out_sock:
+	sock_unregister(PF_NETROM);
 fail:
 	while (--i >= 0) {
 		unregister_netdev(dev_nr[i]);
 		free_netdev(dev_nr[i]);
 	}
 	kfree(dev_nr);
+unregister_proto:
 	proto_unregister(&nr_proto);
-	rc = -1;
-	goto out;
+	return rc;
 }
 
 module_init(nr_proto_init);
--- a/net/netrom/nr_loopback.c
+++ b/net/netrom/nr_loopback.c
@@ -70,7 +70,7 @@ static void nr_loopback_timer(struct tim
 	}
 }
 
-void __exit nr_loopback_clear(void)
+void nr_loopback_clear(void)
 {
 	del_timer_sync(&loopback_timer);
 	skb_queue_purge(&loopback_queue);
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -953,7 +953,7 @@ const struct seq_operations nr_neigh_seq
 /*
  *	Free all memory associated with the nodes and routes lists.
  */
-void __exit nr_rt_free(void)
+void nr_rt_free(void)
 {
 	struct nr_neigh *s = NULL;
 	struct nr_node  *t = NULL;
--- a/net/netrom/sysctl_net_netrom.c
+++ b/net/netrom/sysctl_net_netrom.c
@@ -146,9 +146,12 @@ static struct ctl_table nr_table[] = {
 	{ }
 };
 
-void __init nr_register_sysctl(void)
+int __init nr_register_sysctl(void)
 {
 	nr_table_header = register_net_sysctl(&init_net, "net/netrom", nr_table);
+	if (!nr_table_header)
+		return -ENOMEM;
+	return 0;
 }
 
 void nr_unregister_sysctl(void)


