Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B032D3ED58F
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbhHPNMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237935AbhHPNIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:08:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF0C61181;
        Mon, 16 Aug 2021 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119222;
        bh=+lW52ZIqBxSz7upJlNfjvdDxX8/DP2zzlrbyJ8KyFQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOvzKz2o4+Zmlc4CM52Q/hBkjgXBpZfz8DP2P8YYk7+DcFTHu4fK624LM6p+gvOaI
         JyMGnx1f0k0Rnp5EekUoTHktoWYY7lhXoCssD0trsbU59Hclqujb40AmHkubVQkzrA
         r1izydlNTwcEKOxjvPKK64kWwyHN9IjISgLD2D/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mori <patacca@autistici.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Lovesh <lovesh.bond@gmail.com>
Subject: [PATCH 5.10 32/96] pinctrl: tigerlake: Fix GPIO mapping for newer version of software
Date:   Mon, 16 Aug 2021 15:01:42 +0200
Message-Id: <20210816125436.026112817@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2f658f7a3953f6d70bab90e117aff8d0ad44e200 ]

The software mapping for GPIO, which initially comes from Microsoft,
is subject to change by respective Windows and firmware developers.
Due to the above the driver had been written and published way ahead
of the schedule, and thus the numbering schema used in it is outdated.

Fix the numbering schema in accordance with the real products on market.

Fixes: 653d96455e1e ("pinctrl: tigerlake: Add support for Tiger Lake-H")
Reported-and-tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-by: Riccardo Mori <patacca@autistici.org>
Reported-and-tested-by: Lovesh <lovesh.bond@gmail.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213463
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213579
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213857
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-tigerlake.c | 26 +++++++++++------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-tigerlake.c b/drivers/pinctrl/intel/pinctrl-tigerlake.c
index 3e354e02f408..bed769d99b8b 100644
--- a/drivers/pinctrl/intel/pinctrl-tigerlake.c
+++ b/drivers/pinctrl/intel/pinctrl-tigerlake.c
@@ -701,32 +701,32 @@ static const struct pinctrl_pin_desc tglh_pins[] = {
 
 static const struct intel_padgroup tglh_community0_gpps[] = {
 	TGL_GPP(0, 0, 24, 0),				/* GPP_A */
-	TGL_GPP(1, 25, 44, 128),			/* GPP_R */
-	TGL_GPP(2, 45, 70, 32),				/* GPP_B */
-	TGL_GPP(3, 71, 78, INTEL_GPIO_BASE_NOMAP),	/* vGPIO_0 */
+	TGL_GPP(1, 25, 44, 32),				/* GPP_R */
+	TGL_GPP(2, 45, 70, 64),				/* GPP_B */
+	TGL_GPP(3, 71, 78, 96),				/* vGPIO_0 */
 };
 
 static const struct intel_padgroup tglh_community1_gpps[] = {
-	TGL_GPP(0, 79, 104, 96),			/* GPP_D */
-	TGL_GPP(1, 105, 128, 64),			/* GPP_C */
-	TGL_GPP(2, 129, 136, 160),			/* GPP_S */
-	TGL_GPP(3, 137, 153, 192),			/* GPP_G */
-	TGL_GPP(4, 154, 180, 224),			/* vGPIO */
+	TGL_GPP(0, 79, 104, 128),			/* GPP_D */
+	TGL_GPP(1, 105, 128, 160),			/* GPP_C */
+	TGL_GPP(2, 129, 136, 192),			/* GPP_S */
+	TGL_GPP(3, 137, 153, 224),			/* GPP_G */
+	TGL_GPP(4, 154, 180, 256),			/* vGPIO */
 };
 
 static const struct intel_padgroup tglh_community3_gpps[] = {
-	TGL_GPP(0, 181, 193, 256),			/* GPP_E */
-	TGL_GPP(1, 194, 217, 288),			/* GPP_F */
+	TGL_GPP(0, 181, 193, 288),			/* GPP_E */
+	TGL_GPP(1, 194, 217, 320),			/* GPP_F */
 };
 
 static const struct intel_padgroup tglh_community4_gpps[] = {
-	TGL_GPP(0, 218, 241, 320),			/* GPP_H */
+	TGL_GPP(0, 218, 241, 352),			/* GPP_H */
 	TGL_GPP(1, 242, 251, 384),			/* GPP_J */
-	TGL_GPP(2, 252, 266, 352),			/* GPP_K */
+	TGL_GPP(2, 252, 266, 416),			/* GPP_K */
 };
 
 static const struct intel_padgroup tglh_community5_gpps[] = {
-	TGL_GPP(0, 267, 281, 416),			/* GPP_I */
+	TGL_GPP(0, 267, 281, 448),			/* GPP_I */
 	TGL_GPP(1, 282, 290, INTEL_GPIO_BASE_NOMAP),	/* JTAG */
 };
 
-- 
2.30.2



