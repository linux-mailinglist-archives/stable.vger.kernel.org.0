Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF507205FDE
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391052AbgFWUhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388059AbgFWUhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:37:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECC7B21527;
        Tue, 23 Jun 2020 20:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944624;
        bh=7xgA9ze/zsUKRfyPT4EJSgtT2Y02WZQzj7wwPDlc/mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WC6Mbtz6OczLx8kJlVMf0mYvT0R6YE1EM+04eo+sYbXMgA8I03WoyoU3DY/GsG9u6
         yjF1OOKiOFYNX5VC3IBTpFrUF9UiMQvAGMvbWEZBBjO3cKMHxsFhMi+k92FS50or9C
         myFR4SFz1ayuCrl6H3bHP6QOpYGjqPtLdlphQqjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <avolmat@me.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/206] clk: clk-flexgen: fix clock-critical handling
Date:   Tue, 23 Jun 2020 21:55:59 +0200
Message-Id: <20200623195318.514766758@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 918ba3164da94..cd856210db58c 100644
--- a/drivers/clk/st/clk-flexgen.c
+++ b/drivers/clk/st/clk-flexgen.c
@@ -373,6 +373,7 @@ static void __init st_of_flexgen_setup(struct device_node *np)
 			break;
 		}
 
+		flex_flags &= ~CLK_IS_CRITICAL;
 		of_clk_detect_critical(np, i, &flex_flags);
 
 		/*
-- 
2.25.1



