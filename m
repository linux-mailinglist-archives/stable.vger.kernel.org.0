Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30C92B65AD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgKQNT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:19:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730402AbgKQNTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:19:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FBE0241A5;
        Tue, 17 Nov 2020 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619163;
        bh=v8MsClufYvTK/t6qcxQVvhqC2wC2CEu2WCZ5DyiZeyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViJderJ7YevJBzW5N3dsniDAgJgSHQP1aBwLTslDX9ewAA/Xt1QWqgzsbjuLzbhND
         CM+tJ/NXtuvErOioBNrtyAABsB9JaiqqrkwLOLgV+ste+oGv6VHqZR1He3xbStH8g6
         yvJCr3kPrVGiTZp1ZkwbMrvVRVws4e++eddP/3/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie McClymont <jamie@kwiius.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/101] pinctrl: intel: Set default bias in case no particular value given
Date:   Tue, 17 Nov 2020 14:05:17 +0100
Message-Id: <20201117122115.531617980@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
index 89ff2795a8b55..5e0adb00b4307 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -621,6 +621,10 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned pin,
 
 		value |= PADCFG1_TERM_UP;
 
+		/* Set default strength value in case none is given */
+		if (arg == 1)
+			arg = 5000;
+
 		switch (arg) {
 		case 20000:
 			value |= PADCFG1_TERM_20K << PADCFG1_TERM_SHIFT;
@@ -643,6 +647,10 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned pin,
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



