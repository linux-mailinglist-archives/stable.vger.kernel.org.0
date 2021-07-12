Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073013C4776
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbhGLGcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235940AbhGLG3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6850361166;
        Mon, 12 Jul 2021 06:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071181;
        bh=UOiV8x1p7nspUJGgzh7j+xn/gUGBhu5AZ4wxndVO/ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z6uR/Yr41hvtRP6nG6V2IIXfrvKFi/s+PUIc5xrOWklmjOwuQlZBis+SAirHCx2CI
         ++KuEnZkPOVtwTAPDrdp7lQn9sARj56Ehh89/PDxwAD4YLM8R8iGBxYmDypc+mf3r4
         lHp9i7cjfrWBWgZuy8Vo17/ra36YFPMY0A9uAljo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andreas Klinger <ak@it-klinger.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 310/348] iio: adc: hx711: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:34 +0200
Message-Id: <20210712060744.970589325@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit afe2a789fbf7acd1a05407fc7839cc08d23825e3 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of this function.

Fixes: d3bf60450d47 ("iio: hx711: add triggered buffer support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andreas Klinger <ak@it-klinger.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210613152301.571002-3-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/hx711.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/hx711.c b/drivers/iio/adc/hx711.c
index 62e6c8badd22..a3265166fd83 100644
--- a/drivers/iio/adc/hx711.c
+++ b/drivers/iio/adc/hx711.c
@@ -85,9 +85,9 @@ struct hx711_data {
 	struct mutex		lock;
 	/*
 	 * triggered buffer
-	 * 2x32-bit channel + 64-bit timestamp
+	 * 2x32-bit channel + 64-bit naturally aligned timestamp
 	 */
-	u32			buffer[4];
+	u32			buffer[4] __aligned(8);
 	/*
 	 * delay after a rising edge on SCK until the data is ready DOUT
 	 * this is dependent on the hx711 where the datasheet tells a
-- 
2.30.2



