Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E16EF55AE
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389264AbfKHTEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389401AbfKHTEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A03820650;
        Fri,  8 Nov 2019 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239839;
        bh=tNf64DL/4DtEM2E0M34hHHFkgT7A8t4mmajD3IE6c3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYro4NtsOYdS2ewth7SyowpQkLYyE3QEQPtW2LT25VRput8sY0hd1Bdb2EMPs4jlt
         knRBeskcf2Q2zMS1crp9jD70SW/zWWuFbzdg5XOsuK5zExAIC7NykbGVHC0QiBj74o
         DOKKFOHPvUcGO4sL1rYnZZzVG9gjMw8on76APRIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shahjada Abul Husain <shahjada@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 37/79] cxgb4: fix panic when attaching to ULD fail
Date:   Fri,  8 Nov 2019 19:50:17 +0100
Message-Id: <20191108174807.577466159@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
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
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c |   29 ++++++++++++++-----------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -673,10 +673,10 @@ static void uld_init(struct adapter *ada
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
@@ -686,7 +686,7 @@ static void uld_attach(struct adapter *a
 		dev_warn(adap->pdev_dev,
 			 "could not attach to the %s driver, error %ld\n",
 			 adap->uld[uld].name, PTR_ERR(handle));
-		return;
+		return PTR_ERR(handle);
 	}
 
 	adap->uld[uld].handle = handle;
@@ -694,23 +694,24 @@ static void uld_attach(struct adapter *a
 
 	if (adap->flags & FULL_INIT_DONE)
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
+ * about any presently available devices that support its type.  Returns
+ * %-EBUSY if a ULD of the same type is already registered.
  */
 int cxgb4_register_uld(enum cxgb4_uld type,
 		       const struct cxgb4_uld_info *p)
 {
-	int ret = 0;
 	unsigned int adap_idx = 0;
 	struct adapter *adap;
+	int ret = 0;
 
 	if (type >= CXGB4_ULD_MAX)
 		return -EINVAL;
@@ -744,12 +745,16 @@ int cxgb4_register_uld(enum cxgb4_uld ty
 		if (ret)
 			goto free_irq;
 		adap->uld[type] = *p;
-		uld_attach(adap, type);
+		ret = uld_attach(adap, type);
+		if (ret)
+			goto free_txq;
 		adap_idx++;
 	}
 	mutex_unlock(&uld_mutex);
 	return 0;
 
+free_txq:
+	release_sge_txq_uld(adap, type);
 free_irq:
 	if (adap->flags & FULL_INIT_DONE)
 		quiesce_rx_uld(adap, type);


