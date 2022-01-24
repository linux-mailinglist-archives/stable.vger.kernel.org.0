Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140E849978D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448696AbiAXVNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33946 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447166AbiAXVKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:10:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A13456148B;
        Mon, 24 Jan 2022 21:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EACC340EC;
        Mon, 24 Jan 2022 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058606;
        bh=0uJHedN80f2xLTdruQW7Fj+OFcuWMBzE4MqBNcSaJxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wr8FMdTXPyGbkmagPzh6rL/VaMxXGw8dFIkkaOc9AeMmkedRfmK5TAsYnVNY2mFW5
         i4ncaISXwTJ2k4506V1s19cEXdJFvUXD2mRf2iWcUfRCrf9zLlGylCUS6luZL+GlHv
         48eUzdbbR7OST0ze8zoxPvKiVI8Dm1cAk/l4hSEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0344/1039] backlight: qcom-wled: Validate enabled string indices in DT
Date:   Mon, 24 Jan 2022 19:35:33 +0100
Message-Id: <20220124184136.861020501@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit c05b21ebc5bce3ecc78c2c71afd76d92c790a2ac ]

The strings passed in DT may possibly cause out-of-bounds register
accesses and should be validated before use.

Fixes: 775d2ffb4af6 ("backlight: qcom-wled: Restructure the driver for WLED3")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211115203459.1634079-2-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index d094299c2a485..8a42ed89c59c9 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1528,12 +1528,28 @@ static int wled_configure(struct wled *wled)
 	string_len = of_property_count_elems_of_size(dev->of_node,
 						     "qcom,enabled-strings",
 						     sizeof(u32));
-	if (string_len > 0)
+	if (string_len > 0) {
+		if (string_len > wled->max_string_count) {
+			dev_err(dev, "Cannot have more than %d strings\n",
+				wled->max_string_count);
+			return -EINVAL;
+		}
+
 		of_property_read_u32_array(dev->of_node,
 						"qcom,enabled-strings",
 						wled->cfg.enabled_strings,
 						sizeof(u32));
 
+		for (i = 0; i < string_len; ++i) {
+			if (wled->cfg.enabled_strings[i] >= wled->max_string_count) {
+				dev_err(dev,
+					"qcom,enabled-strings index %d at %d is out of bounds\n",
+					wled->cfg.enabled_strings[i], i);
+				return -EINVAL;
+			}
+		}
+	}
+
 	return 0;
 }
 
-- 
2.34.1



