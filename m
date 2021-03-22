Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3EA344461
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhCVM7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233181AbhCVM5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:57:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63811619DF;
        Mon, 22 Mar 2021 12:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417379;
        bh=5sppupOWfMhTGCdAJeoS+79+ZmNuabC4TOrs9JOgtdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnHyflegLncNjqUnopwK4kLeg7nyer/oFc3g9nu1F9ie0AQ5s9CfWkY/JF/Q0gqho
         45tnBboe28H9i7BaVeM+PNbcfnQeKTPrJKJWnhIUmKe8/YkOpYWwlpFpq9DWks7a+P
         ITIjudLxKNRUlq8/90UELD3A7Uh1MP/3yzSi7oMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 29/43] iio: adis16400: Fix an error code in adis16400_initial_setup()
Date:   Mon, 22 Mar 2021 13:29:10 +0100
Message-Id: <20210322121920.966074505@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a71266e454b5df10d019b06f5ebacd579f76be28 upstream.

This is to silence a new Smatch warning:

    drivers/iio/imu/adis16400.c:492 adis16400_initial_setup()
    warn: sscanf doesn't return error codes

If the condition "if (st->variant->flags & ADIS16400_HAS_SLOW_MODE) {"
is false then we return 1 instead of returning 0 and probe will fail.

Fixes: 72a868b38bdd ("iio: imu: check sscanf return value")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YCwgFb3JVG6qrlQ+@mwanda
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/adis16400_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/imu/adis16400_core.c
+++ b/drivers/iio/imu/adis16400_core.c
@@ -288,8 +288,7 @@ static int adis16400_initial_setup(struc
 		if (ret)
 			goto err_ret;
 
-		ret = sscanf(indio_dev->name, "adis%u\n", &device_id);
-		if (ret != 1) {
+		if (sscanf(indio_dev->name, "adis%u\n", &device_id) != 1) {
 			ret = -EINVAL;
 			goto err_ret;
 		}


