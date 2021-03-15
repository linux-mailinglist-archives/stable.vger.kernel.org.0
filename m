Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC88233B5D1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhCONz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhCONzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:55:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A15D064EB6;
        Mon, 15 Mar 2021 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816503;
        bh=l69FUftW8NIve7NEWCJlehUULKtIpdKpxh9a8jGzzag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ft/kQvJwp3IiuyU3wviaGcfKwf0v77Ieb3uYH+Jjxp/epLz0zF1jxeWNevUDQv54T
         +bNzxRst1J2NllkUEc6qC1STaK1JINtRoDy2Kph6uD3nwisA0JC40LeUX/2CqxRUJ9
         pTSuVmrvy6651HoDMa185W7HXFT2BCm3p51PIhAE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 4.9 75/78] iio: imu: adis16400: fix memory leak
Date:   Mon, 15 Mar 2021 14:52:38 +0100
Message-Id: <20210315135214.517438267@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit 9c0530e898f384c5d279bfcebd8bb17af1105873 upstream.

In adis_update_scan_mode_burst, if adis->buffer allocation fails release
the adis->xfer.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[krzk: backport applied to adis16400_buffer.c instead of adis_buffer.c]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16400_buffer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16400_buffer.c
+++ b/drivers/iio/imu/adis16400_buffer.c
@@ -37,8 +37,11 @@ int adis16400_update_scan_mode(struct ii
 		return -ENOMEM;
 
 	adis->buffer = kzalloc(burst_length + sizeof(u16), GFP_KERNEL);
-	if (!adis->buffer)
+	if (!adis->buffer) {
+		kfree(adis->xfer);
+		adis->xfer = NULL;
 		return -ENOMEM;
+	}
 
 	tx = adis->buffer + burst_length;
 	tx[0] = ADIS_READ_REG(ADIS16400_GLOB_CMD);


