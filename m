Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E677613FDC4
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391035AbgAPX3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391215AbgAPX3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 549682072E;
        Thu, 16 Jan 2020 23:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217344;
        bh=rZ/4iKaq8uIjgqvRUh+yZFY9mkIMBvDqMhsOuQB+H54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0uMGnyEkDmR4MVZOTtW5Bc0N5fX7gpoyQ+c//x7RrhUWZLiIRtzhkT81Uj8G1aNF
         1e1Cj0N4VpU0I6EMEtu8p0STGKxnDM7UJaKftjtd8Wws+h1iGlZ529Hqy5jee40/tg
         4x3aD/1ZDNK/4ZVijVSpORVh669XFYrEqpGduxS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 45/84] iio: imu: adis16480: assign bias value only if operation succeeded
Date:   Fri, 17 Jan 2020 00:18:19 +0100
Message-Id: <20200116231719.130048158@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

commit 9b742763d9d4195e823ae6ece760c9ed0500c1dc upstream.

This was found only after the whole thing with the inline functions, but
the compiler actually found something. The value of the `bias` (in
adis16480_get_calibbias()) should only be set if the read operation was
successful.

No actual known problem occurs as users of this function all
ultimately check the return value.  Hence probably not stable material.

Fixes: 2f3abe6cbb6c9 ("iio:imu: Add support for the ADIS16480 and similar IMUs")
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/adis16480.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -376,12 +376,14 @@ static int adis16480_get_calibbias(struc
 	case IIO_MAGN:
 	case IIO_PRESSURE:
 		ret = adis_read_reg_16(&st->adis, reg, &val16);
-		*bias = sign_extend32(val16, 15);
+		if (ret == 0)
+			*bias = sign_extend32(val16, 15);
 		break;
 	case IIO_ANGL_VEL:
 	case IIO_ACCEL:
 		ret = adis_read_reg_32(&st->adis, reg, &val32);
-		*bias = sign_extend32(val32, 31);
+		if (ret == 0)
+			*bias = sign_extend32(val32, 31);
 		break;
 	default:
 			ret = -EINVAL;


