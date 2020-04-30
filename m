Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051BE1BFA7F
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgD3NyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbgD3NyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:54:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB582063A;
        Thu, 30 Apr 2020 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254844;
        bh=2q6xYtEnk5Q9fAbhYOot0AOAKQNt/B7JU4vxKPWHFG0=;
        h=From:To:Cc:Subject:Date:From;
        b=el+UKp8X4Hs8p+up8LaYpNIcWkgJ3xnqAeAnrt4cNxr+csL97WCdhop9mIXgENQQ1
         J31zQlTRoLm76jFT9slCfmvVb84aRXd8LuCeKMuELWiYwZ7Z6KKflfEAp3hY2t1VSa
         iaKvgFGFr3kuMdk0rHXQOWQXo+t3rsNW6Fa6FOgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/27] iio:ad7797: Use correct attribute_group
Date:   Thu, 30 Apr 2020 09:53:36 -0400
Message-Id: <20200430135402.20994-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 28535877ac5b2b84f0d394fd67a5ec71c0c48b10 ]

It should use ad7797_attribute_group in ad7797_info,
according to commit ("iio:ad7793: Add support for the ad7796 and ad7797").

Scale is fixed for the ad7796 and not programmable, hence
should not have the scale_available attribute.

Fixes: fd1a8b912841 ("iio:ad7793: Add support for the ad7796 and ad7797")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7793.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7793.c b/drivers/iio/adc/ad7793.c
index 07246a6037e31..f64781d03d5d3 100644
--- a/drivers/iio/adc/ad7793.c
+++ b/drivers/iio/adc/ad7793.c
@@ -543,7 +543,7 @@ static const struct iio_info ad7797_info = {
 	.read_raw = &ad7793_read_raw,
 	.write_raw = &ad7793_write_raw,
 	.write_raw_get_fmt = &ad7793_write_raw_get_fmt,
-	.attrs = &ad7793_attribute_group,
+	.attrs = &ad7797_attribute_group,
 	.validate_trigger = ad_sd_validate_trigger,
 	.driver_module = THIS_MODULE,
 };
-- 
2.20.1

