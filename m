Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AAF51A8E7
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355837AbiEDRNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356803AbiEDRJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EAC1E3F5;
        Wed,  4 May 2022 09:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE1F761851;
        Wed,  4 May 2022 16:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436CAC385AA;
        Wed,  4 May 2022 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683342;
        bh=T3taqKNS4GW6ujjq9vOvlKK0jXWPRH8z2xtSBaw/epo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdkjBie8o9iDFYlddVxGc4bXrG4q6sheQjmKaNOKLnZoQEjNcTE0WnZDs6xagwZzf
         OV3JC9noA/z9+JXNwRpQa15ovJGV+ZKDQI+u6qQm5Hioze9Val9j996tZIwIrkpS7K
         s9G+Za1jnaOljYR7e0l1VRrYMVMaHI+1XIxG2p7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fawzi Khaber <fawzi.khaber@tdk.com>,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.17 017/225] iio: imu: inv_icm42600: Fix I2C init possible nack
Date:   Wed,  4 May 2022 18:44:15 +0200
Message-Id: <20220504153111.812343287@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Fawzi Khaber <fawzi.khaber@tdk.com>

commit b5d6ba09b10d2ccb865ed9bc45941db0a41c6756 upstream.

This register write to REG_INTF_CONFIG6 enables a spike filter that
is impacting the line and can prevent the I2C ACK to be seen by the
controller. So we don't test the return value.

Fixes: 7297ef1e261672b8 ("iio: imu: inv_icm42600: add I2C driver")
Signed-off-by: Fawzi Khaber <fawzi.khaber@tdk.com>
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20220411111533.5826-1-jmaneyrol@invensense.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_i2c.c
@@ -18,12 +18,15 @@ static int inv_icm42600_i2c_bus_setup(st
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


