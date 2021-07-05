Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230F83BBCFF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 14:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhGEMrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 08:47:55 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40816 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhGEMry (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 08:47:54 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 391A5225E6;
        Mon,  5 Jul 2021 12:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625489117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkix/MuBeaAucqA02/qtk3Y8Hdui/c9rKLpTFt2ykBw=;
        b=LkJQx+ddyN6izZIXOb1HMR9lu30V6etFzdUGo/p0X9MXhFMF7I0RVBbFeBABSBLAsNQwXX
        pW0Eo3n8DIZxCbwGBkHmCelG44WpqWe6RemiPGB3xDfjHTUsaf9p+35L4k2AyQKahbiXMG
        V+qEEMd/T0KC8rYS13NvBfcQyvjrR7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625489117;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkix/MuBeaAucqA02/qtk3Y8Hdui/c9rKLpTFt2ykBw=;
        b=elfIQrMRXqdeAOuAsSvPziBDivWjLkEFxoSRfnhGP2+W4LANYZ4n/JQnxRP/HmtmucwWoP
        /fECSQAsWUobGqDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 048F013A7E;
        Mon,  5 Jul 2021 12:45:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EKc+AN3+4mDkcAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 05 Jul 2021 12:45:17 +0000
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     daniel@ffwll.ch, airlied@redhat.com, sam@ravnborg.org,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        emil.velikov@collabora.com, John.p.donnelly@oracle.com
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: [PATCH 01/12] drm/mgag200: Select clock in PLL update functions
Date:   Mon,  5 Jul 2021 14:45:04 +0200
Message-Id: <20210705124515.27253-2-tzimmermann@suse.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210705124515.27253-1-tzimmermann@suse.de>
References: <20210705124515.27253-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Put the clock-selection code into each of the PLL-update functions to
make them select the correct pixel clock.

The pixel clock for video output was not actually set before programming
the clock's values. It worked because the device had the correct clock
pre-set.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: db05f8d3dc87 ("drm/mgag200: Split MISC register update into PLL selection, SYNC and I/O")
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Emil Velikov <emil.velikov@collabora.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.9+
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 47 ++++++++++++++++++++------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 3b3059f471c2..482843ebb69f 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -130,6 +130,7 @@ static int mgag200_g200_set_plls(struct mga_device *mdev, long clock)
 	long ref_clk = mdev->model.g200.ref_clk;
 	long p_clk_min = mdev->model.g200.pclk_min;
 	long p_clk_max =  mdev->model.g200.pclk_max;
+	u8 misc;
 
 	if (clock > p_clk_max) {
 		drm_err(dev, "Pixel Clock %ld too high\n", clock);
@@ -174,6 +175,11 @@ static int mgag200_g200_set_plls(struct mga_device *mdev, long clock)
 	drm_dbg_kms(dev, "clock: %ld vco: %ld m: %d n: %d p: %d s: %d\n",
 		    clock, f_vco, m, n, p, s);
 
+	misc = RREG8(MGA_MISC_IN);
+	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
+	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
+	WREG8(MGA_MISC_OUT, misc);
+
 	WREG_DAC(MGA1064_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_PIX_PLLC_N, n);
 	WREG_DAC(MGA1064_PIX_PLLC_P, (p | (s << 3)));
@@ -194,6 +200,7 @@ static int mga_g200se_set_plls(struct mga_device *mdev, long clock)
 	unsigned int pvalues_e4[P_ARRAY_SIZE] = {16, 14, 12, 10, 8, 6, 4, 2, 1};
 	unsigned int fvv;
 	unsigned int i;
+	u8 misc;
 
 	if (unique_rev_id <= 0x03) {
 
@@ -289,6 +296,11 @@ static int mga_g200se_set_plls(struct mga_device *mdev, long clock)
 		return 1;
 	}
 
+	misc = RREG8(MGA_MISC_IN);
+	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
+	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
+	WREG8(MGA_MISC_OUT, misc);
+
 	WREG_DAC(MGA1064_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_PIX_PLLC_N, n);
 	WREG_DAC(MGA1064_PIX_PLLC_P, p);
@@ -312,7 +324,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 	unsigned int computed;
 	int i, j, tmpcount, vcount;
 	bool pll_locked = false;
-	u8 tmp;
+	u8 tmp, misc;
 
 	m = n = p = 0;
 
@@ -385,6 +397,11 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	misc = RREG8(MGA_MISC_IN);
+	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
+	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
+	WREG8(MGA_MISC_OUT, misc);
+
 	for (i = 0; i <= 32 && pll_locked == false; i++) {
 		if (i > 0) {
 			WREG8(MGAREG_CRTC_INDEX, 0x1e);
@@ -489,7 +506,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	unsigned int testp, testm, testn;
 	unsigned int p, m, n;
 	unsigned int computed;
-	u8 tmp;
+	u8 tmp, misc;
 
 	m = n = p = 0;
 	vcomax = 550000;
@@ -522,6 +539,11 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	misc = RREG8(MGA_MISC_IN);
+	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
+	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
+	WREG8(MGA_MISC_OUT, misc);
+
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
@@ -583,7 +605,7 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 	unsigned int p, m, n;
 	unsigned int computed;
 	int i, j, tmpcount, vcount;
-	u8 tmp;
+	u8 tmp, misc;
 	bool pll_locked = false;
 
 	m = n = p = 0;
@@ -654,6 +676,12 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 			}
 		}
 	}
+
+	misc = RREG8(MGA_MISC_IN);
+	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
+	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
+	WREG8(MGA_MISC_OUT, misc);
+
 	for (i = 0; i <= 32 && pll_locked == false; i++) {
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
@@ -714,6 +742,7 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 	unsigned int p, m, n;
 	unsigned int computed, vco;
 	int tmp;
+	u8 misc;
 
 	m = n = p = 0;
 	vcomax = 1488000;
@@ -754,6 +783,11 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 		}
 	}
 
+	misc = RREG8(MGA_MISC_IN);
+	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
+	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
+	WREG8(MGA_MISC_OUT, misc);
+
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
@@ -787,8 +821,6 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 
 static int mgag200_crtc_set_plls(struct mga_device *mdev, long clock)
 {
-	u8 misc;
-
 	switch(mdev->type) {
 	case G200_PCI:
 	case G200_AGP:
@@ -808,11 +840,6 @@ static int mgag200_crtc_set_plls(struct mga_device *mdev, long clock)
 		return mga_g200er_set_plls(mdev, clock);
 	}
 
-	misc = RREG8(MGA_MISC_IN);
-	misc &= ~MGAREG_MISC_CLK_SEL_MASK;
-	misc |= MGAREG_MISC_CLK_SEL_MGA_MSK;
-	WREG8(MGA_MISC_OUT, misc);
-
 	return 0;
 }
 
-- 
2.32.0

