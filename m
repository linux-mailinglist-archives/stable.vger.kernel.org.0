Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B5E3C524C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243783AbhGLHpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346804AbhGLHmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9619761107;
        Mon, 12 Jul 2021 07:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075590;
        bh=il2SBpFi5PFaRU9QMo5BZnr6zgSfsdzYsFYM4E0opTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxOTNWKRoVjmAW3oungUltzvyHathdH7p8B5g6XUCuGH9e/te2S3rF5vRhW94AUf0
         1aQhg0khr6Wn2bNeVfeedHuUf0Jhgox797M7B1K0GhyLw/wE/DCjb556DBCo5Vc10r
         oppHr8+kLQm4dKYdUdvoGNPdF8ZeCGNfYgcpGRdg=
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
Subject: [PATCH 5.13 278/800] media: I2C: change RST to "RSET" to fix multiple build errors
Date:   Mon, 12 Jul 2021 08:05:01 +0200
Message-Id: <20210712060954.009049726@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 5b4c4a3547c9..71804a70bc6d 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1386,7 +1386,7 @@ static int __s5c73m3_power_on(struct s5c73m3 *state)
 	s5c73m3_gpio_deassert(state, STBY);
 	usleep_range(100, 200);
 
-	s5c73m3_gpio_deassert(state, RST);
+	s5c73m3_gpio_deassert(state, RSET);
 	usleep_range(50, 100);
 
 	return 0;
@@ -1401,7 +1401,7 @@ static int __s5c73m3_power_off(struct s5c73m3 *state)
 {
 	int i, ret;
 
-	if (s5c73m3_gpio_assert(state, RST))
+	if (s5c73m3_gpio_assert(state, RSET))
 		usleep_range(10, 50);
 
 	if (s5c73m3_gpio_assert(state, STBY))
@@ -1606,7 +1606,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 
 		state->mclk_frequency = pdata->mclk_frequency;
 		state->gpio[STBY] = pdata->gpio_stby;
-		state->gpio[RST] = pdata->gpio_reset;
+		state->gpio[RSET] = pdata->gpio_reset;
 		return 0;
 	}
 
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3.h b/drivers/media/i2c/s5c73m3/s5c73m3.h
index ef7e85b34263..c3fcfdd3ea66 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3.h
+++ b/drivers/media/i2c/s5c73m3/s5c73m3.h
@@ -353,7 +353,7 @@ struct s5c73m3_ctrls {
 
 enum s5c73m3_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index b2d53417badf..4e97309a67f4 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -173,7 +173,7 @@ static const char * const s5k4ecgx_supply_names[] = {
 
 enum s5k4ecgx_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
@@ -476,7 +476,7 @@ static int __s5k4ecgx_power_on(struct s5k4ecgx *priv)
 	if (s5k4ecgx_gpio_set_value(priv, STBY, priv->gpio[STBY].level))
 		usleep_range(30, 50);
 
-	if (s5k4ecgx_gpio_set_value(priv, RST, priv->gpio[RST].level))
+	if (s5k4ecgx_gpio_set_value(priv, RSET, priv->gpio[RSET].level))
 		usleep_range(30, 50);
 
 	return 0;
@@ -484,7 +484,7 @@ static int __s5k4ecgx_power_on(struct s5k4ecgx *priv)
 
 static int __s5k4ecgx_power_off(struct s5k4ecgx *priv)
 {
-	if (s5k4ecgx_gpio_set_value(priv, RST, !priv->gpio[RST].level))
+	if (s5k4ecgx_gpio_set_value(priv, RSET, !priv->gpio[RSET].level))
 		usleep_range(30, 50);
 
 	if (s5k4ecgx_gpio_set_value(priv, STBY, !priv->gpio[STBY].level))
@@ -872,7 +872,7 @@ static int s5k4ecgx_config_gpios(struct s5k4ecgx *priv,
 	int ret;
 
 	priv->gpio[STBY].gpio = -EINVAL;
-	priv->gpio[RST].gpio  = -EINVAL;
+	priv->gpio[RSET].gpio  = -EINVAL;
 
 	ret = s5k4ecgx_config_gpio(gpio->gpio, gpio->level, "S5K4ECGX_STBY");
 
@@ -891,7 +891,7 @@ static int s5k4ecgx_config_gpios(struct s5k4ecgx *priv,
 		s5k4ecgx_free_gpios(priv);
 		return ret;
 	}
-	priv->gpio[RST] = *gpio;
+	priv->gpio[RSET] = *gpio;
 	if (gpio_is_valid(gpio->gpio))
 		gpio_set_value(gpio->gpio, 0);
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 6e702b57c37d..bc560817e504 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -235,7 +235,7 @@ struct s5k5baf_gpio {
 
 enum s5k5baf_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	NUM_GPIOS,
 };
 
@@ -969,7 +969,7 @@ static int s5k5baf_power_on(struct s5k5baf *state)
 
 	s5k5baf_gpio_deassert(state, STBY);
 	usleep_range(50, 100);
-	s5k5baf_gpio_deassert(state, RST);
+	s5k5baf_gpio_deassert(state, RSET);
 	return 0;
 
 err_reg_dis:
@@ -987,7 +987,7 @@ static int s5k5baf_power_off(struct s5k5baf *state)
 	state->apply_cfg = 0;
 	state->apply_crop = 0;
 
-	s5k5baf_gpio_assert(state, RST);
+	s5k5baf_gpio_assert(state, RSET);
 	s5k5baf_gpio_assert(state, STBY);
 
 	if (!IS_ERR(state->clock))
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 038e38500760..e9be7323a22e 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -177,7 +177,7 @@ static const char * const s5k6aa_supply_names[] = {
 
 enum s5k6aa_gpio_id {
 	STBY,
-	RST,
+	RSET,
 	GPIO_NUM,
 };
 
@@ -841,7 +841,7 @@ static int __s5k6aa_power_on(struct s5k6aa *s5k6aa)
 		ret = s5k6aa->s_power(1);
 	usleep_range(4000, 5000);
 
-	if (s5k6aa_gpio_deassert(s5k6aa, RST))
+	if (s5k6aa_gpio_deassert(s5k6aa, RSET))
 		msleep(20);
 
 	return ret;
@@ -851,7 +851,7 @@ static int __s5k6aa_power_off(struct s5k6aa *s5k6aa)
 {
 	int ret;
 
-	if (s5k6aa_gpio_assert(s5k6aa, RST))
+	if (s5k6aa_gpio_assert(s5k6aa, RSET))
 		usleep_range(100, 150);
 
 	if (s5k6aa->s_power) {
@@ -1510,7 +1510,7 @@ static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa,
 	int ret;
 
 	s5k6aa->gpio[STBY].gpio = -EINVAL;
-	s5k6aa->gpio[RST].gpio  = -EINVAL;
+	s5k6aa->gpio[RSET].gpio  = -EINVAL;
 
 	gpio = &pdata->gpio_stby;
 	if (gpio_is_valid(gpio->gpio)) {
@@ -1533,7 +1533,7 @@ static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa,
 		if (ret < 0)
 			return ret;
 
-		s5k6aa->gpio[RST] = *gpio;
+		s5k6aa->gpio[RSET] = *gpio;
 	}
 
 	return 0;
-- 
2.30.2



