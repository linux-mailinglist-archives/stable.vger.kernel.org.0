Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B7D2F1368
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbhAKNI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730717AbhAKNIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0674C2255F;
        Mon, 11 Jan 2021 13:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370446;
        bh=xZ1KM2mAM+I8lha5zVNC04268JKBR9S4Re8rH9GztMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vc7NQRdegENR2RkN28IGtHh2wZn9ExL1+9GzSI/BpvkiDNxrJLj2hrPKB3tjV77I7
         DAaEq5Sxynh/WdgLpZ45XeyDTCu7hQ8LfFT6xG6zt7JTfqrcBltIKGgHgxab0sqZ1/
         majwUCN5LG5BwMfoRuo2ENArsqDx4WfM2GWg5lM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 25/77] net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered
Date:   Mon, 11 Jan 2021 14:01:34 +0100
Message-Id: <20210111130037.616124873@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 4614792eebcbf81c60ad3604c1aeeb2b0899cea4 ]

The CPTS driver registers PTP PHC clock when first netif is going up and
unregister it when all netif are down. Now ethtool will show:
 - PTP PHC clock index 0 after boot until first netif is up;
 - the last assigned PTP PHC clock index even if PTP PHC clock is not
registered any more after all netifs are down.

This patch ensures that -1 is returned by ethtool when PTP PHC clock is not
registered any more.

Fixes: 8a2c9a5ab4b9 ("net: ethernet: ti: cpts: rework initialization/deinitialization")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20201224162405.28032-1-grygorii.strashko@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpts.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -476,6 +476,7 @@ void cpts_unregister(struct cpts *cpts)
 
 	ptp_clock_unregister(cpts->clock);
 	cpts->clock = NULL;
+	cpts->phc_index = -1;
 
 	cpts_write32(cpts, 0, int_enable);
 	cpts_write32(cpts, 0, control);
@@ -577,6 +578,7 @@ struct cpts *cpts_create(struct device *
 	cpts->cc.read = cpts_systim_read;
 	cpts->cc.mask = CLOCKSOURCE_MASK(32);
 	cpts->info = cpts_info;
+	cpts->phc_index = -1;
 
 	cpts_calc_mult_shift(cpts);
 	/* save cc.mult original value as it can be modified


