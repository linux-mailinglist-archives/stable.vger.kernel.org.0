Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DB31FE871
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgFRBJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbgFRBJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A569921D7E;
        Thu, 18 Jun 2020 01:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442588;
        bh=2k53BUB6tR7j3zcSfFJF3SuY35bWiRwDUV7sos9HbBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cL6t3U3cVIKa8IuCv3jKbz0Wn2IvU5oG2aMt7fSPM/JVIYJhRVDsIv4vQEgOP9zN8
         QlnWh0zm76+1BV/+xYOE3A+Nx7uO4NkM+kydccMvTH8TJ8cwnOG40ArRJJ3FX54WXl
         w9iFQIJiNkc9jYFH4fWo66qpUx6Uvq7E7UnnypCc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <avolmat@me.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 078/388] clk: clk-flexgen: fix clock-critical handling
Date:   Wed, 17 Jun 2020 21:02:55 -0400
Message-Id: <20200618010805.600873-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <avolmat@me.com>

[ Upstream commit a403bbab1a73d798728d76931cab3ff0399b9560 ]

Fixes an issue leading to having all clocks following a critical
clocks marked as well as criticals.

Fixes: fa6415affe20 ("clk: st: clk-flexgen: Detect critical clocks")
Signed-off-by: Alain Volmat <avolmat@me.com>
Link: https://lkml.kernel.org/r/20200322140740.3970-1-avolmat@me.com
Reviewed-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/st/clk-flexgen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/st/clk-flexgen.c b/drivers/clk/st/clk-flexgen.c
index 4413b6e04a8e..55873d4b7603 100644
--- a/drivers/clk/st/clk-flexgen.c
+++ b/drivers/clk/st/clk-flexgen.c
@@ -375,6 +375,7 @@ static void __init st_of_flexgen_setup(struct device_node *np)
 			break;
 		}
 
+		flex_flags &= ~CLK_IS_CRITICAL;
 		of_clk_detect_critical(np, i, &flex_flags);
 
 		/*
-- 
2.25.1

