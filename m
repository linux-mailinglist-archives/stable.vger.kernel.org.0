Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33857767BB
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfGZNjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727336AbfGZNjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:39:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AABF02238C;
        Fri, 26 Jul 2019 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148385;
        bh=+gfJVkpJS/vtb+jxiW5lbIi3FK/ZDmUKp2Z1JV4ZXZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOUxWQzK24Wd+8j0SYcRMLiJvEfqSRDwOVcFjnahyJ1purZueB6xO3qRwTzokzB5C
         uJhkFYsKHlvluj+1f/cz8SoIdct/5W3lVggoaxy1Un4TejDF7gFvxoisn6geLKd3lb
         W/VNKGkGP8+005TrAcriki31TvdmCgKimyx3A1Lg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Vinod Koul <vkoul@kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 08/85] soc: qcom: rpmpd: fixup rpmpd set performance state
Date:   Fri, 26 Jul 2019 09:38:18 -0400
Message-Id: <20190726133936.11177-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 8b3344422f097debe52296b87a39707d56ca3abe ]

Remoteproc q6v5-mss calls set_performance_state with INT_MAX on
rpmpd. This is currently ignored since it is greater than the
max supported state. Fixup rpmpd state to max if the required
state is greater than all the supported states.

Fixes: 075d3db8d10d ("soc: qcom: rpmpd: Add support for get/set performance state")
Reviewed-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <agross@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmpd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/rpmpd.c b/drivers/soc/qcom/rpmpd.c
index 005326050c23..235d01870dd8 100644
--- a/drivers/soc/qcom/rpmpd.c
+++ b/drivers/soc/qcom/rpmpd.c
@@ -226,7 +226,7 @@ static int rpmpd_set_performance(struct generic_pm_domain *domain,
 	struct rpmpd *pd = domain_to_rpmpd(domain);
 
 	if (state > MAX_RPMPD_STATE)
-		goto out;
+		state = MAX_RPMPD_STATE;
 
 	mutex_lock(&rpmpd_lock);
 
-- 
2.20.1

