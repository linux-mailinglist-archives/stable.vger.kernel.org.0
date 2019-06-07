Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1878F39032
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbfFGPts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbfFGPtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AC0D20840;
        Fri,  7 Jun 2019 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922587;
        bh=Dpndc8p/r3PbUm9FkMP47ORcNiP1aD71MDgt/ZF6wjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KffXUTvs+oq0u+HZ0DErokF15D+tjat2Ll/wa0oc/YwDtNLL2tB1MhezVnahdvVPW
         DVsyX7F0eMaOgxveuw2/uBHRyztwY6JeJjHJLPnGiz3EgTnIGgM+Yp4gs4yq7wBAMm
         dtamIGcj9JCqLZ1Ffi1dpDJWkJEaeWLBkjmXvsj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomer Maimon <tmaimon77@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.1 30/85] iio: adc: modify NPCM ADC read reference voltage
Date:   Fri,  7 Jun 2019 17:39:15 +0200
Message-Id: <20190607153852.991032877@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomer Maimon <tmaimon77@gmail.com>

commit 4e63ed6b90803eeb400c392e9ff493200d926b06 upstream.

Checking if regulator is valid before reading
NPCM ADC regulator voltage to avoid system crash
in a case the regulator is not valid.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/npcm_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/npcm_adc.c
+++ b/drivers/iio/adc/npcm_adc.c
@@ -149,7 +149,7 @@ static int npcm_adc_read_raw(struct iio_
 		}
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
-		if (info->vref) {
+		if (!IS_ERR(info->vref)) {
 			vref_uv = regulator_get_voltage(info->vref);
 			*val = vref_uv / 1000;
 		} else {


