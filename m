Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD258CD685
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfJFRs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731401AbfJFRmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:42:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DD4B20862;
        Sun,  6 Oct 2019 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383773;
        bh=2q6xEFHuaBCJckqpbWV8+FPNL6zSQ5+BT+Wwq/4urfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fohcY4F6xt0IKkYA8Q42kwfO+1ZNe2QkVpw+SStqj9/RzPZV8rH7nW4NnDWmyQJ9r
         1BjK1V8brQyMIFKTssOheT++MWMP+wugLJliT8hlxoBGCrasLV/WBE++TKPjbbrT/8
         97RIqWDrSixlVhdIfWSJHq1ZgxmExWekEHb4lhv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <zhang.chunyan@linaro.org>,
        Baolin Wang <baolin.wang@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 036/166] clk: sprd: Dont reference clk_init_data after registration
Date:   Sun,  6 Oct 2019 19:20:02 +0200
Message-Id: <20191006171215.967153034@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit f6c90df8e7e33c3dc33d4d7471bc42c232b0510e ]

A future patch is going to change semantics of clk_register() so that
clk_hw::init is guaranteed to be NULL after a clk is registered. Avoid
referencing this member here so that we don't run into NULL pointer
exceptions.

Cc: Chunyan Zhang <zhang.chunyan@linaro.org>
Cc: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lkml.kernel.org/r/20190731193517.237136-8-sboyd@kernel.org
Acked-by: Baolin Wang <baolin.wang@linaro.org>
Acked-by: Chunyan Zhang <zhang.chunyan@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sprd/common.c b/drivers/clk/sprd/common.c
index a5bdca1de5d07..9d56eac43832a 100644
--- a/drivers/clk/sprd/common.c
+++ b/drivers/clk/sprd/common.c
@@ -76,16 +76,17 @@ int sprd_clk_probe(struct device *dev, struct clk_hw_onecell_data *clkhw)
 	struct clk_hw *hw;
 
 	for (i = 0; i < clkhw->num; i++) {
+		const char *name;
 
 		hw = clkhw->hws[i];
-
 		if (!hw)
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



