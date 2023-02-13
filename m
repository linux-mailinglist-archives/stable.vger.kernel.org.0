Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CEA694A1E
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjBMPEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjBMPEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:04:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D723C1DB8D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:04:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F127610A4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72572C433D2;
        Mon, 13 Feb 2023 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300673;
        bh=7Zh6+6uu1xARXr1+iq9wDoel6vMURA8Hu632DijSVJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3IGas7tJcAUAQX7nrSrihSB/VZYWRAqpRz7Bfw28f/95MhWDQOAVEGDWK2I7Mxeg
         0XhoyF72i6h4yDweL7kSkG6BHSU6kfKVWsQfEThuLHSfn93q33gHUibHInSIs26Nvp
         SpiGUsfeaHZ9gsPq1wJpd1qshyVS86vTg8qZBaws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Carlos Song <carlos.song@nxp.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 066/139] iio: imu: fxos8700: fix map label of channel type to MAGN sensor
Date:   Mon, 13 Feb 2023 15:50:11 +0100
Message-Id: <20230213144749.264293810@linuxfoundation.org>
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

commit 429e1e8ec696e0e7a0742904e3dc2f83b7b23dfb upstream.

FXOS8700 is an IMU sensor with ACCEL sensor and MAGN sensor.
Sensor type is indexed by corresponding channel type in a switch.
IIO_ANGL_VEL channel type mapped to MAGN sensor has caused confusion.

Fix the mapping label of "IIO_MAGN" channel type instead of
"IIO_ANGL_VEL" channel type to MAGN sensor.

Fixes: 84e5ddd5c46e ("iio: imu: Add support for the FXOS8700 IMU")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://lore.kernel.org/r/20221208071911.2405922-2-carlos.song@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/fxos8700_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/fxos8700_core.c
+++ b/drivers/iio/imu/fxos8700_core.c
@@ -320,7 +320,7 @@ static enum fxos8700_sensor fxos8700_to_
 	switch (iio_type) {
 	case IIO_ACCEL:
 		return FXOS8700_ACCEL;
-	case IIO_ANGL_VEL:
+	case IIO_MAGN:
 		return FXOS8700_MAGN;
 	default:
 		return -EINVAL;


