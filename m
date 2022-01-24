Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AF649A4C4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369613AbiAYACP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581148AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666E4C0A552A;
        Mon, 24 Jan 2022 13:32:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05BCE61028;
        Mon, 24 Jan 2022 21:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECF1C340E4;
        Mon, 24 Jan 2022 21:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059974;
        bh=JiOVbM2qS81Tf9TfdFeLSOmQd6su6h5Fdx5wlgaihSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+vByxuXPcDK4VHOid5r7IroSYktw8nN0VYIiWYtHf7nDO2b+SbmB5u3F03rETE9A
         kFDed1dQpHlby+gd6PmPZeqYORijPPKwTZdFN2szIggrAc/l/28o/7+26ZyjVh7V5V
         uP30WOUhnQow97k6cAhKFJa+076NjrwlG2MwRmjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Ye Guojin <ye.guojin@zte.com.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0764/1039] MIPS: OCTEON: add put_device() after of_find_device_by_node()
Date:   Mon, 24 Jan 2022 19:42:33 +0100
Message-Id: <20220124184150.994855214@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6e4d3619137af..4df919d26b082 100644
--- a/arch/mips/cavium-octeon/octeon-usb.c
+++ b/arch/mips/cavium-octeon/octeon-usb.c
@@ -537,6 +537,7 @@ static int __init dwc3_octeon_device_init(void)
 			devm_iounmap(&pdev->dev, base);
 			devm_release_mem_region(&pdev->dev, res->start,
 						resource_size(res));
+			put_device(&pdev->dev);
 		}
 	} while (node != NULL);
 
-- 
2.34.1



