Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015832B6362
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732965AbgKQNhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732466AbgKQNhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6478E207BC;
        Tue, 17 Nov 2020 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620258;
        bh=aTPvIWSdGl3VNu+IMvu8NQNJp1W9U1nYpkDGppYYOTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boiD/3luQLfTlONo+giPDgdJ2wl43oP2/pySPOpQc7FvHMtOcs3E5wWP/Fkye+kc2
         +7vaI9BpnEGbUIQTHTXd3VUy897BfJHwB0OlTVtqdZNopkju2c0Miv3LIjR8bEqQ1L
         hseQ8AtyME/XZZ5cjpUOyM95PM5CmVZmELIWHuYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie McClymont <jamie@kwiius.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 129/255] pinctrl: intel: Set default bias in case no particular value given
Date:   Tue, 17 Nov 2020 14:04:29 +0100
Message-Id: <20201117122145.213313363@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f3c75e7a9349d1d33eb53ddc1b31640994969f73 ]

When GPIO library asks pin control to set the bias, it doesn't pass
any value of it and argument is considered boolean (and this is true
for ACPI GpioIo() / GpioInt() resources, by the way). Thus, individual
drivers must behave well, when they got the resistance value of 1 Ohm,
i.e. transforming it to sane default.

In case of Intel pin control hardware the 5 kOhm sounds plausible
because on one hand it's a minimum of resistors present in all
hardware generations and at the same time it's high enough to minimize
leakage current (will be only 200 uA with the above choice).

Fixes: e57725eabf87 ("pinctrl: intel: Add support for hardware debouncer")
Reported-by: Jamie McClymont <jamie@kwiius.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index b738b28239bd4..31e7840bc5e25 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -683,6 +683,10 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned int pin,
 
 		value |= PADCFG1_TERM_UP;
 
+		/* Set default strength value in case none is given */
+		if (arg == 1)
+			arg = 5000;
+
 		switch (arg) {
 		case 20000:
 			value |= PADCFG1_TERM_20K << PADCFG1_TERM_SHIFT;
@@ -705,6 +709,10 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned int pin,
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 		value &= ~(PADCFG1_TERM_UP | PADCFG1_TERM_MASK);
 
+		/* Set default strength value in case none is given */
+		if (arg == 1)
+			arg = 5000;
+
 		switch (arg) {
 		case 20000:
 			value |= PADCFG1_TERM_20K << PADCFG1_TERM_SHIFT;
-- 
2.27.0



