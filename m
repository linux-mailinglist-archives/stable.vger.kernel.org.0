Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C98CD442
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfJFRYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbfJFRYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:24:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EE622080F;
        Sun,  6 Oct 2019 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382640;
        bh=vTl9zJpljgQsfufSouxqoZf5478I80hsMeKWww/XdhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Okv0FPGRdB1gDVO+gFv+/XqPfJ4IDbdEr7z1U7cxlz5YN30/WWH6ARr0iVX0Ao6jC
         le5EM79D0ZiFCAKyw3fgaV3Da34FOWlJeAQuMJRtE7gaE9ECyRrBECb2wPbJEG2279
         X5fgDLQ5Y7mLplgtYgi4fimOAYORTzKL/3BJel+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shahjada Abul Husain <shahjada@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 32/47] cxgb4:Fix out-of-bounds MSI-X info array access
Date:   Sun,  6 Oct 2019 19:21:19 +0200
Message-Id: <20191006172018.586286013@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006172016.873463083@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>

[ Upstream commit 6b517374f4ea5a3c6e307e1219ec5f35d42e6d00 ]

When fetching free MSI-X vectors for ULDs, check for the error code
before accessing MSI-X info array. Otherwise, an out-of-bounds access is
attempted, which results in kernel panic.

Fixes: 94cdb8bb993a ("cxgb4: Add support for dynamic allocation of resources for ULD")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -137,13 +137,12 @@ static int uldrx_handler(struct sge_rspq
 static int alloc_uld_rxqs(struct adapter *adap,
 			  struct sge_uld_rxq_info *rxq_info, bool lro)
 {
-	struct sge *s = &adap->sge;
 	unsigned int nq = rxq_info->nrxq + rxq_info->nciq;
+	int i, err, msi_idx, que_idx = 0, bmap_idx = 0;
 	struct sge_ofld_rxq *q = rxq_info->uldrxq;
 	unsigned short *ids = rxq_info->rspq_id;
-	unsigned int bmap_idx = 0;
+	struct sge *s = &adap->sge;
 	unsigned int per_chan;
-	int i, err, msi_idx, que_idx = 0;
 
 	per_chan = rxq_info->nrxq / adap->params.nports;
 
@@ -161,6 +160,10 @@ static int alloc_uld_rxqs(struct adapter
 
 		if (msi_idx >= 0) {
 			bmap_idx = get_msix_idx_from_bmap(adap);
+			if (bmap_idx < 0) {
+				err = -ENOSPC;
+				goto freeout;
+			}
 			msi_idx = adap->msix_info_ulds[bmap_idx].idx;
 		}
 		err = t4_sge_alloc_rxq(adap, &q->rspq, false,


