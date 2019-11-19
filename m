Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709ED1018EA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfKSFYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:24:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728221AbfKSFYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:24:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763B221783;
        Tue, 19 Nov 2019 05:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141075;
        bh=MeTFZGRJid8ZbNeiR81q23RkFona0u2IvdbdJMDE4Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sbKEbXUu70aAQrCKXbDr1OWf1ALo/KNaR3Xn2W6Raiy3ldWds1oM/zRrv3kMNgJO8
         qmrnuqrC0AhSRGI2GLetqO61/UDgDufG0JVApwdoUhEAQGFDRqqJZAgrItWAUD15JN
         L0X95wckdsPSa9HO/XkTYpyW4lt8+5jUbexUJr+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/422] iio: dac: mcp4922: fix error handling in mcp4922_write_raw
Date:   Tue, 19 Nov 2019 06:13:53 +0100
Message-Id: <20191119051402.331301983@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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
index bf9aa3fc0534e..b5190d1dae8e3 100644
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



