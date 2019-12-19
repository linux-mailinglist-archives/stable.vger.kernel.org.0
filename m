Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA54B126DB0
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfLSTKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfLSSjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:39:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F682222C2;
        Thu, 19 Dec 2019 18:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780744;
        bh=sgvSsHT1HrAvcpowKwzs5s4e7dGUrVatLm0FTA/3/lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwUg3EIJwYMtCRh0RRufZ6Bvd9y9De+GOzQgiWcspBXIiS+0rztBQnr+P2eB1w/ag
         3GuB95TPmayMUJGg4jQbTugVJnbUB6Q34Wh4+EbzJ7BjvS+hS7nPGLggJgpvHxD6AM
         5UMDoCVaaXx0XPx5eV0niBRHolkUEaVk0D9P2aDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 072/162] appletalk: Fix potential NULL pointer dereference in unregister_snap_client
Date:   Thu, 19 Dec 2019 19:33:00 +0100
Message-Id: <20191219183212.195804514@linuxfoundation.org>
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
[bwh: Backported to <4.15: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/atalk.h |    2 +-
 net/appletalk/aarp.c  |   15 ++++++++++++---
 net/appletalk/ddp.c   |   20 ++++++++++++--------
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
@@ -1911,9 +1911,6 @@ static unsigned char ddp_snap_id[] = { 0
 EXPORT_SYMBOL(atrtr_get_dev);
 EXPORT_SYMBOL(atalk_find_dev_addr);
 
-static const char atalk_err_snap[] __initconst =
-	KERN_CRIT "Unable to register DDP with SNAP.\n";
-
 /* Called by proto.c on kernel start up */
 static int __init atalk_init(void)
 {
@@ -1928,17 +1925,22 @@ static int __init atalk_init(void)
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
@@ -1952,11 +1954,13 @@ out_proc:
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


