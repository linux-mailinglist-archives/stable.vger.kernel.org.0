Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBE714B625
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgA1OCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgA1OCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3A2B205F4;
        Tue, 28 Jan 2020 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220169;
        bh=L5tXybbfFwLNhPwySu2m1ddDBS2AwIZyIJJ34ryLuCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXEXinvH3fPTC5uiAgLlfoWR8U13hDI/rgzanIW+ZAxldEx0ZsaZzU0Rden+GEUUf
         iYp9iJdX2eD63BW1itnOotJm+6KNdgGSWc4VcEDhtrAoRZMLwnLbUnJNnBiLFcQu6S
         Ym8DVI6SURQaODyNxF4gMaid7+MdEIjYuU1SElIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com,
        David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>
Subject: [PATCH 5.4 013/104] net-sysfs: Fix reference count leak
Date:   Tue, 28 Jan 2020 14:59:34 +0100
Message-Id: <20200128135819.067629019@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

[ Upstream commit cb626bf566eb4433318d35681286c494f04fedcc ]

Netdev_register_kobject is calling device_initialize. In case of error
reference taken by device_initialize is not given up.

Drivers are supposed to call free_netdev in case of error. In non-error
case the last reference is given up there and device release sequence
is triggered. In error case this reference is kept and the release
sequence is never started.

Fix this by setting reg_state as NETREG_UNREGISTERED if registering
fails.

This is the rootcause for couple of memory leaks reported by Syzkaller:

BUG: memory leak unreferenced object 0xffff8880675ca008 (size 256):
  comm "netdev_register", pid 281, jiffies 4294696663 (age 6.808s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  backtrace:
    [<0000000058ca4711>] kmem_cache_alloc_trace+0x167/0x280
    [<000000002340019b>] device_add+0x882/0x1750
    [<000000001d588c3a>] netdev_register_kobject+0x128/0x380
    [<0000000011ef5535>] register_netdevice+0xa1b/0xf00
    [<000000007fcf1c99>] __tun_chr_ioctl+0x20d5/0x3dd0
    [<000000006a5b7b2b>] tun_chr_ioctl+0x2f/0x40
    [<00000000f30f834a>] do_vfs_ioctl+0x1c7/0x1510
    [<00000000fba062ea>] ksys_ioctl+0x99/0xb0
    [<00000000b1c1b8d2>] __x64_sys_ioctl+0x78/0xb0
    [<00000000984cabb9>] do_syscall_64+0x16f/0x580
    [<000000000bde033d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000e6ca2d9f>] 0xffffffffffffffff

BUG: memory leak
unreferenced object 0xffff8880668ba588 (size 8):
  comm "kobject_set_nam", pid 286, jiffies 4294725297 (age 9.871s)
  hex dump (first 8 bytes):
    6e 72 30 00 cc be df 2b                          nr0....+
  backtrace:
    [<00000000a322332a>] __kmalloc_track_caller+0x16e/0x290
    [<00000000236fd26b>] kstrdup+0x3e/0x70
    [<00000000dd4a2815>] kstrdup_const+0x3e/0x50
    [<0000000049a377fc>] kvasprintf_const+0x10e/0x160
    [<00000000627fc711>] kobject_set_name_vargs+0x5b/0x140
    [<0000000019eeab06>] dev_set_name+0xc0/0xf0
    [<0000000069cb12bc>] netdev_register_kobject+0xc8/0x320
    [<00000000f2e83732>] register_netdevice+0xa1b/0xf00
    [<000000009e1f57cc>] __tun_chr_ioctl+0x20d5/0x3dd0
    [<000000009c560784>] tun_chr_ioctl+0x2f/0x40
    [<000000000d759e02>] do_vfs_ioctl+0x1c7/0x1510
    [<00000000351d7c31>] ksys_ioctl+0x99/0xb0
    [<000000008390040a>] __x64_sys_ioctl+0x78/0xb0
    [<0000000052d196b7>] do_syscall_64+0x16f/0x580
    [<0000000019af9236>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000bc384531>] 0xffffffffffffffff

v3 -> v4:
  Set reg_state to NETREG_UNREGISTERED if registering fails

v2 -> v3:
* Replaced BUG_ON with WARN_ON in free_netdev and netdev_release

v1 -> v2:
* Relying on driver calling free_netdev rather than calling
  put_device directly in error path

Reported-by: syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com
Cc: David Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9082,8 +9082,10 @@ int register_netdevice(struct net_device
 		goto err_uninit;
 
 	ret = netdev_register_kobject(dev);
-	if (ret)
+	if (ret) {
+		dev->reg_state = NETREG_UNREGISTERED;
 		goto err_uninit;
+	}
 	dev->reg_state = NETREG_REGISTERED;
 
 	__netdev_update_features(dev);


