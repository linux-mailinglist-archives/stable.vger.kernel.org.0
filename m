Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39D4F572C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733061AbfKHTS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389521AbfKHTAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB0F42247A;
        Fri,  8 Nov 2019 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239490;
        bh=ALXLVrMT++fTiNRn7HeIjfwjcrLRnK0M8YRl47E6Qnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wm9WXtmQvfJTl7NmhQz/Vmerr/O6u+miWuMAxRfcwnbB2tEPv/wdQamFRJ/o68RXZ
         Rjms+aVDdN2rnRv88yT4YXwc+e5u9T7R/HIiQfYkkVmZpDx+QQsSXw9LzW+fr4kEbL
         /ZjXpxyIP5rTSnkiBLa0dtpXg0VUvBpDPaGYLenw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shahjada Abul Husain <shahjada@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 23/62] cxgb4: fix panic when attaching to ULD fail
Date:   Fri,  8 Nov 2019 19:50:11 +0100
Message-Id: <20191108174739.009216039@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
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
@@ -670,10 +670,10 @@ static void uld_init(struct adapter *ada
 	lld->fr_nsmr_tpte_wr_support = adap->params.fr_nsmr_tpte_wr_support;
 }
 
-static void uld_attach(struct adapter *adap, unsigned int uld)
+static int uld_attach(struct adapter *adap, unsigned int uld)
 {
-	void *handle;
 	struct cxgb4_lld_info lli;
+	void *handle;
 
 	uld_init(adap, &lli);
 	uld_queue_init(adap, uld, &lli);
@@ -683,7 +683,7 @@ static void uld_attach(struct adapter *a
 		dev_warn(adap->pdev_dev,
 			 "could not attach to the %s driver, error %ld\n",
 			 adap->uld[uld].name, PTR_ERR(handle));
-		return;
+		return PTR_ERR(handle);
 	}
 
 	adap->uld[uld].handle = handle;
@@ -691,23 +691,24 @@ static void uld_attach(struct adapter *a
 
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
@@ -741,12 +742,16 @@ int cxgb4_register_uld(enum cxgb4_uld ty
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


