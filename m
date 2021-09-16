Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74B240E3B9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhIPQvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245068AbhIPQsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:48:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ECCC60FA0;
        Thu, 16 Sep 2021 16:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809627;
        bh=3O0lqPPUH/2D2pVU3SgtAvx6ACObZxJzsIqXDUgcDLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzQeWQGwFjEPA7qOhDSLA51MyXHqEHWlUpk1oTWVyocV/8MzXhidFh2wPcC0l82tF
         gYCjQQ1ZxUkSFc58OtB108KxaXbaKmvk5MsCm9H0UOYprgTvjBUQrYsnzumrs0kbHC
         a9xGQgACnibZUkr0KNOFCeV22SjXMszvUqJZIZmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 224/380] dpaa2-switch: do not enable the DPSW at probe time
Date:   Thu, 16 Sep 2021 17:59:41 +0200
Message-Id: <20210916155811.710697285@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
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
index 58964d22cb17..e3a3499ba7a2 100644
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



