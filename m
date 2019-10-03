Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD05CA937
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404813AbfJCQjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404041AbfJCQjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:39:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6040B2086A;
        Thu,  3 Oct 2019 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120750;
        bh=CULuGB7gsyM3Y59RrSUZU5hpkj8xaPh1ImJ1WEo61dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tt8uMcj6zdzpuPRvFeudFNOL42gl1am6h9FK2LYzUmnFIFwHKyDP3QrchpMbleI0o
         pqOcOXp8BV9dnxPMwah+SE5guGfa30OvHsCmynasr+tqybI867UIUxGzxU7i/JHGun
         iyOyB0F6r8uDeKYzOrU3UyYGo/yJ2d8+X6YheVh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hans Andersson <hans.andersson@cellavision.se>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 024/344] net: phy: micrel: add Asym Pause workaround for KSZ9021
Date:   Thu,  3 Oct 2019 17:49:49 +0200
Message-Id: <20191003154542.471018655@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Andersson <hans.andersson@cellavision.se>

[ Upstream commit 407d8098cb1ab338199f4753162799a488d87d23 ]

The Micrel KSZ9031 PHY may fail to establish a link when the Asymmetric
Pause capability is set. This issue is described in a Silicon Errata
(DS80000691D or DS80000692D), which advises to always disable the
capability.

Micrel KSZ9021 has no errata, but has the same issue with Asymmetric Pause.
This patch apply the same workaround as the one for KSZ9031.

Fixes: 3aed3e2a143c ("net: phy: micrel: add Asym Pause workaround")
Signed-off-by: Hans Andersson <hans.andersson@cellavision.se>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -763,6 +763,8 @@ static int ksz9031_get_features(struct p
 	 * Whenever the device's Asymmetric Pause capability is set to 1,
 	 * link-up may fail after a link-up to link-down transition.
 	 *
+	 * The Errata Sheet is for ksz9031, but ksz9021 has the same issue
+	 *
 	 * Workaround:
 	 * Do not enable the Asymmetric Pause capability bit.
 	 */
@@ -1076,6 +1078,7 @@ static struct phy_driver ksphy_driver[]
 	/* PHY_GBIT_FEATURES */
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
+	.get_features	= ksz9031_get_features,
 	.config_init	= ksz9021_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,


