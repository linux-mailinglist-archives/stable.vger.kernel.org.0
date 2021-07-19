Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248683CDB36
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245034AbhGSOlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244306AbhGSOhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297AB6124B;
        Mon, 19 Jul 2021 15:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707843;
        bh=BgMKc00guxCKJPNIXP4D8BgeB4U39zHrplx0EyrfGa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vI2VKyI1yaHYxY1hiLWuDlwU2dVTCOpUtadltufRCoNlgIpEAlvZd/QrolRqFPqJD
         b1Xt2uCOE0L0Pl9byy+zkvByQuj+vGdcT8+w31v5Lr4FXPVUpY5LBfdvFEQ2DoFHFv
         nKs0WFtBARp8zDLpbow5bYXmGsl3xcM7tH49q5Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org (moderated for non-subscribers),
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sangwook Lee <sangwook.lee@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 080/315] media: I2C: change RST to "RSET" to fix multiple build errors
Date:   Mon, 19 Jul 2021 16:49:29 +0200
Message-Id: <20210719144945.501008023@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 8edcb5049ac29aa3c8acc5ef15dd4036543d747e ]

The use of an enum named 'RST' conflicts with a #define macro
named 'RST' in arch/mips/include/asm/mach-rc32434/rb.h.

The MIPS use of RST was there first (AFAICT), so change the
media/i2c/ uses of RST to be named 'RSET'.
'git grep -w RSET' does not report any naming conflicts with the
new name.

This fixes multiple build errors:

arch/mips/include/asm/mach-rc32434/rb.h:15:14: error: expected identifier before '(' token
   15 | #define RST  (1 << 15)
      |              ^
drivers/media/i2c/s5c73m3/s5c73m3.h:356:2: note: in expansion of macro 'RST'
  356 |  RST,
      |  ^~~

../arch/mips/include/asm/mach-rc32434/rb.h:15:14: error: expected identifier before '(' token
   15 | #define RST  (1 << 15)
      |              ^
../drivers/media/i2c/s5k6aa.c:180:2: note: in expansion of macro 'RST'
  180 |  RST,
      |  ^~~

../arch/mips/include/asm/mach-rc32434/rb.h:15:14: error: expected identifier before '(' token
   15 | #define RST  (1 << 15)
      |              ^
../drivers/media/i2c/s5k5baf.c:238:2: note: in expansion of macro 'RST'
  238 |  RST,
      |  ^~~

and some others that I have trimmed.

Fixes: cac47f1822fc ("[media] V4L: Add S5C73M3 camera driver")
Fixes: 8b99312b7214 ("[media] Add v4l2 subdev driver for S5K4ECGX sensor")
Fixes: 7d459937dc09 ("[media] Add driver for Samsung S5K5BAF camera sensor")
Fixes: bfa8dd3a0524 ("[media] v4l: Add v4l2 subdev driver for S5K6AAFX sensor")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sangwook Lee <sangwook.lee@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |  6 +++---
 drivers/media/i2c/s5c73m3/s5c73m3.h      |  2 +-
 drivers/media/i2c/s5k4ecgx.c             | 10 +++++-----
 drivers/media/i2c/s5k5baf.c              |  6 +++---
 drivers/media/i2c/s5k6aa.c               | 10 +++++-----
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index cdc4f2392ef9..e7a107ecd219 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1394,7 +1394,7 @@ static int __s5c73m3_power_on(struct s5c73m3 *state)
 	s5c73m3_gpio_deassert(state, STBY);
 	usleep_range(100, 200);
 
-	s5c73m3_gpio_deassert(state, RST);
+	s5c73m3_gpio_deassert(state, RSET);
 	usleep_range(50, 100);
 
 	return 0;
@@ -1409,7 +1409,7 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 {
 	int i, ret;
 
-	if (s5c73m3_gpio_assert(state, RST))
+	if (s5c73m3_gpio_assert(state, RSET))
 		usleep_range(10, 50);
 
 	if (s5c73m3_gpio_assert(state, STBY))
@@ -1614,7 +1614,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 
 		state->mclk_frequency = pdata->mclk_frequency;
 		state->gpio[STBY] = pdata->gpio_stby;
-		state->gpio[RST] = pdata->gpio_reset;
+		state->gpio[RSET] = pdata->gpio_reset;
 		return 0;
 	}
 
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3.h b/drivers/media/i2c/s5c73m3/s5c73m3.h
index 653f68e7ea07..e267b2522149 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3.h
+++ b/drivers/media/i2c/s5c73m3/s5c73m3.h
@@ -361,7 +361,7 @@ struct s5c73m3_ctrls {
 
 enum s5c73m3_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 6ebcf254989a..75fb13a33eab 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -177,7 +177,7 @@ static const char * const s5k4ecgx_supply_names[] = {
 
 enum s5k4ecgx_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
@@ -482,7 +482,7 @@ static int __s5k4ecgx_power_on(struct s5k4ecgx *priv)
 	if (s5k4ecgx_gpio_set_value(priv, STBY, priv->gpio[STBY].level))
 		usleep_range(30, 50);
 
-	if (s5k4ecgx_gpio_set_value(priv, RST, priv->gpio[RST].level))
+	if (s5k4ecgx_gpio_set_value(priv, RSET, priv->gpio[RSET].level))
 		usleep_range(30, 50);
 
 	return 0;
@@ -490,7 +490,7 @@ static int __s5k4ecgx_power_on(struct s5k4ecgx *priv)
 
 static int __s5k4ecgx_power_off(struct s5k4ecgx *priv)
 {
-	if (s5k4ecgx_gpio_set_value(priv, RST, !priv->gpio[RST].level))
+	if (s5k4ecgx_gpio_set_value(priv, RSET, !priv->gpio[RSET].level))
 		usleep_range(30, 50);
 
 	if (s5k4ecgx_gpio_set_value(priv, STBY, !priv->gpio[STBY].level))
@@ -878,7 +878,7 @@ static int s5k4ecgx_config_gpios(struct s5k4ecgx *priv,
 	int ret;
 
 	priv->gpio[STBY].gpio = -EINVAL;
-	priv->gpio[RST].gpio  = -EINVAL;
+	priv->gpio[RSET].gpio  = -EINVAL;
 
 	ret = s5k4ecgx_config_gpio(gpio->gpio, gpio->level, "S5K4ECGX_STBY");
 
@@ -897,7 +897,7 @@ static int s5k4ecgx_config_gpios(struct s5k4ecgx *priv,
 		s5k4ecgx_free_gpios(priv);
 		return ret;
 	}
-	priv->gpio[RST] = *gpio;
+	priv->gpio[RSET] = *gpio;
 	if (gpio_is_valid(gpio->gpio))
 		gpio_set_value(gpio->gpio, 0);
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index ff46d2c96cea..18a88eb50ad8 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -238,7 +238,7 @@ struct s5k5baf_gpio {
 
 enum s5k5baf_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	NUM_GPIOS,
 };
 
@@ -973,7 +973,7 @@ static int s5k5baf_power_on(struct s5k5baf *state)
 
 	s5k5baf_gpio_deassert(state, STBY);
 	usleep_range(50, 100);
-	s5k5baf_gpio_deassert(state, RST);
+	s5k5baf_gpio_deassert(state, RSET);
 	return 0;
 
 err_reg_dis:
@@ -991,7 +991,7 @@ static int s5k5baf_power_off(struct s5k5baf *state)
 	state->apply_cfg = 0;
 	state->apply_crop = 0;
 
-	s5k5baf_gpio_assert(state, RST);
+	s5k5baf_gpio_assert(state, RSET);
 	s5k5baf_gpio_assert(state, STBY);
 
 	if (!IS_ERR(state->clock))
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 13c10b5e2b45..e9c6e41cd44d 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -181,7 +181,7 @@ static const char * const s5k6aa_supply_names[] = {
 
 enum s5k6aa_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
@@ -845,7 +845,7 @@ static int __s5k6aa_power_on(struct s5k6aa *s5k6aa)
 		ret = s5k6aa->s_power(1);
 	usleep_range(4000, 5000);
 
-	if (s5k6aa_gpio_deassert(s5k6aa, RST))
+	if (s5k6aa_gpio_deassert(s5k6aa, RSET))
 		msleep(20);
 
 	return ret;
@@ -855,7 +855,7 @@ static int __s5k6aa_power_off(struct s5k6aa *s5k6aa)
 {
 	int ret;
 
-	if (s5k6aa_gpio_assert(s5k6aa, RST))
+	if (s5k6aa_gpio_assert(s5k6aa, RSET))
 		usleep_range(100, 150);
 
 	if (s5k6aa->s_power) {
@@ -1514,7 +1514,7 @@ static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa,
 	int ret;
 
 	s5k6aa->gpio[STBY].gpio = -EINVAL;
-	s5k6aa->gpio[RST].gpio  = -EINVAL;
+	s5k6aa->gpio[RSET].gpio  = -EINVAL;
 
 	gpio = &pdata->gpio_stby;
 	if (gpio_is_valid(gpio->gpio)) {
@@ -1537,7 +1537,7 @@ static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa,
 		if (ret < 0)
 			return ret;
 
-		s5k6aa->gpio[RST] = *gpio;
+		s5k6aa->gpio[RSET] = *gpio;
 	}
 
 	return 0;
-- 
2.30.2



