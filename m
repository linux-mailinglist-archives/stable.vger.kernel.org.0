Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37339126D44
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLSSkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:40:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfLSSkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:40:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2FD2222C2;
        Thu, 19 Dec 2019 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780809;
        bh=ATnj3BQ3YFkCqTJr6jnXGnZ4VPwhhvyADN1J6/i+yg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8KIiISR6h6P7DLA7fI4FPoVMKiAEznpfQ+7bfqhoUxtutzgTE9Rz/ZaJQpxaVNIn
         qqnzTPk/lNvFLtBzNlgF5CgV9cv/n6AYhJ4Ulj7E3Xzu3pejsOMEV6CE3tH2Fvq3gf
         UqbZQEi2Aq0c36J5OeQGlk20dMA0lHLc5dSw4Tqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 127/162] iio: adis16480: Add debugfs_reg_access entry
Date:   Thu, 19 Dec 2019 19:33:55 +0100
Message-Id: <20191219183215.505528223@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 4c35b7a51e2f291471f7221d112c6a45c63e83bc ]

The driver is defining debugfs entries by calling
`adis16480_debugfs_init()`. However, those entries are attached to the
iio_dev debugfs entry which won't exist if no debugfs_reg_access
callback is provided.

Fixes: 2f3abe6cbb6c ("iio:imu: Add support for the ADIS16480 and similar IMUs")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16480.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index 778a46247f8de..eeed374ebc6c5 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -724,6 +724,7 @@ static const struct iio_info adis16480_info = {
 	.write_raw = &adis16480_write_raw,
 	.update_scan_mode = adis_update_scan_mode,
 	.driver_module = THIS_MODULE,
+	.debugfs_reg_access = adis_debugfs_reg_access,
 };
 
 static int adis16480_stop_device(struct iio_dev *indio_dev)
-- 
2.20.1



