Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C83C8604
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhGNOZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 10:25:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37478 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhGNOZf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 10:25:35 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 087A022A2D;
        Wed, 14 Jul 2021 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626272563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNMhQbMSOHb7kXKp9lOByybRL+HVB3D2chztXvrZNPc=;
        b=Qg1zSUNKM0HlBRVroIJa+SDeBEhqCJMxAsiUHK99HLDZTXe4YFwQ78BgQD+GLao16znlgA
        UMYvRFtVw2pqQ9ndtD+k3P4KxvnA3v7YKyEA2pVijhwsxrkoY1Ta3JlEh1Xw9CuhDVWNLt
        GeXDCSOaI06cByqcPd1+csruNwP7CGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626272563;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNMhQbMSOHb7kXKp9lOByybRL+HVB3D2chztXvrZNPc=;
        b=5Ho4q0cSKLSOZhKJYqbnfv6I5tkyO9SW98WaZc5MP5qzjICQVdAVnvWJBXk8gJW2PvbU4k
        9XusYnp1CEjTxZCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BC2B713E77;
        Wed, 14 Jul 2021 14:22:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8I8MLTLz7mBUdwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 14 Jul 2021 14:22:42 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     sam@ravnborg.org, daniel@ffwll.ch, airlied@redhat.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        emil.velikov@collabora.com, John.p.donnelly@oracle.com
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH v2 01/13] drm/mgag200: Select clock in PLL update functions
Date:   Wed, 14 Jul 2021 16:22:28 +0200
Message-Id: <20210714142240.21979-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714142240.21979-1-tzimmermann@suse.de>
References: <20210714142240.21979-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.9+
---
 drivers/gpu/drm/mgag200/mgag200_drv.h  | 16 ++++++++++++++++
 drivers/gpu/drm/mgag200/mgag200_mode.c | 20 +++++++++++++-------
 drivers/gpu/drm/mgag200/mgag200_reg.h  |  9 ++++-----
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index f7a0537c0d0a..5302d6566d7c 100644
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
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 3b3059f471c2..1bdf21474bcb 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -174,6 +174,8 @@ static int mgag200_g200_set_plls(struct mga_device *mdev, long clock)
 	drm_dbg_kms(dev, "clock: %ld vco: %ld m: %d n: %d p: %d s: %d\n",
 		    clock, f_vco, m, n, p, s);
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG_DAC(MGA1064_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_PIX_PLLC_N, n);
 	WREG_DAC(MGA1064_PIX_PLLC_P, (p | (s << 3)));
@@ -289,6 +291,8 @@ static int mga_g200se_set_plls(struct mga_device *mdev, long clock)
 		return 1;
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG_DAC(MGA1064_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_PIX_PLLC_N, n);
 	WREG_DAC(MGA1064_PIX_PLLC_P, p);
@@ -385,6 +389,8 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	for (i = 0; i <= 32 && pll_locked == false; i++) {
 		if (i > 0) {
 			WREG8(MGAREG_CRTC_INDEX, 0x1e);
@@ -522,6 +528,8 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
@@ -654,6 +662,9 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 			}
 		}
 	}
+
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	for (i = 0; i <= 32 && pll_locked == false; i++) {
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
@@ -754,6 +765,8 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	WREG_MISC_MASKED(MGAREG_MISC_CLKSEL_MGA, MGAREG_MISC_CLKSEL_MASK);
+
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
@@ -787,8 +800,6 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 
 static int mgag200_crtc_set_plls(struct mga_device *mdev, long clock)
 {
-	u8 misc;
-
 	switch(mdev->type) {
 	case G200_PCI:
 	case G200_AGP:
@@ -808,11 +819,6 @@ static int mgag200_crtc_set_plls(struct mga_device *mdev, long clock)
 		return mga_g200er_set_plls(mdev, clock);
 	}
 
-	misc = RREG8(MGA_MISC_IN);
-	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
-	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
-	WREG8(MGA_MISC_OUT, misc);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_reg.h b/drivers/gpu/drm/mgag200/mgag200_reg.h
index 977be0565c06..60e705283fe8 100644
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
-- 
2.32.0

