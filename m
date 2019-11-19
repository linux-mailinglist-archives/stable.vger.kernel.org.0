Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99531018ED
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKSFY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbfKSFY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:24:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 571CA222ED;
        Tue, 19 Nov 2019 05:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141065;
        bh=fUrFUQ0VcsIJkVEdn4DWVyWlVpEN5y6KkxK0GRYbpqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cu8iCPhuX5/FpqzfpuJLyiIypDrD1jiVbMk/mtGj5a1EuTJSQ0GiormOhWmKPmtUV
         x3A9O+Td1hwx4EgOYTZ7JPwdzcDS5VqZRUA0MCIkHKU23nuRvWa/rVG23ik7su7iHm
         vNfYyaWgxSBLjqVWnd5M/rbddrarIV2DxJBLu1k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/422] iio: adc: max9611: explicitly cast gain_selectors
Date:   Tue, 19 Nov 2019 06:13:50 +0100
Message-Id: <20191119051402.157233793@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 49c1956e6a674..0884435eec68d 100644
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



