Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680451576B6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgBJMyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730104AbgBJMl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:56 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE96C2085B;
        Mon, 10 Feb 2020 12:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338516;
        bh=f5yk36EK64CQTFfSzSoUwsCNOY4a2Hv8MBIcE2VV3Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwjSKjju1PINFH9duzhsHc7CPX5VD5fCYIvejKOeAwmubJgZ1Ixtz5xtjZtVAACET
         Wa2rKiKwuMeDQHjOjjjbzYUiHdHefhggy6ma0o0EiffBYeKzLeWCc5aZgVmTHOJNYy
         FAa874ab7r5eKw9jpPDCfliR1ShuaogSgsRZQCvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 324/367] net: stmmac: fix a possible endless loop
Date:   Mon, 10 Feb 2020 04:33:57 -0800
Message-Id: <20200210122452.888800113@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit 7d10f0774f9e32aa2f2e012f7fcb312a2ce422b9 ]

It forgot to reduce the value of the variable retry in a while loop
in the ethqos_configure() function. It may cause an endless loop and
without timeout.

Fixes: a7c30e62d4b8 ("net: stmmac: Add driver for Qualcomm ethqos")
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -413,6 +413,7 @@ static int ethqos_configure(struct qcom_
 			dll_lock = rgmii_readl(ethqos, SDC4_STATUS);
 			if (dll_lock & SDC4_STATUS_DLL_LOCK)
 				break;
+			retry--;
 		} while (retry > 0);
 		if (!retry)
 			dev_err(&ethqos->pdev->dev,


