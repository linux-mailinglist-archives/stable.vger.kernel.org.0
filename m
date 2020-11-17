Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7F72B6233
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgKQN0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731421AbgKQN0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FC0C20781;
        Tue, 17 Nov 2020 13:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619580;
        bh=lvfsHQcO7u3GELzLUIdgG9XJIFaFT6NRrk0CYy3NwrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAkOw/Z76TA+yGSBJEuKjrWwT3FVNXgCkIC20zmuQX8OhTQwaPJnhwYiqBjWplGfE
         ahLX98VIT5AT9KC0q6SNHU6dPlTpxuvSxS0VbE2JADmhIbEv8YxMqmGubu2nNfj7lY
         BZPrQVd/KAT4EA3RvoaiyQrq4T+jOB2socSgfdC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie McClymont <jamie@kwiius.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/151] pinctrl: intel: Set default bias in case no particular value given
Date:   Tue, 17 Nov 2020 14:05:17 +0100
Message-Id: <20201117122125.648004832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index 83981ad66a71e..4e89bbf6b76a0 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -662,6 +662,10 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned int pin,
 
 		value |= PADCFG1_TERM_UP;
 
+		/* Set default strength value in case none is given */
+		if (arg == 1)
+			arg = 5000;
+
 		switch (arg) {
 		case 20000:
 			value |= PADCFG1_TERM_20K << PADCFG1_TERM_SHIFT;
@@ -684,6 +688,10 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned int pin,
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



