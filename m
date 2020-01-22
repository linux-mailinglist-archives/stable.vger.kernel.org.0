Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41DCD1451E5
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgAVJ5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:57:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729559AbgAVJbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:31:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860F82467B;
        Wed, 22 Jan 2020 09:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685471;
        bh=P7rZRElKkOwxcczbNkXYkerQ7t32gQFeDOJWyqJPqGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJ5EjTJYSr2VjWmbKw5uo2JJ09UpShKCx7+gnab8nK0q7vFyZ4bqOySXYQsqtfPm8
         wen+dwv0sj9jG18VO8GCLj0qqYesGqocdTdvWKe3UzZeC0xvEhA8uady2gydo6OhZj
         Bko+2hjwhQ7LyUEOd5QC1RBAPFf5r7ocsgd8dSBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.4 27/76] iio: imu: adis16480: assign bias value only if operation succeeded
Date:   Wed, 22 Jan 2020 10:28:43 +0100
Message-Id: <20200122092754.514655086@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
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
@@ -372,12 +372,14 @@ static int adis16480_get_calibbias(struc
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


