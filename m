Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E16C33B5D0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhCONz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhCONzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:55:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4029F64F01;
        Mon, 15 Mar 2021 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816501;
        bh=z90pGu7p3BOrQPmS8E6uLrmVTmfzYnYHQMcVmptljWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs7gjBwMFuCOTn3sU6wExWD45OlzrFN4ij/CLiPUyFzv5eJRKuIaeadQpCgULJmO1
         ZDxzaNP7Z+ww6myFS+lZqTuZ/HPROEQsDM0JrfOaYin9qn2Rniz5+U+meDFxOgVKNc
         9OHbNdBZuJnEku85FJVq1RMKvjqSMW93oxrC3j/A=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 4.9 74/78] iio: imu: adis16400: release allocated memory on failure
Date:   Mon, 15 Mar 2021 14:52:37 +0100
Message-Id: <20210315135214.486187760@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

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


