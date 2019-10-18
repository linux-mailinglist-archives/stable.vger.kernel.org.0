Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D90DD1AD
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbfJRWFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729207AbfJRWFI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40FA1222CD;
        Fri, 18 Oct 2019 22:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436308;
        bh=6aa/a7zujgcd5pc1XDGvvY94SwdoNTlHCpqsNXN7EwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyWNU1sPO/Zcq6c26Xm+B2dxaq6eyjH+rk90VM+VLtJXBFNLpuExULTJOUK6ga9L+
         qDShaZ0mxNoNUXnds2cX8L1Eu1+7ioDln9yUp/fEPCBvGwraibP6eO94PRgfJ2bh6h
         OdGQhffjOGkZy2cqprQ6AyaxczbxPj09Y8U7plzs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 78/89] iio: adc: ad799x: fix probe error handling
Date:   Fri, 18 Oct 2019 18:03:13 -0400
Message-Id: <20191018220324.8165-78-sashal@kernel.org>
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
index 5a3ca5904dedc..f658012baad88 100644
--- a/drivers/iio/adc/ad799x.c
+++ b/drivers/iio/adc/ad799x.c
@@ -810,10 +810,10 @@ static int ad799x_probe(struct i2c_client *client,
 
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

