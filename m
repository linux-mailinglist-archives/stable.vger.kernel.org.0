Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E19E106A83
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfKVKf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:35:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfKVKf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:35:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49C5720715;
        Fri, 22 Nov 2019 10:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418926;
        bh=p3wOtXFwCxxL6GayYEYYWLwTqQWP8j50iQYNkNIRsMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlHz10DTD25qq0IMmmiG8iSb9EMlP5sSthgoooSlUgFJOr9ieSYoSenu2DhjzkhjW
         Nh4El3yJfRgH5sbWC8okzC8zdyp0yBqSupk9JAIHleFanbR+YFdhDyLN9fuBcZ86Ox
         3D2/BMcT+dqb8aclv6WlTk6SMU0fEYaCSN+BaGHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH 4.4 099/159] slcan: Fix memory leak in error path
Date:   Fri, 22 Nov 2019 11:28:10 +0100
Message-Id: <20191122100819.529582595@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

commit ed50e1600b4483c049ce76e6bd3b665a6a9300ed upstream.

This patch is fixing memory leak reported by Syzkaller:

BUG: memory leak unreferenced object 0xffff888067f65500 (size 4096):
  comm "syz-executor043", pid 454, jiffies 4294759719 (age 11.930s)
  hex dump (first 32 bytes):
    73 6c 63 61 6e 30 00 00 00 00 00 00 00 00 00 00 slcan0..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  backtrace:
    [<00000000a06eec0d>] __kmalloc+0x18b/0x2c0
    [<0000000083306e66>] kvmalloc_node+0x3a/0xc0
    [<000000006ac27f87>] alloc_netdev_mqs+0x17a/0x1080
    [<0000000061a996c9>] slcan_open+0x3ae/0x9a0
    [<000000001226f0f9>] tty_ldisc_open.isra.1+0x76/0xc0
    [<0000000019289631>] tty_set_ldisc+0x28c/0x5f0
    [<000000004de5a617>] tty_ioctl+0x48d/0x1590
    [<00000000daef496f>] do_vfs_ioctl+0x1c7/0x1510
    [<0000000059068dbc>] ksys_ioctl+0x99/0xb0
    [<000000009a6eb334>] __x64_sys_ioctl+0x78/0xb0
    [<0000000053d0332e>] do_syscall_64+0x16f/0x580
    [<0000000021b83b99>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<000000008ea75434>] 0xffffffffffffffff

Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
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
+	free_netdev(sl->dev);
 
 err_exit:
 	rtnl_unlock();


