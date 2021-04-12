Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0635BEBE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238703AbhDLJBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238263AbhDLI5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FE6D6128E;
        Mon, 12 Apr 2021 08:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217807;
        bh=0OJSYjFmcQVR8Y+J6nqu6mWK+cmBCkQ7Sz9Ivf9TdQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4b1aqlJUa3YzThrhTFd840BIqngVhybpXKL7YnIXCICmFx4ncz5f/d8G6RjOf+Gd
         gVb9m0mkrHRKAO/YavQwkGx5saqhgaKAUsugcAx6wPiqBjv0tkx59f/n7UEgWTGj2T
         2bUbQZWdfAhOmvQ5FQ21R+PoZFAFIQDGA9ZftS5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/188] i2c: designware: Adjust bus_freq_hz when refuse high speed mode set
Date:   Mon, 12 Apr 2021 10:41:07 +0200
Message-Id: <20210412084018.709994647@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e729bc54bda705f64941008b018b4e41a4322bf ]

When hardware doesn't support High Speed Mode, we forget bus_freq_hz
timing adjustment. This makes the timings and real registers being
unsynchronized. Adjust bus_freq_hz when refuse high speed mode set.

Fixes: b6e67145f149 ("i2c: designware: Enable high speed mode")
Reported-by: "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index d6425ad6e6a3..2871cf2ee8b4 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -129,6 +129,7 @@ static int i2c_dw_set_timings_master(struct dw_i2c_dev *dev)
 		if ((comp_param1 & DW_IC_COMP_PARAM_1_SPEED_MODE_MASK)
 			!= DW_IC_COMP_PARAM_1_SPEED_MODE_HIGH) {
 			dev_err(dev->dev, "High Speed not supported!\n");
+			t->bus_freq_hz = I2C_MAX_FAST_MODE_FREQ;
 			dev->master_cfg &= ~DW_IC_CON_SPEED_MASK;
 			dev->master_cfg |= DW_IC_CON_SPEED_FAST;
 			dev->hs_hcnt = 0;
-- 
2.30.2



