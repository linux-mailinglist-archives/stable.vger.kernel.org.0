Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C3F141E34
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 14:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgASNdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 08:33:35 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57853 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASNdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 08:33:35 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 152C951A;
        Sun, 19 Jan 2020 08:33:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 08:33:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0bT6E6
        crKSyKeGr8nWuuYv61QNYt14VsoMJrNXWCQkM=; b=uqiOg2rgdJqZDjbU95z+bb
        Q2/5MCiphCZqN/LsMRMyYFKimH7ze5D9X1KOmxcGYtkUcWP/dXX8HYYGLGloq66y
        5Qxr2CrA+uBdafdNtdpEcmUIPWGzOGWIR7HjtxeUBDL8G/Ia/F7l0B6VNDZe1UFn
        Wc3OOgQ1eMQLXJoKf3qVCoza/tpcUSBEmEGEwHQBX9zNEf07ynjlBYJXXwCWKM1U
        bKpUlOg4TvBJwSqWx42lXwfggDABmIXK7kulgtZfzqwtADcfUV5aha7hgNaPbmgC
        39lGq/9XftUajlo88hUqX+DxYVOfDO+ny07ma8Ky2Q2IkMk3lfXVQ+sSSgFxKMAw
        ==
X-ME-Sender: <xms:rFokXp_rHD4o-KAGXIZcYWhRrhhrsieoUO-spvFqb2OcMNgOtL4tZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:rFokXkVGMNK0RCylU2XXyeKN-KPDeRKkAmyjO0XN6JU0rE8ZHQOibg>
    <xmx:rFokXuLWie-FCv746Fjs5QavkqQ5LNI46xmVIKUz85DayYXeMckA1g>
    <xmx:rFokXqZhvjQNW9yrNLdNmQ-Scu_bWz9VLUX5JDej1-NedtQNYI7jOQ>
    <xmx:rVokXjF25jnUoYt8awl0Gx3ulStiYJYPqfgY7qw2kQJhVtIm-go41A>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 616948005A;
        Sun, 19 Jan 2020 08:33:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID" failed to apply to 4.19-stable tree
To:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        gregkh@linuxfoundation.org, lorenzo@kernel.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 14:33:30 +0100
Message-ID: <1579440810243255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

