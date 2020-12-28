Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF7D2E3CCB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438295AbgL1OHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437815AbgL1OGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 254E722B45;
        Mon, 28 Dec 2020 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164355;
        bh=j46StAFyhEDQgEQK2MouMzDAFqYogRt0xNVqxWIRz/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1dPyqd3O2h/F47p7QOVhlZ7O//yLT/Zwmo0jgmOlzsVkuFEXSIhsa3fppcHzA6vdy
         K/lRIQB10/ZGJkG7/Wv3WVQMz2+bS3L+3cW89/V5d59DsdL/bk+LAFGjYId+HInJsK
         uP4e1NWuPmwocRZQCbjc44nmukv/KYW8ee3g/7aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/717] usb/max3421: fix return error code in max3421_probe()
Date:   Mon, 28 Dec 2020 13:42:30 +0100
Message-Id: <20201228125028.240770332@linuxfoundation.org>
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
index 0894f6caccb2c..ebb8180b52ab1 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1847,7 +1847,7 @@ max3421_probe(struct spi_device *spi)
 	struct max3421_hcd *max3421_hcd;
 	struct usb_hcd *hcd = NULL;
 	struct max3421_hcd_platform_data *pdata = NULL;
-	int retval = -ENOMEM;
+	int retval;
 
 	if (spi_setup(spi) < 0) {
 		dev_err(&spi->dev, "Unable to setup SPI bus");
@@ -1889,6 +1889,7 @@ max3421_probe(struct spi_device *spi)
 		goto error;
 	}
 
+	retval = -ENOMEM;
 	hcd = usb_create_hcd(&max3421_hcd_desc, &spi->dev,
 			     dev_name(&spi->dev));
 	if (!hcd) {
-- 
2.27.0



