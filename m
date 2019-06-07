Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6175E38F53
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfFGPkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730062AbfFGPkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:40:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C84C20840;
        Fri,  7 Jun 2019 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922031;
        bh=yJPBos43c0Oc6npwygAeQLjhZMjaKkYfT8ljzRntpYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KygqNpgORUzOgBoDXRAEUpeYEyu1wnquQizalhvsyu2NXS8R9WCDPB2PZ/vAr6vW9
         5R5MA4eKrIeVxDWiIXkdRmPlEDErRH0fOD8mQoRivQgsbbXYR1T8wd6FpMxYXcPM7Q
         5m/wKIGPsvd5ID6SOlzLBN6VnUPY2NhcGmKAc/xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 04/69] net: fec: fix the clk mismatch in failed_reset path
Date:   Fri,  7 Jun 2019 17:38:45 +0200
Message-Id: <20190607153848.793186001@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>

[ Upstream commit ce8d24f9a5965a58c588f9342689702a1024433c ]

Fix the clk mismatch in the error path "failed_reset" because
below error path will disable clk_ahb and clk_ipg directly, it
should use pm_runtime_put_noidle() instead of pm_runtime_put()
to avoid to call runtime resume callback.

Reported-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Tested-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3539,7 +3539,7 @@ failed_init:
 	if (fep->reg_phy)
 		regulator_disable(fep->reg_phy);
 failed_reset:
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 failed_regulator:
 	clk_disable_unprepare(fep->clk_ahb);


