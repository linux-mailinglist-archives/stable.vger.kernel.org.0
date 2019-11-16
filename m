Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD95FF090
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfKPQGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbfKPPuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:50:46 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F45020729;
        Sat, 16 Nov 2019 15:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919445;
        bh=gZtgvh8qFeJ0rwP1uNVOTHy9jivYcPY13ibJR/gnb4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EON9I6ddyOSiwpPweBV8wEt2ZEIj3j/Uov9zDl/q7oCSh96B9NmKY4v/IUq6cUW3H
         nkkRlCaUzQrjDa9AZYBDcyljxWblz11KHAcXchUOQRC8Mgk3A2wvUHy23yS7uXhZmV
         kkC+qnMBwAKm1cxL/LiGqiRCpHUe5AMML7sU0yPA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 144/150] pinctrl: zynq: Use define directive for PIN_CONFIG_IO_STANDARD
Date:   Sat, 16 Nov 2019 10:47:22 -0500
Message-Id: <20191116154729.9573-144-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit cd8a145a066a1a3beb0ae615c7cb2ee4217418d7 ]

Clang warns when one enumerated type is implicitly converted to another:

drivers/pinctrl/pinctrl-zynq.c:985:18: warning: implicit conversion from
enumeration type 'enum zynq_pin_config_param' to different enumeration
type 'enum pin_config_param' [-Wenum-conversion]
        {"io-standard", PIN_CONFIG_IOSTANDARD, zynq_iostd_lvcmos18},
        ~               ^~~~~~~~~~~~~~~~~~~~~
drivers/pinctrl/pinctrl-zynq.c:990:16: warning: implicit conversion from
enumeration type 'enum zynq_pin_config_param' to different enumeration
type 'enum pin_config_param' [-Wenum-conversion]
        = { PCONFDUMP(PIN_CONFIG_IOSTANDARD, "IO-standard", NULL, true),
            ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/pinctrl/pinconf-generic.h:163:11: note: expanded from
macro 'PCONFDUMP'
        .param = a, .display = b, .format = c, .has_arg = d     \
                 ^
2 warnings generated.

It is expected that pinctrl drivers can extend pin_config_param because
of the gap between PIN_CONFIG_END and PIN_CONFIG_MAX so this conversion
isn't an issue. Most drivers that take advantage of this define the
PIN_CONFIG variables as constants, rather than enumerated values. Do the
same thing here so that Clang no longer warns.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-zynq.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-zynq.c b/drivers/pinctrl/pinctrl-zynq.c
index a0daf27042bd0..90fd37e8207bf 100644
--- a/drivers/pinctrl/pinctrl-zynq.c
+++ b/drivers/pinctrl/pinctrl-zynq.c
@@ -971,15 +971,12 @@ enum zynq_io_standards {
 	zynq_iostd_max
 };
 
-/**
- * enum zynq_pin_config_param - possible pin configuration parameters
- * @PIN_CONFIG_IOSTANDARD: if the pin can select an IO standard, the argument to
+/*
+ * PIN_CONFIG_IOSTANDARD: if the pin can select an IO standard, the argument to
  *	this parameter (on a custom format) tells the driver which alternative
  *	IO standard to use.
  */
-enum zynq_pin_config_param {
-	PIN_CONFIG_IOSTANDARD = PIN_CONFIG_END + 1,
-};
+#define PIN_CONFIG_IOSTANDARD		(PIN_CONFIG_END + 1)
 
 static const struct pinconf_generic_params zynq_dt_params[] = {
 	{"io-standard", PIN_CONFIG_IOSTANDARD, zynq_iostd_lvcmos18},
-- 
2.20.1

