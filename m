Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D417423A52C
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgHCMeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728227AbgHCMd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:33:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B76262054F;
        Mon,  3 Aug 2020 12:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596458038;
        bh=ntHVsyRurvGjVshNXwBX4PbkBBTnvkshNG9V5gbHCPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrVTXUl6OU4z4HTa8JsHSkBTTWKXYaExe1gRqiTV7gbIpnxniQq7QF3GMLKDjXr3t
         n8mVTvt80c0NxvrHUI78ebi/1yxYecTfMpAOAQ7X3ke3PPavjHNP5xbpzg9G36ygzQ
         /Sl90s2plaEQ4YUet2FKEHd0MQ88QOfawxM3EniA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/51] iio: imu: adis16400: fix memory leak
Date:   Mon,  3 Aug 2020 14:19:50 +0200
Message-Id: <20200803121849.741925258@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121849.488233135@linuxfoundation.org>
References: <20200803121849.488233135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9c0530e898f384c5d279bfcebd8bb17af1105873 ]

In adis_update_scan_mode_burst, if adis->buffer allocation fails release
the adis->xfer.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16400_buffer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16400_buffer.c b/drivers/iio/imu/adis16400_buffer.c
index e70a5339acb19..3fc11aec98b95 100644
--- a/drivers/iio/imu/adis16400_buffer.c
+++ b/drivers/iio/imu/adis16400_buffer.c
@@ -38,8 +38,11 @@ int adis16400_update_scan_mode(struct iio_dev *indio_dev,
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
-- 
2.25.1



