Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D440395E12
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbhEaNyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231542AbhEaNwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9C2B6135D;
        Mon, 31 May 2021 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467965;
        bh=Y5+dEpA0SfVXkbYtN5nq8rOucY7Lmnj4S52INcUap0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYl5e3ZMtt3eywkR4vmA90qq0KR0z/Djw+GWLkDulWQ5x7grKOkrS4vvREH0ghzRf
         PASHfY9HU6CARGSK5lBR4FW8mupBp7HmhReJeJ9b4tk2S5O0MmrSZqp/Tx2uSqEGG0
         fnP8cHXe+ydU2meaQBDVEq3x5px0R4hxITRR6ghs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Daniel Junho <djunho@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.10 066/252] iio: adc: ad7923: Fix undersized rx buffer.
Date:   Mon, 31 May 2021 15:12:11 +0200
Message-Id: <20210531130700.233067255@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 01fcf129f61b26d5b3d2d8afb03e770dee271bc8 upstream.

Fixes tag is where the max channels became 8, but timestamp space was missing
before that.

Fixes: 851644a60d20 ("iio: adc: ad7923: Add support for the ad7908/ad7918/ad7928")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel Junho <djunho@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501165314.511954-3-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7923.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7923.c
+++ b/drivers/iio/adc/ad7923.c
@@ -59,8 +59,10 @@ struct ad7923_state {
 	/*
 	 * DMA (thus cache coherency maintenance) requires the
 	 * transfer buffers to live in their own cache lines.
+	 * Ensure rx_buf can be directly used in iio_push_to_buffers_with_timetamp
+	 * Length = 8 channels + 4 extra for 8 byte timestamp
 	 */
-	__be16				rx_buf[4] ____cacheline_aligned;
+	__be16				rx_buf[12] ____cacheline_aligned;
 	__be16				tx_buf[4];
 };
 


