Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FEFB1F71
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbfIMNTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730276AbfIMNTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:36 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B9F920717;
        Fri, 13 Sep 2019 13:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380775;
        bh=6ju7qoV4XtxiOYiydTZ/xi21M3nC3WCFupiG3JE4sJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdiBhIoSsnx+2p+c6yJDy9FPIAuYZW3psvk6Od4zR1EG2p15Lr92vfjoqQpvE1msW
         Z8oajTS5434TFB7XXDeKD1G7fdzqsHlhcir9DV4o4d1imAeCJ8SIohKDZtxcDJl4HM
         GGzA9S2VybkR2E5KwBGvLJJvUlLUCp9L1D9n7B/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/190] iio: adc: gyroadc: fix uninitialized return code
Date:   Fri, 13 Sep 2019 14:07:10 +0100
Message-Id: <20190913130613.727863726@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 90c6260c1905a68fb596844087f2223bd4657fee ]

gcc-9 complains about a blatant uninitialized variable use that
all earlier compiler versions missed:

drivers/iio/adc/rcar-gyroadc.c:510:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]

Return -EINVAL instead here and a few lines above it where
we accidentally return 0 on failure.

Cc: stable@vger.kernel.org
Fixes: 059c53b32329 ("iio: adc: Add Renesas GyroADC driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/rcar-gyroadc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/rcar-gyroadc.c b/drivers/iio/adc/rcar-gyroadc.c
index dcb50172186f4..f3a966ab35dcb 100644
--- a/drivers/iio/adc/rcar-gyroadc.c
+++ b/drivers/iio/adc/rcar-gyroadc.c
@@ -391,7 +391,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 				dev_err(dev,
 					"Only %i channels supported with %s, but reg = <%i>.\n",
 					num_channels, child->name, reg);
-				return ret;
+				return -EINVAL;
 			}
 		}
 
@@ -400,7 +400,7 @@ static int rcar_gyroadc_parse_subdevs(struct iio_dev *indio_dev)
 			dev_err(dev,
 				"Channel %i uses different ADC mode than the rest.\n",
 				reg);
-			return ret;
+			return -EINVAL;
 		}
 
 		/* Channel is valid, grab the regulator. */
-- 
2.20.1



