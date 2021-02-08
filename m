Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6031C313718
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhBHPTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:19:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231209AbhBHPN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7BDD64EFD;
        Mon,  8 Feb 2021 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797024;
        bh=LBpRctlgsjp6Ty6pZGBIq1HrRNcTVz+SzubAqo4XwKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmxHgA1vvjQ2IlB8JD1C/u1hxLFkBwShvPihBmbu/p6U3eCZMjs9faP3qtrdeNZON
         5TXF4L983oSZehp3y+ftH2iTMHivtx8rSSgTNr85N3CBI3BUV3kuJoRTsN9vQQy9Z2
         s4ILbI4IybBQn+wwbbj82pylQ/1RIX/2NhjcWRfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liangyan <liangyan.peng@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 32/65] ovl: fix dentry leak in ovl_get_redirect
Date:   Mon,  8 Feb 2021 16:01:04 +0100
Message-Id: <20210208145811.470511391@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liangyan <liangyan.peng@linux.alibaba.com>

commit e04527fefba6e4e66492f122cf8cc6314f3cf3bf upstream.

We need to lock d_parent->d_lock before dget_dlock, or this may
have d_lockref updated parallelly like calltrace below which will
cause dentry->d_lockref leak and risk a crash.

     CPU 0                                CPU 1
ovl_set_redirect                       lookup_fast
  ovl_get_redirect                       __d_lookup
    dget_dlock
      //no lock protection here            spin_lock(&dentry->d_lock)
      dentry->d_lockref.count++            dentry->d_lockref.count++

[   49.799059] PGD 800000061fed7067 P4D 800000061fed7067 PUD 61fec5067 PMD 0
[   49.799689] Oops: 0002 [#1] SMP PTI
[   49.800019] CPU: 2 PID: 2332 Comm: node Not tainted 4.19.24-7.20.al7.x86_64 #1
[   49.800678] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 8a46cfe 04/01/2014
[   49.801380] RIP: 0010:_raw_spin_lock+0xc/0x20
[   49.803470] RSP: 0018:ffffac6fc5417e98 EFLAGS: 00010246
[   49.803949] RAX: 0000000000000000 RBX: ffff93b8da3446c0 RCX: 0000000a00000000
[   49.804600] RDX: 0000000000000001 RSI: 000000000000000a RDI: 0000000000000088
[   49.805252] RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff993cf040
[   49.805898] R10: ffff93b92292e580 R11: ffffd27f188a4b80 R12: 0000000000000000
[   49.806548] R13: 00000000ffffff9c R14: 00000000fffffffe R15: ffff93b8da3446c0
[   49.807200] FS:  00007ffbedffb700(0000) GS:ffff93b927880000(0000) knlGS:0000000000000000
[   49.807935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   49.808461] CR2: 0000000000000088 CR3: 00000005e3f74006 CR4: 00000000003606a0
[   49.809113] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   49.809758] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   49.810410] Call Trace:
[   49.810653]  d_delete+0x2c/0xb0
[   49.810951]  vfs_rmdir+0xfd/0x120
[   49.811264]  do_rmdir+0x14f/0x1a0
[   49.811573]  do_syscall_64+0x5b/0x190
[   49.811917]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   49.812385] RIP: 0033:0x7ffbf505ffd7
[   49.814404] RSP: 002b:00007ffbedffada8 EFLAGS: 00000297 ORIG_RAX: 0000000000000054
[   49.815098] RAX: ffffffffffffffda RBX: 00007ffbedffb640 RCX: 00007ffbf505ffd7
[   49.815744] RDX: 0000000004449700 RSI: 0000000000000000 RDI: 0000000006c8cd50
[   49.816394] RBP: 00007ffbedffaea0 R08: 0000000000000000 R09: 0000000000017d0b
[   49.817038] R10: 0000000000000000 R11: 0000000000000297 R12: 0000000000000012
[   49.817687] R13: 00000000072823d8 R14: 00007ffbedffb700 R15: 00000000072823d8
[   49.818338] Modules linked in: pvpanic cirrusfb button qemu_fw_cfg atkbd libps2 i8042
[   49.819052] CR2: 0000000000000088
[   49.819368] ---[ end trace 4e652b8aa299aa2d ]---
[   49.819796] RIP: 0010:_raw_spin_lock+0xc/0x20
[   49.821880] RSP: 0018:ffffac6fc5417e98 EFLAGS: 00010246
[   49.822363] RAX: 0000000000000000 RBX: ffff93b8da3446c0 RCX: 0000000a00000000
[   49.823008] RDX: 0000000000000001 RSI: 000000000000000a RDI: 0000000000000088
[   49.823658] RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff993cf040
[   49.825404] R10: ffff93b92292e580 R11: ffffd27f188a4b80 R12: 0000000000000000
[   49.827147] R13: 00000000ffffff9c R14: 00000000fffffffe R15: ffff93b8da3446c0
[   49.828890] FS:  00007ffbedffb700(0000) GS:ffff93b927880000(0000) knlGS:0000000000000000
[   49.830725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   49.832359] CR2: 0000000000000088 CR3: 00000005e3f74006 CR4: 00000000003606a0
[   49.834085] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   49.835792] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Cc: <stable@vger.kernel.org>
Fixes: a6c606551141 ("ovl: redirect on rename-dir")
Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -940,8 +940,8 @@ static char *ovl_get_redirect(struct den
 
 		buflen -= thislen;
 		memcpy(&buf[buflen], name, thislen);
-		tmp = dget_dlock(d->d_parent);
 		spin_unlock(&d->d_lock);
+		tmp = dget_parent(d);
 
 		dput(d);
 		d = tmp;


