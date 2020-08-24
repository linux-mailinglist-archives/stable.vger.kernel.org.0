Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7C924F4C6
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgHXIkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgHXIku (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:40:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B9F92074D;
        Mon, 24 Aug 2020 08:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258449;
        bh=0AS/NqJ02rNsmOCbDOMV0JDy+0mcrZ7HiZfRljRPa6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLuzmKeXHFr/kVMaM5h6AMtVmh56SS7cNr7JWa4zIq5Wzq7T2rexfRNphllOTDgG5
         Vdkc5l6G5xJPHXlyR/AyPBXIPYW2mOivZX3faS9d4ysrG9EKN0ISRQmiODvqWXUet+
         cTVM6OvhUyW7nihYA4YMMPiSdNODWfHbCr3yRobg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 034/124] opp: Put opp table in dev_pm_opp_set_rate() for empty tables
Date:   Mon, 24 Aug 2020 10:29:28 +0200
Message-Id: <20200824082411.097960489@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 8979ef70850eb469e1094279259d1ef393ffe85f ]

We get the opp_table pointer at the top of the function and so we should
put the pointer at the end of the function like all other exit paths
from this function do.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Fixes: aca48b61f963 ("opp: Manage empty OPP tables with clk handle")
Reviewed-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
[ Viresh: Split the patch into two ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 2d3880b3d6ee0..a55d083e5be21 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -822,8 +822,10 @@ int dev_pm_opp_set_rate(struct device *dev, unsigned long target_freq)
 		 * have OPP table for the device, while others don't and
 		 * opp_set_rate() just needs to behave like clk_set_rate().
 		 */
-		if (!_get_opp_count(opp_table))
-			return 0;
+		if (!_get_opp_count(opp_table)) {
+			ret = 0;
+			goto put_opp_table;
+		}
 
 		if (!opp_table->required_opp_tables) {
 			dev_err(dev, "target frequency can't be 0\n");
-- 
2.25.1



