Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A421C2C0A1D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388819AbgKWNQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731944AbgKWMnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A35CF2173E;
        Mon, 23 Nov 2020 12:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135383;
        bh=Be6u3ygjTcFq9YECDesDrKaqj6cTxBX0ovbFj+Idg7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGXpGANYqRDfeZQQYTDYkBEUJ9cagvD2O8aygr9RAp4sihcH2KQHkjMTZurPoPvCn
         PBQLzXfV/zDQzuUNEvOBUB9qF7qtDMs/KECl9SNoGJih7s4dWw0raP/Ecd7BlSSzO5
         8BikwqzpCtCz90aPbMtfXZhKaLo9lC6QWTEoUvag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Qing <wangqing@vivo.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 018/252] net: ethernet: ti: am65-cpts: update ret when ptp_clock is ERROR
Date:   Mon, 23 Nov 2020 13:19:28 +0100
Message-Id: <20201123121836.473572157@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit 81e329e93b860b31c216b40eb5e1373db0ffe0ba ]

We always have to update the value of ret, otherwise the
 error value may be the previous one.

Fixes: f6bd59526ca5 ("net: ethernet: ti: introduce am654 common platform time sync driver")
Signed-off-by: Wang Qing <wangqing@vivo.com>
[grygorii.strashko@ti.com: fix build warn, subj add fixes tag]
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20201112164541.3223-1-grygorii.strashko@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/am65-cpts.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -1016,8 +1016,7 @@ struct am65_cpts *am65_cpts_create(struc
 	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
 		dev_err(dev, "Failed to register ptp clk %ld\n",
 			PTR_ERR(cpts->ptp_clock));
-		if (!cpts->ptp_clock)
-			ret = -ENODEV;
+		ret = cpts->ptp_clock ? PTR_ERR(cpts->ptp_clock) : -ENODEV;
 		goto refclk_disable;
 	}
 	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);


