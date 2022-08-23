Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FDD59E32B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiHWMSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351583AbiHWMO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:14:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65D898C99;
        Tue, 23 Aug 2022 02:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E121CE1B66;
        Tue, 23 Aug 2022 09:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9480EC433D6;
        Tue, 23 Aug 2022 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247549;
        bh=osf53EroZCz/s8yUtx8kUiASllsEgsWNQw87FBJd2e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUOf6eaRGFZxrhmI8yUJsWoB4dupQyO0Q59KBWizZhA2+fBzYoTNmrgtwOS/HKWw1
         42AlOCmqOVUdzvUIZzSRriINgiVosOlhLveyJylSGZK5rdymnCOKamz219b+qAjOpp
         piyfhMgQXpNaD3HAs3/eTn8ieIXVIQxecl71R75I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianhua Lu <lujianhua000@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 042/158] pinctrl: qcom: sm8250: Fix PDC map
Date:   Tue, 23 Aug 2022 10:26:14 +0200
Message-Id: <20220823080047.761588389@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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
 drivers/pinctrl/qcom/pinctrl-sm8250.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sm8250.c b/drivers/pinctrl/qcom/pinctrl-sm8250.c
index af144e724bd9..3bd7f9fedcc3 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8250.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8250.c
@@ -1316,7 +1316,7 @@ static const struct msm_pingroup sm8250_groups[] = {
 static const struct msm_gpio_wakeirq_map sm8250_pdc_map[] = {
 	{ 0, 79 }, { 1, 84 }, { 2, 80 }, { 3, 82 }, { 4, 107 }, { 7, 43 },
 	{ 11, 42 }, { 14, 44 }, { 15, 52 }, { 19, 67 }, { 23, 68 }, { 24, 105 },
-	{ 27, 92 }, { 28, 106 }, { 31, 69 }, { 35, 70 }, { 39, 37 },
+	{ 27, 92 }, { 28, 106 }, { 31, 69 }, { 35, 70 }, { 39, 73 },
 	{ 40, 108 }, { 43, 71 }, { 45, 72 }, { 47, 83 }, { 51, 74 }, { 55, 77 },
 	{ 59, 78 }, { 63, 75 }, { 64, 81 }, { 65, 87 }, { 66, 88 }, { 67, 89 },
 	{ 68, 54 }, { 70, 85 }, { 77, 46 }, { 80, 90 }, { 81, 91 }, { 83, 97 },
-- 
2.37.2



