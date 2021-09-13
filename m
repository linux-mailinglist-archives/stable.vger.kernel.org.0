Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F3740915C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343625AbhIMOA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243252AbhIMN6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9822603E7;
        Mon, 13 Sep 2021 13:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540211;
        bh=UrStQuAPaM2Cr+gc5mXEncvTddHEC76z+RhnOH6qYz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZuOe5nd1fX76cm71rI2LIWoxN/PkY4FhhUh74d0E58B9mzST7wH1EVZ6vYCsXV2y
         dJhXDmNadrpn7zidhf/3HzDCySIWBxzUm7FuuiGk9iWvhrUHW7lKlfe+TPS8SVASGM
         jxW5fXlPf9//3zYyWorekfuvLgcgdsUSN6LwUf5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 099/300] soc: qcom: rpmhpd: Use corner in power_off
Date:   Mon, 13 Sep 2021 15:12:40 +0200
Message-Id: <20210913131112.727882463@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit d43b3a989bc8c06fd4bbb69a7500d180db2d68e8 ]

rpmhpd_aggregate_corner() takes a corner as parameter, but in
rpmhpd_power_off() the code requests the level of the first corner
instead.

In all (known) current cases the first corner has level 0, so this
change should be a nop, but in case that there's a power domain with a
non-zero lowest level this makes sure that rpmhpd_power_off() actually
requests the lowest level - which is the closest to "power off" we can
get.

While touching the code, also skip the unnecessary zero-initialization
of "ret".

Fixes: 279b7e8a62cc ("soc: qcom: rpmhpd: Add RPMh power domain driver")
Reviewed-by: Rajendra Nayak <rnayak@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Tested-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20210703005416.2668319-2-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmhpd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/rpmhpd.c b/drivers/soc/qcom/rpmhpd.c
index bb21c4f1c0c4..90d2e5817371 100644
--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -382,12 +382,11 @@ static int rpmhpd_power_on(struct generic_pm_domain *domain)
 static int rpmhpd_power_off(struct generic_pm_domain *domain)
 {
 	struct rpmhpd *pd = domain_to_rpmhpd(domain);
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&rpmhpd_lock);
 
-	ret = rpmhpd_aggregate_corner(pd, pd->level[0]);
-
+	ret = rpmhpd_aggregate_corner(pd, 0);
 	if (!ret)
 		pd->enabled = false;
 
-- 
2.30.2



