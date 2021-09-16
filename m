Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB1840E74D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbhIPRbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352806AbhIPR2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0B0161C57;
        Thu, 16 Sep 2021 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810752;
        bh=HJfAW2t0hTonjZ5FlDW4q1tk06LyhkwoiHH4zkem0bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mb5PXnovNRMzjD/+Eyc1CpWn8NDJjuSY86XdOrY7gtD/O4cYZNJ2ZCFlND3V8Gh5K
         jRO7EYAU3D9a+JjgxmkrcipKU3gKNZ0uP+Z/TNkkUK9MxUGYSyAyfgnvH/yeEo8d4n
         PJ381i1338qlvfWN2bpPhccqj83ncXS8ao9ib5EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 254/432] dpaa2-switch: do not enable the DPSW at probe time
Date:   Thu, 16 Sep 2021 18:00:03 +0200
Message-Id: <20210916155819.435159181@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 042ad90ca7ce70f35dc5efd5b2043d2f8aceb12a ]

We should not enable the switch interfaces at probe time since this is
trigged by the open callback. Remove the call dpsw_enable() which does
exactly this.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 98cc0133c343..5ad5419e8be3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3231,12 +3231,6 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			       &ethsw->fq[i].napi, dpaa2_switch_poll,
 			       NAPI_POLL_WEIGHT);
 
-	err = dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
-	if (err) {
-		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);
-		goto err_free_netdev;
-	}
-
 	/* Setup IRQs */
 	err = dpaa2_switch_setup_irqs(sw_dev);
 	if (err)
-- 
2.30.2



