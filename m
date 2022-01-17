Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F750490E77
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242639AbiAQRJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:09:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57252 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241885AbiAQRHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:07:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7855C6120D;
        Mon, 17 Jan 2022 17:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11724C36AE7;
        Mon, 17 Jan 2022 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642439227;
        bh=BhvH5FYxPJNi12cUpjUBB71t6MBUCKzlBxAp22IT8s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVkX8eDZabaxSJ22w/nKPazfCCYj8NCdBfSf0+l05zH7DySkDAqo+R1jNJGz0kWQV
         VOsNVKvjIZzqUcCWO0Uhyp3ZqYJKaku7+z/iiHrshlew7wOFCDnTTLfbc0h3/+Capo
         vpU0zy5xJfe2CXWaSweYx9G/vluvjmk59vsyHCe25PPTqEtxNTnKu0cQGmibXoUmXQ
         qmwqLmCKOmfdg30eMa4J1ny36ROKPrMx+Vw5yLhBGWnp/9l2Nj267ysd8IIxzQ2sEF
         UxlJ/1P7ribVkeC6S/0DcZcXc+v6mrSLfcyvPXjeZv+nB4Fb4vO6zoOpBpoa+J9VhS
         iJ9pruM6VFeFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Guojin <ye.guojin@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, yangyingliang@huawei.com,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/16] MIPS: OCTEON: add put_device() after of_find_device_by_node()
Date:   Mon, 17 Jan 2022 12:06:34 -0500
Message-Id: <20220117170638.1472900-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170638.1472900-1-sashal@kernel.org>
References: <20220117170638.1472900-1-sashal@kernel.org>
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
index e1e24118c169e..ed42fc27033c4 100644
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
index 75189ff2f3c78..3465452e28195 100644
--- a/arch/mips/cavium-octeon/octeon-usb.c
+++ b/arch/mips/cavium-octeon/octeon-usb.c
@@ -543,6 +543,7 @@ static int __init dwc3_octeon_device_init(void)
 			devm_iounmap(&pdev->dev, base);
 			devm_release_mem_region(&pdev->dev, res->start,
 						resource_size(res));
+			put_device(&pdev->dev);
 		}
 	} while (node != NULL);
 
-- 
2.34.1

