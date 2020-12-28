Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D42E39B3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389556AbgL1N0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389552AbgL1N0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:26:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 573A820719;
        Mon, 28 Dec 2020 13:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161991;
        bh=lZofJ3VNRktxQHlzSTjJmfu73GV5N5UgrLRwgsGVNag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsAXne/SKjmcVDh8k24pX6Q4OSmEo1MxqUNyNhGRTRhsggj8T+t0TR3d8utf0Uxpr
         SYatohJIPHGwV3zF1vuduitKjZwW8KHCxEvnvrhR9a+BvRMVO0W5LzCtH/AmBwYHwO
         fR5ovrjwFDBcyxfoo8Xcc4H+0/HrdIFknlDuWfF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/346] usb/max3421: fix return error code in max3421_probe()
Date:   Mon, 28 Dec 2020 13:47:49 +0100
Message-Id: <20201228124927.036138519@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5a569343e8a618dc73edebe0957eb42f2ab476bd ]

retval may be reassigned to 0 after max3421_of_vbus_en_pin(),
if allocate memory failed after this, max3421_probe() cann't
return ENOMEM, fix this by moving assign retval afther max3421_probe().

Fixes: 721fdc83b31b ("usb: max3421: Add devicetree support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20201117061500.3454223-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/max3421-hcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index afa321ab55fcf..c9acc59f4addd 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1864,7 +1864,7 @@ max3421_probe(struct spi_device *spi)
 	struct max3421_hcd *max3421_hcd;
 	struct usb_hcd *hcd = NULL;
 	struct max3421_hcd_platform_data *pdata = NULL;
-	int retval = -ENOMEM;
+	int retval;
 
 	if (spi_setup(spi) < 0) {
 		dev_err(&spi->dev, "Unable to setup SPI bus");
@@ -1906,6 +1906,7 @@ max3421_probe(struct spi_device *spi)
 		goto error;
 	}
 
+	retval = -ENOMEM;
 	hcd = usb_create_hcd(&max3421_hcd_desc, &spi->dev,
 			     dev_name(&spi->dev));
 	if (!hcd) {
-- 
2.27.0



