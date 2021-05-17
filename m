Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABA938358C
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242483AbhEQPXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243132AbhEQPRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:17:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1E3D61C67;
        Mon, 17 May 2021 14:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261998;
        bh=5a0i6618Sf3aj//L1ZmO2dcxrnJP/ZYs+X1dx/dkXyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgpgPQgPJfUrob2OWCrv7DSx19oGeaUDJUt2YNsJMD4Y0zGxNi6zDcoGf2OtYE99G
         bkgUFbjufUu3l9H8n0ma6e3KcM4mQcH7gAA8QhpKqWd0kgB6Samos5xkvmoO08WK7w
         S/w5Gvnx7zQvlmknAJLhvn2pMcfcsot7UoHEM51U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 122/141] iio: tsl2583: Fix division by a zero lux_val
Date:   Mon, 17 May 2021 16:02:54 +0200
Message-Id: <20210517140246.911066330@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit af0e1871d79cfbb91f732d2c6fa7558e45c31038 upstream.

The lux_val returned from tsl2583_get_lux can potentially be zero,
so check for this to avoid a division by zero and an overflowed
gain_trim_val.

Fixes clang scan-build warning:

drivers/iio/light/tsl2583.c:345:40: warning: Either the
condition 'lux_val<0' is redundant or there is division
by zero at line 345. [zerodivcond]

Fixes: ac4f6eee8fe8 ("staging: iio: TAOS tsl258x: Device driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2583.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -341,6 +341,14 @@ static int tsl2583_als_calibrate(struct
 		return lux_val;
 	}
 
+	/* Avoid division by zero of lux_value later on */
+	if (lux_val == 0) {
+		dev_err(&chip->client->dev,
+			"%s: lux_val of 0 will produce out of range trim_value\n",
+			__func__);
+		return -ENODATA;
+	}
+
 	gain_trim_val = (unsigned int)(((chip->als_settings.als_cal_target)
 			* chip->als_settings.als_gain_trim) / lux_val);
 	if ((gain_trim_val < 250) || (gain_trim_val > 4000)) {


