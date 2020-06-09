Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049911F4518
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388394AbgFISLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:11:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41240 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388135AbgFISF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-0001oN-SM; Tue, 09 Jun 2020 19:05:52 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidE-006Vum-AX; Tue, 09 Jun 2020 19:05:52 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Lukas Bulwahn" <lukas.bulwahn@gmail.com>,
        "David Miller" <davem@davemloft.net>,
        "Jouni Hogander" <jouni.hogander@unikie.com>
Date:   Tue, 09 Jun 2020 19:03:58 +0100
Message-ID: <lsq.1591725832.855703324@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 07/61] net-sysfs: Fix reference count leak in
 rx|netdev_queue_add_kobject
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

commit b8eb718348b8fb30b5a7d0a8fce26fb3f4ac741b upstream.

kobject_init_and_add takes reference even when it fails. This has
to be given up by the caller in error handling. Otherwise memory
allocated by kobject_init_and_add is never freed. Originally found
by Syzkaller:

BUG: memory leak
unreferenced object 0xffff8880679f8b08 (size 8):
  comm "netdev_register", pid 269, jiffies 4294693094 (age 12.132s)
  hex dump (first 8 bytes):
    72 78 2d 30 00 36 20 d4                          rx-0.6 .
  backtrace:
    [<000000008c93818e>] __kmalloc_track_caller+0x16e/0x290
    [<000000001f2e4e49>] kvasprintf+0xb1/0x140
    [<000000007f313394>] kvasprintf_const+0x56/0x160
    [<00000000aeca11c8>] kobject_set_name_vargs+0x5b/0x140
    [<0000000073a0367c>] kobject_init_and_add+0xd8/0x170
    [<0000000088838e4b>] net_rx_queue_update_kobjects+0x152/0x560
    [<000000006be5f104>] netdev_register_kobject+0x210/0x380
    [<00000000e31dab9d>] register_netdevice+0xa1b/0xf00
    [<00000000f68b2465>] __tun_chr_ioctl+0x20d5/0x3dd0
    [<000000004c50599f>] tun_chr_ioctl+0x2f/0x40
    [<00000000bbd4c317>] do_vfs_ioctl+0x1c7/0x1510
    [<00000000d4c59e8f>] ksys_ioctl+0x99/0xb0
    [<00000000946aea81>] __x64_sys_ioctl+0x78/0xb0
    [<0000000038d946e5>] do_syscall_64+0x16f/0x580
    [<00000000e0aa5d8f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<00000000285b3d1a>] 0xffffffffffffffff

Cc: David Miller <davem@davemloft.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/net-sysfs.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -786,21 +786,23 @@ static int rx_queue_add_kobject(struct n
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
 	    "rx-%u", index);
 	if (error)
-		return error;
+		goto err;
 
 	dev_hold(queue->dev);
 
 	if (net->sysfs_rx_queue_group) {
 		error = sysfs_create_group(kobj, net->sysfs_rx_queue_group);
-		if (error) {
-			kobject_put(kobj);
-			return error;
-		}
+		if (error)
+			goto err;
 	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
 	return error;
+
+err:
+	kobject_put(kobj);
+	return error;
 }
 #endif /* CONFIG_SYSFS */
 
@@ -1145,21 +1147,21 @@ static int netdev_queue_add_kobject(stru
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
 	    "tx-%u", index);
 	if (error)
-		return error;
+		goto err;
 
 	dev_hold(queue->dev);
 
 #ifdef CONFIG_BQL
 	error = sysfs_create_group(kobj, &dql_group);
-	if (error) {
-		kobject_put(kobj);
-		return error;
-	}
+	if (error)
+		goto err;
 #endif
 
 	kobject_uevent(kobj, KOBJ_ADD);
 
-	return 0;
+err:
+	kobject_put(kobj);
+	return error;
 }
 #endif /* CONFIG_SYSFS */
 

