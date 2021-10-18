Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8995431E58
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhJROA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234620AbhJRN6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E3BD61A35;
        Mon, 18 Oct 2021 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564487;
        bh=woakGkc7RD5Tlnj94w8maMjglj3qeTr2P5jmvvbKFtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFcz7DZlMJYWWv1md5/aQ+eyFId6Iwo7nT6ltg0QNtexoxwLDVOV1W+fXKB5UdPnn
         iAEZVvIVv5LzKQQ9W7Ow5mRIcNXaNsxbZa4IOsWmtatTKJ77rSFUVCSxyRZOZIGolC
         iWvWWoiFb8ISjJ5Yi+zBI81B2jlZot9a6DPCyHgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 074/151] iio: adis16475: fix deadlock on frequency set
Date:   Mon, 18 Oct 2021 15:24:13 +0200
Message-Id: <20211018132343.097628795@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit 9da1b86865ab4376408c58cd9fec332c8bdb5c73 upstream.

With commit 39c024b51b560
("iio: adis16475: improve sync scale mode handling"), two deadlocks were
introduced:
 1) The call to 'adis_write_reg_16()' was not changed to it's unlocked
    version.
 2) The lock was not being released on the success path of the function.

This change fixes both these issues.

Fixes: 39c024b51b560 ("iio: adis16475: improve sync scale mode handling")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20210920090047.74903-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16475.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16475.c
+++ b/drivers/iio/imu/adis16475.c
@@ -353,10 +353,11 @@ static int adis16475_set_freq(struct adi
 	if (dec > st->info->max_dec)
 		dec = st->info->max_dec;
 
-	ret = adis_write_reg_16(&st->adis, ADIS16475_REG_DEC_RATE, dec);
+	ret = __adis_write_reg_16(&st->adis, ADIS16475_REG_DEC_RATE, dec);
 	if (ret)
 		goto error;
 
+	adis_dev_unlock(&st->adis);
 	/*
 	 * If decimation is used, then gyro and accel data will have meaningful
 	 * bits on the LSB registers. This info is used on the trigger handler.


