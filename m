Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9533A1CAB54
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgEHMmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgEHMmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A7E624970;
        Fri,  8 May 2020 12:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941758;
        bh=ZQ0XHbfBWQiIWiONf5FTHXKsilzV6KRIvH4mlihmPd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnRNANWtfxRUZyP1IroffIhMBqymu4fenGDEopGd190rsy6L6mLJEpTp0V81hTwJp
         sIf1oQ+vaiBhlukzt257FkNpyf8nMWmd3ugUNxVcWR3wY2viIwLm9qHdRFMydYEdQx
         BmEJxPSSICM68ShkAVjZ6p/E8RKWX/EcXdQjasc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 161/312] iio:ad7797: Use correct attribute_group
Date:   Fri,  8 May 2020 14:32:32 +0200
Message-Id: <20200508123135.778053240@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 91d34ed756eaf..fe0c5a155e211 100644
--- a/drivers/iio/adc/ad7793.c
+++ b/drivers/iio/adc/ad7793.c
@@ -579,7 +579,7 @@ static const struct iio_info ad7797_info = {
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



