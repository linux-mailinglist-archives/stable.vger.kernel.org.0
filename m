Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D080DF4946
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388339AbfKHLnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:43:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732512AbfKHLnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9693C222C4;
        Fri,  8 Nov 2019 11:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213392;
        bh=BVN4guRbz7t3vPSsHyZRa9cgH9ITtQ3dmc9IWsNpJng=;
        h=From:To:Cc:Subject:Date:From;
        b=EKgUWDOGMSQXTHNvEA3M2njbHIYJW7P19pOAypOixENKV8+NUux1awzzSJObZdj8D
         SyP0B9ooQpLhEZvu0opZl/gJOebXHWO/uV44qQ4iHiEpOHoHFmnT4SUj5b3efGx8xc
         1jYxMFlcjG5wt1V/voauPyjD052DGV1dEVwPOt9o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Agner <stefan@agner.ch>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 001/103] iio: adc: max9611: explicitly cast gain_selectors
Date:   Fri,  8 Nov 2019 06:41:26 -0500
Message-Id: <20191108114310.14363-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit b1ec0802503820ccbc894aadfd2a44da20232f5e ]

After finding a reasonable gain, the function converts the configured
gain to a gain configuration option selector enum max9611_csa_gain.
Make the conversion clearly visible by using an explicit cast. This
also avoids a warning seen with clang:
  drivers/iio/adc/max9611.c:292:16: warning: implicit conversion from
      enumeration type 'enum max9611_conf_ids' to different enumeration
      type 'enum max9611_csa_gain' [-Wenum-conversion]
                        *csa_gain = gain_selectors[i];
                                  ~ ^~~~~~~~~~~~~~~~~

Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max9611.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/max9611.c b/drivers/iio/adc/max9611.c
index c61fbf5602718..33be07c78b96f 100644
--- a/drivers/iio/adc/max9611.c
+++ b/drivers/iio/adc/max9611.c
@@ -289,7 +289,7 @@ static int max9611_read_csa_voltage(struct max9611_dev *max9611,
 			return ret;
 
 		if (*adc_raw > 0) {
-			*csa_gain = gain_selectors[i];
+			*csa_gain = (enum max9611_csa_gain)gain_selectors[i];
 			return 0;
 		}
 	}
-- 
2.20.1

