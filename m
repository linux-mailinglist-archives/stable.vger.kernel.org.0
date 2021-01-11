Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33622F1722
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbhAKNFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:05:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbhAKNFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:05:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADDB022AAD;
        Mon, 11 Jan 2021 13:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370293;
        bh=pMw7ZG+3QM75jB2cus0sUy0EotEx5E+UnmlRWtwyBdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SX9wM9OIdc8SrCdEfdwGT3LRqGkJFHmbDZE8soG9TWlhzZ9f6W6Oi2+fq1Y0AIsYd
         0rF5CxpGTi2c6/1tnTvNPjLA2BadOKLdVH+xNn6wy+WCsgxmK4xOQfMeJbEkUYIGRO
         e7TA8BItkSQfIebO8Ggy3nJD7jK9872PMWAFVLio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 16/57] net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered
Date:   Mon, 11 Jan 2021 14:01:35 +0100
Message-Id: <20210111130034.515781108@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
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
@@ -471,6 +471,7 @@ void cpts_unregister(struct cpts *cpts)
 
 	ptp_clock_unregister(cpts->clock);
 	cpts->clock = NULL;
+	cpts->phc_index = -1;
 
 	cpts_write32(cpts, 0, int_enable);
 	cpts_write32(cpts, 0, control);
@@ -572,6 +573,7 @@ struct cpts *cpts_create(struct device *
 	cpts->cc.read = cpts_systim_read;
 	cpts->cc.mask = CLOCKSOURCE_MASK(32);
 	cpts->info = cpts_info;
+	cpts->phc_index = -1;
 
 	cpts_calc_mult_shift(cpts);
 	/* save cc.mult original value as it can be modified


