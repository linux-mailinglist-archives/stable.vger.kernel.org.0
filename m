Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7326C2611
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCTXut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCTXus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:50:48 -0400
Received: from out198-153.us.a.mail.aliyun.com (out198-153.us.a.mail.aliyun.com [47.90.198.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960D6EC5A;
        Mon, 20 Mar 2023 16:50:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.04438621|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.00185546-0.00012679-0.998018;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047193;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.RvYBynT_1679356099;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.RvYBynT_1679356099)
          by smtp.aliyun-inc.com;
          Tue, 21 Mar 2023 07:48:20 +0800
Date:   Tue, 21 Mar 2023 07:48:20 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
Message-Id: <20230321074819.2A17.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,


> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

fstests btrfs/056 triggered a panic for 6.1.21-rc1, but the panic does not
happen on 6.1.20.

the patch *1 dropped in 6.1.9-rc is added to 6.1.21-rc1 again.
*1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset

we need to drop it again, or need more patches.

dmesg output:
[  144.826161] run fstests btrfs/056 at 2023-03-21 07:38:22
[  145.218508] BTRFS: device fsid f51b57f4-387d-4cad-9abb-7d564b046644 devid 1 transid 26305 /dev/nvme0n1p1 scanned by mount (2411)
[  145.232873] BTRFS info (device nvme0n1p1): using crc32c (crc32c-intel) checksum algorithm
[  145.242079] BTRFS info (device nvme0n1p1): using free space tree
[  145.254748] BTRFS info (device nvme0n1p1): enabling ssd optimizations
[  145.767372] BTRFS: device fsid 6c57e1ae-86b5-416b-9583-ced6f290ee2c devid 1 transid 6 /dev/nvme0n1p2 scanned by systemd-udevd (2087)
[  145.863002] BTRFS info (device dm-0): using crc32c (crc32c-intel) checksum algorithm
[  145.871720] BTRFS info (device dm-0): using free space tree
[  145.881697] BTRFS info (device dm-0): enabling ssd optimizations
[  145.889144] BTRFS info (device dm-0): checking UUID tree
[  145.986698] BTRFS info: devid 1 device path /dev/mapper/flakey-test changed to /dev/dm-0 scanned by systemd-udevd (2087)
[  146.000451] BTRFS info: devid 1 device path /dev/dm-0 changed to /dev/mapper/flakey-test scanned by systemd-udevd (2087)
[  146.079464] BTRFS: device fsid 6c57e1ae-86b5-416b-9583-ced6f290ee2c devid 1 transid 6 /dev/dm-0 scanned by systemd-udevd (2087)
[  146.109496] BTRFS info (device dm-0): using crc32c (crc32c-intel) checksum algorithm
[  146.118224] BTRFS info (device dm-0): using free space tree
[  146.127288] BTRFS info (device dm-0): enabling ssd optimizations
[  146.134034] BTRFS info (device dm-0): start tree-log replay
[  146.142813] BTRFS info (device dm-0): checking UUID tree
[  146.228077] BUG: kernel NULL pointer dereference, address: 0000000000000058
[  146.235907] #PF: supervisor read access in kernel mode
[  146.241662] #PF: error_code(0x0000) - not-present page
[  146.247420] PGD 0 P4D 0
[  146.251227] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  146.257016] CPU: 35 PID: 2661 Comm: dmsetup Not tainted 6.1.21-0.1.el7.x86_64 #1
[  146.266227] Hardware name: Dell Inc. PowerEdge T620/02CD1V, BIOS 2.9.0 12/06/2019
[  146.275524] RIP: 0010:blk_mq_wait_quiesce_done+0xc/0x30
[  146.282294] Code: 00 00 00 e8 66 48 ff ff 4c 89 e6 5b 48 89 ef 5d 41 5c e9 a7 7c 65 00 0f 1f 80 00 00 00 00 0f 1f 44 00 00 48 8b 87 50 03 00 00 <f6> 40 58 20 74 0c 48 8b b8 a8 00 00 00 e9 e2 69 c4 ff e9 dd e4 c4
[  146.305208] RSP: 0018:ffffb03ecea6bbd0 EFLAGS: 00010286
[  146.312029] RAX: 0000000000000000 RBX: ffffa086c7523800 RCX: 0000000000000000
[  146.320997] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffffa086f1c27500
[  146.329955] RBP: ffffa086f1c27500 R08: ffffa0a64dd9b300 R09: ffffa0a64d9ae800
[  146.338913] R10: 0000000000000001 R11: ffffa086c7527400 R12: 0000000000000000
[  146.347884] R13: ffffa086f5403e80 R14: ffffa086cd0dee00 R15: ffffffffc188a5d0
[  146.356836] FS:  00007f7636967840(0000) GS:ffffa0b5ffc40000(0000) knlGS:0000000000000000
[  146.366839] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  146.374211] CR2: 0000000000000058 CR3: 000000209451a001 CR4: 00000000001706e0
[  146.383146] Call Trace:
[  146.386841]  <TASK>
[  146.390144]  del_gendisk+0x1ec/0x2c0
[  146.395096]  cleanup_mapped_device+0x130/0x140 [dm_mod]
[  146.401893]  __dm_destroy+0x13d/0x1e0 [dm_mod]
[  146.407796]  ? remove_all+0x30/0x30 [dm_mod]
[  146.413505]  dev_remove+0x119/0x1a0 [dm_mod]
[  146.419199]  ctl_ioctl+0x1ee/0x520 [dm_mod]
[  146.424802]  dm_ctl_ioctl+0xa/0x20 [dm_mod]
[  146.430378]  __x64_sys_ioctl+0x89/0xc0
[  146.435433]  do_syscall_64+0x58/0x80
[  146.440272]  ? ksys_semctl.constprop.21+0x13e/0x170
[  146.446568]  ? syscall_exit_to_user_mode+0x12/0x30
[  146.452760]  ? do_syscall_64+0x67/0x80
[  146.457766]  ? do_syscall_64+0x67/0x80
[  146.462740]  ? syscall_exit_to_user_mode+0x12/0x30
[  146.468866]  ? do_syscall_64+0x67/0x80
[  146.473827]  ? exc_page_fault+0x64/0x140
[  146.478985]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  146.485414] RIP: 0033:0x7f7634af54a7
[  146.490172] Code: 44 00 00 48 8b 05 c9 19 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 99 19 2d 00 f7 d8 64 89 01 48
[  146.512729] RSP: 002b:00007ffd0354ac08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  146.521970] RAX: ffffffffffffffda RBX: 00007f763620d0a0 RCX: 00007f7634af54a7
[  146.530718] RDX: 0000555d423aa110 RSI: 00000000c138fd04 RDI: 0000000000000003
[  146.539465] RBP: 00007f76362482c3 R08: 00007f7636248e68 R09: 00007ffd0354ab30
[  146.548212] R10: 0000000000000006 R11: 0000000000000246 R12: 0000555d423aa110
[  146.556971] R13: 00007f76362482c3 R14: 0000555d423aa030 R15: 00007f76362482c3
[  146.565738]  </TASK>
[  146.568961] Modules linked in: dm_flakey rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache netfs rfkill ib_core dm_multipath intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel btrfs kvm acpi_power_meter acpi_ipmi nfsd irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel blake2b_generic xor rapl auth_rpcgss raid6_pq intel_cstate iTCO_wdt nfs_acl dm_mod iTCO_vendor_support dcdbas zstd_compress intel_uncore lockd mei_me ipmi_si pcspkr mei grace joydev lpc_ich sg ipmi_devintf wmi ipmi_msghandler sunrpc ip_tables x_tables xfs sd_mod ahci nvme libahci mpt3sas nvme_core igb libata megaraid_sas raid_class nvme_common crc32c_intel mgag200 dca scsi_transport_sas t10_pi
[  146.644444] CR2: 0000000000000058
[  146.649073] ---[ end trace 0000000000000000 ]---
[  146.662547] RIP: 0010:blk_mq_wait_quiesce_done+0xc/0x30
[  146.669275] Code: 00 00 00 e8 66 48 ff ff 4c 89 e6 5b 48 89 ef 5d 41 5c e9 a7 7c 65 00 0f 1f 80 00 00 00 00 0f 1f 44 00 00 48 8b 87 50 03 00 00 <f6> 40 58 20 74 0c 48 8b b8 a8 00 00 00 e9 e2 69 c4 ff e9 dd e4 c4
[  146.691900] RSP: 0018:ffffb03ecea6bbd0 EFLAGS: 00010286
[  146.698578] RAX: 0000000000000000 RBX: ffffa086c7523800 RCX: 0000000000000000
[  146.707395] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffffa086f1c27500
[  146.716212] RBP: ffffa086f1c27500 R08: ffffa0a64dd9b300 R09: ffffa0a64d9ae800
[  146.725028] R10: 0000000000000001 R11: ffffa086c7527400 R12: 0000000000000000
[  146.733834] R13: ffffa086f5403e80 R14: ffffa086cd0dee00 R15: ffffffffc188a5d0
[  146.742637] FS:  00007f7636967840(0000) GS:ffffa0b5ffc40000(0000) knlGS:0000000000000000
[  146.752516] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  146.759773] CR2: 0000000000000058 CR3: 000000209451a001 CR4: 00000000001706e0
[  146.768597] Kernel panic - not syncing: Fatal exception
[  147.210009] Kernel Offset: 0x16200000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  147.225480] ---[ end Kernel panic - not syncing: Fatal exception ]---

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/03/21



