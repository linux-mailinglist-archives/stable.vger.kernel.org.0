Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C444DBCD65
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409975AbfIXQpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409970AbfIXQp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:45:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3944C217D9;
        Tue, 24 Sep 2019 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343529;
        bh=NpxL+WCCtdslumQX2yqO+h1199gm+NJi3hIXzXiutNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8x2zMMT4qONdrRNXxbwYpkOTPbS5gugIEQMRdAkvxNZmYJ37FfIyvqDf6U5aLMPY
         fTSgl3qtyD0B4JwXaxXjBYHmacD/OVLTMKiTV2WGd6GbeDTbMEOo06jbi3JJskLYS8
         /YZ3QAOIgS04ATUl+I0nOM2/AOTAYye3Ek218G/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 79/87] clk: Make clk_bulk_get_all() return a valid "id"
Date:   Tue, 24 Sep 2019 12:41:35 -0400
Message-Id: <20190924164144.25591-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 7f81c2426587b34bf73e643c1a6d080dfa14cf8a ]

The adreno driver expects the "id" field of the returned clk_bulk_data
to be filled in with strings from the clock-names property.

But due to the use of kmalloc_array() in of_clk_bulk_get_all() it
receives a list of bogus pointers instead.

Zero-initialize the "id" field and attempt to populate with strings from
the clock-names property to resolve both these issues.

Fixes: 616e45df7c4a ("clk: add new APIs to operate on all available clocks")
Fixes: 8e3e791d20d2 ("drm/msm: Use generic bulk clock function")
Cc: Dong Aisheng <aisheng.dong@nxp.com>
Cc: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lkml.kernel.org/r/20190913024029.2640-1-bjorn.andersson@linaro.org
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-bulk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-bulk.c b/drivers/clk/clk-bulk.c
index 524bf9a530985..e9e16425c739c 100644
--- a/drivers/clk/clk-bulk.c
+++ b/drivers/clk/clk-bulk.c
@@ -18,10 +18,13 @@ static int __must_check of_clk_bulk_get(struct device_node *np, int num_clks,
 	int ret;
 	int i;
 
-	for (i = 0; i < num_clks; i++)
+	for (i = 0; i < num_clks; i++) {
+		clks[i].id = NULL;
 		clks[i].clk = NULL;
+	}
 
 	for (i = 0; i < num_clks; i++) {
+		of_property_read_string_index(np, "clock-names", i, &clks[i].id);
 		clks[i].clk = of_clk_get(np, i);
 		if (IS_ERR(clks[i].clk)) {
 			ret = PTR_ERR(clks[i].clk);
-- 
2.20.1

