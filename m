Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460F92E99B9
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbhADQDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbhADQDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 260A6224DF;
        Mon,  4 Jan 2021 16:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776140;
        bh=G23dfkrAHPZhboxC+aXY8DzjP5Px6s/TVN7rP+2ICP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+ODs5tPda2fLEO5qHEQRNmcMR89KLR0ge1cDwzTAoYZPlVPiIhEL33+mB4Zt0t5c
         JUVm7+OT1C4Rkk4Nla4D1epJfHzq+ee32/Nix1lCYeOJaacDQ9fUkgu+aRX5o7sMQA
         bvyRIKj440T0E6no/zDCV5iA0oZhlmUBgS27P844=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jamie Iles <jamie@nuviainc.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/63] jffs2: Fix NULL pointer dereference in rp_size fs option parsing
Date:   Mon,  4 Jan 2021 16:57:02 +0100
Message-Id: <20210104155709.260418079@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Iles <jamie@nuviainc.com>

[ Upstream commit a61df3c413e49b0042f9caf774c58512d1cc71b7 ]

syzkaller found the following JFFS2 splat:

  Unable to handle kernel paging request at virtual address dfffa00000000001
  Mem abort info:
    ESR = 0x96000004
    EC = 0x25: DABT (current EL), IL = 32 bits
    SET = 0, FnV = 0
    EA = 0, S1PTW = 0
  Data abort info:
    ISV = 0, ISS = 0x00000004
    CM = 0, WnR = 0
  [dfffa00000000001] address between user and kernel address ranges
  Internal error: Oops: 96000004 [#1] SMP
  Dumping ftrace buffer:
     (ftrace buffer empty)
  Modules linked in:
  CPU: 0 PID: 12745 Comm: syz-executor.5 Tainted: G S                5.9.0-rc8+ #98
  Hardware name: linux,dummy-virt (DT)
  pstate: 20400005 (nzCv daif +PAN -UAO BTYPE=--)
  pc : jffs2_parse_param+0x138/0x308 fs/jffs2/super.c:206
  lr : jffs2_parse_param+0x108/0x308 fs/jffs2/super.c:205
  sp : ffff000022a57910
  x29: ffff000022a57910 x28: 0000000000000000
  x27: ffff000057634008 x26: 000000000000d800
  x25: 000000000000d800 x24: ffff0000271a9000
  x23: ffffa0001adb5dc0 x22: ffff000023fdcf00
  x21: 1fffe0000454af2c x20: ffff000024cc9400
  x19: 0000000000000000 x18: 0000000000000000
  x17: 0000000000000000 x16: ffffa000102dbdd0
  x15: 0000000000000000 x14: ffffa000109e44bc
  x13: ffffa00010a3a26c x12: ffff80000476e0b3
  x11: 1fffe0000476e0b2 x10: ffff80000476e0b2
  x9 : ffffa00010a3ad60 x8 : ffff000023b70593
  x7 : 0000000000000003 x6 : 00000000f1f1f1f1
  x5 : ffff000023fdcf00 x4 : 0000000000000002
  x3 : ffffa00010000000 x2 : 0000000000000001
  x1 : dfffa00000000000 x0 : 0000000000000008
  Call trace:
   jffs2_parse_param+0x138/0x308 fs/jffs2/super.c:206
   vfs_parse_fs_param+0x234/0x4e8 fs/fs_context.c:117
   vfs_parse_fs_string+0xe8/0x148 fs/fs_context.c:161
   generic_parse_monolithic+0x17c/0x208 fs/fs_context.c:201
   parse_monolithic_mount_data+0x7c/0xa8 fs/fs_context.c:649
   do_new_mount fs/namespace.c:2871 [inline]
   path_mount+0x548/0x1da8 fs/namespace.c:3192
   do_mount+0x124/0x138 fs/namespace.c:3205
   __do_sys_mount fs/namespace.c:3413 [inline]
   __se_sys_mount fs/namespace.c:3390 [inline]
   __arm64_sys_mount+0x164/0x238 fs/namespace.c:3390
   __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
   invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
   el0_svc_common.constprop.0+0x15c/0x598 arch/arm64/kernel/syscall.c:149
   do_el0_svc+0x60/0x150 arch/arm64/kernel/syscall.c:195
   el0_svc+0x34/0xb0 arch/arm64/kernel/entry-common.c:226
   el0_sync_handler+0xc8/0x5b4 arch/arm64/kernel/entry-common.c:236
   el0_sync+0x15c/0x180 arch/arm64/kernel/entry.S:663
  Code: d2d40001 f2fbffe1 91002260 d343fc02 (38e16841)
  ---[ end trace 4edf690313deda44 ]---

This is because since ec10a24f10c8, the option parsing happens before
fill_super and so the MTD device isn't associated with the filesystem.
Defer the size check until there is a valid association.

Fixes: ec10a24f10c8 ("vfs: Convert jffs2 to use the new mount API")
Cc: <stable@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/super.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index c523adaca79f3..81ca58c10b728 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -202,12 +202,8 @@ static int jffs2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_rp_size:
 		if (result.uint_32 > UINT_MAX / 1024)
 			return invalf(fc, "jffs2: rp_size unrepresentable");
-		opt = result.uint_32 * 1024;
-		if (opt > c->mtd->size)
-			return invalf(fc, "jffs2: Too large reserve pool specified, max is %llu KB",
-				      c->mtd->size / 1024);
+		c->mount_opts.rp_size = result.uint_32 * 1024;
 		c->mount_opts.set_rp_size = true;
-		c->mount_opts.rp_size = opt;
 		break;
 	default:
 		return -EINVAL;
@@ -269,6 +265,10 @@ static int jffs2_fill_super(struct super_block *sb, struct fs_context *fc)
 	c->mtd = sb->s_mtd;
 	c->os_priv = sb;
 
+	if (c->mount_opts.rp_size > c->mtd->size)
+		return invalf(fc, "jffs2: Too large reserve pool specified, max is %llu KB",
+			      c->mtd->size / 1024);
+
 	/* Initialize JFFS2 superblock locks, the further initialization will
 	 * be done later */
 	mutex_init(&c->alloc_sem);
-- 
2.27.0



