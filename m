Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA113E53F7
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 08:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhHJG4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 02:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhHJG4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 02:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2752861019;
        Tue, 10 Aug 2021 06:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628578553;
        bh=Q4amZh3YZUeXG+fdiqjGHwa6vXzpyjHVLwfupqI4o4g=;
        h=Subject:To:From:Date:From;
        b=qWW1RxA+/6WjCDEOwPqSsfH0TN0GEjJAezk6tmjnBWy9BeNWJ6n3JHa/ZdzCPdvJn
         gZbkTUGZowtL8OsxV2ts94oqEwCnNXZJyBwe8OXUcEMPw9CmSpeBUoJEWSz0NDq52W
         zyv3Yb10nK3LU9H0vuP8DA2b/nfJQTaG5IwWYi4I=
Subject: patch "iio: adc: Fix incorrect exit of for-loop" added to staging-linus
To:     colin.king@canonical.com, Jonathan.Cameron@huawei.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Aug 2021 08:55:34 +0200
Message-ID: <162857853412770@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: Fix incorrect exit of for-loop

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5afc1540f13804a31bb704b763308e17688369c5 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Fri, 30 Jul 2021 08:16:51 +0100
Subject: iio: adc: Fix incorrect exit of for-loop

Currently the for-loop that scans for the optimial adc_period iterates
through all the possible adc_period levels because the exit logic in
the loop is inverted. I believe the comparison should be swapped and
the continue replaced with a break to exit the loop at the correct
point.

Addresses-Coverity: ("Continue has no effect")
Fixes: e08e19c331fb ("iio:adc: add iio driver for Palmas (twl6035/7) gpadc")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20210730071651.17394-1-colin.king@canonical.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/palmas_gpadc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/palmas_gpadc.c b/drivers/iio/adc/palmas_gpadc.c
index 6ef09609be9f..f9c8385c72d3 100644
--- a/drivers/iio/adc/palmas_gpadc.c
+++ b/drivers/iio/adc/palmas_gpadc.c
@@ -664,8 +664,8 @@ static int palmas_adc_wakeup_configure(struct palmas_gpadc *adc)
 
 	adc_period = adc->auto_conversion_period;
 	for (i = 0; i < 16; ++i) {
-		if (((1000 * (1 << i)) / 32) < adc_period)
-			continue;
+		if (((1000 * (1 << i)) / 32) >= adc_period)
+			break;
 	}
 	if (i > 0)
 		i--;
-- 
2.32.0


