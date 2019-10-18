Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56ADDD2A4
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389659AbfJRWNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389556AbfJRWKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:10:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7DE622488;
        Fri, 18 Oct 2019 22:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436599;
        bh=oHLDuTqhmbIyiPId9IHh+J6glKoYTbZKPH9cV1JEMcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEFP8SsFf/wLOEbfmbdEHfq5FUg7qsbdwO6QX4NqIRmvOesRLy7fAOzGOFMUH+hBp
         gS6EZ+jRkGuGBrLPMO0mzjOOPGxKvx/ix+s+j7u5ugfwP2CX1+ipTpAJLVa8tTjAzT
         z9kgeZMwVdSEQIBs7Vbb2pPe864z2z2fwydZo0Oo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 23/29] iio: adc: ad799x: fix probe error handling
Date:   Fri, 18 Oct 2019 18:09:14 -0400
Message-Id: <20191018220920.10545-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220920.10545-1-sashal@kernel.org>
References: <20191018220920.10545-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit c62dd44901cfff12acc5792bf3d2dec20bcaf392 ]

Since commit 0f7ddcc1bff1 ("iio:adc:ad799x: Write default config on probe
and reset alert status on probe") the error path is wrong since it
leaves the vref regulator on. Fix this by disabling both regulators.

Fixes: 0f7ddcc1bff1 ("iio:adc:ad799x: Write default config on probe and reset alert status on probe")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad799x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad799x.c b/drivers/iio/adc/ad799x.c
index 9704090b79084..cd6dbe95125b3 100644
--- a/drivers/iio/adc/ad799x.c
+++ b/drivers/iio/adc/ad799x.c
@@ -817,10 +817,10 @@ static int ad799x_probe(struct i2c_client *client,
 
 	ret = ad799x_write_config(st, st->chip_config->default_config);
 	if (ret < 0)
-		goto error_disable_reg;
+		goto error_disable_vref;
 	ret = ad799x_read_config(st);
 	if (ret < 0)
-		goto error_disable_reg;
+		goto error_disable_vref;
 	st->config = ret;
 
 	ret = iio_triggered_buffer_setup(indio_dev, NULL,
-- 
2.20.1

