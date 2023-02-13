Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B771A6949F0
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjBMPD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjBMPDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:03:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46511C7DA
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:02:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9495C61158
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55F9C433D2;
        Mon, 13 Feb 2023 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300571;
        bh=amPiSJfm8e7IixX6HmpAH1wtZAE3/roE0VOFRzwiUEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmJVXUJ4UnmTgfM7dw+KDvQf7owTJ7vLcMxrTeXttOKNyQOIL/UQ/egICGI8XwYSL
         hfQOqnsfjrLsbzuEEQNIeIyPnq3F6/1qBK4B2EPk8wh+4QtKyc5TVsMqnKFD64NP4y
         C07EwIgcT4bRW8kXOTFwM/XUoONnquQyzlT7oTrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Carlos Song <carlos.song@nxp.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 064/139] iio: imu: fxos8700: fix incomplete ACCEL and MAGN channels readback
Date:   Mon, 13 Feb 2023 15:50:09 +0100
Message-Id: <20230213144749.143225589@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Song <carlos.song@nxp.com>

commit 37a94d86d7050665d6d01378b2c916c28e454f10 upstream.

The length of ACCEL and MAGN 3-axis channels output data is 6 byte
individually. However block only read 3 bytes data into buffer from
ACCEL or MAGN output data registers every time. It causes an incomplete
ACCEL and MAGN channels readback.

Set correct value count for regmap_bulk_read to get 6 bytes ACCEL and
MAGN channels readback.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-4-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -425,7 +425,7 @@ static int fxos8700_get_data(struct fxos
 
 	/* Block read 6 bytes of device output registers to avoid data loss */
 	ret = regmap_bulk_read(data->regmap, base, data->buf,
-			       FXOS8700_DATA_BUF_SIZE);
+			       sizeof(data->buf));
 	if (ret)
 		return ret;
 


