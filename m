Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59B2FE7E9
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKOWeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:10 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46585 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfKOWeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:10 -0500
Received: by mail-pf1-f195.google.com with SMTP id 193so7307194pfc.13
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RCAvV+63fHypoFXOnsyRxH4xHTzRyP2HC/taWojKmLE=;
        b=cMafIXdS6g1uj9flwmN+t7PFzSGyqKH/b0cq+G1THxzoFk+UYaUMhkK+sCXvoR+FRO
         T/JwOcWSRAaDWyQpMyfm6t8Zb6xoOLE3pEo2VEaHnfKiwlYUUFO3RDSGQagkVZ+iwFjP
         wmmcuLiR+iKDMK2bzVS9A3BLyV6YTliwZCITCbOSSg1eQn5ZOIEhEWr/kh5vqAomZ4ZQ
         cgRA8eugzOEYPUvEM8fNYj8/Yg/ARhoLFq31/vgr7hZNUdFh2ItkshREq+pM+lKJazBg
         bqbGPI4XSYbM8QdMhxpjnWpQ3YJz8+9wR7dpzxgu9Pvr/+j05k3lwfNTVW/WugA3V86p
         o+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RCAvV+63fHypoFXOnsyRxH4xHTzRyP2HC/taWojKmLE=;
        b=NKhbsCwsA0vVrspHL7b6/x16WKTwh0ItPI9ggp/+Fa2k6Bd7+X8+H3EnE8eAVuQwHD
         D8ocZjC+driMXl0M7fg2Xrg6M3Sp0KSCmKsaRfSVwDlU+FwqkAidn0a7XkqihdLPuKUs
         NBicYlTnYCt2SAYqvkV0inWR51Si772l/L3ikiwSJXDRypvfz7P03uQaT/KPy/ukKh7O
         OrVmdZol3xSLXaRv3QUdNy80p62PXRrnvLD482if8tgue9WnckUjgksGC+HhnSenOpbw
         W+IdqTCnhzDGXv+7BaugpjNiJrHkz2JmwMeTL2oZV0lGewf7ezX8xRt9fy2onTboxVDU
         J3oQ==
X-Gm-Message-State: APjAAAWVZ76nLotaG78ya5+DnFpe8GCE+In9iqiElWaqbVt9LYLL6xhM
        sUyCLJs0/zLA3e5isrbtObkhvMF1hJY=
X-Google-Smtp-Source: APXvYqw4qvK8le8SxLbnkh5RF54RDhXA5UUgg6LQQZAv/fDVCg5l5miSaDJNYjoAmSiE4kYzPg4uSQ==
X-Received: by 2002:a62:1914:: with SMTP id 20mr19374168pfz.68.1573857249524;
        Fri, 15 Nov 2019 14:34:09 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:09 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 14/20] pinctrl: stm32: fix memory leak issue
Date:   Fri, 15 Nov 2019 15:33:50 -0700
Message-Id: <20191115223356.27675-14-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

commit cd8c9b5a49576bf28990237715bc2cb2210ac80a upstream

configs is allocated by pinconf_generic_parse_dt_config(),
pinctrl_utils_add_map_configs() duplicates configs so it can and has to
be freed to prevent memory leaks.

Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index a9bec6e6fdd1..14dfbbd6c1c3 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -410,7 +410,7 @@ static int stm32_pctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	unsigned int num_configs;
 	bool has_config = 0;
 	unsigned reserve = 0;
-	int num_pins, num_funcs, maps_per_pin, i, err;
+	int num_pins, num_funcs, maps_per_pin, i, err = 0;
 
 	pctl = pinctrl_dev_get_drvdata(pctldev);
 
@@ -437,41 +437,45 @@ static int stm32_pctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 	if (has_config && num_pins >= 1)
 		maps_per_pin++;
 
-	if (!num_pins || !maps_per_pin)
-		return -EINVAL;
+	if (!num_pins || !maps_per_pin) {
+		err = -EINVAL;
+		goto exit;
+	}
 
 	reserve = num_pins * maps_per_pin;
 
 	err = pinctrl_utils_reserve_map(pctldev, map,
 			reserved_maps, num_maps, reserve);
 	if (err)
-		return err;
+		goto exit;
 
 	for (i = 0; i < num_pins; i++) {
 		err = of_property_read_u32_index(node, "pinmux",
 				i, &pinfunc);
 		if (err)
-			return err;
+			goto exit;
 
 		pin = STM32_GET_PIN_NO(pinfunc);
 		func = STM32_GET_PIN_FUNC(pinfunc);
 
 		if (!stm32_pctrl_is_function_valid(pctl, pin, func)) {
 			dev_err(pctl->dev, "invalid function.\n");
-			return -EINVAL;
+			err = -EINVAL;
+			goto exit;
 		}
 
 		grp = stm32_pctrl_find_group_by_pin(pctl, pin);
 		if (!grp) {
 			dev_err(pctl->dev, "unable to match pin %d to group\n",
 					pin);
-			return -EINVAL;
+			err = -EINVAL;
+			goto exit;
 		}
 
 		err = stm32_pctrl_dt_node_to_map_func(pctl, pin, func, grp, map,
 				reserved_maps, num_maps);
 		if (err)
-			return err;
+			goto exit;
 
 		if (has_config) {
 			err = pinctrl_utils_add_map_configs(pctldev, map,
@@ -479,11 +483,13 @@ static int stm32_pctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 					configs, num_configs,
 					PIN_MAP_TYPE_CONFIGS_GROUP);
 			if (err)
-				return err;
+				goto exit;
 		}
 	}
 
-	return 0;
+exit:
+	kfree(configs);
+	return err;
 }
 
 static int stm32_pctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
-- 
2.17.1

