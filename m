Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F640205E86
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390302AbgFWUXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390315AbgFWUXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:23:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F9E920723;
        Tue, 23 Jun 2020 20:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943812;
        bh=2MC5q5RSqVKgcx5B9gE5+mDpo3ta5TgsrmT7263qL1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PEBZ/WD8baVvRbNHvDK42ajztt0vixaRUt9RIJMtaO0VPlS86nMYhjVnktLWEjGM
         5Sh05vnYjY9wBfmAKAHJVpLBEprvj9WAm1wMsz4T+X4GZ8qFl1T5Wy+Qm/SWx66pyI
         iUxu+CRg6rNx+OBPfXTvSJ8f4HZ4gIZg+tguvjDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <avolmat@me.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/314] clk: clk-flexgen: fix clock-critical handling
Date:   Tue, 23 Jun 2020 21:54:14 +0200
Message-Id: <20200623195341.637769741@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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
index 4413b6e04a8ec..55873d4b76032 100644
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



