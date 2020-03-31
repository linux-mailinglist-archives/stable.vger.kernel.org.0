Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4161198F71
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgCaJD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730597AbgCaJDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB005208E0;
        Tue, 31 Mar 2020 09:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645404;
        bh=PFJ61hZlXewm98PbidinrVr4O2dRVdQs+bRrFd1QcbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gk+DrDXlxd3iXOvwPAD3AOGWpRvcJ3J7ipBtR1h9yvByQ6sXESMNsu7nCfBhRvvj4
         o60SvuyyOFu7u3J2yRvqf+FgYOYqD8JjTHGB/qWQrB1J1KFYobiy37eiVcYRsWNTlj
         FYNIt8S17+JFJOPEI6kPjzZvbnerJrPDJYAgIePE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 043/170] bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()
Date:   Tue, 31 Mar 2020 10:57:37 +0200
Message-Id: <20200331085429.012819417@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit 62d4073e86e62e316bea2c53e77db10418fd5dd7 ]

The allocated ieee_ets structure goes out of scope without being freed,
leaking memory. Appropriate result codes should be returned so that
callers do not rely on invalid data passed by reference.

Also cache the ETS config retrieved from the device so that it doesn't
need to be freed. The balance of the code was clearly written with the
intent of having the results of querying the hardware cached in the
device structure. The commensurate store was evidently missed though.

Fixes: 7df4ae9fe855 ("bnxt_en: Implement DCBNL to support host-based DCBX.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -479,24 +479,26 @@ static int bnxt_dcbnl_ieee_getets(struct
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct ieee_ets *my_ets = bp->ieee_ets;
+	int rc;
 
 	ets->ets_cap = bp->max_tc;
 
 	if (!my_ets) {
-		int rc;
-
 		if (bp->dcbx_cap & DCB_CAP_DCBX_HOST)
 			return 0;
 
 		my_ets = kzalloc(sizeof(*my_ets), GFP_KERNEL);
 		if (!my_ets)
-			return 0;
+			return -ENOMEM;
 		rc = bnxt_hwrm_queue_cos2bw_qcfg(bp, my_ets);
 		if (rc)
-			return 0;
+			goto error;
 		rc = bnxt_hwrm_queue_pri2cos_qcfg(bp, my_ets);
 		if (rc)
-			return 0;
+			goto error;
+
+		/* cache result */
+		bp->ieee_ets = my_ets;
 	}
 
 	ets->cbs = my_ets->cbs;
@@ -505,6 +507,9 @@ static int bnxt_dcbnl_ieee_getets(struct
 	memcpy(ets->tc_tsa, my_ets->tc_tsa, sizeof(ets->tc_tsa));
 	memcpy(ets->prio_tc, my_ets->prio_tc, sizeof(ets->prio_tc));
 	return 0;
+error:
+	kfree(my_ets);
+	return rc;
 }
 
 static int bnxt_dcbnl_ieee_setets(struct net_device *dev, struct ieee_ets *ets)


