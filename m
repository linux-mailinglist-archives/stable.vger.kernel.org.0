Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2777233B907
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhCOOFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhCOOBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E51BD64EFD;
        Mon, 15 Mar 2021 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816835;
        bh=c83b0+G92OB4ZbeFEUPVFsbv/0Da022iGYLka0DJuDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI5mLwQ0xUipQNSRoROYuna+4W2i1LnawUMBKhdGOzQ+0zCBys9mLqvKnwuWWWV9z
         L9WFWIgq4BOrB1jp1VFREz9UIHWYWwsXQL8bfdH9b6aFh4ubs7ZaBrsh0mwJL+5Rv1
         AAZ/IDVnP2Y7DRosh1LMTsAnQhZH0uM1Wqxz7qko=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 4.14 92/95] iio: imu: adis16400: release allocated memory on failure
Date:   Mon, 15 Mar 2021 14:58:02 +0100
Message-Id: <20210315135743.308885315@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit ab612b1daf415b62c58e130cb3d0f30b255a14d0 upstream.

In adis_update_scan_mode, if allocation for adis->buffer fails,
previously allocated adis->xfer needs to be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis_buffer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/adis_buffer.c
+++ b/drivers/iio/imu/adis_buffer.c
@@ -39,8 +39,11 @@ int adis_update_scan_mode(struct iio_dev
 		return -ENOMEM;
 
 	adis->buffer = kzalloc(indio_dev->scan_bytes * 2, GFP_KERNEL);
-	if (!adis->buffer)
+	if (!adis->buffer) {
+		kfree(adis->xfer);
+		adis->xfer = NULL;
 		return -ENOMEM;
+	}
 
 	rx = adis->buffer;
 	tx = rx + scan_count;


