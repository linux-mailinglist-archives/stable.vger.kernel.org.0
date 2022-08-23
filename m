Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5568F59DE34
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352724AbiHWKKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352720AbiHWKIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:08:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BD26E2CF;
        Tue, 23 Aug 2022 01:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B4EFB81C48;
        Tue, 23 Aug 2022 08:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E4BC43145;
        Tue, 23 Aug 2022 08:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243927;
        bh=drOoGIBMOeRwHmzS4ziAXbQ0TDul30Lkh7ed/X2k6Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7bZ8yo5AO+fJB5yHu/wJE2aT4po1Z+cTg7SjkgnT9U0Wzjk1uYtpptlFPeys6Sz7
         LIoTKlMqx8Y0cF0MxvRFk/kfy6z/uS0XodTU+lvX/g11oXTi+jswm4mz+clsagAezp
         Sc/7k6aaetVm2TXfXOvQrd9xoI88vemY9G8KQZw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 057/229] regulator: of: Fix refcount leak bug in of_get_regulation_constraints()
Date:   Tue, 23 Aug 2022 10:23:38 +0200
Message-Id: <20220823080055.767674846@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index a3bf7c993723..f82b522bffa7 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -158,8 +158,12 @@ static void of_get_regulation_constraints(struct device_node *np,
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



