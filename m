Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFB2DA135
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389688AbfJPWUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437526AbfJPVxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:43 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F86222C1;
        Wed, 16 Oct 2019 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262822;
        bh=hyhmoGrtgBALpuITUMJpgc5B0vB0P4Ck+P3tweLPDA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k62JdYJK+su9q3UteH5yyBCMJ/AFenNw4SDxApbLzsl9hvw58SQna7ts4ELagThA8
         dOfLbRek5fnywcGQ0cHD9MMCbHbExrG9vBG8w5BnSdZkB+DMx0kZkdFhxVX7Gi+ELr
         ydBAC7YV8E1bKfK4KqzpdM4KmOpjGvpCfI8+5Cxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.4 65/79] iio: adc: ad799x: fix probe error handling
Date:   Wed, 16 Oct 2019 14:50:40 -0700
Message-Id: <20191016214826.468391956@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit c62dd44901cfff12acc5792bf3d2dec20bcaf392 upstream.

Since commit 0f7ddcc1bff1 ("iio:adc:ad799x: Write default config on probe
and reset alert status on probe") the error path is wrong since it
leaves the vref regulator on. Fix this by disabling both regulators.

Fixes: 0f7ddcc1bff1 ("iio:adc:ad799x: Write default config on probe and reset alert status on probe")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ad799x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad799x.c
+++ b/drivers/iio/adc/ad799x.c
@@ -822,10 +822,10 @@ static int ad799x_probe(struct i2c_clien
 
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


