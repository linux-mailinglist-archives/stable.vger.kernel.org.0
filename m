Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BE31677E3
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgBUHts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:49:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728915AbgBUHtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:49:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E770207FD;
        Fri, 21 Feb 2020 07:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271387;
        bh=z70ujt1EqXAZKyx0yyjAuQe/ZW4XhB3+LwH5tlRzWqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ij5GzNZnieMU3Qb1AKCRTktbQb5LrKJmaZbNn4R5IhsPqek0icQg+1JOz/HaPgDqq
         qGSaqWs79l50SwqmSyQYSbgjCxFm1sFBWNy1QdSwvaui9WbuP02DiIceUW0l6K+3IT
         QKzvUmB1RhWg0k9SjJKNlysX0RECV3xhFSqdrHDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 145/399] fore200e: Fix incorrect checks of NULL pointer dereference
Date:   Fri, 21 Feb 2020 08:37:50 +0100
Message-Id: <20200221072416.610622795@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit bbd20c939c8aa3f27fa30e86691af250bf92973a ]

In fore200e_send and fore200e_close, the pointers from the arguments
are dereferenced in the variable declaration block and then checked
for NULL. The patch fixes these issues by avoiding NULL pointer
dereferences.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/fore200e.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index f1a5002053132..8fbd36eb89410 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1414,12 +1414,14 @@ fore200e_open(struct atm_vcc *vcc)
 static void
 fore200e_close(struct atm_vcc* vcc)
 {
-    struct fore200e*        fore200e = FORE200E_DEV(vcc->dev);
     struct fore200e_vcc*    fore200e_vcc;
+    struct fore200e*        fore200e;
     struct fore200e_vc_map* vc_map;
     unsigned long           flags;
 
     ASSERT(vcc);
+    fore200e = FORE200E_DEV(vcc->dev);
+
     ASSERT((vcc->vpi >= 0) && (vcc->vpi < 1<<FORE200E_VPI_BITS));
     ASSERT((vcc->vci >= 0) && (vcc->vci < 1<<FORE200E_VCI_BITS));
 
@@ -1464,10 +1466,10 @@ fore200e_close(struct atm_vcc* vcc)
 static int
 fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
-    struct fore200e*        fore200e     = FORE200E_DEV(vcc->dev);
-    struct fore200e_vcc*    fore200e_vcc = FORE200E_VCC(vcc);
+    struct fore200e*        fore200e;
+    struct fore200e_vcc*    fore200e_vcc;
     struct fore200e_vc_map* vc_map;
-    struct host_txq*        txq          = &fore200e->host_txq;
+    struct host_txq*        txq;
     struct host_txq_entry*  entry;
     struct tpd*             tpd;
     struct tpd_haddr        tpd_haddr;
@@ -1480,9 +1482,18 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
     unsigned char*          data;
     unsigned long           flags;
 
-    ASSERT(vcc);
-    ASSERT(fore200e);
-    ASSERT(fore200e_vcc);
+    if (!vcc)
+        return -EINVAL;
+
+    fore200e = FORE200E_DEV(vcc->dev);
+    fore200e_vcc = FORE200E_VCC(vcc);
+
+    if (!fore200e)
+        return -EINVAL;
+
+    txq = &fore200e->host_txq;
+    if (!fore200e_vcc)
+        return -EINVAL;
 
     if (!test_bit(ATM_VF_READY, &vcc->flags)) {
 	DPRINTK(1, "VC %d.%d.%d not ready for tx\n", vcc->itf, vcc->vpi, vcc->vpi);
-- 
2.20.1



