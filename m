Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B8138D44C
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhEVHvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhEVHvw (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6E1A611CB;
        Sat, 22 May 2021 07:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669828;
        bh=kch02hiPk/HTceJeCR9Y+N8GL/4CeYR8UEfZrWIAp+4=;
        h=Subject:To:From:Date:From;
        b=jB2dqtxrYbscELcylNgob+EA9f2/VbMTr+/Hw+HJyWHqFrjFm4KKE31MryUEk+sup
         AqHbw13lGpPRZOuKHz5SsyPUY44XVldc0IA041vilO/wcL6R3ojdx50FXVM7dbYkCs
         4SIIyHtLcZYbriIAimKT2vJedTnPyjvuIE+Zi25Q=
Subject: patch "iio: gyro: fxas21002c: balance runtime power in error path" added to staging-linus
To:     rui.silva@linaro.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, mchehab+huawei@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:19 +0200
Message-ID: <16216698197187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: gyro: fxas21002c: balance runtime power in error path

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2a54c8c9ebc2006bf72554afc84ffc67768979a0 Mon Sep 17 00:00:00 2001
From: Rui Miguel Silva <rui.silva@linaro.org>
Date: Wed, 12 May 2021 23:39:29 +0100
Subject: iio: gyro: fxas21002c: balance runtime power in error path

If we fail to read temperature or axis we need to decrement the
runtime pm reference count to trigger autosuspend.

Add the call to pm_put to do that in case of error.

Fixes: a0701b6263ae ("iio: gyro: add core driver for fxas21002c")
Suggested-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Link: https://lore.kernel.org/linux-iio/CBBZA9T1OY9C.2611WSV49DV2G@arch-thunder/
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/gyro/fxas21002c_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/gyro/fxas21002c_core.c b/drivers/iio/gyro/fxas21002c_core.c
index 1a20c6b88e7d..645461c70454 100644
--- a/drivers/iio/gyro/fxas21002c_core.c
+++ b/drivers/iio/gyro/fxas21002c_core.c
@@ -399,6 +399,7 @@ static int fxas21002c_temp_get(struct fxas21002c_data *data, int *val)
 	ret = regmap_field_read(data->regmap_fields[F_TEMP], &temp);
 	if (ret < 0) {
 		dev_err(dev, "failed to read temp: %d\n", ret);
+		fxas21002c_pm_put(data);
 		goto data_unlock;
 	}
 
@@ -432,6 +433,7 @@ static int fxas21002c_axis_get(struct fxas21002c_data *data,
 			       &axis_be, sizeof(axis_be));
 	if (ret < 0) {
 		dev_err(dev, "failed to read axis: %d: %d\n", index, ret);
+		fxas21002c_pm_put(data);
 		goto data_unlock;
 	}
 
-- 
2.31.1


