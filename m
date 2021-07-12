Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221A3C4F88
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242319AbhGLH0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233218AbhGLHXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCC8C611AD;
        Mon, 12 Jul 2021 07:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074450;
        bh=PGJXkvvqmAF5u/OVARzIvilvQhxzceA6Bxy6uw4LpKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyvitLR9c/yUpTxcSnRlmn9632ZpI1l4eFGuMYXRytRdNIQ18t2vSy1PTiUK2BWAb
         PA6l3pl0nVllACnfpfQLJsT2hqSwa+LUpFoX0FTX/0pPKEeElc63lRakhVXklg1NIw
         WpwhX51V4wLF5OJ/qVU1DR1rzIqodrwTlPXzvqy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Nuno Sa <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 531/700] iio: adis16475: do not return ints in irq handlers
Date:   Mon, 12 Jul 2021 08:10:14 +0200
Message-Id: <20210712061032.986117476@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 00a72db718fa198da3946286dcad222399ccd4fb ]

On an IRQ handler we should not return normal error codes as 'irqreturn_t'
is expected.

This is done by jumping to the 'check_burst32' label where we return
'IRQ_HANDLED'. Note that it is fine to do the burst32 check in this
error path. If we have proper settings to apply burst32, we might just
do the setup now so that the next sample already uses it.

Fixes: fff7352bf7a3c ("iio: imu: Add support for adis16475")
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210427085454.30616-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16475.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16475.c b/drivers/iio/imu/adis16475.c
index 197d48240991..3c4e4deb8760 100644
--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -990,7 +990,7 @@ static irqreturn_t adis16475_trigger_handler(int irq, void *p)
 
 	ret = spi_sync(adis->spi, &adis->msg);
 	if (ret)
-		return ret;
+		goto check_burst32;
 
 	adis->spi->max_speed_hz = cached_spi_speed_hz;
 	buffer = adis->buffer;
-- 
2.30.2



