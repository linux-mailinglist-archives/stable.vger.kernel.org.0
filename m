Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C072E417E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438798AbgL1PHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:07:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391725AbgL1OId (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C550220715;
        Mon, 28 Dec 2020 14:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164498;
        bh=LciEQlA0Wt/TM7z3ud8WIqK17lvwTRyS+orTdOpSgKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orEu+3Knp80P5a74FpIcgzopDfaFdxAz8K7r7MOXdZ/XRBAnUBY4JfMHk49IFnRwn
         XkvddKS8GiRzvAmEQc30iCSFeMRjK15jdI+LdKc3OiVr3GzolBDBuYhPZJoWqtU4QY
         TOxB7BaIfglE9NLsVQHtECw3a3eHq53QB9X4bH5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/717] dmaengine: mv_xor_v2: Fix error return code in mv_xor_v2_probe()
Date:   Mon, 28 Dec 2020 13:43:19 +0100
Message-Id: <20201228125030.607471591@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit c95e6515a8c065862361f7e0e452978ade7f94ec ]

Return the corresponding error code when first_msi_entry() returns
NULL in mv_xor_v2_probe().

Fixes: 19a340b1a820430 ("dmaengine: mv_xor_v2: new driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20201124010813.1939095-1-chengzhihao1@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/mv_xor_v2.c b/drivers/dma/mv_xor_v2.c
index 2753a6b916f60..9b0d463f89bbd 100644
--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -771,8 +771,10 @@ static int mv_xor_v2_probe(struct platform_device *pdev)
 		goto disable_clk;
 
 	msi_desc = first_msi_entry(&pdev->dev);
-	if (!msi_desc)
+	if (!msi_desc) {
+		ret = -ENODEV;
 		goto free_msi_irqs;
+	}
 	xor_dev->msi_desc = msi_desc;
 
 	ret = devm_request_irq(&pdev->dev, msi_desc->irq,
-- 
2.27.0



