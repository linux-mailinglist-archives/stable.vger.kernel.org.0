Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 566F0113498
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfLDSAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729434AbfLDSAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:00:48 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EDB920833;
        Wed,  4 Dec 2019 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482447;
        bh=++kv+KeKfGMg3IoKC0FD1iBtYXrwWcW/HHkAtrTZE8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYhmaVns5m8MbNrUciea8rBMVruCSKs0WegFicA5D6lFWLQBdQ1kcvd6mVsSDhBi/
         264ZChpNJA/HSq50z0wUSp3JOewYEcz9BvlrHqS/2kHf/WJ8nfVOpUZXr27kN2vFKm
         1SKfwgHYCQqI+ZY3nj6E0lk47K5A84+miCpA2myA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4d5170758f3762109542@syzkaller.appspotmail.com,
        David Miller <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>
Subject: [PATCH 4.4 85/92] slip: Fix use-after-free Read in slip_open
Date:   Wed,  4 Dec 2019 18:50:25 +0100
Message-Id: <20191204174335.302449183@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

[ Upstream commit e58c1912418980f57ba2060017583067f5f71e52 ]

Slip_open doesn't clean-up device which registration failed from the
slip_devs device list. On next open after failure this list is iterated
and freed device is accessed. Fix this by calling sl_free_netdev in error
path.

Here is the trace from the Syzbot:

__dump_stack lib/dump_stack.c:77 [inline]
dump_stack+0x197/0x210 lib/dump_stack.c:118
print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
__kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
kasan_report+0x12/0x20 mm/kasan/common.c:634
__asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
sl_sync drivers/net/slip/slip.c:725 [inline]
slip_open+0xecd/0x11b7 drivers/net/slip/slip.c:801
tty_ldisc_open.isra.0+0xa3/0x110 drivers/tty/tty_ldisc.c:469
tty_set_ldisc+0x30e/0x6b0 drivers/tty/tty_ldisc.c:596
tiocsetd drivers/tty/tty_io.c:2334 [inline]
tty_ioctl+0xe8d/0x14f0 drivers/tty/tty_io.c:2594
vfs_ioctl fs/ioctl.c:46 [inline]
file_ioctl fs/ioctl.c:509 [inline]
do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
__do_sys_ioctl fs/ioctl.c:720 [inline]
__se_sys_ioctl fs/ioctl.c:718 [inline]
__x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 3b5a39979daf ("slip: Fix memory leak in slip_open error path")
Reported-by: syzbot+4d5170758f3762109542@syzkaller.appspotmail.com
Cc: David Miller <davem@davemloft.net>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/slip/slip.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -860,6 +860,7 @@ err_free_chan:
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	sl_free_netdev(sl->dev);
 	free_netdev(sl->dev);
 
 err_exit:


