Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF451DD464
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfJRWFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbfJRWFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8243A222D4;
        Fri, 18 Oct 2019 22:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436303;
        bh=ygm/bLbEKE+ydYb6n27zhUbjztKPi1bevmfl1GTnNCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kltX15avdl3QHp7AYoatQdM1VE4OR7S4GA9c9pzu3EFHBn8PjhYb4ZgUpsmCoRZ/t
         F1sQ25KBBxqWar64qgjsIVC/pOBiKdzzadUOLpiiAamsbPzlrrnvUxJFVnAz1Zqx9W
         aOmXNOdCAPwl31WzkeyfTlPIpnh984IwqddrmmyE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 74/89] iio: imu: adis16400: fix memory leak
Date:   Fri, 18 Oct 2019 18:03:09 -0400
Message-Id: <20191018220324.8165-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 9c0530e898f384c5d279bfcebd8bb17af1105873 ]

In adis_update_scan_mode_burst, if adis->buffer allocation fails release
the adis->xfer.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis_buffer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis_buffer.c b/drivers/iio/imu/adis_buffer.c
index f446ff4978091..4998a89d083d5 100644
--- a/drivers/iio/imu/adis_buffer.c
+++ b/drivers/iio/imu/adis_buffer.c
@@ -35,8 +35,11 @@ static int adis_update_scan_mode_burst(struct iio_dev *indio_dev,
 		return -ENOMEM;
 
 	adis->buffer = kzalloc(burst_length + sizeof(u16), GFP_KERNEL);
-	if (!adis->buffer)
+	if (!adis->buffer) {
+		kfree(adis->xfer);
+		adis->xfer = NULL;
 		return -ENOMEM;
+	}
 
 	tx = adis->buffer + burst_length;
 	tx[0] = ADIS_READ_REG(adis->burst->reg_cmd);
-- 
2.20.1

