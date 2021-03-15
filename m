Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BA133C00D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhCOPgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233358AbhCOPfj (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C3EB64E64;
        Mon, 15 Mar 2021 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822538;
        bh=QldZ6OLLsdgSmWeuxCzaIL/gSc5qhDwNJ9GsDKQ1c5c=;
        h=Subject:To:From:Date:From;
        b=V7N0c4wZiAC44F89HIAlRTs/ZCuNmWcSxQk051nifyAaplPlzPizjEso1RTsaAfLZ
         LjYN2bQVcnZM3l3zz5Bfuw6vDO2V8QTz6vYwrKrB2us+KWepsZZKbMPd6wJ3P33ufl
         19Fx8XJJlOaMR7qJVxbM5RpvnhzfqJ81TlwjDyoI=
Subject: patch "iio: adis16400: Fix an error code in adis16400_initial_setup()" added to staging-linus
To:     dan.carpenter@oracle.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:23 +0100
Message-ID: <161582252366237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adis16400: Fix an error code in adis16400_initial_setup()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a71266e454b5df10d019b06f5ebacd579f76be28 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 16 Feb 2021 22:42:13 +0300
Subject: iio: adis16400: Fix an error code in adis16400_initial_setup()

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
---
 drivers/iio/imu/adis16400.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/imu/adis16400.c b/drivers/iio/imu/adis16400.c
index 54af2ed664f6..785a4ce606d8 100644
--- a/drivers/iio/imu/adis16400.c
+++ b/drivers/iio/imu/adis16400.c
@@ -462,8 +462,7 @@ static int adis16400_initial_setup(struct iio_dev *indio_dev)
 		if (ret)
 			goto err_ret;
 
-		ret = sscanf(indio_dev->name, "adis%u\n", &device_id);
-		if (ret != 1) {
+		if (sscanf(indio_dev->name, "adis%u\n", &device_id) != 1) {
 			ret = -EINVAL;
 			goto err_ret;
 		}
-- 
2.30.2


