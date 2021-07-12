Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C6A3C4AC6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240536AbhGLGxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240340AbhGLGvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E0E261008;
        Mon, 12 Jul 2021 06:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072500;
        bh=7ig6Boh5ZC+q/X3fhU+8OylFMeep0I6e83jHJe3dyw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hLjmV3bARGJStK65QRkOJGI6z/StiTGu9QIx0xziynzHuXzXWDtwq0dzI08v0899
         ZgEZ/HKIBbNbvw2WdvWmyU065zV5B6h8VkM5igyW6r0NhCjMGZ+Lwm7AcfXtbzJ/6N
         Lyggl4N8QuQzB4Ni4MhCUh6IlJdUr70m/9j6S3v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andreas Klinger <ak@it-klinger.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 516/593] iio: adc: hx711: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:16 +0200
Message-Id: <20210712060948.922083078@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 6a173531d355..f7ee856a6b8b 100644
--- a/drivers/iio/adc/hx711.c
+++ b/drivers/iio/adc/hx711.c
@@ -86,9 +86,9 @@ struct hx711_data {
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



