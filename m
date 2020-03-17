Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77404188016
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgCQLHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgCQLHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:07:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FCE620658;
        Tue, 17 Mar 2020 11:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443229;
        bh=87YDOx4vlNwGxbBRUO+lscPSg2TyqTU6nz98NfTHxiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKZhkoJox41Xm7iQ/bGu0HFfXoUDw/e1p3mEjQ0X+w+n44Tw+uQsxWZ9cDb/bZvtn
         CMvYUbM5wtWpSYp4wgWEtGjOP3+wL4WxAYKtAr80qDassTBJKJLj+uno2DabZlI9bT
         x6TUKKPKOwi4hZ/c09jn76VW6d2RpWHMg+Q8gmZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH 5.5 006/151] cxgb4: fix checks for max queues to allocate
Date:   Tue, 17 Mar 2020 11:53:36 +0100
Message-Id: <20200317103326.949456225@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>

[ Upstream commit 116ca924aea664141afa86a1425edc3fcda0d06f ]

Hardware can support more than 8 queues currently limited by
netif_get_num_default_rss_queues(). So, rework and fix checks for max
number of queues to allocate. The checks should be based on how many are
actually supported by hardware, OR the number of online cpus; whichever
is lower.

Fixes: 5952dde72307 ("cxgb4: set maximal number of default RSS queues")
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>"
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |   49 +++++++++++++-----------
 1 file changed, 27 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5351,12 +5351,11 @@ static inline bool is_x_10g_port(const s
 static int cfg_queues(struct adapter *adap)
 {
 	u32 avail_qsets, avail_eth_qsets, avail_uld_qsets;
+	u32 i, n10g = 0, qidx = 0, n1g = 0;
+	u32 ncpus = num_online_cpus();
 	u32 niqflint, neq, num_ulds;
 	struct sge *s = &adap->sge;
-	u32 i, n10g = 0, qidx = 0;
-#ifndef CONFIG_CHELSIO_T4_DCB
-	int q10g = 0;
-#endif
+	u32 q10g = 0, q1g;
 
 	/* Reduce memory usage in kdump environment, disable all offload. */
 	if (is_kdump_kernel() || (is_uld(adap) && t4_uld_mem_alloc(adap))) {
@@ -5394,44 +5393,50 @@ static int cfg_queues(struct adapter *ad
 		n10g += is_x_10g_port(&adap2pinfo(adap, i)->link_cfg);
 
 	avail_eth_qsets = min_t(u32, avail_qsets, MAX_ETH_QSETS);
+
+	/* We default to 1 queue per non-10G port and up to # of cores queues
+	 * per 10G port.
+	 */
+	if (n10g)
+		q10g = (avail_eth_qsets - (adap->params.nports - n10g)) / n10g;
+
+	n1g = adap->params.nports - n10g;
 #ifdef CONFIG_CHELSIO_T4_DCB
 	/* For Data Center Bridging support we need to be able to support up
 	 * to 8 Traffic Priorities; each of which will be assigned to its
 	 * own TX Queue in order to prevent Head-Of-Line Blocking.
 	 */
+	q1g = 8;
 	if (adap->params.nports * 8 > avail_eth_qsets) {
 		dev_err(adap->pdev_dev, "DCB avail_eth_qsets=%d < %d!\n",
 			avail_eth_qsets, adap->params.nports * 8);
 		return -ENOMEM;
 	}
 
-	for_each_port(adap, i) {
-		struct port_info *pi = adap2pinfo(adap, i);
+	if (adap->params.nports * ncpus < avail_eth_qsets)
+		q10g = max(8U, ncpus);
+	else
+		q10g = max(8U, q10g);
 
-		pi->first_qset = qidx;
-		pi->nqsets = is_kdump_kernel() ? 1 : 8;
-		qidx += pi->nqsets;
-	}
-#else /* !CONFIG_CHELSIO_T4_DCB */
-	/* We default to 1 queue per non-10G port and up to # of cores queues
-	 * per 10G port.
-	 */
-	if (n10g)
-		q10g = (avail_eth_qsets - (adap->params.nports - n10g)) / n10g;
-	if (q10g > netif_get_num_default_rss_queues())
-		q10g = netif_get_num_default_rss_queues();
+	while ((q10g * n10g) > (avail_eth_qsets - n1g * q1g))
+		q10g--;
 
-	if (is_kdump_kernel())
+#else /* !CONFIG_CHELSIO_T4_DCB */
+	q1g = 1;
+	q10g = min(q10g, ncpus);
+#endif /* !CONFIG_CHELSIO_T4_DCB */
+	if (is_kdump_kernel()) {
 		q10g = 1;
+		q1g = 1;
+	}
 
 	for_each_port(adap, i) {
 		struct port_info *pi = adap2pinfo(adap, i);
 
 		pi->first_qset = qidx;
-		pi->nqsets = is_x_10g_port(&pi->link_cfg) ? q10g : 1;
+		pi->nqsets = is_x_10g_port(&pi->link_cfg) ? q10g : q1g;
 		qidx += pi->nqsets;
 	}
-#endif /* !CONFIG_CHELSIO_T4_DCB */
 
 	s->ethqsets = qidx;
 	s->max_ethqsets = qidx;   /* MSI-X may lower it later */
@@ -5443,7 +5448,7 @@ static int cfg_queues(struct adapter *ad
 		 * capped by the number of available cores.
 		 */
 		num_ulds = adap->num_uld + adap->num_ofld_uld;
-		i = min_t(u32, MAX_OFLD_QSETS, num_online_cpus());
+		i = min_t(u32, MAX_OFLD_QSETS, ncpus);
 		avail_uld_qsets = roundup(i, adap->params.nports);
 		if (avail_qsets < num_ulds * adap->params.nports) {
 			adap->params.offload = 0;


