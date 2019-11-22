Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B428106A08
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfKVKbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbfKVKbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:31:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B106020708;
        Fri, 22 Nov 2019 10:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418668;
        bh=WiBksml3Di1WYFYiOQH1mulf+M8x8gaNtPvMG683ctI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StY2qZclZgjg8KoYf/QV2jZDqxS6YGOtJa8Mlo4Vzzyd+EFQemZt+0WQcaZJXUEpY
         evDfxinV/T6Xm3zH9cMs0+68LcShqBDlSb2619yROYJZ90YeNut+wtrGJsI/qvIY0l
         5Eb3Kv4WEiO6BmikZHLg1C54IViXfzD4FowMkdIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 012/159] iio: dac: mcp4922: fix error handling in mcp4922_write_raw
Date:   Fri, 22 Nov 2019 11:26:43 +0100
Message-Id: <20191122100718.354014416@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



