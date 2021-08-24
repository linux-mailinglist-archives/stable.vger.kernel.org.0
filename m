Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013B63F6618
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbhHXRUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240428AbhHXRSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C5961529;
        Tue, 24 Aug 2021 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824574;
        bh=NjP7ZJLOYvdl/UQqEsVJMtFLCz9N18do3Kp0bEVoQ0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ul0Uz9LQckdc6Tv49KdGW5f9sMSoEZOHCGI9tVWdo+ZfjQ9WNFakNUGX3l1uWQYQY
         gtMteFdMzkUDtEMjA0WpeSq79GqSNgGFor3qMP5y5HCMDQl5tof+M2Y69Fq5edIh4O
         ui6DU54iB2EWIfbJDjn5P7HFWZ6xWnxooPRuyTzXd0xxwEDBYhKzRgIggJxhY8BKJy
         KLKtvyv4h2OYooPYebr2K7Lid7DkSd9IS5WTlh7R6VJF6CEhY2KcZyN+VkE837hsgt
         kbz/BccrnmqwJxZ3RN21n4n677s2RnNGtAwgGmFaulFOuwZ/AL+vnvIRQao8EkwgzQ
         XpBJFu2PJvaqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 02/84] iio: adc: Fix incorrect exit of for-loop
Date:   Tue, 24 Aug 2021 13:01:28 -0400
Message-Id: <20210824170250.710392-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/iio/adc/palmas_gpadc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/palmas_gpadc.c b/drivers/iio/adc/palmas_gpadc.c
index 69b9affeef1e..7dcd4213d38a 100644
--- a/drivers/iio/adc/palmas_gpadc.c
+++ b/drivers/iio/adc/palmas_gpadc.c
@@ -659,8 +659,8 @@ static int palmas_adc_wakeup_configure(struct palmas_gpadc *adc)
 
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
2.30.2

