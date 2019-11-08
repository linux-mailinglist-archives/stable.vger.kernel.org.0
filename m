Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D33F484D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403763AbfKHLpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:45:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391194AbfKHLpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:45:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA37C2084D;
        Fri,  8 Nov 2019 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213549;
        bh=WiBksml3Di1WYFYiOQH1mulf+M8x8gaNtPvMG683ctI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIIgK7S86uDeuSsDAXKaNeN0e91ePIxo7E0pAsruPmRVio9azhuN075lzwma575Ot
         XJl5/X3nLaEXaoPBNgyIlnxQeYxGmVq5RXiMFBQz3SLIupB6Njg3BF2UzxiLsOh12t
         S0F14tfKWfMsCQ9nHwG0021hKHZn8K4hHUFbShGU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/64] iio: dac: mcp4922: fix error handling in mcp4922_write_raw
Date:   Fri,  8 Nov 2019 06:44:43 -0500
Message-Id: <20191108114545.15351-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 0833627fc3f757a0dca11e2a9c46c96335a900ee ]

Do not try to write negative values and make sure that the write goes well.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp4922.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/dac/mcp4922.c b/drivers/iio/dac/mcp4922.c
index 3854d201a5d6c..68dd0be1ac076 100644
--- a/drivers/iio/dac/mcp4922.c
+++ b/drivers/iio/dac/mcp4922.c
@@ -94,17 +94,22 @@ static int mcp4922_write_raw(struct iio_dev *indio_dev,
 		long mask)
 {
 	struct mcp4922_state *state = iio_priv(indio_dev);
+	int ret;
 
 	if (val2 != 0)
 		return -EINVAL;
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		if (val > GENMASK(chan->scan_type.realbits-1, 0))
+		if (val < 0 || val > GENMASK(chan->scan_type.realbits - 1, 0))
 			return -EINVAL;
 		val <<= chan->scan_type.shift;
-		state->value[chan->channel] = val;
-		return mcp4922_spi_write(state, chan->channel, val);
+
+		ret = mcp4922_spi_write(state, chan->channel, val);
+		if (!ret)
+			state->value[chan->channel] = val;
+		return ret;
+
 	default:
 		return -EINVAL;
 	}
-- 
2.20.1

