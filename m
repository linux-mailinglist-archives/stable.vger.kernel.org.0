Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81A3419C1A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhI0RZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237366AbhI0RXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:23:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8009613A6;
        Mon, 27 Sep 2021 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762876;
        bh=75ArG7m6E2Rh9NiQgdj3xRp3nhgs2JPiKzG8onYYs+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnV4rh/9sz/x5eXq1+ccdCC6m/rW2ebzQ0up1TupqMYFr1v0N18upSSo80XQie1UF
         0OWB19/VBz1RZhNuQVxZDNw2jTQ6IhARpxwbr5IiNn7jVpRN3wka6TJsNJRBBcKCjF
         H4QSypHujrDmPDWY8kzElbvnGXvgzwBwYtJwBEO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 057/162] enetc: Fix uninitialized struct dim_sample field usage
Date:   Mon, 27 Sep 2021 19:01:43 +0200
Message-Id: <20210927170235.460660782@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
index 7f90c27c0e79..042327b9981f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -419,7 +419,7 @@ static void enetc_rx_dim_work(struct work_struct *w)
 
 static void enetc_rx_net_dim(struct enetc_int_vector *v)
 {
-	struct dim_sample dim_sample;
+	struct dim_sample dim_sample = {};
 
 	v->comp_cnt++;
 
-- 
2.33.0



