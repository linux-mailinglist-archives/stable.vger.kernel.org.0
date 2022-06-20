Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9AF5511DD
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiFTHwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239605AbiFTHwB (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:52:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938C41055E
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 457D2B80EB4
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCA2C341C4;
        Mon, 20 Jun 2022 07:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711517;
        bh=E+0xyzPlvX+5cvxFPw9DfVpYbT8idmR5SrDm50p8Bmo=;
        h=Subject:To:From:Date:From;
        b=oOh+eRRX0qpCUmPG7XUPwu3cWWl8bka5+2nk5XmyaQUqCY6ZhnN/kvFMzj7JTe9/p
         SNzUBlMfiZ6h3zQbSP9fZiDf+yCryoOfKh/ISvtlHgL+J7mDrK9fDj9I0HVd6Xht1n
         GJnUqmJuGIwKelIISS5b5qE119U1okSF9aJUtB7c=
Subject: patch "iio: accel: mma8452: ignore the return value of reset operation" added to char-misc-linus
To:     haibo.chen@nxp.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hdegoede@redhat.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:51 +0200
Message-ID: <165571145112385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: mma8452: ignore the return value of reset operation

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bf745142cc0a3e1723f9207fb0c073c88464b7b4 Mon Sep 17 00:00:00 2001
From: Haibo Chen <haibo.chen@nxp.com>
Date: Wed, 15 Jun 2022 19:31:58 +0800
Subject: iio: accel: mma8452: ignore the return value of reset operation

On fxls8471, after set the reset bit, the device will reset immediately,
will not give ACK. So ignore the return value of this reset operation,
let the following code logic to check whether the reset operation works.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Fixes: ecabae713196 ("iio: mma8452: Initialise before activating")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/1655292718-14287-1-git-send-email-haibo.chen@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/mma8452.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 4156d216c640..f4f835274d75 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1510,10 +1510,14 @@ static int mma8452_reset(struct i2c_client *client)
 	int i;
 	int ret;
 
-	ret = i2c_smbus_write_byte_data(client,	MMA8452_CTRL_REG2,
+	/*
+	 * Find on fxls8471, after config reset bit, it reset immediately,
+	 * and will not give ACK, so here do not check the return value.
+	 * The following code will read the reset register, and check whether
+	 * this reset works.
+	 */
+	i2c_smbus_write_byte_data(client, MMA8452_CTRL_REG2,
 					MMA8452_CTRL_REG2_RST);
-	if (ret < 0)
-		return ret;
 
 	for (i = 0; i < 10; i++) {
 		usleep_range(100, 200);
-- 
2.36.1


