Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD19F29B83D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799918AbgJ0PeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368808AbgJ0PeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 920112225E;
        Tue, 27 Oct 2020 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812846;
        bh=euCQJTDf+exXUOZoff9kk4oG/35H4TMwvNvwLFJ3Wpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHR5/dzXerPlp8k0of5QHMPi0SoVO8m8qF0HzJixMV6nfgE6mDwyMWF0IJ544pL9o
         37Etb9gaSAEd4kEdNx1dt2P+W29lMsIYVOqACdcSyvDu8pmmtjIOboyLH+jkdlbJmA
         Coh08WibRdGslra3tTztZcbTHTYswFBLo/fxG+xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 351/757] pinctrl: tigerlake: Fix register offsets for TGL-H variant
Date:   Tue, 27 Oct 2020 14:50:01 +0100
Message-Id: <20201027135507.035773583@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit cb8cc18508fb0cad74929ffd080bebafe91609e2 ]

It appears that almost traditionally the H variants have some deviations
in the register offsets in comparison to LP ones. This is the case for
Intel Tiger Lake as well. Fix register offsets for TGL-H variant.

Fixes: 653d96455e1e ("pinctrl: tigerlake: Add support for Tiger Lake-H")
Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20200929110306.40852-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-tigerlake.c | 42 ++++++++++++++---------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-tigerlake.c b/drivers/pinctrl/intel/pinctrl-tigerlake.c
index 8c162dd5f5a10..3e354e02f4084 100644
--- a/drivers/pinctrl/intel/pinctrl-tigerlake.c
+++ b/drivers/pinctrl/intel/pinctrl-tigerlake.c
@@ -15,11 +15,13 @@
 
 #include "pinctrl-intel.h"
 
-#define TGL_PAD_OWN	0x020
-#define TGL_PADCFGLOCK	0x080
-#define TGL_HOSTSW_OWN	0x0b0
-#define TGL_GPI_IS	0x100
-#define TGL_GPI_IE	0x120
+#define TGL_PAD_OWN		0x020
+#define TGL_LP_PADCFGLOCK	0x080
+#define TGL_H_PADCFGLOCK	0x090
+#define TGL_LP_HOSTSW_OWN	0x0b0
+#define TGL_H_HOSTSW_OWN	0x0c0
+#define TGL_GPI_IS		0x100
+#define TGL_GPI_IE		0x120
 
 #define TGL_GPP(r, s, e, g)				\
 	{						\
@@ -29,12 +31,12 @@
 		.gpio_base = (g),			\
 	}
 
-#define TGL_COMMUNITY(b, s, e, g)			\
+#define TGL_COMMUNITY(b, s, e, pl, ho, g)		\
 	{						\
 		.barno = (b),				\
 		.padown_offset = TGL_PAD_OWN,		\
-		.padcfglock_offset = TGL_PADCFGLOCK,	\
-		.hostown_offset = TGL_HOSTSW_OWN,	\
+		.padcfglock_offset = (pl),		\
+		.hostown_offset = (ho),			\
 		.is_offset = TGL_GPI_IS,		\
 		.ie_offset = TGL_GPI_IE,		\
 		.pin_base = (s),			\
@@ -43,6 +45,12 @@
 		.ngpps = ARRAY_SIZE(g),			\
 	}
 
+#define TGL_LP_COMMUNITY(b, s, e, g)			\
+	TGL_COMMUNITY(b, s, e, TGL_LP_PADCFGLOCK, TGL_LP_HOSTSW_OWN, g)
+
+#define TGL_H_COMMUNITY(b, s, e, g)			\
+	TGL_COMMUNITY(b, s, e, TGL_H_PADCFGLOCK, TGL_H_HOSTSW_OWN, g)
+
 /* Tiger Lake-LP */
 static const struct pinctrl_pin_desc tgllp_pins[] = {
 	/* GPP_B */
@@ -367,10 +375,10 @@ static const struct intel_padgroup tgllp_community5_gpps[] = {
 };
 
 static const struct intel_community tgllp_communities[] = {
-	TGL_COMMUNITY(0, 0, 66, tgllp_community0_gpps),
-	TGL_COMMUNITY(1, 67, 170, tgllp_community1_gpps),
-	TGL_COMMUNITY(2, 171, 259, tgllp_community4_gpps),
-	TGL_COMMUNITY(3, 260, 276, tgllp_community5_gpps),
+	TGL_LP_COMMUNITY(0, 0, 66, tgllp_community0_gpps),
+	TGL_LP_COMMUNITY(1, 67, 170, tgllp_community1_gpps),
+	TGL_LP_COMMUNITY(2, 171, 259, tgllp_community4_gpps),
+	TGL_LP_COMMUNITY(3, 260, 276, tgllp_community5_gpps),
 };
 
 static const struct intel_pinctrl_soc_data tgllp_soc_data = {
@@ -723,11 +731,11 @@ static const struct intel_padgroup tglh_community5_gpps[] = {
 };
 
 static const struct intel_community tglh_communities[] = {
-	TGL_COMMUNITY(0, 0, 78, tglh_community0_gpps),
-	TGL_COMMUNITY(1, 79, 180, tglh_community1_gpps),
-	TGL_COMMUNITY(2, 181, 217, tglh_community3_gpps),
-	TGL_COMMUNITY(3, 218, 266, tglh_community4_gpps),
-	TGL_COMMUNITY(4, 267, 290, tglh_community5_gpps),
+	TGL_H_COMMUNITY(0, 0, 78, tglh_community0_gpps),
+	TGL_H_COMMUNITY(1, 79, 180, tglh_community1_gpps),
+	TGL_H_COMMUNITY(2, 181, 217, tglh_community3_gpps),
+	TGL_H_COMMUNITY(3, 218, 266, tglh_community4_gpps),
+	TGL_H_COMMUNITY(4, 267, 290, tglh_community5_gpps),
 };
 
 static const struct intel_pinctrl_soc_data tglh_soc_data = {
-- 
2.25.1



