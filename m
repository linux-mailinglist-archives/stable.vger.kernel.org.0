Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A056088EB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiJVIZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbiJVIY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:24:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5216E4000C;
        Sat, 22 Oct 2022 00:59:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71980B82E2C;
        Sat, 22 Oct 2022 07:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3525C433C1;
        Sat, 22 Oct 2022 07:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425411;
        bh=ihLTuvpV7fDfB9cdHCvDyrLZholIYyBFIIbqcDNjvCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZZdsA+JwsBt2b4VahehVTDo6DK35zmDtTIJRpn2h1y8o4M2VOgF8UCGzVY+Z3ToN
         LWXkZmZUwxMBiJl6f3B3jsAOLGsoCZQ/0rCpuBWkZdKaLssbfIPdsCCq60PT2GIMlP
         xeZnmqcdoyp4jn/3WsdccJFGkWhtZYCF3C/aGHQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robimarko@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 462/717] clk: qcom: apss-ipq6018: mark apcs_alias0_core_clk as critical
Date:   Sat, 22 Oct 2022 09:25:41 +0200
Message-Id: <20221022072518.732027452@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


