Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E815A1F451A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388656AbgFISLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:11:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41252 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388131AbgFISF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-0001oL-1K; Tue, 09 Jun 2020 19:05:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006Vue-8t; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jouni Hogander" <jouni.hogander@unikie.com>,
        "Lukas Bulwahn" <lukas.bulwahn@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        "Oliver Hartkopp" <socketcan@hartkopp.net>,
        syzbot+4d5170758f3762109542@syzkaller.appspotmail.com
Date:   Tue, 09 Jun 2020 19:03:56 +0100
Message-ID: <lsq.1591725832.69289718@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 05/61] slip: Fix use-after-free Read in slip_open
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Hogander <jouni.hogander@unikie.com>

commit e58c1912418980f57ba2060017583067f5f71e52 upstream.

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
[bwh: Backported to 3.16: sl_free_netdev() calls free_netdev() here, so
 delete the direct call to free_netdev()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -867,7 +867,7 @@ err_free_chan:
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
-	free_netdev(sl->dev);
+	sl_free_netdev(sl->dev);
 
 err_exit:
 	rtnl_unlock();

