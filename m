Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137432F1596
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbhAKNmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbhAKNMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:12:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684372253A;
        Mon, 11 Jan 2021 13:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370701;
        bh=ELab6JmI6Vjau1uX1EZ9XSVTKXfryRr71i/2nF9x+Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pchh0mRpv6Dg1YHD13O0StNiLTErQAeSuUCuOaH65DrWH5txaJjl46tBKePjR3vLH
         zqaqvGz/E9CnZN5v29UymuXEb5q5ysyzAgRCWIEpmDuh3fAaBksZ+7wAcVUx1O482i
         deBxRC3apjCEBw5BUYJWenximcbv+BjcV0IsNmpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 30/92] net: ethernet: ti: cpts: fix ethtool output when no ptp_clock registered
Date:   Mon, 11 Jan 2021 14:01:34 +0100
Message-Id: <20210111130040.600057780@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
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
@@ -485,6 +485,7 @@ void cpts_unregister(struct cpts *cpts)
 
 	ptp_clock_unregister(cpts->clock);
 	cpts->clock = NULL;
+	cpts->phc_index = -1;
 
 	cpts_write32(cpts, 0, int_enable);
 	cpts_write32(cpts, 0, control);
@@ -667,6 +668,7 @@ struct cpts *cpts_create(struct device *
 	cpts->cc.read = cpts_systim_read;
 	cpts->cc.mask = CLOCKSOURCE_MASK(32);
 	cpts->info = cpts_info;
+	cpts->phc_index = -1;
 
 	cpts_calc_mult_shift(cpts);
 	/* save cc.mult original value as it can be modified


