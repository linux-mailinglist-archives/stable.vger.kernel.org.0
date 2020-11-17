Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172202B6360
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732974AbgKQNhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732969AbgKQNhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 844072469D;
        Tue, 17 Nov 2020 13:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620255;
        bh=6ApJEoX/IvjqEPCeHzJNnAXX3VgpsxxHxzsC58U8le0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sl7ke0ccRQ9XZYiNUzsz95EJ7JeS3trxmz0dHbeZ1MMOjvDnsDJPHPXW+p5ps5pDY
         JkIGqZ5jPiHRPsS4hfe3MUT/nrlX9VWz4twr/7zpBrY5DOnsK6i/8ka+ZiTntmsgOA
         VSDDxZqqJ+mIbY5mI58FxDZKvOwEBmP76FDmyypw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamie McClymont <jamie@kwiius.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 128/255] pinctrl: intel: Fix 2 kOhm bias which is 833 Ohm
Date:   Tue, 17 Nov 2020 14:04:28 +0100
Message-Id: <20201117122145.162352736@linuxfoundation.org>
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

[ Upstream commit dd26209bc56886cacdbd828571e54a6bca251e55 ]

2 kOhm bias was never an option in Intel GPIO hardware, the available
matrix is:

	000	none
	001	1 kOhm (if available)
	010	5 kOhm
	100	20 kOhm

As easy to get the 3 resistors are gated separately and according to
parallel circuits calculations we may get combinations of the above where
the result is always strictly less than minimal resistance. Hence,
additional values can be:

	011	~833.3 Ohm
	101	~952.4 Ohm
	110	~4 kOhm
	111	~800 Ohm

That said, convert TERM definitions to be the bit masks to reflect the above.

While at it, enable the same setting for pull down case.

Fixes: 7981c0015af2 ("pinctrl: intel: Add Intel Sunrisepoint pin controller and GPIO support")
Cc: Jamie McClymont <jamie@kwiius.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 32 ++++++++++++++++++---------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index b64997b303e0c..b738b28239bd4 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -62,10 +62,10 @@
 #define PADCFG1_TERM_UP			BIT(13)
 #define PADCFG1_TERM_SHIFT		10
 #define PADCFG1_TERM_MASK		GENMASK(12, 10)
-#define PADCFG1_TERM_20K		4
-#define PADCFG1_TERM_2K			3
-#define PADCFG1_TERM_5K			2
-#define PADCFG1_TERM_1K			1
+#define PADCFG1_TERM_20K		BIT(2)
+#define PADCFG1_TERM_5K			BIT(1)
+#define PADCFG1_TERM_1K			BIT(0)
+#define PADCFG1_TERM_833		(BIT(1) | BIT(0))
 
 #define PADCFG2				0x008
 #define PADCFG2_DEBEN			BIT(0)
@@ -549,12 +549,12 @@ static int intel_config_get_pull(struct intel_pinctrl *pctrl, unsigned int pin,
 			return -EINVAL;
 
 		switch (term) {
+		case PADCFG1_TERM_833:
+			*arg = 833;
+			break;
 		case PADCFG1_TERM_1K:
 			*arg = 1000;
 			break;
-		case PADCFG1_TERM_2K:
-			*arg = 2000;
-			break;
 		case PADCFG1_TERM_5K:
 			*arg = 5000;
 			break;
@@ -570,6 +570,11 @@ static int intel_config_get_pull(struct intel_pinctrl *pctrl, unsigned int pin,
 			return -EINVAL;
 
 		switch (term) {
+		case PADCFG1_TERM_833:
+			if (!(community->features & PINCTRL_FEATURE_1K_PD))
+				return -EINVAL;
+			*arg = 833;
+			break;
 		case PADCFG1_TERM_1K:
 			if (!(community->features & PINCTRL_FEATURE_1K_PD))
 				return -EINVAL;
@@ -685,12 +690,12 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned int pin,
 		case 5000:
 			value |= PADCFG1_TERM_5K << PADCFG1_TERM_SHIFT;
 			break;
-		case 2000:
-			value |= PADCFG1_TERM_2K << PADCFG1_TERM_SHIFT;
-			break;
 		case 1000:
 			value |= PADCFG1_TERM_1K << PADCFG1_TERM_SHIFT;
 			break;
+		case 833:
+			value |= PADCFG1_TERM_833 << PADCFG1_TERM_SHIFT;
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -714,6 +719,13 @@ static int intel_config_set_pull(struct intel_pinctrl *pctrl, unsigned int pin,
 			}
 			value |= PADCFG1_TERM_1K << PADCFG1_TERM_SHIFT;
 			break;
+		case 833:
+			if (!(community->features & PINCTRL_FEATURE_1K_PD)) {
+				ret = -EINVAL;
+				break;
+			}
+			value |= PADCFG1_TERM_833 << PADCFG1_TERM_SHIFT;
+			break;
 		default:
 			ret = -EINVAL;
 		}
-- 
2.27.0



