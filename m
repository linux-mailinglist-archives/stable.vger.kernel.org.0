Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA682B6C1C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 18:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgKQRrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 12:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbgKQRrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 12:47:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2646DC0613CF;
        Tue, 17 Nov 2020 09:47:13 -0800 (PST)
Date:   Tue, 17 Nov 2020 17:47:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605635231;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TtcJ/Dhuz1KukPIcUPXcf25NvLw1I8V/R0UBTaSf6c=;
        b=h67FLW+MBNaga4uIUQkLpERbff8jiuI07FrAX/+XfJOMhuDvP4wxanAj/4eMP8FtnqX8yH
        K27mfj1hvKmEHcIrlKhH/dRgt6ubzpWxgRcnjo+Om2q1La4Dic68i6j1EAYQT4h9O5h9Mi
        qbAx78ZA2+2Fa+a5QmBjR6aRpId8lUATokH4jKnkq6II7kkGtbTeem1L0jAoElzlEEyCq9
        o+40tWf3u9QgAOw6AbIhaL364BrnS5ng/kLBRoLwxv0442jg4Y+xeYsK6ZjD4jmXwk94Or
        lwTQpdq0aQdKjZt0HIo89PpGh3YgSdKyU7mTazgAny4x6qs181EvoYFNz/Z3yA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605635231;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TtcJ/Dhuz1KukPIcUPXcf25NvLw1I8V/R0UBTaSf6c=;
        b=AjOBiTchlV7Kpw4YmF0fu+2f72GRsyTvEKD9l2yib8z+4SuX89C11E5Rcakht1kkBsWh/g
        2m+zxyfLAGelpAAw==
From:   "tip-bot2 for Vamshi K Sthambamkadi" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efivarfs: fix memory leak in efivarfs_create()
Cc:     <stable@vger.kernel.org>,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201023115429.GA2479@cosmos>
References: <20201023115429.GA2479@cosmos>
MIME-Version: 1.0
Message-ID: <160563523031.11244.13285027603206176660.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     fe5186cf12e30facfe261e9be6c7904a170bd822
Gitweb:        https://git.kernel.org/tip/fe5186cf12e30facfe261e9be6c7904a170bd822
Author:        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
AuthorDate:    Fri, 23 Oct 2020 17:24:39 +05:30
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Mon, 26 Oct 2020 08:15:24 +01:00

efivarfs: fix memory leak in efivarfs_create()

kmemleak report:
  unreferenced object 0xffff9b8915fcb000 (size 4096):
  comm "efivarfs.sh", pid 2360, jiffies 4294920096 (age 48.264s)
  hex dump (first 32 bytes):
    2d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  -...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000cc4d897c>] kmem_cache_alloc_trace+0x155/0x4b0
    [<000000007d1dfa72>] efivarfs_create+0x6e/0x1a0
    [<00000000e6ee18fc>] path_openat+0xe4b/0x1120
    [<000000000ad0414f>] do_filp_open+0x91/0x100
    [<00000000ce93a198>] do_sys_openat2+0x20c/0x2d0
    [<000000002a91be6d>] do_sys_open+0x46/0x80
    [<000000000a854999>] __x64_sys_openat+0x20/0x30
    [<00000000c50d89c9>] do_syscall_64+0x38/0x90
    [<00000000cecd6b5f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

In efivarfs_create(), inode->i_private is setup with efivar_entry
object which is never freed.

Cc: <stable@vger.kernel.org>
Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
Link: https://lore.kernel.org/r/20201023115429.GA2479@cosmos
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 fs/efivarfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 15880a6..f943fd0 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -21,6 +21,7 @@ LIST_HEAD(efivarfs_list);
 static void efivarfs_evict_inode(struct inode *inode)
 {
 	clear_inode(inode);
+	kfree(inode->i_private);
 }
 
 static const struct super_operations efivarfs_ops = {
