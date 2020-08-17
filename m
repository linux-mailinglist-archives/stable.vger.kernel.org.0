Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F52246B49
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387838AbgHQPwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387832AbgHQPwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:52:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E56AB20657;
        Mon, 17 Aug 2020 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679525;
        bh=zfTbdVOfDIBpKELnc64oGWyDb5AwND2CYHOdFudtnok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNOp62eH+ZKahuGtVTZh3qhF6qNCspYXHGsrnZr6T15cRIU87+HK4jC0YRkAm5uYj
         KZ8wrUttp4c9YAc0IeZh9IFWWaWgqxw4nCH37QRYsE6gC3hZN/tUcyQdOthoQNW6mD
         3ShF4L+riQqeLH4alnUZUqLB977tqmBixOktibBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 242/393] MIPS: OCTEON: add missing put_device() call in dwc3_octeon_device_init()
Date:   Mon, 17 Aug 2020 17:14:52 +0200
Message-Id: <20200817143831.358053883@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e8b9fc10f2615b9a525fce56981e40b489528355 ]

if of_find_device_by_node() succeed, dwc3_octeon_device_init() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: 93e502b3c2d4 ("MIPS: OCTEON: Platform support for OCTEON III USB controller")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cavium-octeon/octeon-usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/mips/cavium-octeon/octeon-usb.c b/arch/mips/cavium-octeon/octeon-usb.c
index cc88a08bc1f73..4017398519cf9 100644
--- a/arch/mips/cavium-octeon/octeon-usb.c
+++ b/arch/mips/cavium-octeon/octeon-usb.c
@@ -518,6 +518,7 @@ static int __init dwc3_octeon_device_init(void)
 
 			res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 			if (res == NULL) {
+				put_device(&pdev->dev);
 				dev_err(&pdev->dev, "No memory resources\n");
 				return -ENXIO;
 			}
@@ -529,8 +530,10 @@ static int __init dwc3_octeon_device_init(void)
 			 * know the difference.
 			 */
 			base = devm_ioremap_resource(&pdev->dev, res);
-			if (IS_ERR(base))
+			if (IS_ERR(base)) {
+				put_device(&pdev->dev);
 				return PTR_ERR(base);
+			}
 
 			mutex_lock(&dwc3_octeon_clocks_mutex);
 			dwc3_octeon_clocks_start(&pdev->dev, (u64)base);
-- 
2.25.1



