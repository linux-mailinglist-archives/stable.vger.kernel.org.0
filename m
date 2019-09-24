Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C71BCF6D
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393107AbfIXQ4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441469AbfIXQtZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:49:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A10A221D7E;
        Tue, 24 Sep 2019 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343764;
        bh=VZnmPg5IckIkj42+lltGSiTdBTdV0VvKLXMECgyNU+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4vUa/Zgt5IJQSJ95Pp00Zf9t6ztsjDXatCPe7YtojWCNvsbHoRbnVFWP9INr3hDL
         JSJq7l8qm6xA2Cq+TXGR9vEiYeVeAxZxZjml8o50qkqWT44JDIDqCEvwbSiKnLkOdV
         Od/ZsfIU3OMEBm0cKW2LjNItglwJb0llSRbEEQ10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Boyd <sboyd@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/50] clk: actions: Don't reference clk_init_data after registration
Date:   Tue, 24 Sep 2019 12:48:16 -0400
Message-Id: <20190924164847.27780-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit cf9ec1fc6d7cceb73e7f1efd079d2eae173fdf57 ]

A future patch is going to change semantics of clk_register() so that
clk_hw::init is guaranteed to be NULL after a clk is registered. Avoid
referencing this member here so that we don't run into NULL pointer
exceptions.

Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20190731193517.237136-2-sboyd@kernel.org
[sboyd@kernel.org: Move name to after checking for error or NULL hw]
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/actions/owl-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/actions/owl-common.c b/drivers/clk/actions/owl-common.c
index 61c1071b5180a..e9be34b17f3f5 100644
--- a/drivers/clk/actions/owl-common.c
+++ b/drivers/clk/actions/owl-common.c
@@ -67,16 +67,17 @@ int owl_clk_probe(struct device *dev, struct clk_hw_onecell_data *hw_clks)
 	struct clk_hw *hw;
 
 	for (i = 0; i < hw_clks->num; i++) {
+		const char *name;
 
 		hw = hw_clks->hws[i];
-
 		if (IS_ERR_OR_NULL(hw))
 			continue;
 
+		name = hw->init->name;
 		ret = devm_clk_hw_register(dev, hw);
 		if (ret) {
 			dev_err(dev, "Couldn't register clock %d - %s\n",
-				i, hw->init->name);
+				i, name);
 			return ret;
 		}
 	}
-- 
2.20.1

