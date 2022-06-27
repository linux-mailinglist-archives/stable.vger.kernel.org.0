Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D8A55C507
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbiF0L11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbiF0L0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:26:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2DF65A8;
        Mon, 27 Jun 2022 04:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AF78B8111D;
        Mon, 27 Jun 2022 11:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A801C3411D;
        Mon, 27 Jun 2022 11:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329196;
        bh=/OV4TQT7m05Fi0VZVfG2VTpYR5hu8IQh+pTF8a8E0mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZS0VeCB9tqSm9DrOqrKEgbJdtaFh6ufZWoD1CMWG8duXblCRrfA5EKs8pY38zQZWz
         XdMdW7JNTesKKjqn87/HsNRvim+Hx4NzAFiHGweQE0bISaJiDAlMZJ4VhZ0kLdm0ee
         /cSXPk4K7qVx7g75rbpcLTegbvKWu+OI0vfcdFM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 080/102] iio: imu: inv_icm42600: Fix broken icm42600 (chip id 0 value)
Date:   Mon, 27 Jun 2022 13:21:31 +0200
Message-Id: <20220627111935.842264654@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 106b391e1b859100a3f38f0ad874236e9be06bde upstream.

The 0 value used for INV_CHIP_ICM42600 was not working since the
match in i2c/spi was checking against NULL value.

To keep this check, add a first INV_CHIP_INVALID 0 value as safe
guard.

Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20220609102301.4794-1-jmaneyrol@invensense.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600.h      |    1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600.h
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600.h
@@ -17,6 +17,7 @@
 #include "inv_icm42600_buffer.h"
 
 enum inv_icm42600_chip {
+	INV_CHIP_INVALID,
 	INV_CHIP_ICM42600,
 	INV_CHIP_ICM42602,
 	INV_CHIP_ICM42605,
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -565,7 +565,7 @@ int inv_icm42600_core_probe(struct regma
 	bool open_drain;
 	int ret;
 
-	if (chip < 0 || chip >= INV_CHIP_NB) {
+	if (chip <= INV_CHIP_INVALID || chip >= INV_CHIP_NB) {
 		dev_err(dev, "invalid chip = %d\n", chip);
 		return -ENODEV;
 	}


