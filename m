Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9541839E11
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfFHLmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbfFHLmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3580214AF;
        Sat,  8 Jun 2019 11:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994154;
        bh=9erjZsPr+3muEteXmFDk9IJ6Bob2nrx1jhDybrkdOHM=;
        h=From:To:Cc:Subject:Date:From;
        b=E+Qd/EccmaS/aW15Fazra4NgelusknRboowoIZG5sCCmvfB10KRGRYEeKtEtROlot
         imyhBVn0PwkFCrsKC1PWG3FXUsnSwztHMPW+pilywe6GskAl7fEXy+W5Gm8QeNVmN2
         i0ejlRYkbEuJPoIYkiU2BLOeNmhslxnFpuuvcW8w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruslan Babayev <ruslan@babayev.com>, xe-linux-external@cisco.com,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/49] iio: dac: ds4422/ds4424 fix chip verification
Date:   Sat,  8 Jun 2019 07:41:42 -0400
Message-Id: <20190608114232.8731-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruslan Babayev <ruslan@babayev.com>

[ Upstream commit 60f2208699ec08ff9fdf1f97639a661a92a18f1c ]

The ds4424_get_value function takes channel number as it's 3rd
argument and translates it internally into I2C address using
DS4424_DAC_ADDR macro. The caller ds4424_verify_chip was passing an
already translated I2C address as its last argument.

Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
Cc: xe-linux-external@cisco.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ds4424.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ds4424.c b/drivers/iio/dac/ds4424.c
index 883a47562055..714a97f91319 100644
--- a/drivers/iio/dac/ds4424.c
+++ b/drivers/iio/dac/ds4424.c
@@ -166,7 +166,7 @@ static int ds4424_verify_chip(struct iio_dev *indio_dev)
 {
 	int ret, val;
 
-	ret = ds4424_get_value(indio_dev, &val, DS4424_DAC_ADDR(0));
+	ret = ds4424_get_value(indio_dev, &val, 0);
 	if (ret < 0)
 		dev_err(&indio_dev->dev,
 				"%s failed. ret: %d\n", __func__, ret);
-- 
2.20.1

