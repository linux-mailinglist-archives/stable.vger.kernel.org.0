Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C7B33B711
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhCON73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229746AbhCON5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A5F364F01;
        Mon, 15 Mar 2021 13:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816667;
        bh=LueKkyeFRpowgjXMPWsJwNWmy+b2MfC9rEuDgZn/XFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnvtjAphcVVWaHr2qmw+o+3FdL6TMzHc3+p2e4Tdg7EeAx6vs3r3/TKCnLchBIrQG
         teN3eWGAFPqIgRn6wwwrEhIvLwsZGm4rFrRazOi7tNMatm5KRyRRpGj3LWBztPyMrJ
         1Kbf+2BNnwA+9wQFUXChwnw0poWtHunejM5l9nVI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 035/168] net: davicom: Fix regulator not turned off on failed probe
Date:   Mon, 15 Mar 2021 14:54:27 +0100
Message-Id: <20210315135551.496322796@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Paul Cercueil <paul@crapouillou.net>

commit ac88c531a5b38877eba2365a3f28f0c8b513dc33 upstream.

When the probe fails or requests to be defered, we must disable the
regulator that was previously enabled.

Fixes: 7994fe55a4a2 ("dm9000: Add regulator and reset support to dm9000")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/davicom/dm9000.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1454,7 +1454,7 @@ dm9000_probe(struct platform_device *pde
 		if (ret) {
 			dev_err(dev, "failed to request reset gpio %d: %d\n",
 				reset_gpios, ret);
-			return -ENODEV;
+			goto out_regulator_disable;
 		}
 
 		/* According to manual PWRST# Low Period Min 1ms */
@@ -1466,8 +1466,10 @@ dm9000_probe(struct platform_device *pde
 
 	if (!pdata) {
 		pdata = dm9000_parse_dt(&pdev->dev);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
+		if (IS_ERR(pdata)) {
+			ret = PTR_ERR(pdata);
+			goto out_regulator_disable;
+		}
 	}
 
 	/* Init network device */
@@ -1708,6 +1710,10 @@ out:
 	dm9000_release_board(pdev, db);
 	free_netdev(ndev);
 
+out_regulator_disable:
+	if (!IS_ERR(power))
+		regulator_disable(power);
+
 	return ret;
 }
 


