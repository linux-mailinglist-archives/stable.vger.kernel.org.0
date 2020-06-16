Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590101FB9F6
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731682AbgFPPqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729867AbgFPPqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:46:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F7E92071A;
        Tue, 16 Jun 2020 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322404;
        bh=hNqsT/ZksuoAUV5wXP1oPVvBuiiQkkr1eY9eKN7FN6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gG1kqQ3AR73Yvs9VEhKjxtKSzk6Hy1haIkPMfL2HwtPit12nEvZ2txTcknVfchQxF
         etH23SmZgtd2TdWqrmYInbfVpneeAzVLcCp/ozkAI56soLvF8Hr8YCS4DCP4aVdczS
         kzjmtVNNiv1HJOnIsTlhtNIK4juJoMDJt5krWLOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7 117/163] exfat: fix memory leak in exfat_parse_param()
Date:   Tue, 16 Jun 2020 17:34:51 +0200
Message-Id: <20200616153112.410137542@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit f341a7d8dcc4e3d01544d7bc145633f062ef6249 upstream.

butt3rflyh4ck reported memory leak found by syzkaller.

A param->string held by exfat_mount_options.

BUG: memory leak

unreferenced object 0xffff88801972e090 (size 8):
  comm "syz-executor.2", pid 16298, jiffies 4295172466 (age 14.060s)
  hex dump (first 8 bytes):
    6b 6f 69 38 2d 75 00 00                          koi8-u..
  backtrace:
    [<000000005bfe35d6>] kstrdup+0x36/0x70 mm/util.c:60
    [<0000000018ed3277>] exfat_parse_param+0x160/0x5e0
fs/exfat/super.c:276
    [<000000007680462b>] vfs_parse_fs_param+0x2b4/0x610
fs/fs_context.c:147
    [<0000000097c027f2>] vfs_parse_fs_string+0xe6/0x150
fs/fs_context.c:191
    [<00000000371bf78f>] generic_parse_monolithic+0x16f/0x1f0
fs/fs_context.c:231
    [<000000005ce5eb1b>] do_new_mount fs/namespace.c:2812 [inline]
    [<000000005ce5eb1b>] do_mount+0x12bb/0x1b30 fs/namespace.c:3141
    [<00000000b642040c>] __do_sys_mount fs/namespace.c:3350 [inline]
    [<00000000b642040c>] __se_sys_mount fs/namespace.c:3327 [inline]
    [<00000000b642040c>] __x64_sys_mount+0x18f/0x230 fs/namespace.c:3327
    [<000000003b024e98>] do_syscall_64+0xf6/0x7d0
arch/x86/entry/common.c:295
    [<00000000ce2b698c>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

exfat_free() should call exfat_free_iocharset(), to prevent a leak
in case we fail after parsing iocharset= but before calling
get_tree_bdev().

Additionally, there's no point copying param->string in
exfat_parse_param() - just steal it, leaving NULL in param->string.
That's independent from the leak or fix thereof - it's simply
avoiding an extra copy.

Fixes: 719c1e182916 ("exfat: add super block operations")
Cc: stable@vger.kernel.org # v5.7
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exfat/super.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -273,9 +273,8 @@ static int exfat_parse_param(struct fs_c
 		break;
 	case Opt_charset:
 		exfat_free_iocharset(sbi);
-		opts->iocharset = kstrdup(param->string, GFP_KERNEL);
-		if (!opts->iocharset)
-			return -ENOMEM;
+		opts->iocharset = param->string;
+		param->string = NULL;
 		break;
 	case Opt_errors:
 		opts->errors = result.uint_32;
@@ -630,7 +629,12 @@ static int exfat_get_tree(struct fs_cont
 
 static void exfat_free(struct fs_context *fc)
 {
-	kfree(fc->s_fs_info);
+	struct exfat_sb_info *sbi = fc->s_fs_info;
+
+	if (sbi) {
+		exfat_free_iocharset(sbi);
+		kfree(sbi);
+	}
 }
 
 static const struct fs_context_operations exfat_context_ops = {


