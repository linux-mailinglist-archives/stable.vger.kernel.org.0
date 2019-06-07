Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA6A399CF
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 02:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbfFHABx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 20:01:53 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:34130 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730402AbfFHABx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 20:01:53 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2019 20:01:52 EDT
Received: from smtp.aristanetworks.com (localhost [127.0.0.1])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 9613941B0E6;
        Fri,  7 Jun 2019 16:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1559951703;
        bh=Dzi853M92v2Ur/j9OKyDN0xQRvNGtOcZnl2jafJyGXg=;
        h=Date:To:Subject:From;
        b=nWtDsrfIRM/wiwsrLsub34vRPFtw0gCM7EgmI8sJ3DzNoIPhxPkN9jfxq2nV/kNjI
         +Q+kmJE+kG5EvzNaEfSusNpkwv+qb0HS1BKJ9iW70tZ/25o3fZG3RVPsbUg2sKHW0Y
         u40S7yh34zzOMrrO70QFd1NH8k7ac806zA88jf4BCZLW3ep1MqHCGvXOsTuKpl/+ne
         qsm/ptGOF3INDeQVRePJD+JC9TXHSYX2Vo+Clz6aTFIl+D+CsTBdFEwxPaT79iOa6u
         +L5gYS6cNHBUvBuEEfbmMeOt6gPzBwvojqIKsaAQVbnEXiZ5uJ2krewlpHjQpoSylv
         oc1+PU22VZRMg==
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [172.25.230.4])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 9484341B0E5;
        Fri,  7 Jun 2019 16:55:03 -0700 (PDT)
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id CFF3F95C0244; Fri,  7 Jun 2019 16:54:37 -0700 (PDT)
Date:   Fri, 07 Jun 2019 16:54:37 -0700
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, fruggeri@arista.com, namit@vmware.com
Subject: kprobe: kernel panic in 4.19.47
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20190607235437.CFF3F95C0244@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I see the following kernel panic in 4.19.47 as soon as I hit a kprobe.
In this case it happened right after

# cd /sys/kernel/debug/tracing/
# echo >trace
# echo 'p rollback_registered_many' >kprobe_events 
# echo 1 >events/kprobes/enable 
# ip netns add dummy
# ip netns del dummy

but I have also seen it with other functions, or when I used kernel modules
to install kprobes.
I bisected to 

8715ce033e [ "x86/modules: Avoid breaking W^X while loading modules" ]

in 4.19.47 (upstream commit f2c65fb322 in v5.2-rc1).

Thanks,
Francesco

[  151.067082] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[  151.074631] BUG: unable to handle kernel paging request at ffffffffa000f000
[  151.081661] PGD 200a067 P4D 200a067 PUD 200b063 PMD 1038324067 PTE 800000101cb73161
[  151.089396] Oops: 0011 [#1] SMP
[  151.092603] CPU: 12 PID: 1831 Comm: kworker/u64:1 Kdump: loaded Not tainted 4.19.47-12345018.AroraKernel419.fc18.x86_64 #1
[  151.103696] Hardware name: Supermicro X9DRT/X9DRT, BIOS 3.0 06/28/2013
[  151.110298] Workqueue: netns cleanup_net
[  151.114297] RIP: 0010:0xffffffffa000f000
[  151.118286] Code: Bad RIP value.
[  151.121562] RSP: 0018:ffffc90007947d60 EFLAGS: 00010206
[  151.126835] RAX: ffff88901cbf8070 RBX: ffffc90007947d88 RCX: ffff88901cbf8070
[  151.134033] RDX: ffffc90007947d88 RSI: ffffc90007947d88 RDI: ffffc90007947d88
[  151.141226] RBP: ffffc90007947d78 R08: 0000000000000001 R09: 0000000000020cc0
[  151.148429] R10: ffffc900063ebe08 R11: 0000000000026cdc R12: ffffc90007947d88
[  151.155630] R13: ffffc90007947e38 R14: ffff88901cbc8110 R15: ffffc90007947e10
[  151.162817] FS:  0000000000000000(0000) GS:ffff88a03f900000(0000) knlGS:0000000000000000
[  151.170964] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  151.176986] CR2: ffffffffa000efd6 CR3: 0000000002009006 CR4: 00000000000606e0
[  151.184403] Call Trace:
[  151.187150]  ? rollback_registered_many+0x5/0x3bc
[  151.192123]  ? unregister_netdevice_many+0x1a/0x79
[  151.197177]  default_device_exit_batch+0x137/0x15f
[  151.202231]  ? __wake_up_sync+0x12/0x12
[  151.206345]  ops_exit_list+0x29/0x53
[  151.210181]  cleanup_net+0x189/0x240
[  151.214030]  process_one_work+0x174/0x280
[  151.218319]  ? rescuer_thread+0x277/0x277
[  151.222610]  worker_thread+0x1b5/0x264
[  151.226639]  ? rescuer_thread+0x277/0x277
[  151.230922]  kthread+0xf5/0xfa
[  151.234239]  ? kthread_cancel_delayed_work_sync+0x15/0x15
[  151.239906]  ret_from_fork+0x1f/0x30
[  151.243751] Modules linked in: ipt_MASQUERADE nf_conntrack_netlink iptable_filter xt_addrtype xt_conntrack br_netfilter bridge stp llc macvlan sg coretemp x86_pkg_temp_thermal ip6table_filter ip6_tables ghash_clmulni_intel pcbc bonding aesni_intel kvm_intel aes_x86_64 crypto_simd kvm igb cryptd irqbypass glue_helper iTCO_wdt ioatdma iTCO_vendor_support hwmon joydev i2c_i801 i2c_algo_bit ipmi_si i2c_core pcc_cpufreq lpc_ich mfd_core ipmi_msghandler fuse dca pcspkr xt_multiport iptable_nat nf_nat_ipv4 ip_tables nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 x_tables tun loop 8021q raid456 async_raid6_recov async_memcpy libcrc32c async_pq async_xor xor async_tx raid6_pq raid1 raid0 isci libsas ehci_pci crc32c_intel ehci_hcd scsi_transport_sas wmi autofs4
[  151.312827] CR2: ffffffffa000f000

