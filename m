Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146D313FCF5
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390601AbgAPXUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390589AbgAPXUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02DD820684;
        Thu, 16 Jan 2020 23:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216814;
        bh=fXiYfFCIwIIUg6LPoG3LFBYLLvM/DDDTgYBvUbxygTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+QJNazTMIgaoe2QkzxPr5PChRly6QszQhfLlK121+V3uODWH5vk1Ft2xEzsc+7t7
         Qq6L7FodPY6uDbQhw2LektYN/JNR5bL5fUGeqV1WcqH92NSwlpiM5C9LYBtO5UC2un
         Y6Rv4dIKBd6SwTW3gg6r/u/mmSjmKKBcq9mnGuUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 013/203] ASoC: stm32: spdifrx: fix input pin state management
Date:   Fri, 17 Jan 2020 00:15:30 +0100
Message-Id: <20200116231745.999662191@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 3b7658679d88b5628939f9bdc8e613f79cd821f9 upstream.

Changing input state in iec capture control is not safe,
as the pin state may be changed concurrently by ASoC
framework.
Remove pin state handling in iec capture control.

Note: This introduces a restriction on capture control,
when pin sleep state is defined in device tree. In this case
channel status can be captured only when an audio stream
capture is active.

Fixes: f68c2a682d44 ("ASoC: stm32: spdifrx: add power management")

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Link: https://lore.kernel.org/r/20191204154333.7152-4-olivier.moysan@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_spdifrx.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -12,7 +12,6 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
 
@@ -482,8 +481,6 @@ static int stm32_spdifrx_get_ctrl_data(s
 	memset(spdifrx->cs, 0, SPDIFRX_CS_BYTES_NB);
 	memset(spdifrx->ub, 0, SPDIFRX_UB_BYTES_NB);
 
-	pinctrl_pm_select_default_state(&spdifrx->pdev->dev);
-
 	ret = stm32_spdifrx_dma_ctrl_start(spdifrx);
 	if (ret < 0)
 		return ret;
@@ -515,7 +512,6 @@ static int stm32_spdifrx_get_ctrl_data(s
 
 end:
 	clk_disable_unprepare(spdifrx->kclk);
-	pinctrl_pm_select_sleep_state(&spdifrx->pdev->dev);
 
 	return ret;
 }


