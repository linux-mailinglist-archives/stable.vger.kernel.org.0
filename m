Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F8F419ACA
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbhI0RMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236237AbhI0RKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B371611C3;
        Mon, 27 Sep 2021 17:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762474;
        bh=u5hZJU/JVpiUgVVDRqOJzkqDord0GSfEfYc0az6Wsww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aPOdl9/2ltNW0Cn4iC4zS6xPM2E4lBRV9X0QY2DIqIMbLFgzPSykDA2dTnxgWNO9
         kiQHdoIAHXI6pCIxfvN1PnFXJYfjkP6SParBeOaXo88Ks3FshGPnsU3crsVYW44oZa
         4VdTVWEY/nsbiHpsJp8Mto0a+7zZ3vmXN7MwxOlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/103] enetc: Fix uninitialized struct dim_sample field usage
Date:   Mon, 27 Sep 2021 19:02:09 +0200
Message-Id: <20210927170227.029475056@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 9f7afa05c9522b086327929ae622facab0f0f72b ]

The only struct dim_sample member that does not get
initialized by dim_update_sample() is comp_ctr. (There
is special API to initialize comp_ctr:
dim_update_sample_with_comps(), and it is currently used
only for RDMA.) comp_ctr is used to compute curr_stats->cmps
and curr_stats->cpe_ratio (see dim_calc_stats()) which in
turn are consumed by the rdma_dim_*() API.  Therefore,
functionally, the net_dim*() API consumers are not affected.
Nevertheless, fix the computation of statistics based
on an uninitialized variable, even if the mentioned statistics
are not used at the moment.

Fixes: ae0e6a5d1627 ("enetc: Add adaptive interrupt coalescing")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 6877f8e2047b..15aa3b3c0089 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -299,7 +299,7 @@ static void enetc_rx_dim_work(struct work_struct *w)
 
 static void enetc_rx_net_dim(struct enetc_int_vector *v)
 {
-	struct dim_sample dim_sample;
+	struct dim_sample dim_sample = {};
 
 	v->comp_cnt++;
 
-- 
2.33.0



