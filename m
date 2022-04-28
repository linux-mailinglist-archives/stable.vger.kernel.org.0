Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0B513713
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 16:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348501AbiD1Olv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345616AbiD1Olu (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 28 Apr 2022 10:41:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFA89682A
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 07:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68C2EB82DA9
        for <Stable@vger.kernel.org>; Thu, 28 Apr 2022 14:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61C6C385A9;
        Thu, 28 Apr 2022 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651156713;
        bh=YPcZ+Ok/TryZCrLnkwMc2/dhMZ5VweJgAXjGyvHp2Mk=;
        h=Subject:To:From:Date:From;
        b=yPXk1gPuJWeoQZ3n9IBXX0ZhvQJSx/012RHLhbZ2S2gDPgadCbyWzbgJePpSKxyls
         Z/ir2iSxG26mNHCMjUhEb2mZjPHuxFJY3iD1ZRa8Tu/z1OmTYt2Yet/cBm7n4VfUm1
         3xNp47pCKr5ZTd47Hlp8BZH1kxOjRyEdD3F5akKY=
Subject: patch "iio: imu: inv_icm42600: Fix I2C init possible nack" added to char-misc-linus
To:     fawzi.khaber@tdk.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jean-baptiste.maneyrol@tdk.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 Apr 2022 16:37:55 +0200
Message-ID: <1651156675139191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: inv_icm42600: Fix I2C init possible nack

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b5d6ba09b10d2ccb865ed9bc45941db0a41c6756 Mon Sep 17 00:00:00 2001
From: Fawzi Khaber <fawzi.khaber@tdk.com>
Date: Mon, 11 Apr 2022 13:15:33 +0200
Subject: iio: imu: inv_icm42600: Fix I2C init possible nack

This register write to REG_INTF_CONFIG6 enables a spike filter that
is impacting the line and can prevent the I2C ACK to be seen by the
controller. So we don't test the return value.

Fixes: 7297ef1e261672b8 ("iio: imu: inv_icm42600: add I2C driver")
Signed-off-by: Fawzi Khaber <fawzi.khaber@tdk.com>
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20220411111533.5826-1-jmaneyrol@invensense.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
index 33d9afb1ba91..d4a692b838d0 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
@@ -18,12 +18,15 @@ static int inv_icm42600_i2c_bus_setup(struct inv_icm42600_state *st)
 	unsigned int mask, val;
 	int ret;
 
-	/* setup interface registers */
-	ret = regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG6,
-				 INV_ICM42600_INTF_CONFIG6_MASK,
-				 INV_ICM42600_INTF_CONFIG6_I3C_EN);
-	if (ret)
-		return ret;
+	/*
+	 * setup interface registers
+	 * This register write to REG_INTF_CONFIG6 enables a spike filter that
+	 * is impacting the line and can prevent the I2C ACK to be seen by the
+	 * controller. So we don't test the return value.
+	 */
+	regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG6,
+			   INV_ICM42600_INTF_CONFIG6_MASK,
+			   INV_ICM42600_INTF_CONFIG6_I3C_EN);
 
 	ret = regmap_update_bits(st->map, INV_ICM42600_REG_INTF_CONFIG4,
 				 INV_ICM42600_INTF_CONFIG4_I3C_BUS_ONLY, 0);
-- 
2.36.0


