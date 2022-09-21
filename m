Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CFD5C020D
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbiIUPr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiIUPq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:46:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7952E83076;
        Wed, 21 Sep 2022 08:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 247F2B81D87;
        Wed, 21 Sep 2022 15:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E3AC433C1;
        Wed, 21 Sep 2022 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775214;
        bh=/2HbVTivqEb46PK8RhHXOVNhUdA6SbRUkyqJhXgxkCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+sL6qqrZv7t+H4c1SDJzrRIpS+E25LqQFU0NS3bt3OcgmPYOCbt9WjiqSAXKky5/
         1gE0rm7s0btSUmL/yYow4hJk9wjCZFyG4TO4OCgE4ucw4nKh0C/f4XVAISGGk/wr7b
         0P0NlW+VRP8r871+o2TnrZVo7R6dEnETvwJX1p4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Molly Sophia <mollysophia379@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 02/38] pinctrl: qcom: sc8180x: Fix gpio_wakeirq_map
Date:   Wed, 21 Sep 2022 17:45:46 +0200
Message-Id: <20220921153646.379439034@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Molly Sophia <mollysophia379@gmail.com>

[ Upstream commit 6124cec530c7d8faab96d340ab2df5161e5d1c8a ]

Currently in the wakeirq_map, gpio36 and gpio37 have the same wakeirq
number, resulting in gpio37 being unable to trigger interrupts.
It looks like that this is a typo in the wakeirq map. So fix it.

Signed-off-by: Molly Sophia <mollysophia379@gmail.com>
Fixes: 97423113ec4b ("pinctrl: qcom: Add sc8180x TLMM driver")
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220807122645.13830-2-mollysophia379@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sc8180x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sc8180x.c b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
index 6bec7f143134..b4bf009fe23e 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8180x.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
@@ -1582,7 +1582,7 @@ static const int sc8180x_acpi_reserved_gpios[] = {
 static const struct msm_gpio_wakeirq_map sc8180x_pdc_map[] = {
 	{ 3, 31 }, { 5, 32 }, { 8, 33 }, { 9, 34 }, { 10, 100 }, { 12, 104 },
 	{ 24, 37 }, { 26, 38 }, { 27, 41 }, { 28, 42 }, { 30, 39 }, { 36, 43 },
-	{ 37, 43 }, { 38, 45 }, { 39, 118 }, { 39, 125 }, { 41, 47 },
+	{ 37, 44 }, { 38, 45 }, { 39, 118 }, { 39, 125 }, { 41, 47 },
 	{ 42, 48 }, { 46, 50 }, { 47, 49 }, { 48, 51 }, { 49, 53 }, { 50, 52 },
 	{ 51, 116 }, { 51, 123 }, { 53, 54 }, { 54, 55 }, { 55, 56 },
 	{ 56, 57 }, { 58, 58 }, { 60, 60 }, { 68, 62 }, { 70, 63 }, { 76, 86 },
-- 
2.35.1



