Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910D859D8E0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242575AbiHWJwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352214AbiHWJvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B7D9F0CC;
        Tue, 23 Aug 2022 01:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B55D6B81C28;
        Tue, 23 Aug 2022 08:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EF4C433D6;
        Tue, 23 Aug 2022 08:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244283;
        bh=1uZf0x+togNFly4eR+qOBeUyoGt1699gwYKKUkpYrlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n1Qk4EHNPUSdyvbEpv33273shqC/lgwMeKDApKsbGEihwDok+nm7zcOGDTLyRMN5J
         gB8KVvEiWppNmvMFZXxpplxUQu0S45dxkUnFFrocNjo3zoFts2sD78AyfSfAZmqq3s
         TI8UopI328gOxnIMljddhVpnQ3gNpBk0F8AWLIu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianhua Lu <lujianhua000@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 067/244] pinctrl: qcom: sm8250: Fix PDC map
Date:   Tue, 23 Aug 2022 10:23:46 +0200
Message-Id: <20220823080101.317608660@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Jianhua Lu <lujianhua000@gmail.com>

commit 4b759ca15a4914f96ea204ea9200ceeb01d70666 upstream.

Fix the PDC mapping for SM8250, gpio39 is mapped to irq73(not irq37).

Fixes: b41efeed507a("pinctrl: qcom: sm8250: Specify PDC map.")
Signed-off-by: Jianhua Lu <lujianhua000@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20220803015645.22388-1-lujianhua000@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-sm8250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/qcom/pinctrl-sm8250.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8250.c
@@ -1316,7 +1316,7 @@ static const struct msm_pingroup sm8250_
 static const struct msm_gpio_wakeirq_map sm8250_pdc_map[] = {
 	{ 0, 79 }, { 1, 84 }, { 2, 80 }, { 3, 82 }, { 4, 107 }, { 7, 43 },
 	{ 11, 42 }, { 14, 44 }, { 15, 52 }, { 19, 67 }, { 23, 68 }, { 24, 105 },
-	{ 27, 92 }, { 28, 106 }, { 31, 69 }, { 35, 70 }, { 39, 37 },
+	{ 27, 92 }, { 28, 106 }, { 31, 69 }, { 35, 70 }, { 39, 73 },
 	{ 40, 108 }, { 43, 71 }, { 45, 72 }, { 47, 83 }, { 51, 74 }, { 55, 77 },
 	{ 59, 78 }, { 63, 75 }, { 64, 81 }, { 65, 87 }, { 66, 88 }, { 67, 89 },
 	{ 68, 54 }, { 70, 85 }, { 77, 46 }, { 80, 90 }, { 81, 91 }, { 83, 97 },


