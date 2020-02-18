Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064CC1621E4
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 08:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgBRH5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 02:57:48 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53643 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgBRH5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 02:57:47 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7800621D6E;
        Tue, 18 Feb 2020 02:57:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 18 Feb 2020 02:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=apR6k2
        3Qgy/fBF2gHABWDfGIg0iCp5HPK0tfDY+3OLc=; b=WQ1r5Z6SYro2gaPTMQyrCA
        TDc1nvXCu8RAw68ocUXcSrjCf1GSP1OB9CbeRZ/QhC0ua7iLIDORDx5s5f9qTCAz
        dfu+TAvjlt/pivF3UMMe4z0vQXZkLpXJMwLD4sdGQKo9Z+O1MxQ2xa2mFgsZ1eT1
        5RfpuPdc0KEx+SG3rYL+XaUL74pujQLyDtXU4lIz6EDID2+xj1Ks8o5Iz9Oqa3Ql
        rY/ZNC4kPknJ5PBtwqCNkeIGyyETkbMv0RkgAWvuyYUxnnbQdLi17pzejfycrexJ
        vaRe7tYR6ceSuXk6lbBZyh8ilT0eIeGrvppF/U+wk2F4VTYkgkii7aWP1RtHu2Og
        ==
X-ME-Sender: <xms:-phLXsPtB96c_ws4BOQFeXITwEi85plSzn-5zjTGjKjwVbjgqgDmZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeejgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehqvghmuhdrohhrghdpkhgvrhhnvghlrdhorhhgnecukfhppe
    ekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-phLXnNj5pPc2HSAVWyj-oVEHRKP3gQVfSyjZNAdYen2VZZBFOM8Xw>
    <xmx:-phLXuSWICCNhYlwzVG4_1EPeDtAGyV-__FBDgSdruW9KT7Q8dZMPw>
    <xmx:-phLXpAgoNaTYPCcmESh1ytOvEIeEqnPIAxJGmY7IsjrSib5GgCrHQ>
    <xmx:-phLXo-cKqEc0iF8OuGejNj91wKvfTuzjvgKqbZO1ohkQurhnN0tdA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC618328005E;
        Tue, 18 Feb 2020 02:57:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] RDMA/core: Fix invalid memory access in spec_filter_size" failed to apply to 4.14-stable tree
To:     avihaih@mellanox.com, jgg@mellanox.com, leonro@mellanox.com,
        maorg@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Feb 2020 08:57:42 +0100
Message-ID: <15820126624280@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a72f4ac1d778f7bde93dfee69bfc23377ec3d74f Mon Sep 17 00:00:00 2001
From: Avihai Horon <avihaih@mellanox.com>
Date: Sun, 26 Jan 2020 19:15:00 +0200
Subject: [PATCH] RDMA/core: Fix invalid memory access in spec_filter_size

Add a check that the size specified in the flow spec header doesn't cause
an overflow when calculating the filter size, and thus prevent access to
invalid memory.  The following crash from syzkaller revealed it.

  kasan: CONFIG_KASAN_INLINE enabled
  kasan: GPF could be caused by NULL-ptr deref or user memory access
  general protection fault: 0000 [#1] SMP KASAN PTI
  CPU: 1 PID: 17834 Comm: syz-executor.3 Not tainted 5.5.0-rc5 #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
  RIP: 0010:memchr_inv+0xd3/0x330
  Code: 89 f9 89 f5 83 e1 07 0f 85 f9 00 00 00 49 89 d5 49 c1 ed 03 45 85
  ed 74 6f 48 89 d9 48 b8 00 00 00 00 00 fc ff df 48 c1 e9 03 <80> 3c 01
  00 0f 85 0d 02 00 00 44 0f b6 e5 48 b8 01 01 01 01 01 01
  RSP: 0018:ffffc9000a13fa50 EFLAGS: 00010202
  RAX: dffffc0000000000 RBX: 7fff88810de9d820 RCX: 0ffff11021bd3b04
  RDX: 000000000000fff8 RSI: 0000000000000000 RDI: 7fff88810de9d820
  RBP: 0000000000000000 R08: ffff888110d69018 R09: 0000000000000009
  R10: 0000000000000001 R11: ffffed10236267cc R12: 0000000000000004
  R13: 0000000000001fff R14: ffff88810de9d820 R15: 0000000000000040
  FS:  00007f9ee0e51700(0000) GS:ffff88811b100000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000115ea0006 CR4: 0000000000360ee0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   spec_filter_size.part.16+0x34/0x50
   ib_uverbs_kern_spec_to_ib_spec_filter+0x691/0x770
   ib_uverbs_ex_create_flow+0x9ea/0x1b40
   ib_uverbs_write+0xaa5/0xdf0
   __vfs_write+0x7c/0x100
   vfs_write+0x168/0x4a0
   ksys_write+0xc8/0x200
   do_syscall_64+0x9c/0x390
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x465b49
  Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89
  f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
  f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
  RSP: 002b:00007f9ee0e50c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
  RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000465b49
  RDX: 00000000000003a0 RSI: 00000000200007c0 RDI: 0000000000000004
  RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9ee0e516bc
  R13: 00000000004ca2da R14: 000000000070deb8 R15: 00000000ffffffff
  Modules linked in:
  Dumping ftrace buffer:
     (ftrace buffer empty)

Fixes: 94e03f11ad1f ("IB/uverbs: Add support for flow tag")
Link: https://lore.kernel.org/r/20200126171500.4623-1-leon@kernel.org
Signed-off-by: Avihai Horon <avihaih@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index c8693f5231dd..025933752e1d 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2745,12 +2745,6 @@ static int kern_spec_to_ib_spec_action(struct uverbs_attr_bundle *attrs,
 	return 0;
 }
 
-static size_t kern_spec_filter_sz(const struct ib_uverbs_flow_spec_hdr *spec)
-{
-	/* Returns user space filter size, includes padding */
-	return (spec->size - sizeof(struct ib_uverbs_flow_spec_hdr)) / 2;
-}
-
 static ssize_t spec_filter_size(const void *kern_spec_filter, u16 kern_filter_size,
 				u16 ib_real_filter_sz)
 {
@@ -2894,11 +2888,16 @@ int ib_uverbs_kern_spec_to_ib_spec_filter(enum ib_flow_spec_type type,
 static int kern_spec_to_ib_spec_filter(struct ib_uverbs_flow_spec *kern_spec,
 				       union ib_flow_spec *ib_spec)
 {
-	ssize_t kern_filter_sz;
+	size_t kern_filter_sz;
 	void *kern_spec_mask;
 	void *kern_spec_val;
 
-	kern_filter_sz = kern_spec_filter_sz(&kern_spec->hdr);
+	if (check_sub_overflow((size_t)kern_spec->hdr.size,
+			       sizeof(struct ib_uverbs_flow_spec_hdr),
+			       &kern_filter_sz))
+		return -EINVAL;
+
+	kern_filter_sz /= 2;
 
 	kern_spec_val = (void *)kern_spec +
 		sizeof(struct ib_uverbs_flow_spec_hdr);

