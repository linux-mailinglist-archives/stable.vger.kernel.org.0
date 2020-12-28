Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB402E63FB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391984AbgL1Nob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391981AbgL1Noa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECA582063A;
        Mon, 28 Dec 2020 13:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163029;
        bh=Dru+aFMcStWGHw7wqFnjO8DnU3qHmsoy4iq6boOYGYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+Y1p9ZEiHgqUyH9sr9imExkP9pZVUzwEoYETyS10EFdpEVBu789bT/KYPue1zTzg
         i6os576Gh5s6u2B5/H1r8KHJUBBQRoMENU7s1RSQXE8P23Pw5dc16g6aKV7Eebd3m0
         vgwiPqM8RQvNej6Ta61ZZqbsdgC/29en3L49RZF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/453] usb/max3421: fix return error code in max3421_probe()
Date:   Mon, 28 Dec 2020 13:46:21 +0100
Message-Id: <20201228124944.179352542@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 8819f502b6a68..903abdf30b5a0 100644
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



