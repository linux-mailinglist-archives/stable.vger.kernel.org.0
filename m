Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1833ED5F8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhHPNQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237244AbhHPNND (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 809C5632A5;
        Mon, 16 Aug 2021 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119434;
        bh=9VMMPXM8/8jTnzlI6tczZZu6AKaPMV2hEeivGTgXr4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTkWuZwH+xyoE0oUK6gzZbPxCB/JVMq5JDcbnXa3mWK3u14Q21x9ilLJRr9UVYF3H
         g6FVlid2VQI6zpmPGnXqPEzrf1e1kdeTKfQWf2QRUkXLJcKmNTAudSjoI92ra1Mmk0
         y2k3gvoV61M4ZCesyzHYm3gKg+SRFfuwh/T1YaTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.13 006/151] iio: adc: Fix incorrect exit of for-loop
Date:   Mon, 16 Aug 2021 15:00:36 +0200
Message-Id: <20210816125444.293829293@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 5afc1540f13804a31bb704b763308e17688369c5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/palmas_gpadc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/palmas_gpadc.c
+++ b/drivers/iio/adc/palmas_gpadc.c
@@ -664,8 +664,8 @@ static int palmas_adc_wakeup_configure(s
 
 	adc_period = adc->auto_conversion_period;
 	for (i = 0; i < 16; ++i) {
-		if (((1000 * (1 << i)) / 32) < adc_period)
-			continue;
+		if (((1000 * (1 << i)) / 32) >= adc_period)
+			break;
 	}
 	if (i > 0)
 		i--;


