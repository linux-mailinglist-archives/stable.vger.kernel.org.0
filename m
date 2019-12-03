Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C00111DF7
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfLCW6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:58:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730439AbfLCW6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C5320865;
        Tue,  3 Dec 2019 22:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413920;
        bh=4ex08+r/cuDKAQl9zddzX8LKdo5LBQJF5e9YP3pFHno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy+EMCwuwFsO23VTjNX6WtjfIGc+QvJzZOBK3v55HOpvD3l/519C3J3XBURo+4Tmq
         /cW0D/GhL8ZOKkVK+kUJOeSXg6vgNr7UXdC/pyujWX1gkHCjHZRQlHVjvVUW1rp+ys
         FJMeQym9szj9fwj/vYCxYl+NzuSFjoSrj8uUTLaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandre Torgue <alexandre.torgue@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.19 314/321] pinctrl: stm32: fix memory leak issue
Date:   Tue,  3 Dec 2019 23:36:20 +0100
Message-Id: <20191203223443.481141861@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@st.com>

commit cd8c9b5a49576bf28990237715bc2cb2210ac80a upstream.

configs is allocated by pinconf_generic_parse_dt_config(),
pinctrl_utils_add_map_configs() duplicates configs so it can and has to
be freed to prevent memory leaks.

Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/stm32/pinctrl-stm32.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -410,7 +410,7 @@ static int stm32_pctrl_dt_subnode_to_map
 	unsigned int num_configs;
 	bool has_config = 0;
 	unsigned reserve = 0;
-	int num_pins, num_funcs, maps_per_pin, i, err;
+	int num_pins, num_funcs, maps_per_pin, i, err = 0;
 
 	pctl = pinctrl_dev_get_drvdata(pctldev);
 
@@ -437,41 +437,45 @@ static int stm32_pctrl_dt_subnode_to_map
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
@@ -479,11 +483,13 @@ static int stm32_pctrl_dt_subnode_to_map
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


