Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE9141E39
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgASNdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:33:44 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:43287 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727011AbgASNdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 08:33:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9FEDF539;
        Sun, 19 Jan 2020 08:33:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lFWWfc
        IabuhPOIlXdHQrBS6/VzwiJQ5Xn/+0ynUQTkA=; b=s82yCBcyyaTvxFMunBo0+E
        FF0xpIU3FrXmBSmttydSzHHLn4TqxyQQbIDTnYvvPyG8Qs4vGWNMq3U5WkMo5PHc
        TP+uKkcc4f17TPX4a6vgXoZAenF2iGtaL+mhKBpl7D+CjL4+jwEPnO9mvBVwklSA
        rqCPQauFy+o1BKMh4UHtgYGt6qA2zG9tKA4mbEUxM2ZTGBi7xbnMug+jC3cN3VG2
        BBCXSZiTrfj6ElK2fZN6CvRx/Zx+QwbMNrhDnIkQ4+BoFz/3cKdZyt8MoUrzqQR6
        5IW5pLUAV0vwwrL8xMWZE1asjn0/9HlonyCi6SgM2hKF8gSfffnW2OBJ6FkDfU9Q
        ==
X-ME-Sender: <xms:t1okXlaUxx9qRvyPpHx6KHXsMCoJN_3K_KbM61myGMZrQLs3a0XbvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:t1okXnUDh1o7dUSDp5LEINkcXCCOfSE1Tk8_CIdZFtbr9KABH4pvHw>
    <xmx:t1okXql8itebmAxb_nGsbs3xLYFVMEtZ34WWKRzdse3fT2R5Q-Y5fw>
    <xmx:t1okXiaec77rtYRk605mW43X_abgQivOCQppbfIlVp-UIGNuzKzsQQ>
    <xmx:t1okXi3b8vwfaPB_RQNaiACK1eH3ZFi2XLuC-uFhci2_3A_KMXlnag>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id B633130607B4;
        Sun, 19 Jan 2020 08:33:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID" failed to apply to 4.14-stable tree
To:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        gregkh@linuxfoundation.org, lorenzo@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:33:32 +0100
Message-ID: <157944081220070@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fb4fbc8904e786537e29329d791147389e1465a2 Mon Sep 17 00:00:00 2001
From: Stephan Gerhold <stephan@gerhold.net>
Date: Mon, 16 Dec 2019 13:41:20 +0100
Subject: [PATCH] iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID

At the moment, attempting to probe a device with ST_LSM6DS3_ID
(e.g. using the st,lsm6ds3 compatible) fails with:

    st_lsm6dsx_i2c 1-006b: unsupported whoami [69]

... even though 0x69 is the whoami listed for ST_LSM6DS3_ID.

This happens because st_lsm6dsx_check_whoami() also attempts
to match unspecified (zero-initialized) entries in the "id" array.
ST_LSM6DS3_ID = 0 will therefore match any entry in
st_lsm6dsx_sensor_settings (here: the first), because none of them
actually have all 12 entries listed in the "id" array.

Avoid this by additionally checking if "name" is set,
which is only set for valid entries in the "id" array.

Note: Although the problem was introduced earlier it did not surface until
commit 52f4b1f19679 ("iio: imu: st_lsm6dsx: add support for accel/gyro unit of lsm9ds1")
because ST_LSM6DS3_ID was the first entry in st_lsm6dsx_sensor_settings.

Fixes: d068e4a0f921 ("iio: imu: st_lsm6dsx: add support to multiple devices with the same settings")
Cc: <stable@vger.kernel.org> # 5.4
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index a7d40c02ce6b..b921dd9e108f 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1301,7 +1301,8 @@ static int st_lsm6dsx_check_whoami(struct st_lsm6dsx_hw *hw, int id,
 
 	for (i = 0; i < ARRAY_SIZE(st_lsm6dsx_sensor_settings); i++) {
 		for (j = 0; j < ST_LSM6DSX_MAX_ID; j++) {
-			if (id == st_lsm6dsx_sensor_settings[i].id[j].hw_id)
+			if (st_lsm6dsx_sensor_settings[i].id[j].name &&
+			    id == st_lsm6dsx_sensor_settings[i].id[j].hw_id)
 				break;
 		}
 		if (j < ST_LSM6DSX_MAX_ID)

