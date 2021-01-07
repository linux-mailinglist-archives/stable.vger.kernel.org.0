Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099142ED1AC
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbhAGORo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbhAGORn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34FAA23380;
        Thu,  7 Jan 2021 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029043;
        bh=jsidkiqeYSJhkvdwoYt9lcgToJlmPuu58iUDlQsq4Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNBXkXCUK5E0KXgHwWEmKGDRXTRJOmyktVrsm22p7U2Qi8QKzDjzMgjmwkPMVxcyf
         zrJ2V5tVMDCDrMUH0LnFLTfuuuTmg4x0OCMH8kgOK9ZimuTKciC1K6NNov9nwPKara
         TzFkRbEnJ5NC1hmLr1MXV9hCOJKo44ZZX+QUslNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, sayli karnik <karniksayli1995@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 29/32] iio: bmi160_core: Fix sparse warning due to incorrect type in assignment
Date:   Thu,  7 Jan 2021 15:16:49 +0100
Message-Id: <20210107140829.249633179@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.866214702@linuxfoundation.org>
References: <20210107140827.866214702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: sayli karnik <karniksayli1995@gmail.com>

commit dd4ba3fb22233e69f06399ee0aa7ecb11d2b595c upstream

There is a type mismatch between the buffer which is of type s16 and the
samples stored, which are declared as __le16.

Fix the following sparse warning:
drivers/iio/imu/bmi160/bmi160_core.c:411:26: warning: incorrect type
in assignment (different base types)

drivers/iio/imu/bmi160/bmi160_core.c:411:26: expected signed short
[signed] [short] [explicitly-signed] <noident>
drivers/iio/imu/bmi160/bmi160_core.c:411:26: got restricted __le16
[addressable] [usertype] sample

This is a cosmetic-type patch since it does not alter code behaviour.
The le16 is going into a 16bit buf element, and is labelled as IIO_LE in the
channel buffer definition.

Signed-off-by: sayli karnik <karniksayli1995@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bmi160/bmi160_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -385,7 +385,8 @@ static irqreturn_t bmi160_trigger_handle
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	s16 buf[16]; /* 3 sens x 3 axis x s16 + 3 x s16 pad + 4 x s16 tstamp */
+	__le16 buf[16];
+	/* 3 sens x 3 axis x __le16 + 3 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 


