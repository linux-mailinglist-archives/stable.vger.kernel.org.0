Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CF354174E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351666AbiFGVC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379051AbiFGVCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A562A188E5F;
        Tue,  7 Jun 2022 11:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D8D76156D;
        Tue,  7 Jun 2022 18:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A753C385A2;
        Tue,  7 Jun 2022 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627576;
        bh=COKzPOsl7kaNsDvx+z01yEVI+nhAt+B84z1IsdH3tzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZir+/tXjmrZPpcl9MkFCJjYUNfBu1SxN2kCGpceY1VdPp0DgQICuVC92MhuS1731
         rYPSMYM4TSvgvBGi1/IKSkWHk7Np97fG0wjm3MnoEFFnOC/ear8KTEuHVd31q4MXPJ
         OltieqgB3Vn5cf8nRbldipQ2RSrRxYNS0LqPTx2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.18 018/879] usb: isp1760: Fix out-of-bounds array access
Date:   Tue,  7 Jun 2022 18:52:16 +0200
Message-Id: <20220607165003.200430319@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 26ae2c942b5702f2e43d36b2a4389cfb7d616b6a upstream.

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
Reviewed-by: Rui Miguel Silva <rui.silva@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220516091424.391209-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/isp1760/isp1760-core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/isp1760/isp1760-core.c
+++ b/drivers/usb/isp1760/isp1760-core.c
@@ -251,6 +251,8 @@ static const struct reg_field isp1760_hc
 	[HW_DM_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 2, 2),
 	[HW_DP_PULLDOWN]	= REG_FIELD(ISP176x_HC_OTG_CTRL, 1, 1),
 	[HW_DP_PULLUP]		= REG_FIELD(ISP176x_HC_OTG_CTRL, 0, 0),
+	/* Make sure the array is sized properly during compilation */
+	[HC_FIELD_MAX]		= {},
 };
 
 static const struct reg_field isp1763_hc_reg_fields[] = {
@@ -321,6 +323,8 @@ static const struct reg_field isp1763_hc
 	[HW_DM_PULLDOWN_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 2, 2),
 	[HW_DP_PULLDOWN_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 1, 1),
 	[HW_DP_PULLUP_CLEAR]	= REG_FIELD(ISP1763_HC_OTG_CTRL_CLEAR, 0, 0),
+	/* Make sure the array is sized properly during compilation */
+	[HC_FIELD_MAX]		= {},
 };
 
 static const struct regmap_range isp1763_hc_volatile_ranges[] = {
@@ -405,6 +409,8 @@ static const struct reg_field isp1761_dc
 	[DC_CHIP_ID_HIGH]	= REG_FIELD(ISP176x_DC_CHIPID, 16, 31),
 	[DC_CHIP_ID_LOW]	= REG_FIELD(ISP176x_DC_CHIPID, 0, 15),
 	[DC_SCRATCH]		= REG_FIELD(ISP176x_DC_SCRATCH, 0, 15),
+	/* Make sure the array is sized properly during compilation */
+	[DC_FIELD_MAX]		= {},
 };
 
 static const struct regmap_range isp1763_dc_volatile_ranges[] = {
@@ -458,6 +464,8 @@ static const struct reg_field isp1763_dc
 	[DC_CHIP_ID_HIGH]	= REG_FIELD(ISP1763_DC_CHIPID_HIGH, 0, 15),
 	[DC_CHIP_ID_LOW]	= REG_FIELD(ISP1763_DC_CHIPID_LOW, 0, 15),
 	[DC_SCRATCH]		= REG_FIELD(ISP1763_DC_SCRATCH, 0, 15),
+	/* Make sure the array is sized properly during compilation */
+	[DC_FIELD_MAX]		= {},
 };
 
 static const struct regmap_config isp1763_dc_regmap_conf = {


