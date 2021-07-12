Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917753C5573
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355726AbhGLIKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353667AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD716145E;
        Mon, 12 Jul 2021 07:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076594;
        bh=sENWkQ5uR0IMnAxF0xKSzpMQnClAuWfwxn0h+ba6SMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otjsAVtqfzI03rEJNhA6tPSzbW9BRZG9miCX5up0YlroUX8CTIckIQeXZr+x8P0vP
         JH9y7V6EVH38oGqkOQ9w2hhnDq72MTw9gSJiKBKhtBDudgu67gEzJp3RgBwXkYbkfZ
         lsV7tNEOdZ5vmTgDJh+qOMsirHTHbvijLiIAbW+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andreas Klinger <ak@it-klinger.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 711/800] iio: adc: mxs-lradc: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:12:14 +0200
Message-Id: <20210712061042.366401833@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 6a6be221b8bd561b053f0701ec752a5ed9007f69 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.
Add a comment on why the buffer is the size it is as not immediately
obvious.

Found during an audit of all calls of this function.

Fixes: 6dd112b9f85e ("iio: adc: mxs-lradc: Add support for ADC driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andreas Klinger <ak@it-klinger.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210613152301.571002-4-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mxs-lradc-adc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/mxs-lradc-adc.c b/drivers/iio/adc/mxs-lradc-adc.c
index 30e29f44ebd2..c480cb489c1a 100644
--- a/drivers/iio/adc/mxs-lradc-adc.c
+++ b/drivers/iio/adc/mxs-lradc-adc.c
@@ -115,7 +115,8 @@ struct mxs_lradc_adc {
 	struct device		*dev;
 
 	void __iomem		*base;
-	u32			buffer[10];
+	/* Maximum of 8 channels + 8 byte ts */
+	u32			buffer[10] __aligned(8);
 	struct iio_trigger	*trig;
 	struct completion	completion;
 	spinlock_t		lock;
-- 
2.30.2



