Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B379C2E6611
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388594AbgL1NXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388546AbgL1NXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:23:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96A022072C;
        Mon, 28 Dec 2020 13:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161790;
        bh=6yANuVazOYdzHVScUvKEp/9J+L6YCvHhqicJMLGwKSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gM4/NG1a262LDp/cxi7qwK9/bpJULprMHncGqxBpGc5i8473Tqf7dZEPdEuFaRnPL
         VYWhAoJhzrUTOFTYAlZjR0L8GLKG/BMcY/nXVih57Av9l8C0UHj8z91dEkGy6uql03
         swzxTjCwPNqJIifzAew8+OWnFx3awA4kaJUkYnV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/346] pinctrl: merrifield: Set default bias in case no particular value given
Date:   Mon, 28 Dec 2020 13:46:14 +0100
Message-Id: <20201228124922.455232508@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0fa86fc2e28227f1e64f13867e73cf864c6d25ad ]

When GPIO library asks pin control to set the bias, it doesn't pass
any value of it and argument is considered boolean (and this is true
for ACPI GpioIo() / GpioInt() resources, by the way). Thus, individual
drivers must behave well, when they got the resistance value of 1 Ohm,
i.e. transforming it to sane default.

In case of Intel Merrifield pin control hardware the 20 kOhm sounds plausible
because it gives a good trade off between weakness and minimization of leakage
current (will be only 50 uA with the above choice).

Fixes: 4e80c8f50574 ("pinctrl: intel: Add Intel Merrifield pin controller support")
Depends-on: 2956b5d94a76 ("pinctrl / gpio: Introduce .set_config() callback for GPIO chips")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-merrifield.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pinctrl/intel/pinctrl-merrifield.c b/drivers/pinctrl/intel/pinctrl-merrifield.c
index 4fa69f988c7b7..6b2312e73f23f 100644
--- a/drivers/pinctrl/intel/pinctrl-merrifield.c
+++ b/drivers/pinctrl/intel/pinctrl-merrifield.c
@@ -729,6 +729,10 @@ static int mrfld_config_set_pin(struct mrfld_pinctrl *mp, unsigned int pin,
 		mask |= BUFCFG_Px_EN_MASK | BUFCFG_PUPD_VAL_MASK;
 		bits |= BUFCFG_PU_EN;
 
+		/* Set default strength value in case none is given */
+		if (arg == 1)
+			arg = 20000;
+
 		switch (arg) {
 		case 50000:
 			bits |= BUFCFG_PUPD_VAL_50K << BUFCFG_PUPD_VAL_SHIFT;
@@ -749,6 +753,10 @@ static int mrfld_config_set_pin(struct mrfld_pinctrl *mp, unsigned int pin,
 		mask |= BUFCFG_Px_EN_MASK | BUFCFG_PUPD_VAL_MASK;
 		bits |= BUFCFG_PD_EN;
 
+		/* Set default strength value in case none is given */
+		if (arg == 1)
+			arg = 20000;
+
 		switch (arg) {
 		case 50000:
 			bits |= BUFCFG_PUPD_VAL_50K << BUFCFG_PUPD_VAL_SHIFT;
-- 
2.27.0



