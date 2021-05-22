Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803E338D451
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEVHwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhEVHwD (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A319D611CB;
        Sat, 22 May 2021 07:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669839;
        bh=ZGq4j1SlPsNHt0wZ5jk0KzJYYzOn+/AwZXKgpzfrXjs=;
        h=Subject:To:From:Date:From;
        b=oiJCdibq6a1qmP7q1Ren5qQ1QsHckDGLGj7QK7NJ/OndqdWaTxL4aQKp11Xb3UHIG
         wiqEi7fPP+hIHqHhTtRpW5b4reWjvL9QcV1KcLoGOd25XNISGG8IAN52p2tNXIk4kN
         HOs8kQZ1fQVuxodnm+s6L5B++iF+dXvrsWy2MAMo=
Subject: patch "iio: adc: ad7923: Fix undersized rx buffer." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, djunho@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:21 +0200
Message-ID: <162166982117458@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7923: Fix undersized rx buffer.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 01fcf129f61b26d5b3d2d8afb03e770dee271bc8 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sat, 1 May 2021 17:53:14 +0100
Subject: iio: adc: ad7923: Fix undersized rx buffer.

Fixes tag is where the max channels became 8, but timestamp space was missing
before that.

Fixes: 851644a60d20 ("iio: adc: ad7923: Add support for the ad7908/ad7918/ad7928")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel Junho <djunho@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501165314.511954-3-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
---
 drivers/iio/adc/ad7923.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7923.c b/drivers/iio/adc/ad7923.c
index 9a649745cd0a..069b561ee768 100644
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
 
-- 
2.31.1


