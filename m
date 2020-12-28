Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030E52E3F03
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504783AbgL1Ocn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504777AbgL1Ocm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC3E0207B2;
        Mon, 28 Dec 2020 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165947;
        bh=K24iJRIX4DRU9kl3rbz/XpvapenhOV22LKkXKlb/PJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+CNjFyBO/uuWMs4wwStOlEAEHE0jyc+erJriEuVOYObsh05dn8WnJ+jRfw9rFsjn
         YCDEqP/E6SJ2M1Q6bBBIQGd3dGVSz7GAN5IPlcKgDysoS2BHxD0wKwhUaopa62PFTt
         xkMgHvK/jO7yTyUbRdIUBgHF4ty1W2HOk69GCk78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Daniel Baluta <daniel.baluta@oss.nxp.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.10 681/717] iio:imu:bmi160: Fix too large a buffer.
Date:   Mon, 28 Dec 2020 13:51:19 +0100
Message-Id: <20201228125053.607081381@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/bmi160/bmi160_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -427,8 +427,8 @@ static irqreturn_t bmi160_trigger_handle
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct bmi160_data *data = iio_priv(indio_dev);
-	__le16 buf[16];
-	/* 3 sens x 3 axis x __le16 + 3 x __le16 pad + 4 x __le16 tstamp */
+	__le16 buf[12];
+	/* 2 sens x 3 axis x __le16 + 2 x __le16 pad + 4 x __le16 tstamp */
 	int i, ret, j = 0, base = BMI160_REG_DATA_MAGN_XOUT_L;
 	__le16 sample;
 


