Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B2E3C4BE5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbhGLHAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241647AbhGLG7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:59:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CDFF6124B;
        Mon, 12 Jul 2021 06:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072992;
        bh=18+Jc0PhP/E+IytzuLC/A+R7EcaqVMwDvZg9ifROpSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBeaZqomko2wI1ueJ3XQ5nXuUZok4HGnk9gW7+BVjQunMZ2XQ3lendYllDIC3Mav/
         NZzCpLR37KPLyhgWmxhforqzK6vB7WyB028RrnamPdApBzAbUhAq2hBaiSHbzMJRGv
         BwBeiX7VFkFdjlSfEAYJK1SKNgLveCpfNAO2Wp4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 091/700] iio: accel: bmc150: Fix bma222 scale unit
Date:   Mon, 12 Jul 2021 08:02:54 +0200
Message-Id: <20210712060937.602105694@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit 6e2a90af0b8d757e850cc023d761ee9a9492e2fe upstream.

According to sysfs-bus-iio documentation the unit for accelerometer
values after applying scale/offset should be m/s^2, not g, which explains
why the scale values for the other variants in bmc150-accel do not match
exactly the values given in the datasheet.

To get the correct values, we need to multiply the BMA222 scale values
by g = 9.80665 m/s^2.

Fixes: a1a210bf29a1 ("iio: accel: bmc150-accel: Add support for BMA222")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20210611080903.14384-2-stephan@gerhold.net
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/bmc150-accel-core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1171,11 +1171,12 @@ static const struct bmc150_accel_chip_in
 		/*
 		 * The datasheet page 17 says:
 		 * 15.6, 31.3, 62.5 and 125 mg per LSB.
+		 * IIO unit is m/s^2 so multiply by g = 9.80665 m/s^2.
 		 */
-		.scale_table = { {156000, BMC150_ACCEL_DEF_RANGE_2G},
-				 {313000, BMC150_ACCEL_DEF_RANGE_4G},
-				 {625000, BMC150_ACCEL_DEF_RANGE_8G},
-				 {1250000, BMC150_ACCEL_DEF_RANGE_16G} },
+		.scale_table = { {152984, BMC150_ACCEL_DEF_RANGE_2G},
+				 {306948, BMC150_ACCEL_DEF_RANGE_4G},
+				 {612916, BMC150_ACCEL_DEF_RANGE_8G},
+				 {1225831, BMC150_ACCEL_DEF_RANGE_16G} },
 	},
 	[bma222e] = {
 		.name = "BMA222E",


