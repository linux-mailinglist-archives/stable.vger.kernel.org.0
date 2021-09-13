Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153B9408CB0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbhIMNVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239614AbhIMNUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2EB2610A3;
        Mon, 13 Sep 2021 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539139;
        bh=PKMhz0ebKCsIG/+kx1GjqvcY4PBBlBtlCPpFstCHtSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ds8gj8FegKb33PpljeFQcFbEaOYL3p+3xcnJigBI71TRddYtfU9qAvMJggEJ/SzLr
         tbgljFWlEYZ009tO7Jmvq26cQIatrFMOcFo8XnuTOiSK2f6hvg5YhzGaQUSp3X8IO3
         zaTuKBN3lw9ufXcSLxfWQZmfIdjn8YNlR7K86UdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/144] soc: qcom: rpmhpd: Use corner in power_off
Date:   Mon, 13 Sep 2021 15:13:55 +0200
Message-Id: <20210913131049.746780199@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 51850cc68b70..aa24237a7840 100644
--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -235,12 +235,11 @@ static int rpmhpd_power_on(struct generic_pm_domain *domain)
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



