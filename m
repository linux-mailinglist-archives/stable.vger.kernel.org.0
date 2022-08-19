Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB87599FA0
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350955AbiHSQCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351291AbiHSQBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CEF10A767;
        Fri, 19 Aug 2022 08:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50607CE26B6;
        Fri, 19 Aug 2022 15:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413C3C433C1;
        Fri, 19 Aug 2022 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924356;
        bh=qVDrBSzVaPi+3Q9Qz4aFGHejuAGKOQ9q8ZjK5k3N9wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZARfBAiogdq/xuOKigGxSIN5VdO9je8I1Z2rDV9wuPp0ZaOhkU4Mu0G07M9zUCcW4
         Zto6mhv78g1e4Ud9a7T/cLCJ0Jyi4VWla1V4XmCCyskqxkNt5mslt/+gsFJecNK09u
         KZYy/lkHm0gH15foppIkrVNvdpkOu0iU00x0GHGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/545] regulator: of: Fix refcount leak bug in of_get_regulation_constraints()
Date:   Fri, 19 Aug 2022 17:38:33 +0200
Message-Id: <20220819153835.726466630@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 66efb665cd5ad69b27dca8571bf89fc6b9c628a4 ]

We should call the of_node_put() for the reference returned by
of_get_child_by_name() which has increased the refcount.

Fixes: 40e20d68bb3f ("regulator: of: Add support for parsing regulator_state for suspend state")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220715111027.391032-1-windhl@126.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 06c0b15fe4c0..5d844697c7b6 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -206,8 +206,12 @@ static int of_get_regulation_constraints(struct device *dev,
 		}
 
 		suspend_np = of_get_child_by_name(np, regulator_states[i]);
-		if (!suspend_np || !suspend_state)
+		if (!suspend_np)
 			continue;
+		if (!suspend_state) {
+			of_node_put(suspend_np);
+			continue;
+		}
 
 		if (!of_property_read_u32(suspend_np, "regulator-mode",
 					  &pval)) {
-- 
2.35.1



