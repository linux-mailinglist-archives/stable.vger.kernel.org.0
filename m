Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD92F5647
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388499AbfKHTHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391499AbfKHTHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EC5A2196F;
        Fri,  8 Nov 2019 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240069;
        bh=VhfGaG+t7C4m+boCGdvk/o/VWd6GI2UgcnodDBhjEtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiMgUzrWkbgsvY/uQ0lyGtyDOUFjezPXVOF5fjyG7cZbAmHUEFTOMi7FXyB9p/eIf
         4V8ZkpgpdHe86TzbIxvUskHXz7NTfb26KXSW3dArkTecchHzepxxjH8R38sixjjuo0
         Sr454osXWZCszbSny+6DZlA7qBywiGX7RsPZXGQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shahjada Abul Husain <shahjada@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 079/140] cxgb4: fix panic when attaching to ULD fail
Date:   Fri,  8 Nov 2019 19:50:07 +0100
Message-Id: <20191108174910.104572878@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>

[ Upstream commit fc89cc358fb64e2429aeae0f37906126636507ec ]

Release resources when attaching to ULD fail. Otherwise, data
mismatch is seen between LLD and ULD later on, which lead to
kernel panic when accessing resources that should not even
exist in the first place.

Fixes: 94cdb8bb993a ("cxgb4: Add support for dynamic allocation of resources for ULD")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c |   28 ++++++++++++++-----------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -695,10 +695,10 @@ static void uld_init(struct adapter *ada
 	lld->write_cmpl_support = adap->params.write_cmpl_support;
 }
 
-static void uld_attach(struct adapter *adap, unsigned int uld)
+static int uld_attach(struct adapter *adap, unsigned int uld)
 {
-	void *handle;
 	struct cxgb4_lld_info lli;
+	void *handle;
 
 	uld_init(adap, &lli);
 	uld_queue_init(adap, uld, &lli);
@@ -708,7 +708,7 @@ static void uld_attach(struct adapter *a
 		dev_warn(adap->pdev_dev,
 			 "could not attach to the %s driver, error %ld\n",
 			 adap->uld[uld].name, PTR_ERR(handle));
-		return;
+		return PTR_ERR(handle);
 	}
 
 	adap->uld[uld].handle = handle;
@@ -716,22 +716,22 @@ static void uld_attach(struct adapter *a
 
 	if (adap->flags & CXGB4_FULL_INIT_DONE)
 		adap->uld[uld].state_change(handle, CXGB4_STATE_UP);
+
+	return 0;
 }
 
-/**
- *	cxgb4_register_uld - register an upper-layer driver
- *	@type: the ULD type
- *	@p: the ULD methods
+/* cxgb4_register_uld - register an upper-layer driver
+ * @type: the ULD type
+ * @p: the ULD methods
  *
- *	Registers an upper-layer driver with this driver and notifies the ULD
- *	about any presently available devices that support its type.  Returns
- *	%-EBUSY if a ULD of the same type is already registered.
+ * Registers an upper-layer driver with this driver and notifies the ULD
+ * about any presently available devices that support its type.
  */
 void cxgb4_register_uld(enum cxgb4_uld type,
 			const struct cxgb4_uld_info *p)
 {
-	int ret = 0;
 	struct adapter *adap;
+	int ret = 0;
 
 	if (type >= CXGB4_ULD_MAX)
 		return;
@@ -763,8 +763,12 @@ void cxgb4_register_uld(enum cxgb4_uld t
 		if (ret)
 			goto free_irq;
 		adap->uld[type] = *p;
-		uld_attach(adap, type);
+		ret = uld_attach(adap, type);
+		if (ret)
+			goto free_txq;
 		continue;
+free_txq:
+		release_sge_txq_uld(adap, type);
 free_irq:
 		if (adap->flags & CXGB4_FULL_INIT_DONE)
 			quiesce_rx_uld(adap, type);


