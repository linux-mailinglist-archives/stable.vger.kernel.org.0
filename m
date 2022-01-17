Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149B8490DEA
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242454AbiAQRG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:06:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52196 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242455AbiAQREb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:04:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA73CB81142;
        Mon, 17 Jan 2022 17:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10EDC36AE7;
        Mon, 17 Jan 2022 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439068;
        bh=1W7QnzWemca3+VHrxEBDJsad3MM3/pf0E4IB4zUs6LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYeVB/v4S56Iisdaed/TUkuX/vcFK6x+C8i5953wjCZbK2rQrtDp1qBsGFWv1mH+n
         UqoI+NP4cccLOXzOyNAA6c1ilrH3ibmB7MuJ4iItb5/zMLvmUB1AXybyAmWieE5SW7
         E7/uXW1Wp3uCmltx8rueKsrtLFmpkya/bwWJ47pE+Okd1ZQQ64ILOQcKWy6/vT7tFC
         jbyQPD+PuqtYrItoW4SMeppbFwkHiDsp2POW7tpVVd7++qoOQqQ9pcRcVvT62w77Zg
         /Lf/wa2N/6r3JCsDyUe6cPfX/rUdpSOMEP8QctHbd481ncFiLShBjzdukGuRms+q/a
         NoMtbT6keGpFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Guojin <ye.guojin@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, yangyingliang@huawei.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/34] MIPS: OCTEON: add put_device() after of_find_device_by_node()
Date:   Mon, 17 Jan 2022 12:03:16 -0500
Message-Id: <20220117170326.1471712-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170326.1471712-1-sashal@kernel.org>
References: <20220117170326.1471712-1-sashal@kernel.org>
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
index d56e9b9d2e434..a994022e32c9f 100644
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
index 950e6c6e86297..fa87e5aa1811d 100644
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

