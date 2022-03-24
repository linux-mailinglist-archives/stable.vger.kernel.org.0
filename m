Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79154E6A1C
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 22:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353681AbiCXVKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 17:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbiCXVKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 17:10:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DD275E6D
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 14:09:15 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2e5bcae3665so45351547b3.16
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 14:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mdqP4zxVNRiOc+J+htL93yYAY01KEmYdX0fyTWoEeqM=;
        b=jW7fuEZZr+qnzxDUJbnyv55DLZ/bAEbYuM/ZeFVD/McrFE6+8wfiBC11L59SmfkQsk
         eo47U61oYGE8J4Xhk68Tbd9ffnV3FqDUUC2a4LiLPVDqgJan5HMwEDGJ46/ZS/QeVNWc
         6jQGEP/HqM7IFlTuNcue38oF9VWUwEvItv/8kVUg6yajXElcqgM60lKlbTeoolNfTVMS
         pQqE4znFjHjSLsy0WtaAmrWZvgfYCHbGybx4ACRtpGLFLEooUaaVcgbdbOXTCZlH30Xa
         R+NZ9HAtiwSTgS5mPsk6z+Igrv0nNj1LtbhOpKGgk8vBm0urpFfnIh0JtNPBQjD2qllX
         Vmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mdqP4zxVNRiOc+J+htL93yYAY01KEmYdX0fyTWoEeqM=;
        b=plFhCnV7hLz8pnbR9E83s2x1WZfsxocnAqiZl9HgUt9ovY8+J0rWUxf/pNW4kBVE49
         rqw5pWE5II3tbMqsA6AdH1GQM39pXp6OoZHvQdorzc9ao8eA4oL3Ztb7mrd2stpoRVeE
         O4PXSWXmBo4gpEkjnU4wpni4aC9LY50D8heA2hYGsO6DNqKMv27jNGmLHibywGKz4MEQ
         ig3obOMSs/1aBut1wIA37w5aaBOJHjFxpHDQUth9NaQYKDuX5M3mdKj15eCoSFFZdKE/
         LJ51kwZ46A686UqPbnSIgIQr8QWwRK1qpejS802uLOFYyrh2VScpWUAlaT8lt81Al7Qd
         he4g==
X-Gm-Message-State: AOAM531YN9vM7AWIAhpYv9q/XTXElrnorDiNGZQVxlRj9lFAq7H8U2Kc
        KTZAMgmrvzlpWMsFlEdK9ptrPt1NgOwU2OENrQT3
X-Google-Smtp-Source: ABdhPJxJM63GBRYAGQEw22Qh0EoGgRme6H7isD/Q8qsj2pXjgqnbrgSWcHPntyE6r8EVavf/WtyVoSGZGEURLJ3POS5j
X-Received: from ajr0.svl.corp.google.com ([2620:15c:2cd:203:9892:9f7f:2c27:2968])
 (user=axelrasmussen job=sendgmr) by 2002:a81:ac59:0:b0:2e5:b784:d582 with
 SMTP id z25-20020a81ac59000000b002e5b784d582mr6992850ywj.253.1648156154914;
 Thu, 24 Mar 2022 14:09:14 -0700 (PDT)
Date:   Thu, 24 Mar 2022 14:09:09 -0700
Message-Id: <20220324210909.1843814-1-axelrasmussen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH] mm/secretmem: fix panic when growing a memfd_secret
From:   Axel Rasmussen <axelrasmussen@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When one tries to grow an existing memfd_secret with ftruncate,
one gets a panic [1]. For example, doing the following reliably
induces the panic:

    fd = memfd_secret();

    ftruncate(fd, 10);
    ptr = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    strcpy(ptr, "123456789");

    munmap(ptr, 10);
    ftruncate(fd, 20);

The basic reason for this is, when we grow with ftruncate, we call down
into simple_setattr, and then truncate_inode_pages_range, and eventually
we try to zero part of the memory. The normal truncation code does this
via the direct map (i.e., it calls page_address() and hands that to
memset()).

For memfd_secret though, we specifically don't map our pages via the
direct map (i.e. we call set_direct_map_invalid_noflush() on every
fault). So the address returned by page_address() isn't useful, and when
we try to memset() with it we panic.

This patch avoids the panic by implementing a custom setattr for
memfd_secret, which detects resizes specifically (setting the size for
the first time works just fine, since there are no existing pages to try
to zero), and rejects them as not supported (ENOTSUP).

One could argue growing should be supported, but I think that will
require a significantly more lengthy change. So, I propose a minimal
fix for the benefit of stable kernels, and then perhaps to extend
memfd_secret to support growing in a separate patch.

[1]:

[  774.320433] BUG: unable to handle page fault for address: ffffa0a889277028
[  774.322297] #PF: supervisor write access in kernel mode
[  774.323306] #PF: error_code(0x0002) - not-present page
[  774.324296] PGD afa01067 P4D afa01067 PUD 83f909067 PMD 83f8bf067 PTE 800ffffef6d88060
[  774.325841] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC PTI
[  774.326934] CPU: 0 PID: 281 Comm: repro Not tainted 5.17.0-dbg-DEV #1
[  774.328074] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[  774.329732] RIP: 0010:memset_erms+0x9/0x10
[  774.330474] Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
[  774.333543] RSP: 0018:ffffb932c09afbf0 EFLAGS: 00010246
[  774.334404] RAX: 0000000000000000 RBX: ffffda63c4249dc0 RCX: 0000000000000fd8
[  774.335545] RDX: 0000000000000fd8 RSI: 0000000000000000 RDI: ffffa0a889277028
[  774.336685] RBP: ffffb932c09afc00 R08: 0000000000001000 R09: ffffa0a889277028
[  774.337929] R10: 0000000000020023 R11: 0000000000000000 R12: ffffda63c4249dc0
[  774.339236] R13: ffffa0a890d70d98 R14: 0000000000000028 R15: 0000000000000fd8
[  774.340356] FS:  00007f7294899580(0000) GS:ffffa0af9bc00000(0000) knlGS:0000000000000000
[  774.341635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  774.342535] CR2: ffffa0a889277028 CR3: 0000000107ef6006 CR4: 0000000000370ef0
[  774.343651] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  774.344780] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  774.345938] Call Trace:
[  774.346334]  <TASK>
[  774.346671]  ? zero_user_segments+0x82/0x190
[  774.347346]  truncate_inode_partial_folio+0xd4/0x2a0
[  774.348128]  truncate_inode_pages_range+0x380/0x830
[  774.348904]  truncate_setsize+0x63/0x80
[  774.349530]  simple_setattr+0x37/0x60
[  774.350102]  notify_change+0x3d8/0x4d0
[  774.350681]  do_sys_ftruncate+0x162/0x1d0
[  774.351302]  __x64_sys_ftruncate+0x1c/0x20
[  774.351936]  do_syscall_64+0x44/0xa0
[  774.352486]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  774.353284] RIP: 0033:0x7f72947c392b
[  774.354001] Code: 77 05 c3 0f 1f 40 00 48 8b 15 41 85 0c 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 4d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 11 85 0c 00 f7 d8
[  774.357938] RSP: 002b:00007ffcad62a1a8 EFLAGS: 00000202 ORIG_RAX: 000000000000004d
[  774.359116] RAX: ffffffffffffffda RBX: 000055f47662b440 RCX: 00007f72947c392b
[  774.360186] RDX: 0000000000000028 RSI: 0000000000000028 RDI: 0000000000000003
[  774.361246] RBP: 00007ffcad62a1c0 R08: 0000000000000003 R09: 0000000000000000
[  774.362324] R10: 00007f72946dc230 R11: 0000000000000202 R12: 000055f47662b0e0
[  774.363393] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  774.364470]  </TASK>
[  774.364807] Modules linked in: xhci_pci xhci_hcd virtio_net net_failover failover virtio_blk virtio_balloon uhci_hcd ohci_pci ohci_hcd evdev ehci_pci ehci_hcd 9pnet_virtio 9p netfs 9pnet
[  774.367325] CR2: ffffa0a889277028
[  774.367838] ---[ end trace 0000000000000000 ]---
[  774.368543] RIP: 0010:memset_erms+0x9/0x10
[  774.369187] Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
[  774.372282] RSP: 0018:ffffb932c09afbf0 EFLAGS: 00010246
[  774.373372] RAX: 0000000000000000 RBX: ffffda63c4249dc0 RCX: 0000000000000fd8
[  774.374814] RDX: 0000000000000fd8 RSI: 0000000000000000 RDI: ffffa0a889277028
[  774.376248] RBP: ffffb932c09afc00 R08: 0000000000001000 R09: ffffa0a889277028
[  774.377687] R10: 0000000000020023 R11: 0000000000000000 R12: ffffda63c4249dc0
[  774.379135] R13: ffffa0a890d70d98 R14: 0000000000000028 R15: 0000000000000fd8
[  774.380550] FS:  00007f7294899580(0000) GS:ffffa0af9bc00000(0000) knlGS:0000000000000000
[  774.382177] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  774.383329] CR2: ffffa0a889277028 CR3: 0000000107ef6006 CR4: 0000000000370ef0
[  774.384763] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  774.386229] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  774.387664] Kernel panic - not syncing: Fatal exception
[  774.388863] Kernel Offset: 0x8000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  774.391014] ---[ end Kernel panic - not syncing: Fatal exception ]---

Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: stable@vger.kernel.org
---
 mm/secretmem.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 098638d3b8a4..a83e98aa3a7b 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -158,6 +158,22 @@ const struct address_space_operations secretmem_aops = {
 	.isolate_page	= secretmem_isolate_page,
 };
 
+static int secretmem_setattr(struct user_namespace *mnt_userns,
+			     struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = d_inode(dentry);
+	unsigned int ia_valid = iattr->ia_valid;
+
+	if ((ia_valid & ATTR_SIZE) && inode->i_size)
+		return -EOPNOTSUPP;
+
+	return simple_setattr(mnt_userns, dentry, iattr);
+}
+
+const struct inode_operations secretmem_iops = {
+	.setattr = secretmem_setattr,
+};
+
 static struct vfsmount *secretmem_mnt;
 
 static struct file *secretmem_file_create(unsigned long flags)
@@ -177,6 +193,7 @@ static struct file *secretmem_file_create(unsigned long flags)
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_unevictable(inode->i_mapping);
 
+	inode->i_op = &secretmem_iops;
 	inode->i_mapping->a_ops = &secretmem_aops;
 
 	/* pretend we are a normal file with zero size */
-- 
2.35.1.1021.g381101b075-goog

