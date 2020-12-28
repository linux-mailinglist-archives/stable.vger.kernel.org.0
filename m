Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08722E37D9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgL1NBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:57930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729816AbgL1NBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:01:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8AA4208D5;
        Mon, 28 Dec 2020 13:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160453;
        bh=3LplwEOCINzARgHDwmDjE88PLhUxKzlSGUbUgBtVux8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgW5ySjCSCNOSRm6HN1ewE6pOBWD+KeENCjm3QfPGZ9dn1EBPCXK6DhHpIfEcSuXP
         Nuq6Uc+sPLOex2z/sgcnjslCCLoTESIrgAsDuWKIsJU1f0uonHvaMAnILcz3Qa5JcR
         Shp4vLtkIB57Apklf4vt7Kb3HdHFDK5HBmKAC77I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 026/175] pinctrl: merrifield: Set default bias in case no particular value given
Date:   Mon, 28 Dec 2020 13:47:59 +0100
Message-Id: <20201228124854.525019102@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 04d6fd2be08cc..8d0cff3146b87 100644
--- a/drivers/pinctrl/intel/pinctrl-merrifield.c
+++ b/drivers/pinctrl/intel/pinctrl-merrifield.c
@@ -731,6 +731,10 @@ static int mrfld_config_set_pin(struct mrfld_pinctrl *mp, unsigned int pin,
 		mask |= BUFCFG_Px_EN_MASK | BUFCFG_PUPD_VAL_MASK;
 		bits |= BUFCFG_PU_EN;
 
+		/* Set default strength value in case none is given */
+		if (arg == 1)
+			arg = 20000;
+
 		switch (arg) {
 		case 50000:
 			bits |= BUFCFG_PUPD_VAL_50K << BUFCFG_PUPD_VAL_SHIFT;
@@ -751,6 +755,10 @@ static int mrfld_config_set_pin(struct mrfld_pinctrl *mp, unsigned int pin,
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



