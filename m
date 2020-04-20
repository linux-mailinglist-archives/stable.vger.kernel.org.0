Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3473A1B08DA
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgDTMJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTMJC (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:09:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8125206F6;
        Mon, 20 Apr 2020 12:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587384541;
        bh=iKf5C19mCtcgeEr+vRNCXNgSlPu9nb2MqiMYvIjUahE=;
        h=Subject:To:From:Date:From;
        b=UdBhlH59HLOO9k/Dedy2thDZPv3ix11Tm2t+CDl51ERw/r6CsO2NApRDBlD3hN480
         iLl7ywNloADi0GFsw3X1FmzQM24aGkZ04y1FfyZI878tgkhFzeorM0+Knw3uSMn2MH
         iebBALsAK6eWBWKuKfjQkSTLgRgItI7OQ9YwVxfw=
Subject: patch "iio: imu: st_lsm6dsx: flush hw FIFO before resetting the device" added to staging-linus
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, mario.tesi@st.com,
        vitor.soares@synopsys.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Apr 2020 14:08:46 +0200
Message-ID: <1587384526195225@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: flush hw FIFO before resetting the device

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3a63da26db0a864134f023f088d41deacd509997 Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 13 Mar 2020 19:06:00 +0100
Subject: iio: imu: st_lsm6dsx: flush hw FIFO before resetting the device

flush hw FIFO before device reset in order to avoid possible races
on interrupt line 1. If the first interrupt line is asserted during
hw reset the device will work in I3C-only mode (if it is supported)

Fixes: 801a6e0af0c6 ("iio: imu: st_lsm6dsx: add support to LSM6DSO")
Fixes: 43901008fde0 ("iio: imu: st_lsm6dsx: add support to LSM6DSR")
Reported-by: Mario Tesi <mario.tesi@st.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Vitor Soares <vitor.soares@synopsys.com>
Tested-by: Vitor Soares <vitor.soares@synopsys.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 24 +++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 84d219ae6aee..4426524b59f2 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2036,11 +2036,21 @@ static int st_lsm6dsx_init_hw_timer(struct st_lsm6dsx_hw *hw)
 	return 0;
 }
 
-static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
+static int st_lsm6dsx_reset_device(struct st_lsm6dsx_hw *hw)
 {
 	const struct st_lsm6dsx_reg *reg;
 	int err;
 
+	/*
+	 * flush hw FIFO before device reset in order to avoid
+	 * possible races on interrupt line 1. If the first interrupt
+	 * line is asserted during hw reset the device will work in
+	 * I3C-only mode (if it is supported)
+	 */
+	err = st_lsm6dsx_flush_fifo(hw);
+	if (err < 0 && err != -ENOTSUPP)
+		return err;
+
 	/* device sw reset */
 	reg = &hw->settings->reset;
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
@@ -2059,6 +2069,18 @@ static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
 
 	msleep(50);
 
+	return 0;
+}
+
+static int st_lsm6dsx_init_device(struct st_lsm6dsx_hw *hw)
+{
+	const struct st_lsm6dsx_reg *reg;
+	int err;
+
+	err = st_lsm6dsx_reset_device(hw);
+	if (err < 0)
+		return err;
+
 	/* enable Block Data Update */
 	reg = &hw->settings->bdu;
 	err = regmap_update_bits(hw->regmap, reg->addr, reg->mask,
-- 
2.26.1


