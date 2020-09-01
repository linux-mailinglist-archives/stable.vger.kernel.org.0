Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86475259939
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgIAP33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730384AbgIAP31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83D2520684;
        Tue,  1 Sep 2020 15:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974167;
        bh=/GIaoVxzI6R1ZbyZoPszE9VDs9AELK8PFQDtPJS1jmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdm5/aQw2Lh+/gLhcjQEFZUsAu4HbnsyXJrJsF95JqI1q4et14Mpi9TC6hvE9x7YA
         5Cs/yak7qnlScmd7RhP1UipFV1U46C9VY5cdsKPwTt8KHyE10gNSLI7sH5Sc/dmH07
         J2U1vyjuvY6khuCUd/K7K5dIIDTCI1vxfGJnGpEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/214] PM / devfreq: rk3399_dmc: Add missing of_node_put()
Date:   Tue,  1 Sep 2020 17:09:11 +0200
Message-Id: <20200901150956.374418546@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 29d867e97f7d781972ed542acfca3c2c0b512603 ]

of_node_put() needs to be called when the device node which is got
from of_parse_phandle has finished using.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/rk3399_dmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/devfreq/rk3399_dmc.c b/drivers/devfreq/rk3399_dmc.c
index 2e65d7279d79e..2f1027c5b6475 100644
--- a/drivers/devfreq/rk3399_dmc.c
+++ b/drivers/devfreq/rk3399_dmc.c
@@ -372,6 +372,7 @@ static int rk3399_dmcfreq_probe(struct platform_device *pdev)
 	node = of_parse_phandle(np, "rockchip,pmu", 0);
 	if (node) {
 		data->regmap_pmu = syscon_node_to_regmap(node);
+		of_node_put(node);
 		if (IS_ERR(data->regmap_pmu))
 			return PTR_ERR(data->regmap_pmu);
 	}
-- 
2.25.1



