Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AFD3CDE3A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345298AbhGSPCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344006AbhGSO71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02F3A6135D;
        Mon, 19 Jul 2021 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709097;
        bh=ou5BlBKgsSyBQbDyhJTEU4sn/fWCLFCHkXKi8FaOd4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEK5FUVHjOQlJ3UWHOc69NK5tBaXWSopnbof+KT75p6552pniaGpF86nhHhiHuZYQ
         kunztzBhl7BYfVCQr8/OeD71thnr4rFWJAbNkNeTJsmjjtVV+Kbajzl3TX3dKAn0u0
         PjN92YQ/W8qUm7qLgDkZdYvFlwCRBXWl5wWgk93Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 250/421] net: mvpp2: check return value after calling platform_get_resource()
Date:   Mon, 19 Jul 2021 16:51:01 +0200
Message-Id: <20210719144955.065864895@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index e65750b3c44f..52fdb200a0c7 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5157,6 +5157,10 @@ static int mvpp2_probe(struct platform_device *pdev)
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



