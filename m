Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8939DF7F54
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKKSca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbfKKSc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:32:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0FA9222BD;
        Mon, 11 Nov 2019 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497146;
        bh=jlnTzvoyGLFnWfdd3rhWLJ0o0stvG4YQ6aaLNBAKQag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14JLI1To+hW8c+9lT/jMAi9QJk1ZhTm/PJmjPCUkKlNvxES9wLvHNA1LjfxA5T2fJ
         UmJ/Keq2ue3VAZ8G20K7ZoXieMKmg98HYJ8bisjEEOJBp1mSUD7MWz8dyh+Kthpu+5
         E3Nc6FT5Qij05y5av7gTfHqlF1Trb/SXOBl77p50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 19/65] iio: imu: adis16480: make sure provided frequency is positive
Date:   Mon, 11 Nov 2019 19:28:19 +0100
Message-Id: <20191111181344.575619117@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

commit 24e1eb5c0d78cfb9750b690bbe997d4d59170258 upstream.

It could happen that either `val` or `val2` [provided from userspace] is
negative. In that case the computed frequency could get a weird value.

Fix this by checking that neither of the 2 variables is negative, and check
that the computed result is not-zero.

Fixes: e4f959390178 ("iio: imu: adis16480 switch sampling frequency attr to core support")
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/adis16480.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -266,8 +266,11 @@ static int adis16480_set_freq(struct iio
 	struct adis16480 *st = iio_priv(indio_dev);
 	unsigned int t;
 
+	if (val < 0 || val2 < 0)
+		return -EINVAL;
+
 	t =  val * 1000 + val2 / 1000;
-	if (t <= 0)
+	if (t == 0)
 		return -EINVAL;
 
 	t = 2460000 / t;


