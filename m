Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755AA2016BC
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388385AbgFSOmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388025AbgFSOmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:42:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7602158C;
        Fri, 19 Jun 2020 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577756;
        bh=P3J1uhq5KaE5PWts86ExAV3RvdYcRyFqVg7BLWLL3Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKQ4cNbQnhsS1i5VkdfXF4Nwefm9h4BKx/b5Rj3ulQM4WR0EAab7X16hKExQjteTe
         719S87Qw3sfAcQ89GrHtc92U2ahkORhS80IVZcJHEBGU7HBdEhjTamOxMS1L8+tBj5
         jt9sYAWaDBAc5TR4xQn1RTy9YTP0rrde5I1CuSTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 076/128] net: lpc-enet: fix error return code in lpc_mii_init()
Date:   Fri, 19 Jun 2020 16:32:50 +0200
Message-Id: <20200619141624.205385764@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 88ec7cb22ddde725ed4ce15991f0bd9dd817fd85 ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 9fcaf1910633..9b98ec3dcb82 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -845,7 +845,8 @@ static int lpc_mii_init(struct netdata_local *pldat)
 	if (mdiobus_register(pldat->mii_bus))
 		goto err_out_unregister_bus;
 
-	if (lpc_mii_probe(pldat->ndev) != 0)
+	err = lpc_mii_probe(pldat->ndev);
+	if (err)
 		goto err_out_unregister_bus;
 
 	return 0;
-- 
2.25.1



