Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E776C639B48
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiK0ONY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiK0ONV (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:13:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7501165
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:13:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E059E60C98
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F87C433C1;
        Sun, 27 Nov 2022 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558400;
        bh=86HdCjVKhDrUHobAwuohigEoJWHc+ZtjNDCv90PZoTs=;
        h=Subject:To:From:Date:From;
        b=SfPXRXXJtEuuI/ZMA0xt2N0b+p7CJPXc7BvfIlIyiuTEVUgAnEKu84tO3zlkoILzG
         QDoRxJizQp6xpAttxfpK7cuyRFpKlBV4sGpQIreK9lfqaenQINI/BGb+FfWkK/P0Qd
         6D5aopOMiHOasx6YubDtxYj9Nr7uPwTsbFGpmkg4=
Subject: patch "iio: accel: bma400: Fix memory leak in bma400_get_steps_reg()" added to char-misc-next
To:     dongchenchen2@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jagathjog1996@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 15:06:09 +0100
Message-ID: <1669557969135241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: bma400: Fix memory leak in bma400_get_steps_reg()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 20690cd50e68c0313472c7539460168b8ea6444d Mon Sep 17 00:00:00 2001
From: Dong Chenchen <dongchenchen2@huawei.com>
Date: Thu, 10 Nov 2022 09:07:26 +0800
Subject: iio: accel: bma400: Fix memory leak in bma400_get_steps_reg()

When regmap_bulk_read() fails, it does not free steps_raw,
which will cause a memory leak issue, this patch fixes it.

Fixes: d221de60eee3 ("iio: accel: bma400: Add separate channel for step counter")
Signed-off-by: Dong Chenchen <dongchenchen2@huawei.com>
Reviewed-by: Jagath Jog J <jagathjog1996@gmail.com>
Link: https://lore.kernel.org/r/20221110010726.235601-1-dongchenchen2@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/bma400_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bma400_core.c b/drivers/iio/accel/bma400_core.c
index 490c342ef72a..6e4d10a7cd32 100644
--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -805,8 +805,10 @@ static int bma400_get_steps_reg(struct bma400_data *data, int *val)
 
 	ret = regmap_bulk_read(data->regmap, BMA400_STEP_CNT0_REG,
 			       steps_raw, BMA400_STEP_RAW_LEN);
-	if (ret)
+	if (ret) {
+		kfree(steps_raw);
 		return ret;
+	}
 	*val = get_unaligned_le24(steps_raw);
 	kfree(steps_raw);
 	return IIO_VAL_INT;
-- 
2.38.1


