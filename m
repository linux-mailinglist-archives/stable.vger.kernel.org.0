Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C76099A5F
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390997AbfHVRMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390656AbfHVRJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:06 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8700D233FE;
        Thu, 22 Aug 2019 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493745;
        bh=shLCSHnvpRv1xLmXamIGPM2iJquvcNkBvhEkuQqbjzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUETEZMJp7T0Tf4hduYfIbtWNhSWhrk8ed3u8yrXsLRgTHlvmxwbb3SSkbZAb1Wj9
         ehXFWm0XQW+BgINZ3S7gad0RS26F/60QFfbR8pluwUcGarphIUhVIjuBJfKnglJHBS
         H66cMKwD7Autwy/UU60beyxAiuZy05JRrWSo9mLE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 094/135] iio: adc: max9611: Fix temperature reading in probe
Date:   Thu, 22 Aug 2019 13:07:30 -0400
Message-Id: <20190822170811.13303-95-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

commit b9ddd5091160793ee9fac10da765cf3f53d2aaf0 upstream.

The max9611 driver reads the die temperature at probe time to validate
the communication channel. Use the actual read value to perform the test
instead of the read function return value, which was mistakenly used so
far.

The temperature reading test was only successful because the 0 return
value is in the range of supported temperatures.

Fixes: 69780a3bbc0b ("iio: adc: Add Maxim max9611 ADC driver")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/max9611.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/max9611.c b/drivers/iio/adc/max9611.c
index 0e3c6529fc4c9..da073d72f649f 100644
--- a/drivers/iio/adc/max9611.c
+++ b/drivers/iio/adc/max9611.c
@@ -480,7 +480,7 @@ static int max9611_init(struct max9611_dev *max9611)
 	if (ret)
 		return ret;
 
-	regval = ret & MAX9611_TEMP_MASK;
+	regval &= MAX9611_TEMP_MASK;
 
 	if ((regval > MAX9611_TEMP_MAX_POS &&
 	     regval < MAX9611_TEMP_MIN_NEG) ||
-- 
2.20.1

