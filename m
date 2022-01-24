Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E590849895D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245201AbiAXSza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344084AbiAXSxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2E4C0613A7;
        Mon, 24 Jan 2022 10:52:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD152614E3;
        Mon, 24 Jan 2022 18:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9B4C340E5;
        Mon, 24 Jan 2022 18:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050370;
        bh=xlYj8+vdIvrzfMuQbGn3srN8dLG2vTqYB47vCUgP9Qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDyfMjtliTD+/toqy+LinISx8XnUZPYZTSON8yZzV0a+Ae2xE8iwP59c4bpi91PI6
         Hsh5qf99DY0m4JjlhlAf3e+QmbT3eOTuQhdHQpYZ1ygEbxXrRqYj5Dsl4tcmR0ozW/
         jRA5457VnaoXDVbhRrjz2BT7EdxBssQXy0vCsxyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Cvachoucek <cvachoucek@gmail.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.4 097/114] ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers
Date:   Mon, 24 Jan 2022 19:43:12 +0100
Message-Id: <20220124183930.107878239@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Cvachoucek <cvachoucek@gmail.com>

commit 3fea4d9d160186617ff40490ae01f4f4f36b28ff upstream.

it seems freeing the write buffers in the error path of the
ubifs_remount_rw() is wrong. It leads later to a kernel oops like this:

[10016.431274] UBIFS (ubi0:0): start fixing up free space
[10090.810042] UBIFS (ubi0:0): free space fixup complete
[10090.814623] UBIFS error (ubi0:0 pid 512): ubifs_remount_fs: cannot
spawn "ubifs_bgt0_0", error -4
[10101.915108] UBIFS (ubi0:0): background thread "ubifs_bgt0_0" started,
PID 517
[10105.275498] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000030
[10105.284352] Mem abort info:
[10105.287160]   ESR = 0x96000006
[10105.290252]   EC = 0x25: DABT (current EL), IL = 32 bits
[10105.295592]   SET = 0, FnV = 0
[10105.298652]   EA = 0, S1PTW = 0
[10105.301848] Data abort info:
[10105.304723]   ISV = 0, ISS = 0x00000006
[10105.308573]   CM = 0, WnR = 0
[10105.311564] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000f03d1000
[10105.318034] [0000000000000030] pgd=00000000f6cee003,
pud=00000000f4884003, pmd=0000000000000000
[10105.326783] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[10105.332355] Modules linked in: ath10k_pci ath10k_core ath mac80211
libarc4 cfg80211 nvme nvme_core cryptodev(O)
[10105.342468] CPU: 3 PID: 518 Comm: touch Tainted: G           O
5.4.3 #1
[10105.349517] Hardware name: HYPEX CPU (DT)
[10105.353525] pstate: 40000005 (nZcv daif -PAN -UAO)
[10105.358324] pc : atomic64_try_cmpxchg_acquire.constprop.22+0x8/0x34
[10105.364596] lr : mutex_lock+0x1c/0x34
[10105.368253] sp : ffff000075633aa0
[10105.371563] x29: ffff000075633aa0 x28: 0000000000000001
[10105.376874] x27: ffff000076fa80c8 x26: 0000000000000004
[10105.382185] x25: 0000000000000030 x24: 0000000000000000
[10105.387495] x23: 0000000000000000 x22: 0000000000000038
[10105.392807] x21: 000000000000000c x20: ffff000076fa80c8
[10105.398119] x19: ffff000076fa8000 x18: 0000000000000000
[10105.403429] x17: 0000000000000000 x16: 0000000000000000
[10105.408741] x15: 0000000000000000 x14: fefefefefefefeff
[10105.414052] x13: 0000000000000000 x12: 0000000000000fe0
[10105.419364] x11: 0000000000000fe0 x10: ffff000076709020
[10105.424675] x9 : 0000000000000000 x8 : 00000000000000a0
[10105.429986] x7 : ffff000076fa80f4 x6 : 0000000000000030
[10105.435297] x5 : 0000000000000000 x4 : 0000000000000000
[10105.440609] x3 : 0000000000000000 x2 : ffff00006f276040
[10105.445920] x1 : ffff000075633ab8 x0 : 0000000000000030
[10105.451232] Call trace:
[10105.453676]  atomic64_try_cmpxchg_acquire.constprop.22+0x8/0x34
[10105.459600]  ubifs_garbage_collect+0xb4/0x334
[10105.463956]  ubifs_budget_space+0x398/0x458
[10105.468139]  ubifs_create+0x50/0x180
[10105.471712]  path_openat+0x6a0/0x9b0
[10105.475284]  do_filp_open+0x34/0x7c
[10105.478771]  do_sys_open+0x78/0xe4
[10105.482170]  __arm64_sys_openat+0x1c/0x24
[10105.486180]  el0_svc_handler+0x84/0xc8
[10105.489928]  el0_svc+0x8/0xc
[10105.492808] Code: 52800013 17fffffb d2800003 f9800011 (c85ffc05)
[10105.498903] ---[ end trace 46b721d93267a586 ]---

To reproduce the problem:

1. Filesystem initially mounted read-only, free space fixup flag set.

2. mount -o remount,rw <mountpoint>

3. it takes some time (free space fixup running)
    ... try to terminate running mount by CTRL-C
    ... does not respond, only after free space fixup is complete
    ... then "ubifs_remount_fs: cannot spawn "ubifs_bgt0_0", error -4"

4. mount -o remount,rw <mountpoint>
    ... now finished instantly (fixup already done).

5. Create file or just unmount the filesystem and we get the oops.

Cc: <stable@vger.kernel.org>
Fixes: b50b9f408502 ("UBIFS: do not free write-buffers when in R/O mode")
Signed-off-by: Petr Cvachoucek <cvachoucek@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/super.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1695,7 +1695,6 @@ out:
 		kthread_stop(c->bgt);
 		c->bgt = NULL;
 	}
-	free_wbufs(c);
 	kfree(c->write_reserve_buf);
 	c->write_reserve_buf = NULL;
 	vfree(c->ileb_buf);


