Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BCB2C0B6E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732229AbgKWNYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730549AbgKWMdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:33:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5805720888;
        Mon, 23 Nov 2020 12:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134824;
        bh=lYUHFsfMSCvVN1o385q1QZefOqjlrdDMMZNDJSIOhaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5HxP0zi21e/kjp/W+Z6FG9N82ha5U1vmJw3u5UNHDQUG13gCn5aWLRVVOphuO0ZI
         Anbkh2SCXtiwD7DdvPlzK0l4Hss4NIxqEQaVJmjOTP8OSqWpC+/WMdXZz1AdMkdtep
         RGaBV1jme4nKKr2NA1bu9nPe5/V9vFTDDwrLFvGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.19 73/91] efivarfs: fix memory leak in efivarfs_create()
Date:   Mon, 23 Nov 2020 13:22:33 +0100
Message-Id: <20201123121812.868073417@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>

commit fe5186cf12e30facfe261e9be6c7904a170bd822 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/efivarfs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -23,6 +23,7 @@ LIST_HEAD(efivarfs_list);
 static void efivarfs_evict_inode(struct inode *inode)
 {
 	clear_inode(inode);
+	kfree(inode->i_private);
 }
 
 static const struct super_operations efivarfs_ops = {


