Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A513CA739
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbhGOSwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235622AbhGOSwW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75712613CA;
        Thu, 15 Jul 2021 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374968;
        bh=5aZaqVlJN1tEwONIPTLplF4PD+U6nHazFadxaYPimhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVLMaKQFepwsdgL3Z9wJ69X/IQAz3vWmrfs+o3PbKvkdys10IMo1M9kBnJ13RGhQ9
         a09iXbrC3a645lhchOoBVtippugBxV74q4FaZzP4/DBndrdi8b1TXCTfLRUZeALQ9S
         7B5uLMHRRTbR6EK9O3RfIQpm5STSaMrFmtqiIacM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/215] net: mvpp2: check return value after calling platform_get_resource()
Date:   Thu, 15 Jul 2021 20:37:13 +0200
Message-Id: <20210715182610.238247147@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0bb51a3a385790a4be20085494cf78f70dadf646 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a9f65d667761..ec9b6c564300 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6871,6 +6871,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 			return PTR_ERR(priv->lms_base);
 	} else {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!res) {
+			dev_err(&pdev->dev, "Invalid resource\n");
+			return -EINVAL;
+		}
 		if (has_acpi_companion(&pdev->dev)) {
 			/* In case the MDIO memory region is declared in
 			 * the ACPI, it can already appear as 'in-use'
-- 
2.30.2



