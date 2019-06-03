Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4587432C6C
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfFCJLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728336AbfFCJLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:11:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B26427E36;
        Mon,  3 Jun 2019 09:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553075;
        bh=VG3xzaa3A1jhxtOHs99V4fP62LFPsrwnGOwBUKvbhmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rI0vSAvkxN22RHVXr33QB0C5PGCQkmXn7yin680zc5UaKB0qiPIq4mnE3qEKdT3sx
         CoP0y1wMnC3TIGJT0yW6+vh3PLrMZkVq1/K1FNV1GU7yjoENffZv7WfQW/6xjYZjHL
         aW/FMm9Zn6+cy755XJSWTdTVwtS0JlUfrZlu9FRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 11/36] net: fec: fix the clk mismatch in failed_reset path
Date:   Mon,  3 Jun 2019 11:08:59 +0200
Message-Id: <20190603090521.704425967@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
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
@@ -3556,7 +3556,7 @@ failed_init:
 	if (fep->reg_phy)
 		regulator_disable(fep->reg_phy);
 failed_reset:
-	pm_runtime_put(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 failed_regulator:
 	clk_disable_unprepare(fep->clk_ahb);


