Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF73F024A
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 13:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbhHRLMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 07:12:17 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45679 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbhHRLMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 07:12:17 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6DBF66000A;
        Wed, 18 Aug 2021 11:11:40 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-iio@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        stable@vger.kernel.org
Subject: [PATCH 01/16] iio: adc: max1027: Fix wrong shift with 12-bit devices
Date:   Wed, 18 Aug 2021 13:11:24 +0200
Message-Id: <20210818111139.330636-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210818111139.330636-1-miquel.raynal@bootlin.com>
References: <20210818111139.330636-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

10-bit devices must shift the value twice.
This is not needed anymore on 12-bit devices.

Fixes: ae47d009b508 ("iio: adc: max1027: Introduce 12-bit devices support")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/iio/adc/max1027.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/max1027.c b/drivers/iio/adc/max1027.c
index 655ab02d03d8..4a42d140a4b0 100644
--- a/drivers/iio/adc/max1027.c
+++ b/drivers/iio/adc/max1027.c
@@ -103,7 +103,7 @@ MODULE_DEVICE_TABLE(of, max1027_adc_dt_ids);
 			.sign = 'u',					\
 			.realbits = depth,				\
 			.storagebits = 16,				\
-			.shift = 2,					\
+			.shift = (depth == 10) ? 2 : 0,			\
 			.endianness = IIO_BE,				\
 		},							\
 	}
-- 
2.27.0

