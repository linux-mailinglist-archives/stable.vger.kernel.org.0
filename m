Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA45126D8F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfLSShf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:55304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbfLSShf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:37:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8D9520716;
        Thu, 19 Dec 2019 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780654;
        bh=ZR19IDXpPk3hAdCKhmbkx3xf7pwKHMAIoGz17JSoSRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqeMCsGqreDVDzSxC3FteM6mRnFH17BUaLgTpCKRL+pe6wBC4iSlxcuz+ry8dMqaI
         coRfMbmMYp3hFhOpggxC/4owSi1OoKKQBT6JB5+6BytkOiQ3+wsELTXVbN/YnK7bSQ
         N8zVQ5BLAdpAIwH0o/7gp+zQr6C3jQdYHqLv3t9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Miller <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>
Subject: [PATCH 4.4 061/162] can: slcan: Fix use-after-free Read in slcan_open
Date:   Thu, 19 Dec 2019 19:32:49 +0100
Message-Id: <20191219183211.572493148@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

commit 9ebd796e24008f33f06ebea5a5e6aceb68b51794 upstream.

Slcan_open doesn't clean-up device which registration failed from the
slcan_devs device list. On next open this list is iterated and freed
device is accessed. Fix this by calling slc_free_netdev in error path.

Driver/net/can/slcan.c is derived from slip.c. Use-after-free error was
identified in slip_open by syzboz. Same bug is in slcan.c. Here is the
trace from the Syzbot slip report:

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

Fixes: ed50e1600b44 ("slcan: Fix memory leak in error path")
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: David Miller <davem@davemloft.net>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/slcan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -613,6 +613,7 @@ err_free_chan:
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	slc_free_netdev(sl->dev);
 	free_netdev(sl->dev);
 
 err_exit:


