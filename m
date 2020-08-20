Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C5124BB2D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgHTMYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:24:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729902AbgHTJxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:53:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CACD12075E;
        Thu, 20 Aug 2020 09:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917230;
        bh=2xhDejPCoJNUZGSpbwq/HA5M4V1OMaAxiLC57IJTps8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMm8bvO9/Ygn6c11blOTxMWKNE3cmV2CY1GHgiMysGGd4NT1i9pAFOr1Lly7S8ajr
         akoeblXDdBH+DOj3CMph6Jvixfytv8sTY+rXH7gyDNCEU39XAtRL9ddY8Oj3p+2qAC
         drOWpbAbWxKSJ2H+5tMUG1K48nJpzR+kkcfVcIgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Stanhope <charles.stanhope@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 19/92] iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()
Date:   Thu, 20 Aug 2020 11:21:04 +0200
Message-Id: <20200820091538.559679156@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

commit 65afb0932a81c1de719ceee0db0b276094b10ac8 upstream.

There are 2 exit paths where the lock isn't held, but try to unlock the
mutex when exiting. In these places we should just return from the
function.

A neater approach would be to cleanup the ad5592r_read_raw(), but that
would make this patch more difficult to backport to stable versions.

Fixes 56ca9db862bf3: ("iio: dac: Add support for the AD5592R/AD5593R ADCs/DACs")
Reported-by: Charles Stanhope <charles.stanhope@gmail.com>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/dac/ad5592r-base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -417,7 +417,7 @@ static int ad5592r_read_raw(struct iio_d
 			s64 tmp = *val * (3767897513LL / 25LL);
 			*val = div_s64_rem(tmp, 1000000000LL, val2);
 
-			ret = IIO_VAL_INT_PLUS_MICRO;
+			return IIO_VAL_INT_PLUS_MICRO;
 		} else {
 			int mult;
 
@@ -448,7 +448,7 @@ static int ad5592r_read_raw(struct iio_d
 		ret =  IIO_VAL_INT;
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 unlock:


