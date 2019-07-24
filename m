Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDB17407D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfGXU47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:56:59 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36027 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXU47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 16:56:59 -0400
Received: by mail-ed1-f68.google.com with SMTP id k21so48304144edq.3
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 13:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o8iLxgrlWg6R9CoefzAOFblGGjqYLC5hmE3t7zd1t6A=;
        b=LuK8wAHybDwx+Iypz/UjnJNHAFZZGsbVzb6b8hfZ8ERvhzduHEFHJC3nZ76bsgfbDQ
         hzGrPy12NijjOfh/2kgdHHJ7J6vfLBaVEp+rID4WJiB2swmpgIg7V8jnvcroMEPfV+g8
         flFFhMudWmGJe2rvYGrTKwD9L0+EDDhgPfU3d0VpmHoCLjBC1QF9QsA2Y2oB7mCYMSKZ
         qgRymgsuzLUB/TxEykXZAyF/GojU6czCdkM76nFZ2R5o3iLK/reoLzdKIEhs5GzAy+ZA
         ulaOuDv10809fIH6KwF9Hd5lLc2a9/xpscty8UG+W+uJOzvXhNy1BJBkdcFfRHFTlu9Q
         yzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o8iLxgrlWg6R9CoefzAOFblGGjqYLC5hmE3t7zd1t6A=;
        b=LHMonCVy0KjvdgBglHtFG24zCymemv2x1YlQ9ZhcNplGtvIYA63wGo4xyyGjeWTv0G
         7cFRIDPpYFdcm/+JLCsT3JYha2BsEOXamj8V9iI0slVOFpRrFE/WYoJLRI20T4mQW8eI
         DCqPg3v3RArIbkYiJqAPLyWSg1QNWicjmqPY6uovIAG+Hb5nWZvWs5Yy5JOpiUXr/4aF
         tYw/o7sVfqae/MTl6CKZYYdnawZ4cdxIj2GWYzCe2WlQFGIGXeAOZPL1IQ9IQWErpkk+
         sd2J5TXLMANv/M2rC8xnZcolBoThfZr+FkNLy1io3qqn6j1dPcaML3Vb6kDoSrq5ruXM
         TSBw==
X-Gm-Message-State: APjAAAVVp4nOVRpNNDBtATaOdPsFUlFJv9NUOMLhQus0XA9PeKqRvf+n
        6RaUoIhKiTgZr7pObQCe7+bzenOrze8=
X-Google-Smtp-Source: APXvYqzrQwtKzXP/JRKRpOgQ//QDvTIKVB1bwtNwOdqRwfgDVLJ1bGypvBYK2cU4Q17VuVMg0tl9gw==
X-Received: by 2002:a50:f599:: with SMTP id u25mr75183574edm.195.1564001816744;
        Wed, 24 Jul 2019 13:56:56 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id g18sm9358317ejo.3.2019.07.24.13.56.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 13:56:56 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     stable@vger.kernel.org
Cc:     asmadeus@codewreck.org, sashal@kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 0/3] Backport request for v4.14 to fix KASAN issues
Date:   Wed, 24 Jul 2019 22:55:54 +0200
Message-Id: <20190724205557.30913-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

First, thank you for maintaining the stable branches!

When testing our MPTCP out-of-tree kernel[1] with KASAN last week-end,
we saw some new warnings, always the same trace and looking like that:


[   16.464577] ==================================================================
[   16.465448] BUG: KASAN: slab-out-of-bounds in strscpy+0x49d/0x590
[   16.466171] Read of size 8 at addr ffff88803525f788 by task confd/330
[   16.467114]
[   16.467313] CPU: 0 PID: 330 Comm: confd Not tainted 4.14.133-mptcp+ #2
[   16.468071] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.5.1 01/01/2011
[   16.469016] Call Trace:
[   16.469318]  dump_stack+0xa6/0x12e
[   16.469721]  ? _atomic_dec_and_lock+0x1b2/0x1b2
[   16.470255]  ? radix_tree_lookup+0x10/0x10
[   16.470764]  ? strscpy+0x49d/0x590
[   16.471299]  print_address_description+0xa1/0x330
[   16.471918]  ? strscpy+0x49d/0x590
[   16.472321]  kasan_report+0x23f/0x350
[   16.472751]  strscpy+0x49d/0x590
[   16.473135]  ? strncpy+0xd0/0xd0
[   16.473518]  p9dirent_read+0x26b/0x510
[   16.473977]  ? unwind_next_frame+0xc97/0x1eb0
[   16.474481]  ? p9stat_read+0x440/0x440
[   16.474945]  ? entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   16.475543]  ? rcutorture_record_progress+0x10/0x10
[   16.476123]  ? kernel_text_address+0x111/0x120
[   16.476656]  ? __kernel_text_address+0xe/0x30
[   16.477273]  v9fs_dir_readdir_dotl+0x340/0x5b0
[   16.477900]  ? kasan_slab_free+0x12d/0x1a0
[   16.478377]  ? v9fs_dir_readdir+0x810/0x810
[   16.478887]  ? new_slab+0x29f/0x3b0
[   16.479298]  ? iterate_fd+0x300/0x300
[   16.479728]  ? do_filp_open+0x24a/0x3b0
[   16.480177]  ? SyS_getcwd+0x3b7/0x9f0
[   16.480626]  ? may_open_dev+0xc0/0xc0
[   16.481056]  ? get_unused_fd_flags+0x180/0x180
[   16.481643]  ? __up.isra.0+0x230/0x230
[   16.482195]  ? __fdget_pos+0x105/0x170
[   16.482658]  ? iterate_dir+0x171/0x5b0
[   16.483097]  iterate_dir+0x171/0x5b0
[   16.483518]  SyS_getdents+0x1dc/0x3a0
[   16.483968]  ? SyS_old_readdir+0x200/0x200
[   16.484444]  ? SyS_write+0x1c0/0x270
[   16.484875]  ? fillonedir+0x1a0/0x1a0
[   16.485315]  ? SyS_old_readdir+0x200/0x200
[   16.485791]  ? do_syscall_64+0x259/0xa90
[   16.486258]  do_syscall_64+0x259/0xa90
[   16.486715]  ? syscall_return_slowpath+0x340/0x340
[   16.487320]  ? do_page_fault+0x11f/0x400
[   16.487849]  ? __do_page_fault+0xe00/0xe00
[   16.488305]  ? __hrtick_start+0x2f0/0x2f0
[   16.488752]  ? __switch_to_asm+0x31/0x60
[   16.489189]  ? __switch_to_asm+0x31/0x60
[   16.489626]  ? __switch_to_asm+0x25/0x60
[   16.490063]  ? __switch_to_asm+0x31/0x60
[   16.490500]  ? __switch_to_asm+0x31/0x60
[   16.490940]  ? __switch_to_asm+0x31/0x60
[   16.491377]  ? __switch_to_asm+0x25/0x60
[   16.491820]  ? __switch_to_asm+0x31/0x60
[   16.492305]  ? __switch_to_asm+0x31/0x60
[   16.492769]  ? __switch_to_asm+0x31/0x60
[   16.493306]  ? __switch_to_asm+0x31/0x60
[   16.493917]  ? __switch_to_asm+0x31/0x60
[   16.494402]  ? __switch_to_asm+0x25/0x60
[   16.494859]  ? __switch_to_asm+0x31/0x60
[   16.495344]  ? __switch_to_asm+0x31/0x60
[   16.495798]  ? __switch_to_asm+0x31/0x60
[   16.496283]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   16.496885] RIP: 0033:0x7f0bd5b26855
[   16.497313] RSP: 002b:00007f0bd69d4d60 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
[   16.498387] RAX: ffffffffffffffda RBX: 00007f0bb800a910 RCX: 00007f0bd5b26855
[   16.499221] RDX: 0000000000008000 RSI: 00007f0bb800a910 RDI: 000000000000002c
[   16.500102] RBP: 00007f0bb800a910 R08: 00007f0bd69d4e10 R09: 0000000000008030
[   16.500942] R10: 0000000000000076 R11: 0000000000000246 R12: ffffffffffffff70
[   16.501780] R13: 0000000000000002 R14: 00007f0bb80008d0 R15: 000000000129cb44
[   16.502641]
[   16.502819] Allocated by task 330:
[   16.503230]  kasan_kmalloc+0xe4/0x170
[   16.503799]  __kmalloc+0xdd/0x1c0
[   16.504259]  p9pdu_readf+0xbb8/0x2940
[   16.504707]  p9dirent_read+0x174/0x510
[   16.505154]  v9fs_dir_readdir_dotl+0x340/0x5b0
[   16.505694]  iterate_dir+0x171/0x5b0
[   16.506122]  SyS_getdents+0x1dc/0x3a0
[   16.506573]  do_syscall_64+0x259/0xa90
[   16.507031]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   16.507633]
[   16.507804] Freed by task 322:
[   16.508178]  kasan_slab_free+0xac/0x1a0
[   16.508741]  kfree+0xcd/0x1e0
[   16.509194]  p9stat_free+0x32/0x200
[   16.509633]  v9fs_vfs_get_link+0x173/0x230
[   16.510118]  ovl_get_link+0x52/0x80
[   16.510538]  trailing_symlink+0x42c/0x5f0
[   16.511034]  path_lookupat+0x1b4/0xc30
[   16.511481]  filename_lookup+0x237/0x470
[   16.511955]  vfs_statx+0xb0/0x120
[   16.512358]  SyS_newstat+0x70/0xc0
[   16.512759]  do_syscall_64+0x259/0xa90
[   16.513205]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[   16.513807]
[   16.514041] The buggy address belongs to the object at ffff88803525f780
[   16.514041]  which belongs to the cache kmalloc-16 of size 16
[   16.515645] The buggy address is located 8 bytes inside of
[   16.515645]  16-byte region [ffff88803525f780, ffff88803525f790)
[   16.516997] The buggy address belongs to the page:
[   16.517563] page:ffff88803f5407c0 count:1 mapcount:0 mapping:   (null) index:0x0
[   16.518504] flags: 0xc80000000100(slab)
[   16.519103] raw: 0000c80000000100 0000000000000000 0000000000000000 0000000180800080
[   16.520066] raw: ffff88803f4fa900 0000000800000008 ffff888035c01b40 0000000000000000
[   16.520981] page dumped because: kasan: bad access detected
[   16.521647]
[   16.521818] Memory state around the buggy address:
[   16.522413]  ffff88803525f680: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
[   16.523258]  ffff88803525f700: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
[   16.524118] >ffff88803525f780: 00 02 fc fc fb fb fc fc fb fb fc fc fb fb fc fc
[   16.525093]                       ^
[   16.525591]  ffff88803525f800: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
[   16.526471]  ffff88803525f880: fb fb fc fc fb fb fc fc fb fb fc fc fb fb fc fc
[   16.527323] ==================================================================


We are running tests in different KVMs and using 9P for the root RO
partition and others for a shared file system between VMs and the host:

    mount -t 9p outshare  "${MOUNT_DIR}/overlay/out" -o trans=virtio,version=9p2000.L,access=0,rw

Our out-of-tree kernel does not modify the FS part, nor net/9p.

With Dominique from v9fs project, we analysed the issue[2]. At the end,
it is confirmed that this KASAN warning is not related to our MPTCP
modifications but due to a recent change in the v4.14 stable branch:
84693d060965 (9p: p9dirent_read: check network-provided name length).

In this change backported by Sasha, strcpy() has been replaced by
strscpy(). This is known to cause KASAN false-positives, see:
1a3241ff10d0 (lib/strscpy: Shut up KASAN false-positives in strscpy()).
Note that this commit depends on the two parent ones.

Could it then be possible to also backport these three commits please?

The three commits apply without any issues. I followed the documention
to propose these three commits to stable, the Option 3.
Just for me for next time: is it easier for you to propose the patches
like I did or to only mention the SHA from Linus GIT tree?

- 1a3241ff10d0 (lib/strscpy: Shut up KASAN false-positives in strscpy())
- 7f1e541fc8d5 (compiler.h: Add read_word_at_a_time() function.)
- bdb5ac801af3 (compiler.h, kasan: Avoid duplicating __read_once_size_nocheck())

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp/
[2] https://sourceforge.net/p/v9fs/mailman/message/36718122/

Andrey Ryabinin (3):
  compiler.h, kasan: Avoid duplicating __read_once_size_nocheck()
  compiler.h: Add read_word_at_a_time() function.
  lib/strscpy: Shut up KASAN false-positives in strscpy()

 include/linux/compiler.h | 22 ++++++++++++++--------
 lib/string.c             |  2 +-
 2 files changed, 15 insertions(+), 9 deletions(-)

Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Sasha Levin <sashal@kernel.org>
-- 
2.20.1

