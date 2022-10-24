Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B031C60B958
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiJXUJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbiJXUJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:09:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060509939C;
        Mon, 24 Oct 2022 11:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A83AD612A1;
        Mon, 24 Oct 2022 12:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9293C433D6;
        Mon, 24 Oct 2022 12:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615663;
        bh=ihLTuvpV7fDfB9cdHCvDyrLZholIYyBFIIbqcDNjvCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoVefmCdjfusKEhg3FiYFm1z0XjNGQZl3JPqT4ad4rx9cKb2MORwFWo83PNwfZHdr
         jeQncaILzdiHd2Wtcw2rpkynzpjskMeTuuVJMgerFAeAxDn0gqfEs4JWqzlCNF+rzy
         8iAUemDqC7QCL2z3ZSlzXx14Kv69MguyeF/M4d8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/530] clk: qcom: apss-ipq6018: mark apcs_alias0_core_clk as critical
Date:   Mon, 24 Oct 2022 13:31:21 +0200
Message-Id: <20221024113100.255301647@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 86e78995c93ee182433f965babfccd48417d4dcf ]

While fixing up the driver I noticed that my IPQ8074 board was hanging
after CPUFreq switched the frequency during boot, WDT would eventually
reset it.

So mark apcs_alias0_core_clk as critical since its the clock feeding the
CPU cluster and must never be disabled.

Fixes: 5e77b4ef1b19 ("clk: qcom: Add ipq6018 apss clock controller")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220818220628.339366-3-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/apss-ipq6018.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/apss-ipq6018.c
+++ b/drivers/clk/qcom/apss-ipq6018.c
@@ -57,7 +57,7 @@ static struct clk_branch apcs_alias0_cor
 			.parent_hws = (const struct clk_hw *[]){
 				&apcs_alias0_clk_src.clkr.hw },
 			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
+			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},


