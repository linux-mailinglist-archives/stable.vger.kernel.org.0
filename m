Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0154490EBC
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242085AbiAQRLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243400AbiAQRJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:09:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4031EC061A75;
        Mon, 17 Jan 2022 09:05:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 062C2B8115C;
        Mon, 17 Jan 2022 17:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EFFC36AE7;
        Mon, 17 Jan 2022 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439137;
        bh=DgL0M9pJ+5hLvwUAh76NXDtoQtsqUyxfMwlZsYc7D1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHzxSgfo/PA/9qYP706HF9exgh2MqGsbZY6NdaVUuFuWLVO1DKjAszufXMlu9wpVT
         JT9vKo/4iFstjvaXpbh46OiTqG8m4MKeGJVDQYqonLJ+Th5Yd0Tbm4ZEXSbd5neHJC
         Jx2/vDK4D8lNDY76U5eCzgDkGG918lnXW0NhbhPRp9VDLbfg6OvcqXODUMIpvpv9Vf
         D3qI9G2486XfEvhQ9TZlXidD+9Pq5HtNFUhRss9tSHnRxsvdoaH6GmabOscHqImlGJ
         3de4XnNVGK4bQ6zvTMUfAtaJ73k34+sQO22JMmuLvk6fDBpLyCYlhp2ZbnOwNA9/sr
         afi9o31fPFBwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Guojin <ye.guojin@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, yangyingliang@huawei.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/21] MIPS: OCTEON: add put_device() after of_find_device_by_node()
Date:   Mon, 17 Jan 2022 12:04:49 -0500
Message-Id: <20220117170454.1472347-17-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170454.1472347-1-sashal@kernel.org>
References: <20220117170454.1472347-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

[ Upstream commit 858779df1c0787d3fec827fb705708df9ebdb15b ]

This was found by coccicheck:
./arch/mips/cavium-octeon/octeon-platform.c, 332, 1-7, ERROR missing
put_device; call of_find_device_by_node on line 324, but without a
corresponding object release within this function.
./arch/mips/cavium-octeon/octeon-platform.c, 395, 1-7, ERROR missing
put_device; call of_find_device_by_node on line 387, but without a
corresponding object release within this function.
./arch/mips/cavium-octeon/octeon-usb.c, 512, 3-9, ERROR missing
put_device; call of_find_device_by_node on line 515, but without a
corresponding object release within this function.
./arch/mips/cavium-octeon/octeon-usb.c, 543, 1-7, ERROR missing
put_device; call of_find_device_by_node on line 515, but without a
corresponding object release within this function.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/octeon-platform.c | 2 ++
 arch/mips/cavium-octeon/octeon-usb.c      | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 51685f893eab0..c214fe4e678bb 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -328,6 +328,7 @@ static int __init octeon_ehci_device_init(void)
 
 	pd->dev.platform_data = &octeon_ehci_pdata;
 	octeon_ehci_hw_start(&pd->dev);
+	put_device(&pd->dev);
 
 	return ret;
 }
@@ -391,6 +392,7 @@ static int __init octeon_ohci_device_init(void)
 
 	pd->dev.platform_data = &octeon_ohci_pdata;
 	octeon_ohci_hw_start(&pd->dev);
+	put_device(&pd->dev);
 
 	return ret;
 }
diff --git a/arch/mips/cavium-octeon/octeon-usb.c b/arch/mips/cavium-octeon/octeon-usb.c
index 4017398519cf9..e092d86e63581 100644
--- a/arch/mips/cavium-octeon/octeon-usb.c
+++ b/arch/mips/cavium-octeon/octeon-usb.c
@@ -544,6 +544,7 @@ static int __init dwc3_octeon_device_init(void)
 			devm_iounmap(&pdev->dev, base);
 			devm_release_mem_region(&pdev->dev, res->start,
 						resource_size(res));
+			put_device(&pdev->dev);
 		}
 	} while (node != NULL);
 
-- 
2.34.1

