Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E00594DC8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244047AbiHPAb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346094AbiHPAaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:30:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248A518524C;
        Mon, 15 Aug 2022 13:35:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F530B80EA9;
        Mon, 15 Aug 2022 20:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD18CC433D6;
        Mon, 15 Aug 2022 20:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595753;
        bh=nrWhq4iCZ7BN31NlTgoGvArbe2SU4K8P3fMYiYDV4vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0U3H527qS3zHVQ8t4wNhl3cOL6ZIMUK6/Q5Bfd2PU9SfTKpkHYXLuCuJwo85IzyPf
         dfD8Wj62BJVvNVeT+Ylb89MHTI52+JP8lNUA/sfJ5NIZjn1mhO5R6vrrppU7hwmQMj
         CSardgsrzzPGRDfpgsDPbLm+LROQo6Yo3YruaFtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0831/1157] clk: qcom: gdsc: Bump parent usage count when GDSC is found enabled
Date:   Mon, 15 Aug 2022 20:03:07 +0200
Message-Id: <20220815180512.735356534@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 41fff779d7948147f2440c4bb134cdf8b45b22d7 ]

When a GDSC is found to be enabled at boot the pm_runtime state will
be unbalanced as the GDSC is later turned off. Fix this by increasing
the usage counter on the power-domain, in line with how we handled the
regulator state.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20220713212818.130277-1-bjorn.andersson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index 44520efc6c72..2db0938f8dd3 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -420,6 +420,14 @@ static int gdsc_init(struct gdsc *sc)
 				return ret;
 		}
 
+		/* ...and the power-domain */
+		ret = gdsc_pm_runtime_get(sc);
+		if (ret) {
+			if (sc->rsupply)
+				regulator_disable(sc->rsupply);
+			return ret;
+		}
+
 		/*
 		 * Votable GDSCs can be ON due to Vote from other masters.
 		 * If a Votable GDSC is ON, make sure we have a Vote.
-- 
2.35.1



