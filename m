Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D780E147D88
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388848AbgAXKB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgAXKB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:01:28 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58E85206D5;
        Fri, 24 Jan 2020 10:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860088;
        bh=Ur9BbBpheYDLZUeTw8gvhibSRDGEq162UaxcoaP1g2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnoSXbpyUjdG1cM5zKUiKxA8XWMDHtHrodi7VtwQ+OKo/sAF5Yyo4jKO+zDhokNKX
         +qOcuo4T6SD3WV+yUipEsKi7GWU8Ax1rsZEmKEtqDcCoo1gJnh3aqgfWYsvQt1kMrx
         8B5HRnE20qFQy9PR/FIkkBi4TOJHilkCIAhKQWVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 238/343] net/af_iucv: always register net_device notifier
Date:   Fri, 24 Jan 2020 10:30:56 +0100
Message-Id: <20200124092951.440361039@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 06996c1d4088a0d5f3e7789d7f96b4653cc947cc ]

Even when running as VM guest (ie pr_iucv != NULL), af_iucv can still
open HiperTransport-based connections. For robust operation these
connections require the af_iucv_netdev_notifier, so register it
unconditionally.

Also handle any error that register_netdevice_notifier() returns.

Fixes: 9fbd87d41392 ("af_iucv: handle netdev events")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index ca98276c27097..7a9cbc9502d9c 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2446,6 +2446,13 @@ out:
 	return err;
 }
 
+static void afiucv_iucv_exit(void)
+{
+	device_unregister(af_iucv_dev);
+	driver_unregister(&af_iucv_driver);
+	pr_iucv->iucv_unregister(&af_iucv_handler, 0);
+}
+
 static int __init afiucv_init(void)
 {
 	int err;
@@ -2479,11 +2486,18 @@ static int __init afiucv_init(void)
 		err = afiucv_iucv_init();
 		if (err)
 			goto out_sock;
-	} else
-		register_netdevice_notifier(&afiucv_netdev_notifier);
+	}
+
+	err = register_netdevice_notifier(&afiucv_netdev_notifier);
+	if (err)
+		goto out_notifier;
+
 	dev_add_pack(&iucv_packet_type);
 	return 0;
 
+out_notifier:
+	if (pr_iucv)
+		afiucv_iucv_exit();
 out_sock:
 	sock_unregister(PF_IUCV);
 out_proto:
@@ -2497,12 +2511,11 @@ out:
 static void __exit afiucv_exit(void)
 {
 	if (pr_iucv) {
-		device_unregister(af_iucv_dev);
-		driver_unregister(&af_iucv_driver);
-		pr_iucv->iucv_unregister(&af_iucv_handler, 0);
+		afiucv_iucv_exit();
 		symbol_put(iucv_if);
-	} else
-		unregister_netdevice_notifier(&afiucv_netdev_notifier);
+	}
+
+	unregister_netdevice_notifier(&afiucv_netdev_notifier);
 	dev_remove_pack(&iucv_packet_type);
 	sock_unregister(PF_IUCV);
 	proto_unregister(&iucv_proto);
-- 
2.20.1



