Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF654C6306
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 07:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiB1GgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 01:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiB1Gf7 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 28 Feb 2022 01:35:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FED66C8C
        for <Stable@vger.kernel.org>; Sun, 27 Feb 2022 22:35:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3669260FD3
        for <Stable@vger.kernel.org>; Mon, 28 Feb 2022 06:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A383C340E7;
        Mon, 28 Feb 2022 06:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646030120;
        bh=Y77DzzqupthNOMP463L1rrIlNrrD+PPQatkLk3E/wEE=;
        h=Subject:To:Cc:From:Date:From;
        b=vma7yG8zKtKN6jOXS6rPw5Plep7vIsoEPJq8KgfLoAhn90ctiK1Ch1+5upf7omYGY
         U+vpcUvhPIduxHyvvdXqPN/d3P7FYczN94LZ6ngHlzLJsuqkdmghnEyaG4r1u0DXOm
         nnhbfuOf+Ll+Ge31EFQaRNEmopGKNxkcMd5e8cHo=
Subject: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: wait for settling time in" failed to apply to 5.4-stable tree
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, mario.tesi@st.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 07:35:15 +0100
Message-ID: <164603011559195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ea85bf906466191b58532bb19f4fbb4591f0a77e Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sat, 5 Feb 2022 22:57:42 +0100
Subject: [PATCH] iio: imu: st_lsm6dsx: wait for settling time in
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

