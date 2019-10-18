Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26E9DD476
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394491AbfJRWYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728993AbfJRWE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EEEE20679;
        Fri, 18 Oct 2019 22:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436298;
        bh=KT6JUrdslB3ISnhA1e5qu4apPwPFT29frazQVGLrH9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUitnbIb4idLkYAgJ1WPahi57kbRl1UgMb36wzjRg8iYrvfZfcTFzbPh9820Ms0mb
         71DOOzeAr2OcyCWhlKXOLT/3yiN+ajobJ1hv46z0n3gId7f1SZBqXLyvX/v/GdlqmH
         hEgEw71pigqQ2G2qcCyjU9yHKDoxCTe/326ZeUO8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Popa <stefan.popa@analog.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 70/89] iio: accel: adxl372: Fix/remove limitation for FIFO samples
Date:   Fri, 18 Oct 2019 18:03:05 -0400
Message-Id: <20191018220324.8165-70-sashal@kernel.org>
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

[ Upstream commit d202ce4787e446556c6b9d01f84734c3f8174ba3 ]

Currently, the driver sets the FIFO_SAMPLES register with the number of
sample sets (maximum of 170 for 3 axis data, 256 for 2-axis and 512 for
single axis). However, the FIFO_SAMPLES register should store the number
of samples, regardless of how the FIFO format is configured.

Signed-off-by: Stefan Popa <stefan.popa@analog.com>
Fixes: f4f55ce38e5f ("iio:adxl372: Add FIFO and interrupts support")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl372.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index 055227cb3d43c..863fe61a371fb 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -474,12 +474,17 @@ static int adxl372_configure_fifo(struct adxl372_state *st)
 	if (ret < 0)
 		return ret;
 
-	fifo_samples = st->watermark & 0xFF;
+	/*
+	 * watermark stores the number of sets; we need to write the FIFO
+	 * registers with the number of samples
+	 */
+	fifo_samples = (st->watermark * st->fifo_set_size);
 	fifo_ctl = ADXL372_FIFO_CTL_FORMAT_MODE(st->fifo_format) |
 		   ADXL372_FIFO_CTL_MODE_MODE(st->fifo_mode) |
-		   ADXL372_FIFO_CTL_SAMPLES_MODE(st->watermark);
+		   ADXL372_FIFO_CTL_SAMPLES_MODE(fifo_samples);
 
-	ret = regmap_write(st->regmap, ADXL372_FIFO_SAMPLES, fifo_samples);
+	ret = regmap_write(st->regmap,
+			   ADXL372_FIFO_SAMPLES, fifo_samples & 0xFF);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1

