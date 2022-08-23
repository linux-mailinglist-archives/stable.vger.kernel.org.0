Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B5D59E3BC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242870AbiHWMaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbiHWM3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:29:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B2DFF8D3;
        Tue, 23 Aug 2022 02:44:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A03DDB81C65;
        Tue, 23 Aug 2022 09:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F138DC433C1;
        Tue, 23 Aug 2022 09:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247820;
        bh=TJ0hjOox9xfZp8N7oYDTFILobmWhpXnKqlLxgwauRfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvgQ6LW2QLwnalfvMvV6Q15zV9wjIoTyz2axp3JoR63J6caVHFnvsi5rGHU3mOVyP
         N1I1IzGBSs/INdgXHwcUSxHAqRqAS7JPRCNPdUCpE1pDgPrFockrYY36wVA9EFS+bw
         4cc/QuAkjmyEMz2Fp+kqLJCs4IGirnh9Tsv3xzW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Goriainov <goriainov@ispras.ru>
Subject: [PATCH 5.10 157/158] qrtr: Convert qrtr_ports from IDR to XArray
Date:   Tue, 23 Aug 2022 10:28:09 +0200
Message-Id: <20220823080052.096211402@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 3cbf7530a163d048a6376cd22fecb9cdcb23b192 upstream.

The XArray interface is easier for this driver to use.  Also fixes a
bug reported by the improper use of GFP_ATOMIC.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Stanislav Goriainov <goriainov@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |   42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -20,6 +20,8 @@
 /* auto-bind range */
 #define QRTR_MIN_EPH_SOCKET 0x4000
 #define QRTR_MAX_EPH_SOCKET 0x7fff
+#define QRTR_EPH_PORT_RANGE \
+		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
 
 /**
  * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
@@ -106,8 +108,7 @@ static LIST_HEAD(qrtr_all_nodes);
 static DEFINE_MUTEX(qrtr_node_lock);
 
 /* local port allocation management */
-static DEFINE_IDR(qrtr_ports);
-static DEFINE_MUTEX(qrtr_port_lock);
+static DEFINE_XARRAY_ALLOC(qrtr_ports);
 
 /**
  * struct qrtr_node - endpoint node
@@ -635,7 +636,7 @@ static struct qrtr_sock *qrtr_port_looku
 		port = 0;
 
 	rcu_read_lock();
-	ipc = idr_find(&qrtr_ports, port);
+	ipc = xa_load(&qrtr_ports, port);
 	if (ipc)
 		sock_hold(&ipc->sk);
 	rcu_read_unlock();
@@ -677,9 +678,7 @@ static void qrtr_port_remove(struct qrtr
 
 	__sock_put(&ipc->sk);
 
-	mutex_lock(&qrtr_port_lock);
-	idr_remove(&qrtr_ports, port);
-	mutex_unlock(&qrtr_port_lock);
+	xa_erase(&qrtr_ports, port);
 
 	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
 	 * wait for it to up increment the refcount */
@@ -698,29 +697,20 @@ static void qrtr_port_remove(struct qrtr
  */
 static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 {
-	u32 min_port;
 	int rc;
 
-	mutex_lock(&qrtr_port_lock);
 	if (!*port) {
-		min_port = QRTR_MIN_EPH_SOCKET;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
-		if (!rc)
-			*port = min_port;
+		rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_EPH_PORT_RANGE,
+				GFP_KERNEL);
 	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
 		rc = -EACCES;
 	} else if (*port == QRTR_PORT_CTRL) {
-		min_port = 0;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, 0, GFP_ATOMIC);
+		rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
 	} else {
-		min_port = *port;
-		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, *port, GFP_ATOMIC);
-		if (!rc)
-			*port = min_port;
+		rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
 	}
-	mutex_unlock(&qrtr_port_lock);
 
-	if (rc == -ENOSPC)
+	if (rc == -EBUSY)
 		return -EADDRINUSE;
 	else if (rc < 0)
 		return rc;
@@ -734,20 +724,16 @@ static int qrtr_port_assign(struct qrtr_
 static void qrtr_reset_ports(void)
 {
 	struct qrtr_sock *ipc;
-	int id;
-
-	mutex_lock(&qrtr_port_lock);
-	idr_for_each_entry(&qrtr_ports, ipc, id) {
-		/* Don't reset control port */
-		if (id == 0)
-			continue;
+	unsigned long index;
 
+	rcu_read_lock();
+	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
 		sock_hold(&ipc->sk);
 		ipc->sk.sk_err = ENETRESET;
 		ipc->sk.sk_error_report(&ipc->sk);
 		sock_put(&ipc->sk);
 	}
-	mutex_unlock(&qrtr_port_lock);
+	rcu_read_unlock();
 }
 
 /* Bind socket to address.


