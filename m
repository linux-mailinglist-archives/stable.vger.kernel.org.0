Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E23A595070
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiHPEmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiHPEkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0914D330;
        Mon, 15 Aug 2022 13:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98CB461089;
        Mon, 15 Aug 2022 20:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FA8C433C1;
        Mon, 15 Aug 2022 20:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595530;
        bh=Bd7fE8Kt4aaU6LVNR5gCH5ownrgcWeBzvZ5qrcrnwI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSUHK1e3hQbguiifx3Sr4nR0lmhmvoyRGD9qm17Ck7iPuvsnyu02NkVcx5E1T5vT0
         YcO+i8mBeYfauKhJQeZindKYAHZ/gAC3ToBeK8k6ipRJiPu27vHhMoNh2gfvVHOLnc
         0CiQlC0nCuorkFicWbTzTF1kddEjs/kC4jCRkIE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikita Travkin <nikita@trvn.ru>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0762/1157] clk: qcom: clk-rcg2: Make sure to not write d=0 to the NMD register
Date:   Mon, 15 Aug 2022 20:01:58 +0200
Message-Id: <20220815180509.964648701@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit d0696770cef35a1fd16ea2167e2198c18aa6fbfe ]

Sometimes calculation of d value may result in 0 because of the
rounding after integer division. This causes the following error:

[  113.969689] camss_gp1_clk_src: rcg didn't update its configuration.
[  113.969754] WARNING: CPU: 3 PID: 35 at drivers/clk/qcom/clk-rcg2.c:122 update_config+0xc8/0xdc

Make sure that D value is never zero.

Fixes: 7f891faf596e ("clk: qcom: clk-rcg2: Add support for duty-cycle for RCG")
Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220612145955.385787-3-nikita@trvn.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 2375e8122012..28019edd2a50 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -13,6 +13,7 @@
 #include <linux/rational.h>
 #include <linux/regmap.h>
 #include <linux/math64.h>
+#include <linux/minmax.h>
 #include <linux/slab.h>
 
 #include <asm/div64.h>
@@ -461,9 +462,11 @@ static int clk_rcg2_set_duty_cycle(struct clk_hw *hw, struct clk_duty *duty)
 	/* Calculate 2d value */
 	d = DIV_ROUND_CLOSEST(n * duty_per * 2, 100);
 
-	 /* Check bit widths of 2d. If D is too big reduce duty cycle. */
-	if (d > mask)
-		d = mask;
+	/*
+	 * Check bit widths of 2d. If D is too big reduce duty cycle.
+	 * Also make sure it is never zero.
+	 */
+	d = clamp_val(d, 1, mask);
 
 	if ((d / 2) > (n - m))
 		d = (n - m) * 2;
-- 
2.35.1



