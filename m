Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CD024B4BF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbgHTKLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgHTKLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:11:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44A05206DA;
        Thu, 20 Aug 2020 10:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918276;
        bh=xjcrObf4mN7gNPTFMw+wXKdHvmzDyVR5jK6iKPHu5FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cebYvtTzFOOcdOjZ2VcC4Ahkz3xBYTc+hM3nsYXcIY85xa2lt2sQ0V9Q1/blhxVuN
         jP22TrFXWyQP9w0cExVM7zxE69ASEkaZ92LLTkJwXxlf7G0RZ1lnnqpStdWlWGxqt/
         r5wYXYiu90KbfDJh3XFxDzRMadcnnDLdN1MQSfuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 113/228] MIPS: OCTEON: add missing put_device() call in dwc3_octeon_device_init()
Date:   Thu, 20 Aug 2020 11:21:28 +0200
Message-Id: <20200820091613.242981944@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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
index bfdfaf32d2c49..75189ff2f3c78 100644
--- a/arch/mips/cavium-octeon/octeon-usb.c
+++ b/arch/mips/cavium-octeon/octeon-usb.c
@@ -517,6 +517,7 @@ static int __init dwc3_octeon_device_init(void)
 
 			res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 			if (res == NULL) {
+				put_device(&pdev->dev);
 				dev_err(&pdev->dev, "No memory resources\n");
 				return -ENXIO;
 			}
@@ -528,8 +529,10 @@ static int __init dwc3_octeon_device_init(void)
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



