Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F4940E107
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbhIPQ0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241171AbhIPQYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 271EB613B5;
        Thu, 16 Sep 2021 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808985;
        bh=tf9OrmOWdZrKDyB7NvmpyNm12addAN9827dFW//GZRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3nHFRWO4Imd8e7FIQZph7sIKbmQMYMTZ85M+sZtsrammu+S2b0lkuFKJJKZ7kQuM
         pnZofdXRrBR6PWRp0KAbX6RcgAOaoNHeknb4eTQNhthPQvUPPoEoC1XugfYM/mQGh3
         KE8k/apatBHFh0Ll7D14NimrpN3lJJCgxZCbeh5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Emil Velikov <emil.velikov@collabora.com>,
        Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5.10 296/306] drm/mgag200: Select clock in PLL update functions
Date:   Thu, 16 Sep 2021 18:00:41 +0200
Message-Id: <20210916155804.189022669@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 147696720eca12ae48d020726208b9a61cdd80bc upstream.

Put the clock-selection code into each of the PLL-update functions to
make them select the correct pixel clock. Instead of copying the code,
introduce a new helper WREG_MISC_MASKED, which does masked writes into
<MISC>. Use it from each individual PLL update function.

The pixel clock for video output was not actually set before programming
the clock's values. It worked because the device had the correct clock
pre-set.

v2:
	* don't duplicate <MISC> update code (Sam)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: db05f8d3dc87 ("drm/mgag200: Split MISC register update into PLL selection, SYNC and I/O")
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.9+
Link: https://patchwork.freedesktop.org/patch/msgid/20210714142240.21979-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_drv.h  |   16 ++++++++++++++++
 drivers/gpu/drm/mgag200/mgag200_mode.c |   20 +++++++++++++-------
 drivers/gpu/drm/mgag200/mgag200_reg.h  |    9 ++++-----
 3 files changed, 33 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -43,6 +43,22 @@
 #define ATTR_INDEX 0x1fc0
 #define ATTR_DATA 0x1fc1
 
+#define WREG_MISC(v)						\
+	WREG8(MGA_MISC_OUT, v)
+
+#define RREG_MISC(v)						\
+	((v) = RREG8(MGA_MISC_IN))
+
+#define WREG_MISC_MASKED(v, mask)				\
+	do {							\
+		u8 misc_;					\
+		u8 mask_ = (mask);				\
+		RREG_MISC(misc_);				\
+		misc_ &= ~mask_;				\
+		misc_ |= ((v) & mask_);				\
+		WREG_MISC(misc_);				\
+	} while (0)
+
 #define WREG_ATTR(reg, v)					\
 	do {							\
 		RREG8(0x1fda);					\
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -172,6 +172,8 @@ static int mgag200_g200_set_plls(struct
 	drm_dbg_kms(dev, "clock: %ld vco: %ld m: %d n: %d p: %d s: %d\n",
 		    clock, f_vco, m, n, p, s);
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG_DAC(MGA1064_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_PIX_PLLC_N, n);
 	WREG_DAC(MGA1064_PIX_PLLC_P, (p | (s << 3)));
@@ -287,6 +289,8 @@ static int mga_g200se_set_plls(struct mg
 		return 1;
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG_DAC(MGA1064_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_PIX_PLLC_N, n);
 	WREG_DAC(MGA1064_PIX_PLLC_P, p);
@@ -383,6 +387,8 @@ static int mga_g200wb_set_plls(struct mg
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	for (i = 0; i <= 32 && pll_locked == false; i++) {
 		if (i > 0) {
 			WREG8(MGAREG_CRTC_INDEX, 0x1e);
@@ -520,6 +526,8 @@ static int mga_g200ev_set_plls(struct mg
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
@@ -652,6 +660,9 @@ static int mga_g200eh_set_plls(struct mg
 			}
 		}
 	}
+
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	for (i = 0; i <= 32 && pll_locked == false; i++) {
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
@@ -752,6 +763,8 @@ static int mga_g200er_set_plls(struct mg
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
@@ -785,8 +798,6 @@ static int mga_g200er_set_plls(struct mg
 
 static int mgag200_crtc_set_plls(struct mga_device *mdev, long clock)
 {
-	u8 misc;
-
 	switch(mdev->type) {
 	case G200_PCI:
 	case G200_AGP:
@@ -811,11 +822,6 @@ static int mgag200_crtc_set_plls(struct
 		break;
 	}
 
-	misc = RREG8(MGA_MISC_IN);
-	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
-	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
-	WREG8(MGA_MISC_OUT, misc);
-
 	return 0;
 }
 
--- a/drivers/gpu/drm/mgag200/mgag200_reg.h
+++ b/drivers/gpu/drm/mgag200/mgag200_reg.h
@@ -222,11 +222,10 @@
 
 #define MGAREG_MISC_IOADSEL	(0x1 << 0)
 #define MGAREG_MISC_RAMMAPEN	(0x1 << 1)
-#define MGAREG_MISC_CLK_SEL_MASK	GENMASK(3, 2)
-#define MGAREG_MISC_CLK_SEL_VGA25	(0x0 << 2)
-#define MGAREG_MISC_CLK_SEL_VGA28	(0x1 << 2)
-#define MGAREG_MISC_CLK_SEL_MGA_PIX	(0x2 << 2)
-#define MGAREG_MISC_CLK_SEL_MGA_MSK	(0x3 << 2)
+#define MGAREG_MISC_CLKSEL_MASK		GENMASK(3, 2)
+#define MGAREG_MISC_CLKSEL_VGA25	(0x0 << 2)
+#define MGAREG_MISC_CLKSEL_VGA28	(0x1 << 2)
+#define MGAREG_MISC_CLKSEL_MGA		(0x3 << 2)
 #define MGAREG_MISC_VIDEO_DIS	(0x1 << 4)
 #define MGAREG_MISC_HIGH_PG_SEL	(0x1 << 5)
 #define MGAREG_MISC_HSYNCPOL		BIT(6)


