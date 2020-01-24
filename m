Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AEE147B18
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbgAXJkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732541AbgAXJkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:40 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930E4208C4;
        Fri, 24 Jan 2020 09:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858840;
        bh=QGoTyyzI+HMaF25JNBKXf8DJXtaz6z5VCHjtGIpTIQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZa032sLK5v8o5AvUrEcOMlHhAl05a6cq55w8I484sVvHluejZ+EHmNw0XdyoCpWf
         keEPwogPDM0LWpKNGnJATmBct+BmwXF80/oRJVJ126ECltIgpoE6A4Gz5tbXXKE707
         wMiAGO6zIbt0E+xZ6YAWM5skasn96s/olpD9XEI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/102] dpaa2-eth: Fix minor bug in ethtool stats reporting
Date:   Fri, 24 Jan 2020 10:30:56 +0100
Message-Id: <20200124092814.639431918@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

[ Upstream commit 4b177f065e7ec37399b18e18412a8c7b75f8f299 ]

Don't print error message for a successful return value.

Fixes: d84c3a4ded96 ("dpaa2-eth: Add new DPNI statistics counters")

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 0aa1c34019bbe..dc9a6c36cac02 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -216,7 +216,7 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		if (err == -EINVAL)
 			/* Older firmware versions don't support all pages */
 			memset(&dpni_stats, 0, sizeof(dpni_stats));
-		else
+		else if (err)
 			netdev_warn(net_dev, "dpni_get_stats(%d) failed\n", j);
 
 		num_cnt = dpni_stats_page_size[j] / sizeof(u64);
-- 
2.20.1



