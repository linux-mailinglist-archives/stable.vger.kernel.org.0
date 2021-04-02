Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AE03526E3
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 09:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhDBHQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 03:16:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15527 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhDBHQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Apr 2021 03:16:31 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FBWVz3WV7zNsDJ;
        Fri,  2 Apr 2021 15:13:47 +0800 (CST)
Received: from [10.174.177.143] (10.174.177.143) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 2 Apr 2021 15:16:21 +0800
To:     <stable@vger.kernel.org>, <vbabka@suse.cz>,
        <gregkh@linuxfoundation.org>, <linux-mm@kvack.org>,
        <open-iscsi@googlegroups.com>, <cleech@redhat.com>
CC:     "zhangyi (F)" <yi.zhang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        <liuyongqiang13@huawei.com>,
        "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>,
        <yangerkun@huawei.com>, Yang Yingliang <yangyingliang@huawei.com>,
        <chenzhou10@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
Subject: [QUESTION] WARNNING after 3d8e2128f26a ("sysfs: Add sysfs_emit and
 sysfs_emit_at to format sysfs output")
Message-ID: <5837f5d9-2235-3ac2-f3f2-712e6cf4da5c@huawei.com>
Date:   Fri, 2 Apr 2021 15:16:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.143]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

sysfs_emit(3d8e2128f26a ("sysfs: Add sysfs_emit and sysfs_emit_at to
format sysfs output")) has a hidden constraint that the buf should be
alignment with PAGE_SIZE. It's OK since 59bb47985c1d ("mm, sl[aou]b:
guarantee natural alignment for kmalloc(power-of-two)") help us to solve
scenes like CONFIG_SLUB_DEBUG or CONFIG_SLOB which will break this.


But since lots of stable branch(we reproduce it with 4.19 stable) merge
3d8e2128f26a ("sysfs: Add sysfs_emit and sysfs_emit_at to format sysfs
output") without 59bb47985c1d ("mm, sl[aou]b: guarantee natural
alignment for kmalloc(power-of-two)"), we will get the follow warning
with command 'cat /sys/class/iscsi_transport/tcp/handle' once we enable
CONFIG_SLUB_DEBUG and start kernel with slub_debug=UFPZ!


Obviously, we can backport 59bb47985c1d ("mm, sl[aou]b: guarantee
natural alignment for kmalloc(power-of-two)") to fix it. But this will
waste some memory to ensure natural alignment which seems unbearable for
embedded device. So for stable branch like 4.19, can we just remove the
warning in sysfs_emit since the only user for it is iscsi, and seq_read
+ sysfs_kf_seq_show can ensure that the buf in sysfs_emit must be aware
of PAGE_SIZE. Or does there some other advise for this problem?


# without 59bb47985c1d + 1G ram
[root@localhost ~]# free
               total        used        free      shared  buff/cache
available
Mem:         947336      169960      389732         896      387644
624216
Swap:             0           0           0

# merge with 59bb47985c1d + 1G ram
[root@localhost ~]# free
               total        used        free      shared  buff/cache
available
Mem:         947340      175176      374396         896      397768
618964
Swap:             0           0           0
[root@localhost ~]#


[   37.683332] ------------[ cut here ]------------
[   37.692747] invalid sysfs_emit: buf:00000000f75441ab
[   37.693914] WARNING: CPU: 1 PID: 576 at fs/sysfs/file.c:577 
sysfs_emit+0xb9/0xe0
[   37.694861] Modules linked in:
[   37.695264] CPU: 1 PID: 576 Comm: cat Not tainted 
4.19.183-00023-gdf225d326e8c #7
[   37.696210] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 
04/01/2014
[   37.697866] RIP: 0010:sysfs_emit+0xb9/0xe0
[   37.698387] Code: 47 c9 c3 48 83 05 76 33 b3 04 01 48 89 fe 48 c7 c7 
64 08 bb 8a 48 83 05 7c 33 b3 04 01 e8 13 7f be 00 48 83 05 77 33 b3 04 
01 <0f> 0b 48 83 05 75 33 b3 04 01 48 83 05 73
[   37.700713] RSP: 0018:ffffc90000af7cf8 EFLAGS: 00010202
[   37.701370] RAX: 0000000000000000 RBX: ffff88803e0e4c00 RCX: 
0000000000000006
[   37.702261] RDX: 0000000000000007 RSI: 0000000000000006 RDI: 
ffff888039455bf0
[   37.703171] RBP: ffffc90000af7d48 R08: 00000000000002f8 R09: 
0000000000000005
[   37.704079] R10: 00000000000002f7 R11: ffffffff8bd9534d R12: 
ffff88801a013740
[   37.705001] R13: ffff88803db37a08 R14: ffff88803db37a30 R15: 
ffff88803db37a48
[   37.705918] FS:  00007fcb96411580(0000) GS:ffff888039440000(0000) 
knlGS:0000000000000000
[   37.706956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.707692] CR2: 00007fcb88cf0000 CR3: 000000001a501000 CR4: 
00000000000006e0
[   37.708607] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   37.709520] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[   37.710427] Call Trace:
[   37.710784]  show_transport_handle+0x3e/0x60
[   37.711338]  dev_attr_show+0x22/0x60
[   37.711808]  sysfs_kf_seq_show+0xc6/0x190
[   37.712332]  kernfs_seq_show+0x25/0x30
[   37.712862]  seq_read+0xe1/0x540
[   37.713292]  ? __handle_mm_fault+0xba3/0x1c70
[   37.713866]  kernfs_fop_read+0x36/0x230
[   37.714371]  __vfs_read+0x3c/0x230
[   37.714819]  ? handle_mm_fault+0x1d1/0x340
[   37.715345]  vfs_read+0xb5/0x1b0
[   37.715774]  ksys_read+0x67/0x130
[   37.716218]  __x64_sys_read+0x1e/0x30
[   37.716701]  do_syscall_64+0x95/0x3d0
[   37.717175]  ? do_async_page_fault+0x2e/0x190
[   37.717747]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   37.718406] RIP: 0033:0x7fcb963363f2
[   37.718881] Code: c0 e9 b2 fe ff ff 50 48 8d 3d 8a 41 0a 00 e8 75 f0 
01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 
05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 04
[   37.721290] RSP: 002b:00007ffea78dff18 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[   37.722264] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 
00007fcb963363f2
[   37.723169] RDX: 0000000000020000 RSI: 00007fcb88cf1000 RDI: 
0000000000000003
[   37.724100] RBP: 00007fcb88cf1000 R08: 00007fcb88cf0010 R09: 
0000000000000000
[   37.725039] R10: 0000000000000022 R11: 0000000000000246 R12: 
0000000000020f00
[   37.725945] R13: 0000000000000003 R14: 0000000000020000 R15: 
0000000000020000
[   37.726857] ---[ end trace fbd5b85cd7d85530 ]---

