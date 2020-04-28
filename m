Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E231BC825
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgD1S37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729438AbgD1S36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:29:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BDDC208E0;
        Tue, 28 Apr 2020 18:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098597;
        bh=0hifaQ70lRgCF0KppeNRWFQqEOv1Xs9uccMIclWC6eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0Sgfx7223I8w78xfrhJ6oM5yfeBzE0xFnRi9lZIoDOeMevTmVnAJkoVYHKMXGvcS
         8f9EgGGr2tKnJcdOq56jIraSQHwDEhQWQX4BXXj5pv2HKj/isEIKPMEY140mbgrrmQ
         hX/Hz55iwGIiedfRaiTZnqdTKFEp3mP6iCHnkVIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mario Tesi <mario.tesi@st.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Vitor Soares <vitor.soares@synopsys.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 082/167] iio: imu: st_lsm6dsx: flush hw FIFO before resetting the device
Date:   Tue, 28 Apr 2020 20:24:18 +0200
Message-Id: <20200428182235.365728512@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 3a63da26db0a864134f023f088d41deacd509997 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -2036,11 +2036,21 @@ static int st_lsm6dsx_init_hw_timer(stru
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
@@ -2059,6 +2069,18 @@ static int st_lsm6dsx_init_device(struct
 
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


