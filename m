Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3017167439
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387732AbgBUITa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388024AbgBUIT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:19:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C5624691;
        Fri, 21 Feb 2020 08:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273169;
        bh=37Tl3sdRVJVadsU+L3wETW4srSquGpwjxB81nM98w+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YawEy/yWIypE7RdU2qJLkyvi4bObUcZXY7FRROitbahWMFdRGTz/U3wecEG6jHFiU
         2nFxv9VGFVM0iQIAC8PoNIiUTn1oY4a9TloU1y1DjtKnDM/QAGEKBayIKOYvD6SzuF
         s67o9yOtctSZqp9JSq4yEl/CF1w5ZD2PasGcwDLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/191] fore200e: Fix incorrect checks of NULL pointer dereference
Date:   Fri, 21 Feb 2020 08:40:44 +0100
Message-Id: <20200221072259.864567901@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
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
index 99a38115b0a8f..86aab14872fd0 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1504,12 +1504,14 @@ fore200e_open(struct atm_vcc *vcc)
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
 
@@ -1554,10 +1556,10 @@ fore200e_close(struct atm_vcc* vcc)
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
@@ -1570,9 +1572,18 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
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



