Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2FA10CD26
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfK1Qun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:50:43 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46813 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfK1QuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:50:17 -0500
Received: by mail-pg1-f195.google.com with SMTP id k1so4771167pga.13
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 08:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nEtPBscm61+nPEVWvbJjdtfKlHF1+Tw29QLFNNlqSXc=;
        b=Jq5l6POXhKBLihg38Usaui6t0nqV5sQvbWbI6rSgNIYk6n8WGDMMVkP1LG1/2x4qCG
         UCyeQoB/AbodwEeK9haGNGeVGO8BzgnQuR/VI/1+k7mg0XhxfCHBQ2Jew9pOj0wEvAwy
         2WnWtwe73c5FU0NnojZiurA8804vygmxVRyse2+b5ZsZ7WpuLU2PEcTZyZGnx12XnU6r
         Cmmwe5RWxdl12kf8dT8BkmTrdBhlYSRqHUThpLcxcOwXlRELSCzdl/hd9EzIozpCZQzy
         eRYJ+rCcOw9gzunEYkOpG2M7cv3cPrz3S8v7jfLhGslUmsAe6+SS9DEnP4dTHmNwFXTb
         sW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nEtPBscm61+nPEVWvbJjdtfKlHF1+Tw29QLFNNlqSXc=;
        b=B6rCxL3ng+mCqGXvz66depga2RiKIKN5mdWSEVMHZg6xWOtT0smVMMq6pDyCEpmmwr
         loHTvKCFe8Ik4vy2ddbIWzo3la9eVjeFF5ECoO5DPbqMGLMz1c3HTM2wCt6QUA8Xcp1Z
         L5T5MMQZ1JbSKPR+eMRmwLGb7WocaVwiN9AqJZxvTgRTke6z6Wt/0PGuLjfQCRih0QSu
         PQe/rIY+8EjhAuxoAlsM8v9lxFqI4xSYz30JotpIhSA4FtD9SOAx8kH0xuAKZydMl8Up
         p7ZUidRLyUrzb7uniAhbTTjEMP2wlkovXFietxyMnpKv4R6+wqz4TXu7Ksz9saLxU+LN
         rEFA==
X-Gm-Message-State: APjAAAX0pXcaJfg5lLQADBiZhwSWsuSodeZA1WIuXCX1CvQngerH/1BQ
        TqLK6JnsIxb+EnNCdmXlA78/tdE6Tgs=
X-Google-Smtp-Source: APXvYqwNdeqTwkb0h/ndd1EIs2BFrMN77BDNUueQ03UK/DdSGN5qX3NDPdyxhT5N5ic6H78Oc/vxeQ==
X-Received: by 2002:a63:5017:: with SMTP id e23mr12224287pgb.32.1574959815274;
        Thu, 28 Nov 2019 08:50:15 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id a15sm2450343pfh.169.2019.11.28.08.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 08:50:14 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 12/17] pinctrl: stm32: fix memory leak issue
Date:   Thu, 28 Nov 2019 09:49:57 -0700
Message-Id: <20191128165002.6234-13-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128165002.6234-1-mathieu.poirier@linaro.org>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
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
Cc: stable <stable@vger.kernel.org> # 4.19
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

