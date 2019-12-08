Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6001161D7
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLHNz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:55:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60536 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbfLHNyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:46 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1G-0007he-Ij; Sun, 08 Dec 2019 13:54:42 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1E-0002PF-Vg; Sun, 08 Dec 2019 13:54:40 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "YueHaibing" <yuehaibing@huawei.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Sun, 08 Dec 2019 13:53:44 +0000
Message-ID: <lsq.1575813165.375922229@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 60/72] appletalk: Fix potential NULL pointer
 dereference in unregister_snap_client
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

commit 9804501fa1228048857910a6bf23e085aade37cc upstream.

register_snap_client may return NULL, all the callers
check it, but only print a warning. This will result in
NULL pointer dereference in unregister_snap_client and other
places.

It has always been used like this since v2.6

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/atalk.h |  2 +-
 net/appletalk/aarp.c  | 15 ++++++++++++---
 net/appletalk/ddp.c   | 20 ++++++++++++--------
 3 files changed, 25 insertions(+), 12 deletions(-)

--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -107,7 +107,7 @@ static __inline__ struct elapaarp *aarp_
 #define AARP_RESOLVE_TIME	(10 * HZ)
 
 extern struct datalink_proto *ddp_dl, *aarp_dl;
-extern void aarp_proto_init(void);
+extern int aarp_proto_init(void);
 
 /* Inter module exports */
 
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -879,15 +879,24 @@ static struct notifier_block aarp_notifi
 
 static unsigned char aarp_snap_id[] = { 0x00, 0x00, 0x00, 0x80, 0xF3 };
 
-void __init aarp_proto_init(void)
+int __init aarp_proto_init(void)
 {
+	int rc;
+
 	aarp_dl = register_snap_client(aarp_snap_id, aarp_rcv);
-	if (!aarp_dl)
+	if (!aarp_dl) {
 		printk(KERN_CRIT "Unable to register AARP with SNAP.\n");
+		return -ENOMEM;
+	}
 	setup_timer(&aarp_timer, aarp_expire_timeout, 0);
 	aarp_timer.expires  = jiffies + sysctl_aarp_expiry_time;
 	add_timer(&aarp_timer);
-	register_netdevice_notifier(&aarp_notifier);
+	rc = register_netdevice_notifier(&aarp_notifier);
+	if (rc) {
+		del_timer_sync(&aarp_timer);
+		unregister_snap_client(aarp_dl);
+	}
+	return rc;
 }
 
 /* Remove the AARP entries associated with a device. */
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1912,9 +1912,6 @@ static unsigned char ddp_snap_id[] = { 0
 EXPORT_SYMBOL(atrtr_get_dev);
 EXPORT_SYMBOL(atalk_find_dev_addr);
 
-static const char atalk_err_snap[] __initconst =
-	KERN_CRIT "Unable to register DDP with SNAP.\n";
-
 /* Called by proto.c on kernel start up */
 static int __init atalk_init(void)
 {
@@ -1929,17 +1926,22 @@ static int __init atalk_init(void)
 		goto out_proto;
 
 	ddp_dl = register_snap_client(ddp_snap_id, atalk_rcv);
-	if (!ddp_dl)
-		printk(atalk_err_snap);
+	if (!ddp_dl) {
+		pr_crit("Unable to register DDP with SNAP.\n");
+		goto out_sock;
+	}
 
 	dev_add_pack(&ltalk_packet_type);
 	dev_add_pack(&ppptalk_packet_type);
 
 	rc = register_netdevice_notifier(&ddp_notifier);
 	if (rc)
-		goto out_sock;
+		goto out_snap;
+
+	rc = aarp_proto_init();
+	if (rc)
+		goto out_dev;
 
-	aarp_proto_init();
 	rc = atalk_proc_init();
 	if (rc)
 		goto out_aarp;
@@ -1953,11 +1955,13 @@ out_proc:
 	atalk_proc_exit();
 out_aarp:
 	aarp_cleanup_module();
+out_dev:
 	unregister_netdevice_notifier(&ddp_notifier);
-out_sock:
+out_snap:
 	dev_remove_pack(&ppptalk_packet_type);
 	dev_remove_pack(&ltalk_packet_type);
 	unregister_snap_client(ddp_dl);
+out_sock:
 	sock_unregister(PF_APPLETALK);
 out_proto:
 	proto_unregister(&ddp_proto);

