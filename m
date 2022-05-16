Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEAA5280A0
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiEPJQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 05:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241864AbiEPJQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 05:16:34 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F090122BD8
        for <stable@vger.kernel.org>; Mon, 16 May 2022 02:16:31 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i10so24585467lfg.13
        for <stable@vger.kernel.org>; Mon, 16 May 2022 02:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YtsGQypIAViopoYzHifgjhQ7LfkQrx2vEG1boAc+HPU=;
        b=kEsPT1AbY0PwOUERQxkG/RWh2QZQTzHttEf2IINRMqoILIbaOwykgbDPzlYa5Fp/YS
         lApXjekjZixuCk/wGwH4QbjjvHYZxL26uLEh4/DICaw12oKzk/p1UM05U8/sQ8GdvYB9
         YBgXsInvc0uUt94l4SK62mly05LKK/9CCH/ZwqiLuDkk0/16p/ZX38t21cvle3iqL2dr
         94nO6zaiABAjYdQ4oGFgxbmmuIZBgiZepgIh5NM6GDZjtvqiQBz6wmY6wYH45BtF9Boa
         2stdr4XSnPB89r3Ob2iJ6AF5D0E99VwJmXJj1RQf85uaaGVY5PEh+NHOd9PX46b8ZD8e
         j4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YtsGQypIAViopoYzHifgjhQ7LfkQrx2vEG1boAc+HPU=;
        b=n7EIg28/E5o9mPNMv1PielIykw6fLVO43DMRJHKWG3C18x5GU1SxiFeHrMC7c6yYwG
         Zy5NEPiygQP2je073DqknZbe5HCDdEGyF1lbvotFr8rlSzQ2YpP84kOscCGEIR7IcF2J
         RwhZlnseXtVOLoYpCJxrvdPPG+HFkxokgSK6o7Hv00mU3q6FRgttYTBFIa4figGa+UUj
         x6kJJKFkhQyCgN+bylHPLyuFzVp5Y/noSQVyITNFDVxcJ4uKM/i/ASadj2fG31DeP3sf
         xPKJ77g4qwJflhpO2Pdk5/7tXv9W5CAlIl2SYPtmQVr/PZqelu9OcNGP5/WlZ4iVRmTz
         dzbw==
X-Gm-Message-State: AOAM531Sk7lRLd0H1OZVZZI38klqQY5OJVeAw8L/7F/mZXE+5hcLt9Jl
        A2wl0Qo9+Gb0DeR0qviNWietJQ==
X-Google-Smtp-Source: ABdhPJwx7w09+cwemCsM2VoYbPtntL8dgFRwE2dglk/1iBkv+l5wV9EGQEyqqT7K08/szaSzTWKkpA==
X-Received: by 2002:a05:6512:33a7:b0:473:ea35:e1d6 with SMTP id i7-20020a05651233a700b00473ea35e1d6mr12771652lfg.369.1652692590276;
        Mon, 16 May 2022 02:16:30 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id t6-20020a056512208600b0047255d21145sm1251798lfr.116.2022.05.16.02.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 02:16:29 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: [PATCH] usb: isp1760: Fix out-of-bounds array access
Date:   Mon, 16 May 2022 11:14:24 +0200
Message-Id: <20220516091424.391209-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Running the driver through kasan gives an interesting splat:

  BUG: KASAN: global-out-of-bounds in isp1760_register+0x180/0x70c
  Read of size 20 at addr f1db2e64 by task swapper/0/1
  (...)
  isp1760_register from isp1760_plat_probe+0x1d8/0x220
  (...)

This happens because the loop reading the regmap fields for the
different ISP1760 variants look like this:

  for (i = 0; i < HC_FIELD_MAX; i++) { ... }

Meaning it expects the arrays to be at least HC_FIELD_MAX - 1 long.

However the arrays isp1760_hc_reg_fields[], isp1763_hc_reg_fields[],
isp1763_hc_volatile_ranges[] and isp1763_dc_volatile_ranges[] are
dynamically sized during compilation.

Fix this by putting an empty assignment to the [HC_FIELD_MAX]
and [DC_FIELD_MAX] array member at the end of each array.
This will make the array one member longer than it needs to be,
but avoids the risk of overwriting whatever is inside
[HC_FIELD_MAX - 1] and is simple and intuitive to read. Also
add comments explaining what is going on.

Fixes: 1da9e1c06873 ("usb: isp1760: move to regmap for register access")
Cc: stable@vger.kernel.org
Cc: Rui Miguel Silva <rui.silva@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Found while testing to compile the Vexpress kernel into the
vmalloc area in some experimental patches, curiously it did not
manifest before, I guess we were lucky with padding
etc.
---
 drivers/usb/isp1760/isp1760-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/isp1760/isp1760-core.c b/drivers/usb/isp1760/isp1760-core.c
index d1d9a7d5da17..af88f4fe00d2 100644
--- a/drivers/usb/isp1760/isp1760-core.c
+++ b/drivers/usb/isp1760/isp1760-core.c
@@ -251,6 +251,8 @@ static const struct reg_field isp1760_hc_reg_fields[] = {
 	[HW_DM_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 2, 2),
 	[HW_DP_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 1, 1),
 	[HW_DP_PULLUP]		= REG_FIELD(ISP176x_HC_OTG_CTRL, 0, 0),
+	/* Make sure the array is sized properly during compilation */
+	[HC_FIELD_MAX]		= {},
 };
 
 static const struct reg_field isp1763_hc_reg_fields[] = {
@@ -321,6 +323,8 @@ static const struct reg_field isp1763_hc_reg_fields[] = {
 	[HW_DM_PULLDOWN_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 2, 2),
 	[HW_DP_PULLDOWN_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 1, 1),
 	[HW_DP_PULLUP_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 0, 0),
+	/* Make sure the array is sized properly during compilation */
+	[HC_FIELD_MAX]		= {},
 };
 
 static const struct regmap_range isp1763_hc_volatile_ranges[] = {
@@ -405,6 +409,8 @@ static const struct reg_field isp1761_dc_reg_fields[] = {
 	[DC_CHIP_ID_HIGH]	= REG_FIELD(ISP176x_DC_CHIPID, 16, 31),
 	[DC_CHIP_ID_LOW]	= REG_FIELD(ISP176x_DC_CHIPID, 0, 15),
 	[DC_SCRATCH]		= REG_FIELD(ISP176x_DC_SCRATCH, 0, 15),
+	/* Make sure the array is sized properly during compilation */
+	[DC_FIELD_MAX]		= {},
 };
 
 static const struct regmap_range isp1763_dc_volatile_ranges[] = {
@@ -458,6 +464,8 @@ static const struct reg_field isp1763_dc_reg_fields[] = {
 	[DC_CHIP_ID_HIGH]	= REG_FIELD(ISP1763_DC_CHIPID_HIGH, 0, 15),
 	[DC_CHIP_ID_LOW]	= REG_FIELD(ISP1763_DC_CHIPID_LOW, 0, 15),
 	[DC_SCRATCH]		= REG_FIELD(ISP1763_DC_SCRATCH, 0, 15),
+	/* Make sure the array is sized properly during compilation */
+	[DC_FIELD_MAX]		= {},
 };
 
 static const struct regmap_config isp1763_dc_regmap_conf = {
-- 
2.35.1

