Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC6D2ED1D1
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbhAGORm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:17:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbhAGORm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:17:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FAD623370;
        Thu,  7 Jan 2021 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029037;
        bh=RswBtloHKf83Hfz4px9bTxlFkA2ersMvDiSVW2cCW6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vltmnBLRPopRxnHUs6n9VTscu5AzZkjzBrBs54+0B3Iefy6u6d1+yjiB0yVJko/+O
         3fSSgY+XVPDMVd/9hzQ92Cx26qwE4rax3XCA7qfrX8gb9qW64XHV7Bl+IHFHaFL8eL
         l3w5Y1SRBfK7mBEc8e7cMOZwrsAe+TKey+I50+Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Daniel Baluta <daniel.baluta@oss.nxp.com>,
        Stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 30/32] iio:imu:bmi160: Fix too large a buffer.
Date:   Thu,  7 Jan 2021 15:16:50 +0100
Message-Id: <20210107140829.292483134@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit dc7de42d6b50a07b37feeba4c6b5136290fcee81 upstream.

The comment implies this device has 3 sensor types, but it only
has an accelerometer and a gyroscope (both 3D).  As such the
buffer does not need to be as long as stated.

Note I've separated this from the following patch which fixes
the alignment for passing to iio_push_to_buffers_with_timestamp()
as they are different issues even if they affect the same line
of code.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Daniel Baluta <daniel.baluta@oss.nxp.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-5-jic23@kernel.org
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bmi160/bmi160_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -385,8 +385,8 @@ static irqreturn_t bmi160_trigger_handle
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[16];
-	/* 3 sens x 3 axis x __le16 + 3 x __le16 pad + 4 x __le16 tstamp */
+	__le16 buf[12];
+	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 


