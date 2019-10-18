Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE3CDD470
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbfJRWYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbfJRWFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F542222CD;
        Fri, 18 Oct 2019 22:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436301;
        bh=1a7w7GetW5FhHuRCvaMI7Qle4+x0C2k7Ge+UODumWyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddaftopwMGTzQDX46oQMo+dzQbSkd3fhv+O29K8Uia45O0LVzJhQIkOoJbR989OyI
         7Zrlqbdi3luP9NnaQNZXY5EEIKocpySNDWn+9njgXJkFyH4aTnUlV2OEEqcTzdwXVD
         9qvY7kYnpeTZ4A5lcUnf4dfaFdVq9xT2mbnTiPWI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Popa <stefan.popa@analog.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 72/89] iio: accel: adxl372: Perform a reset at start up
Date:   Fri, 18 Oct 2019 18:03:07 -0400
Message-Id: <20191018220324.8165-72-sashal@kernel.org>
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

From: Stefan Popa <stefan.popa@analog.com>

[ Upstream commit d9a997bd4d762d5bd8cc548d762902f58b5e0a74 ]

We need to perform a reset a start up to make sure that the chip is in a
consistent state. This reset also disables all the interrupts which
should only be enabled together with the iio buffer. Not doing this, was
sometimes causing unwanted interrupts to trigger.

Signed-off-by: Stefan Popa <stefan.popa@analog.com>
Fixes: f4f55ce38e5f ("iio:adxl372: Add FIFO and interrupts support")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl372.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index fbad4b45fe42d..67b8817995c04 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -575,6 +575,14 @@ static int adxl372_setup(struct adxl372_state *st)
 		return -ENODEV;
 	}
 
+	/*
+	 * Perform a software reset to make sure the device is in a consistent
+	 * state after start up.
+	 */
+	ret = regmap_write(st->regmap, ADXL372_RESET, ADXL372_RESET_CODE);
+	if (ret < 0)
+		return ret;
+
 	ret = adxl372_set_op_mode(st, ADXL372_STANDBY);
 	if (ret < 0)
 		return ret;
-- 
2.20.1

