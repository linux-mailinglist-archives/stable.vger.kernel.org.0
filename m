Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581FA4BE356
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352119AbiBUQ7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:59:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350922AbiBUQ7f (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 21 Feb 2022 11:59:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E320522BCE
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 08:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83FCFB815A6
        for <Stable@vger.kernel.org>; Mon, 21 Feb 2022 16:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FB3C340F1;
        Mon, 21 Feb 2022 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645462749;
        bh=sfk+ICcuXtOwICd6Frqb9J3SAU7w3HnAfkkbkkh6Hf0=;
        h=Subject:To:From:Date:From;
        b=E0rOiQg+KLrXYxG9qKm8f25sS7ZQFVKdTiFv3rsOPs9YBZbM5byUaiAifNW4xRli4
         oEvY1P6vYxgexfJUrqh9GfB1bHt6Z93iUeY4b4XiJPfoht45YhHdNZHC6iunOH/VzT
         JyjwjaCz3yWiQB07KW/5amvUUtP4OkNYUpFFl02k=
Subject: patch "iio: imu: st_lsm6dsx: wait for settling time in" added to char-misc-linus
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, mario.tesi@st.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Feb 2022 17:58:44 +0100
Message-ID: <16454627241015@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: wait for settling time in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ea85bf906466191b58532bb19f4fbb4591f0a77e Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 5 Feb 2022 22:57:42 +0100
Subject: iio: imu: st_lsm6dsx: wait for settling time in
 st_lsm6dsx_read_oneshot

We need to wait for sensor settling time (~ 3/ODR) before reading data
in st_lsm6dsx_read_oneshot routine in order to avoid corrupted samples.

Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Reported-by: Mario Tesi <mario.tesi@st.com>
Tested-by: Mario Tesi <mario.tesi@st.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/b41ebda5535895298716c76d939f9f165fcd2d13.1644098120.git.lorenzo@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 727b4b6ac696..93f0c6bce502 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1374,8 +1374,12 @@ static int st_lsm6dsx_read_oneshot(struct st_lsm6dsx_sensor *sensor,
 	if (err < 0)
 		return err;
 
+	/*
+	 * we need to wait for sensor settling time before
+	 * reading data in order to avoid corrupted samples
+	 */
 	delay = 1000000000 / sensor->odr;
-	usleep_range(delay, 2 * delay);
+	usleep_range(3 * delay, 4 * delay);
 
 	err = st_lsm6dsx_read_locked(hw, addr, &data, sizeof(data));
 	if (err < 0)
-- 
2.35.1


