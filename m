Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEAB87F17F
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfHBJen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391386AbfHBJem (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:34:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7527F21773;
        Fri,  2 Aug 2019 09:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738482;
        bh=ucdRFPuww9+Vif2YGDPnNBnscdm99AdsOr/ZthvgRfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3+kPpwudyXh1CoA2X55O2i+R1PH7MnEUaaCzaAGattC08crpBUIwb475MZWHb926
         TNuvNUJIgX/jhXo9kdEZJ734CqCZtfJVHbwR8AE4hwCxnq+j0oLnm3G5Tp0b1mD4jx
         kSXHpHd00ZXYF4ge5+yU08/++qC3AP+rgKIEnOaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 121/158] iio: iio-utils: Fix possible incorrect mask calculation
Date:   Fri,  2 Aug 2019 11:29:02 +0200
Message-Id: <20190802092228.474158921@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 208a68c8393d6041a90862992222f3d7943d44d6 ]

On some machines, iio-sensor-proxy was returning all 0's for IIO sensor
values. It turns out that the bits_used for this sensor is 32, which makes
the mask calculation:

*mask = (1 << 32) - 1;

If the compiler interprets the 1 literals as 32-bit ints, it generates
undefined behavior depending on compiler version and optimization level.
On my system, it optimizes out the shift, so the mask value becomes

*mask = (1) - 1;

With a mask value of 0, iio-sensor-proxy will always return 0 for every axis.

Avoid incorrect 0 values caused by compiler optimization.

See original fix by Brett Dutro <brett.dutro@gmail.com> in
iio-sensor-proxy:
https://github.com/hadess/iio-sensor-proxy/commit/9615ceac7c134d838660e209726cd86aa2064fd3

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/iio/iio_utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index 5eb6793f3972..2d0dcd6fc64c 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -163,9 +163,9 @@ int iioutils_get_type(unsigned *is_signed, unsigned *bytes, unsigned *bits_used,
 			*be = (endianchar == 'b');
 			*bytes = padint / 8;
 			if (*bits_used == 64)
-				*mask = ~0;
+				*mask = ~(0ULL);
 			else
-				*mask = (1ULL << *bits_used) - 1;
+				*mask = (1ULL << *bits_used) - 1ULL;
 
 			*is_signed = (signchar == 's');
 			if (fclose(sysfsfp)) {
-- 
2.20.1



